export const DEFAULT_ADMIN_IDLE_MINUTES = 30;

export function adminIdleTimeoutMs(value: string | undefined) {
  const minutes = Number(value ?? DEFAULT_ADMIN_IDLE_MINUTES);
  return Number.isFinite(minutes) && minutes >= 1 && minutes <= 480
    ? minutes * 60_000
    : DEFAULT_ADMIN_IDLE_MINUTES * 60_000;
}

export function startIdleSessionMonitor(
  onIdle: () => void,
  timeoutMs = adminIdleTimeoutMs(import.meta.env.VITE_ADMIN_IDLE_MINUTES),
) {
  let lastActivity = Date.now();
  let stopped = false;
  let timer: ReturnType<typeof setTimeout>;

  const check = () => {
    if (stopped) return;
    const remaining = timeoutMs - (Date.now() - lastActivity);
    if (remaining <= 0) {
      stopped = true;
      onIdle();
      return;
    }
    timer = setTimeout(check, remaining);
  };
  const activity = () => {
    if (stopped || document.visibilityState === "hidden") return;
    lastActivity = Date.now();
    clearTimeout(timer);
    timer = setTimeout(check, timeoutMs);
  };
  const visibility = () => {
    if (document.visibilityState === "visible") check();
  };
  const events: Array<keyof WindowEventMap> = [
    "keydown",
    "pointerdown",
    "touchstart",
    "scroll",
  ];
  events.forEach((event) => window.addEventListener(event, activity));
  document.addEventListener("visibilitychange", visibility);
  timer = setTimeout(check, timeoutMs);

  return () => {
    stopped = true;
    clearTimeout(timer);
    events.forEach((event) => window.removeEventListener(event, activity));
    document.removeEventListener("visibilitychange", visibility);
  };
}
