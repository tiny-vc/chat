import { ApiProperty } from "@nestjs/swagger";

export class RuntimeCapabilitiesDto {
  @ApiProperty()
  messaging!: boolean;

  @ApiProperty()
  files!: boolean;

  @ApiProperty()
  groups!: boolean;

  @ApiProperty()
  audioCalls!: boolean;

  @ApiProperty()
  videoCalls!: boolean;
}

export class MessagingPolicySyncDto {
  @ApiProperty({ enum: ["PENDING", "SYNCING", "SYNCED", "FAILED"] })
  status!: string;

  @ApiProperty()
  attempts!: number;

  @ApiProperty({ nullable: true, type: String })
  lastError!: string | null;

  @ApiProperty({ nullable: true, type: String, format: "date-time" })
  syncedAt!: string | null;
}

export class RuntimeSettingsResponseDto {
  @ApiProperty()
  registrationEnabled!: boolean;

  @ApiProperty({ type: RuntimeCapabilitiesDto })
  capabilities!: RuntimeCapabilitiesDto;

  @ApiProperty({ type: MessagingPolicySyncDto })
  messagingPolicy!: MessagingPolicySyncDto;

  @ApiProperty({ format: "date-time" })
  updatedAt!: string;
}
