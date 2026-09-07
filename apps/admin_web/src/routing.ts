export const routeKeys = [
  "overview",
  "users",
  "groups",
  "calls",
  "files",
  "reports",
  "audit",
  "jobs",
  "settings",
] as const;

export type RouteKey = (typeof routeKeys)[number];

export function routeFromHash(hash: string): RouteKey {
  const candidate = hash.replace(/^#\/?/, "").split(/[?&]/, 1)[0];
  return routeKeys.includes(candidate as RouteKey)
    ? (candidate as RouteKey)
    : "overview";
}

export function hrefForRoute(route: RouteKey) {
  return `#/${route}`;
}
