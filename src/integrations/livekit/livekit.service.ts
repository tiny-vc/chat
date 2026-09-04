import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AccessToken, LiveKitAPI } from 'livekit-server-sdk';

@Injectable()
export class LiveKitService {
  private readonly apiKey: string;
  private readonly apiSecret: string;
  private readonly wsUrl: string;
  private readonly api: LiveKitAPI;
  private readonly httpUrl: string;

  constructor(config: ConfigService) {
    this.apiKey = config.getOrThrow<string>('LIVEKIT_API_KEY');
    this.apiSecret = config.getOrThrow<string>('LIVEKIT_API_SECRET');
    this.wsUrl = config.getOrThrow<string>('LIVEKIT_URL');
    this.httpUrl = config.getOrThrow<string>('LIVEKIT_HTTP_URL').replace(/\/$/, '');
    this.api = new LiveKitAPI({
      host: this.httpUrl,
      apiKey: this.apiKey,
      secret: this.apiSecret,
      requestTimeout: 5,
    });
  }

  async createJoinToken(input: {
    roomName: string;
    userId: string;
    displayName: string;
  }) {
    const token = new AccessToken(this.apiKey, this.apiSecret, {
      identity: input.userId,
      name: input.displayName,
      ttl: '15m',
    });
    token.addGrant({
      roomJoin: true,
      room: input.roomName,
      canPublish: true,
      canSubscribe: true,
      canPublishData: true,
    });
    return { url: this.wsUrl, token: await token.toJwt() };
  }

  async deleteRoom(roomName: string) {
    await this.api.room.deleteRoom(roomName);
  }

  async participantIdentities(roomName: string): Promise<string[]> {
    // Only a successful room lookup can establish absence. Transport/auth
    // errors must propagate so maintenance never mistakes an outage for a hangup.
    const rooms = await this.api.room.listRooms([roomName]);
    if (!rooms.some((room) => room.name === roomName)) return [];
    const participants = await this.api.room.listParticipants(roomName);
    return participants.map((participant) => participant.identity);
  }

  async healthCheck() {
    const response = await fetch(this.httpUrl, { signal: AbortSignal.timeout(3_000) });
    if (!response.ok) throw new Error(`LiveKit health returned ${response.status}`);
  }
}
