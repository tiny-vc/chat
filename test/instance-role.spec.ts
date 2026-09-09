import { backgroundJobsEnabled } from "../src/config/instance-role";

function config(values: Record<string, string>) {
  return {
    getOrThrow: (key: string) => values[key],
  } as never;
}

describe("instance roles", () => {
  it("runs background work only on worker-capable instances", () => {
    expect(
      backgroundJobsEnabled(config({ JOBS_ENABLED: "true", INSTANCE_ROLE: "api" })),
    ).toBe(false);
    expect(
      backgroundJobsEnabled(
        config({ JOBS_ENABLED: "true", INSTANCE_ROLE: "worker" }),
      ),
    ).toBe(true);
    expect(
      backgroundJobsEnabled(config({ JOBS_ENABLED: "true", INSTANCE_ROLE: "all" })),
    ).toBe(true);
    expect(
      backgroundJobsEnabled(config({ JOBS_ENABLED: "false", INSTANCE_ROLE: "all" })),
    ).toBe(false);
  });
});
