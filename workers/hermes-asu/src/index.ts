import { handleBuild, handleBuildPoll, handleOverview, handleProfile } from "./routes";

export interface Env {
  HERMES_METADATA_URL: string;
  HERMES_CACHE_TTL_SECONDS: string;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === "/health") {
      return Response.json({ status: "ok" });
    }

    if (request.method === "GET" && url.pathname === "/json/v1/overview.json") {
      return handleOverview(env);
    }

    const profileMatch = url.pathname.match(/^\/json\/v1\/releases\/([^/]+)\/targets\/([^/]+)\/([^/]+)\.json$/);
    if (request.method === "GET" && profileMatch) {
      let version: string;
      let target: string;
      let profile: string;

      try {
        version = decodeURIComponent(profileMatch[1]);
        target = decodeURIComponent(profileMatch[2]);
        profile = decodeURIComponent(profileMatch[3]);
      } catch {
        return Response.json({ detail: "invalid path encoding" }, { status: 400 });
      }

      return handleProfile(
        {
          version,
          target,
          profile,
        },
        env,
      );
    }

    if (request.method === "POST" && url.pathname === "/api/v1/build") {
      return handleBuild(request, env);
    }

    const pollMatch = url.pathname.match(/^\/api\/v1\/build\/([^/]+)$/);
    if (request.method === "GET" && pollMatch) {
      let requestHash: string;

      try {
        requestHash = decodeURIComponent(pollMatch[1]);
      } catch {
        return Response.json({ detail: "invalid path encoding" }, { status: 400 });
      }

      return handleBuildPoll(requestHash, env);
    }

    return new Response("Not Found", { status: 404 });
  },
};
