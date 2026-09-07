import type { RuntimeSettingsResponseDto } from "@chat/admin-api-client";
import { MessagingPolicySyncDtoStatusEnum } from "@chat/admin-api-client";
import { describe, expect, it } from "vitest";
import { editableSettings, settingsChanged } from "./SettingsPage";

const response: RuntimeSettingsResponseDto = {
  registrationEnabled: true,
  capabilities: {
    messaging: true,
    files: false,
    groups: true,
    audioCalls: true,
    videoCalls: false,
  },
  messagingPolicy: {
    status: MessagingPolicySyncDtoStatusEnum.Synced,
    attempts: 0,
    lastError: null,
    syncedAt: "2026-09-04T00:00:01.000Z",
  },
  updatedAt: "2026-09-04T00:00:00.000Z",
};

describe("runtime settings", () => {
  it("maps the nested response to the atomic update payload", () => {
    expect(editableSettings(response)).toEqual({
      registrationEnabled: true,
      messaging: true,
      files: false,
      groups: true,
      audioCalls: true,
      videoCalls: false,
    });
  });

  it("detects changes without mutating the saved value", () => {
    const saved = editableSettings(response);
    const draft = { ...saved, files: true };
    expect(settingsChanged(saved, draft)).toBe(true);
    expect(settingsChanged(saved, { ...saved })).toBe(false);
    expect(saved.files).toBe(false);
  });
});
