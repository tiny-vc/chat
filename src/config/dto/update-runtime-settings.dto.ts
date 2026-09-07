import { IsBoolean } from "class-validator";

export class UpdateRuntimeSettingsDto {
  @IsBoolean()
  registrationEnabled!: boolean;

  @IsBoolean()
  messaging!: boolean;

  @IsBoolean()
  files!: boolean;

  @IsBoolean()
  groups!: boolean;

  @IsBoolean()
  audioCalls!: boolean;

  @IsBoolean()
  videoCalls!: boolean;
}
