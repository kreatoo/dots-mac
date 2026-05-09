import { loadCanonicalMetadata } from "./metadata";
import type { Env } from "./index";
import type { CanonicalMetadata } from "./types";

type Tuple = {
  version: string;
  target: string;
  profile: string;
};

function json(data: unknown, status = 200): Response {
  return Response.json(data, { status });
}

function tupleMatchesMetadata(tuple: Tuple, metadata: CanonicalMetadata): boolean {
  return (
    tuple.version === metadata.openwrt_version &&
    tuple.target === metadata.target &&
    tuple.profile === metadata.profile
  );
}

function buildDonePayload(metadata: CanonicalMetadata): Record<string, unknown> {
  return {
    status: 200,
    id: metadata.profile,
    version_code: metadata.version_code,
    target: metadata.target,
    images: [
      {
        name: metadata.sysupgrade_name,
        type: "sysupgrade",
        sha256: metadata.sha256,
        url: metadata.sysupgrade_url,
      },
    ],
    bin_dir: metadata.release_id ?? metadata.version_code,
    manifest: metadata.manifest,
    build_at: metadata.build_at,
  };
}

async function getMetadata(env: Env): Promise<CanonicalMetadata | Response> {
  const ttlSeconds = Number(env.HERMES_CACHE_TTL_SECONDS);
  const result = await loadCanonicalMetadata({
    url: env.HERMES_METADATA_URL,
    ttlSeconds: Number.isNaN(ttlSeconds) ? 0 : ttlSeconds,
  });

  if (!result.ok) {
    return json({ detail: result.error.message }, 500);
  }

  return result.data;
}

export async function handleOverview(env: Env): Promise<Response> {
  const metadataOrResponse = await getMetadata(env);
  if (metadataOrResponse instanceof Response) {
    return metadataOrResponse;
  }

  const metadata = metadataOrResponse;
  return json({
    latest: metadata.openwrt_version,
    versions: [metadata.openwrt_version],
    branches: [
      {
        name: metadata.release_id ?? metadata.version_code,
        version: metadata.openwrt_version,
      },
    ],
  });
}

export async function handleProfile(tuple: Tuple, env: Env): Promise<Response> {
  const metadataOrResponse = await getMetadata(env);
  if (metadataOrResponse instanceof Response) {
    return metadataOrResponse;
  }

  const metadata = metadataOrResponse;
  if (!tupleMatchesMetadata(tuple, metadata)) {
    return json({ detail: "unsupported version/target/profile" }, 400);
  }

  return json({
    id: metadata.profile,
    target: metadata.target,
    version_code: metadata.version_code,
    supported_devices: metadata.supported_devices,
  });
}

export async function handleBuild(request: Request, env: Env): Promise<Response> {
  let payload: unknown;

  try {
    payload = await request.json();
  } catch {
    return json({ detail: "invalid JSON body" }, 400);
  }

  if (!payload || typeof payload !== "object" || Array.isArray(payload)) {
    return json({ detail: "JSON body must be an object" }, 400);
  }

  const payloadObject = payload as Record<string, unknown>;

  const tuple = {
    version: String(payloadObject.version ?? ""),
    target: String(payloadObject.target ?? ""),
    profile: String(payloadObject.profile ?? ""),
  };

  if (!tuple.version || !tuple.target || !tuple.profile) {
    return json({ detail: "version, target, and profile are required" }, 400);
  }

  if (payloadObject.defaults !== undefined || payloadObject.packages !== undefined) {
    return json({ detail: "dynamic build options are unsupported for hermes" }, 400);
  }

  const metadataOrResponse = await getMetadata(env);
  if (metadataOrResponse instanceof Response) {
    return metadataOrResponse;
  }
  const metadata = metadataOrResponse;

  if (!tupleMatchesMetadata(tuple, metadata)) {
    return json({ detail: "unsupported version/target/profile" }, 400);
  }

  return json(buildDonePayload(metadata));
}

export async function handleBuildPoll(requestHash: string, env: Env): Promise<Response> {
  const metadataOrResponse = await getMetadata(env);
  if (metadataOrResponse instanceof Response) {
    return metadataOrResponse;
  }
  const metadata = metadataOrResponse;

  if (requestHash !== metadata.profile) {
    return json({ detail: "unsupported request hash" }, 400);
  }

  return json(buildDonePayload(metadata));
}
