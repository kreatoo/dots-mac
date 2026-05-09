import { handleBuild, handleBuildPoll, handleOverview, handleProfile, handleRevision, handleStore } from "./routes";

export interface Env {
  HERMES_METADATA_URL: string;
  HERMES_CACHE_TTL_SECONDS: string;
}

function withCors(response: Response): Response {
  const headers = new Headers(response.headers);
  headers.set("Access-Control-Allow-Origin", "*");
  headers.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  headers.set("Access-Control-Allow-Headers", "Content-Type, Accept");
  headers.set("Access-Control-Max-Age", "86400");
  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (request.method === "OPTIONS") {
      return withCors(new Response(null, { status: 204 }));
    }

    if (url.pathname === "/health") {
      return withCors(Response.json({ status: "ok" }));
    }

    if (
      request.method === "GET" &&
      (url.pathname === "/json/v1/overview.json" || url.pathname === "/api/v1/overview")
    ) {
      return withCors(await handleOverview(env));
    }

    const revisionMatch = url.pathname.match(/^\/api\/v1\/revision\/([^/]+)\/(.+)$/);
    if (request.method === "GET" && revisionMatch) {
      let version: string;
      let target: string;

      try {
        version = decodeURIComponent(revisionMatch[1]);
        target = decodeURIComponent(revisionMatch[2]);
      } catch {
        return withCors(Response.json({ detail: "invalid path encoding" }, { status: 400 }));
      }

      return withCors(await handleRevision(version, target, env));
    }

    const profileMatch = url.pathname.match(/^\/json\/v1\/releases\/([^/]+)\/targets\/(.+)\/([^/]+)\.json$/);
    if (request.method === "GET" && profileMatch) {
      let version: string;
      let target: string;
      let profile: string;

      try {
        version = decodeURIComponent(profileMatch[1]);
        target = decodeURIComponent(profileMatch[2]);
        profile = decodeURIComponent(profileMatch[3]);
      } catch {
        return withCors(Response.json({ detail: "invalid path encoding" }, { status: 400 }));
      }

      return withCors(await handleProfile(
        {
          version,
          target,
          profile,
        },
        env,
      ));
    }

    if (request.method === "POST" && url.pathname === "/api/v1/build") {
      return withCors(await handleBuild(request, env));
    }

    const pollMatch = url.pathname.match(/^\/api\/v1\/build\/([^/]+)$/);
    if (request.method === "GET" && pollMatch) {
      let requestHash: string;

      try {
        requestHash = decodeURIComponent(pollMatch[1]);
      } catch {
        return withCors(Response.json({ detail: "invalid path encoding" }, { status: 400 }));
      }

      return withCors(await handleBuildPoll(requestHash, env));
    }

    const storeMatch = url.pathname.match(/^\/store\/([^/]+)\/(.+)$/);
    if (request.method === "GET" && storeMatch) {
      let binDir: string;
      let imageName: string;

      try {
        binDir = decodeURIComponent(storeMatch[1]);
        imageName = decodeURIComponent(storeMatch[2]);
      } catch {
        return withCors(Response.json({ detail: "invalid path encoding" }, { status: 400 }));
      }

      return withCors(await handleStore(binDir, imageName, env));
    }

    return withCors(new Response("Not Found", { status: 404 }));
  },
};
