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

export function routeFromPath(pathname: string): RouteKey {
  const candidate = pathname.replace(/^\/+|\/+$/g, "").split("/", 1)[0];
  return routeKeys.includes(candidate as RouteKey)
    ? (candidate as RouteKey)
    : "overview";
}

export function hrefForRoute(route: RouteKey) {
  return `/${route}`;
}
