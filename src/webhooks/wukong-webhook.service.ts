import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Prisma } from '@prisma/client';
import { createHash, timingSafeEqual } from 'node:crypto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WukongWebhookService {
  private readonly secret: string;

  constructor(config: ConfigService, private readonly prisma: PrismaService) {
    this.secret = config.getOrThrow<string>('WUKONGIM_WEBHOOK_SECRET');
  }

  async receive(token: string | undefined, payload: unknown) {
    if (!this.isValidToken(token)) throw new UnauthorizedException('Invalid webhook token');
    const normalized = this.asJsonObject(payload);
    const eventType = this.readString(normalized, ['event', 'type']) ?? 'unknown';
    const suppliedId = this.readString(normalized, ['event_id', 'id']);
    const digest = createHash('sha256').update(JSON.stringify(normalized)).digest('hex');
    const eventKey = suppliedId ? `${eventType}:${suppliedId}` : `${eventType}:${digest}`;

    try {
      await this.prisma.webhookEvent.create({
        data: {
        source: 'wukongim',
        eventKey,
        eventType,
        payload: normalized,
        processedAt: new Date(),
      },
      });
      return { accepted: true, duplicate: false };
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        return { accepted: true, duplicate: true };
      }
      throw error;
    }
  }

  private isValidToken(token: string | undefined) {
    if (!token) return false;
    const actual = Buffer.from(token);
    const expected = Buffer.from(this.secret);
    return actual.length === expected.length && timingSafeEqual(actual, expected);
  }

  private asJsonObject(payload: unknown): Prisma.InputJsonObject {
    if (!payload || typeof payload !== 'object' || Array.isArray(payload)) return { value: String(payload) };
    return payload;
  }

  private readString(payload: Prisma.InputJsonObject, keys: string[]) {
    for (const key of keys) {
      const value = payload[key];
      if (typeof value === 'string' && value.length > 0) return value;
    }
    return undefined;
  }
}
