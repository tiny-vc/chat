import { BadGatewayException, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { randomUUID } from "node:crypto";

@Injectable()
export class WuKongImService {
  private readonly baseUrl: string;
  private readonly managerToken?: string;

  constructor(config: ConfigService) {
    this.baseUrl = config
      .getOrThrow<string>("WUKONGIM_API_URL")
      .replace(/\/$/, "");
    this.managerToken = config.get<string>("WUKONGIM_MANAGER_TOKEN");
  }

  async disconnectDevice(uid: string, deviceId: string): Promise<number> {
    const matches: Array<{ connId: number; nodeId: number }> = [];
    const limit = 100;
    let offset = 0;

    for (let pageNumber = 0; pageNumber < 100; pageNumber += 1) {
      const page = this.asRecord(
        await this.get(`/connz?offset=${offset}&limit=${limit}&subs=0`),
      );
      const connections = Array.isArray(page.connections)
        ? page.connections
        : [];

      for (const value of connections) {
        const connection = this.asRecord(value);
        if (connection.uid !== uid || connection.device_id !== deviceId)
          continue;
        const connId = Number(connection.conn_id ?? connection.id);
        const nodeId = Number(connection.node_id);
        if (Number.isSafeInteger(connId) && Number.isSafeInteger(nodeId)) {
          matches.push({ connId, nodeId });
        }
      }

      offset += connections.length;
      const total = Number(page.total ?? offset);
      if (connections.length === 0 || offset >= total) break;
      if (pageNumber === 99) {
        throw new BadGatewayException(
          "WuKongIM connection listing did not converge",
        );
      }
    }

    for (const match of matches) {
      await this.post("/conn/kick", {
        uid,
        conn_id: match.connId,
        node_id: match.nodeId,
      });
    }
    return matches.length;
  }

  async upsertUserToken(
    uid: string,
    token: string,
    deviceFlag = 0,
  ): Promise<void> {
    await this.post("/user/token", {
      uid,
      token,
      device_flag: deviceFlag,
      // Secondary devices with the same uid/device_flag may coexist. Device
      // sessions and revocation remain owned by the application API.
      device_level: 0,
    });
  }

  async addChannelSubscribers(
    channelId: string,
    userIds: string[],
  ): Promise<void> {
    await this.post("/channel/subscriber_add", {
      channel_id: channelId,
      channel_type: 2,
      subscribers: userIds,
      reset: 0,
      temp_subscriber: 0,
    });
  }

  async removeChannelSubscribers(
    channelId: string,
    userIds: string[],
  ): Promise<void> {
    await this.post("/channel/subscriber_remove", {
      channel_id: channelId,
      channel_type: 2,
      subscribers: userIds,
    });
  }

  async updateChannelPolicy(
    channelId: string,
    policy: { banned?: boolean; disbanded?: boolean; sendBanned?: boolean },
  ): Promise<void> {
    await this.post("/channel", {
      channel_id: channelId,
      channel_type: 2,
      ...(policy.banned === undefined ? {} : { ban: policy.banned ? 1 : 0 }),
      ...(policy.disbanded === undefined
        ? {}
        : { disband: policy.disbanded ? 1 : 0 }),
      ...(policy.sendBanned === undefined
        ? {}
        : { send_ban: policy.sendBanned ? 1 : 0 }),
    });
  }

  async addChannelBlacklist(
    channelId: string,
    channelType: 1 | 2,
    userIds: string[],
  ) {
    await this.post("/channel/blacklist_add", {
      channel_id: channelId,
      channel_type: channelType,
      uids: userIds,
    });
  }

  async removeChannelBlacklist(
    channelId: string,
    channelType: 1 | 2,
    userIds: string[],
  ) {
    await this.post("/channel/blacklist_remove", {
      channel_id: channelId,
      channel_type: channelType,
      uids: userIds,
    });
  }

  async healthCheck() {
    const response = await fetch(`${this.baseUrl}/health`, {
      signal: AbortSignal.timeout(3_000),
    });
    if (!response.ok)
      throw new Error(`WuKongIM health returned ${response.status}`);
  }

  async sendPersonalMessage(input: {
    fromUserId: string;
    toUserId: string;
    payload: Record<string, unknown>;
  }): Promise<void> {
    await this.post("/message/send", {
      header: { no_persist: 0, red_dot: 1, sync_once: 0 },
      client_msg_no: randomUUID(),
      from_uid: input.fromUserId,
      channel_id: input.toUserId,
      channel_type: 1,
      payload: Buffer.from(JSON.stringify(input.payload)).toString("base64"),
    });
  }

  async sendGroupMessage(input: {
    fromUserId: string;
    groupId: string;
    payload: Record<string, unknown>;
  }): Promise<void> {
    await this.post("/message/send", {
      header: { no_persist: 0, red_dot: 0, sync_once: 1 },
      client_msg_no:
        typeof input.payload.clientMsgNo === "string"
          ? input.payload.clientMsgNo
          : randomUUID(),
      from_uid: input.fromUserId,
      channel_id: input.groupId,
      channel_type: 2,
      payload: Buffer.from(JSON.stringify(input.payload)).toString("base64"),
    });
  }

  async syncConversations(input: {
    userId: string;
    lastMsgSeqs: string;
    msgCount: number;
    version: number;
  }) {
    return this.post("/conversation/sync", {
      uid: input.userId,
      version: input.version,
      last_msg_seqs: input.lastMsgSeqs,
      msg_count: input.msgCount,
      only_unread: 0,
      exclude_channel_types: [3, 4, 5],
    });
  }

  async syncChannelMessages(input: {
    userId: string;
    channelId: string;
    channelType: 1 | 2;
    startMessageSeq: number;
    endMessageSeq: number;
    limit: number;
    pullMode: 0 | 1;
  }) {
    return this.post("/channel/messagesync", {
      login_uid: input.userId,
      channel_id: input.channelId,
      channel_type: input.channelType,
      start_message_seq: input.startMessageSeq,
      end_message_seq: input.endMessageSeq,
      limit: input.limit,
      pull_mode: input.pullMode,
      event_summary_mode: "basic",
    });
  }

  async clearConversationUnread(
    userId: string,
    channelId: string,
    channelType: 1 | 2,
  ) {
    await this.post("/conversations/clearUnread", {
      uid: userId,
      channel_id: channelId,
      channel_type: channelType,
      message_seq: 0,
    });
  }

  async findMessage(input: {
    loginUserId: string;
    channelId: string;
    channelType: 1 | 2;
    clientMsgNo: string;
  }) {
    return this.post("/message", {
      login_uid: input.loginUserId,
      channel_id: input.channelId,
      channel_type: input.channelType,
      client_msg_no: input.clientMsgNo,
    });
  }

  async sendChannelMessage(input: {
    fromUserId: string;
    channelId: string;
    channelType: 1 | 2;
    payload: Record<string, unknown>;
  }) {
    await this.post("/message/send", {
      header: {
        no_persist: 0,
        red_dot: 0,
        sync_once: input.channelType === 2 ? 1 : 0,
      },
      client_msg_no: randomUUID(),
      from_uid: input.fromUserId,
      channel_id: input.channelId,
      channel_type: input.channelType,
      payload: Buffer.from(JSON.stringify(input.payload)).toString("base64"),
    });
  }

  private async post(path: string, body: unknown): Promise<unknown> {
    const response = await fetch(`${this.baseUrl}${path}`, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        ...(this.managerToken
          ? { authorization: `Bearer ${this.managerToken}` }
          : {}),
      },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(5_000),
    }).catch((error: unknown) => {
      throw new BadGatewayException(
        `WuKongIM is unavailable: ${String(error)}`,
      );
    });

    if (!response.ok) {
      const details = await response.text();
      throw new BadGatewayException(
        `WuKongIM request failed (${response.status}): ${details.slice(0, 300)}`,
      );
    }

    const text = await response.text();
    return text ? JSON.parse(text) : undefined;
  }

  private async get(path: string): Promise<unknown> {
    const response = await fetch(`${this.baseUrl}${path}`, {
      headers: this.managerToken
        ? { authorization: `Bearer ${this.managerToken}` }
        : {},
      signal: AbortSignal.timeout(5_000),
    }).catch((error: unknown) => {
      throw new BadGatewayException(
        `WuKongIM is unavailable: ${String(error)}`,
      );
    });
    if (!response.ok) {
      const details = await response.text();
      throw new BadGatewayException(
        `WuKongIM request failed (${response.status}): ${details.slice(0, 300)}`,
      );
    }
    return response.json();
  }

  private asRecord(value: unknown): Record<string, unknown> {
    return value !== null && typeof value === "object"
      ? (value as Record<string, unknown>)
      : {};
  }
}
