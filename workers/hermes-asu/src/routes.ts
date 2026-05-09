import { loadCanonicalMetadata } from "./metadata";
import type { Env } from "./index";
import type { CanonicalMetadata } from "./types";

type Tuple = {
  version: string;
  target: string;
  profile: string;
};

function detectFilesystemFromImageName(name: string): string {
  const marker = "-squashfs-";
  if (name.includes(marker)) {
    return "squashfs";
  }

  return "unknown";
}

function json(data: unknown, status = 200): Response {
  return Response.json(data, { status });
}

function tupleMatchesMetadata(tuple: Tuple, metadata: CanonicalMetadata): boolean {
  const profileMatches =
    tuple.profile === metadata.profile || metadata.supported_devices.includes(tuple.profile);

  return (
    tuple.version === metadata.openwrt_version &&
    tuple.target === metadata.target &&
    profileMatches
  );
}

function buildDonePayload(metadata: CanonicalMetadata): Record<string, unknown> {
  const filesystem = detectFilesystemFromImageName(metadata.sysupgrade_name);

  return {
    status: 200,
    id: metadata.profile,
    version_number: metadata.openwrt_version,
    version_code: metadata.version_code,
    target: metadata.target,
    images: [
      {
        name: metadata.sysupgrade_name,
        type: "sysupgrade",
        filesystem,
        sha256: metadata.sha256,
        sha256_unsigned: metadata.sha256,
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
  const branchKey = metadata.openwrt_version.split(".").slice(0, 2).join(".") || metadata.openwrt_version;

  return json({
    latest: [metadata.openwrt_version],
    versions: [metadata.openwrt_version],
    branches: {
      [branchKey]: {
        version: metadata.openwrt_version,
        package_changes: [],
      },
    },
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

export async function handleRevision(version: string, target: string, env: Env): Promise<Response> {
  const metadataOrResponse = await getMetadata(env);
  if (metadataOrResponse instanceof Response) {
    return metadataOrResponse;
  }

  const metadata = metadataOrResponse;
  if (version !== metadata.openwrt_version || target !== metadata.target) {
    return json({ detail: "unsupported version/target" }, 400);
  }

  return json({
    revision: `r99999-${metadata.release_id ?? metadata.version_code}`,
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

  if (payloadObject.defaults !== undefined) {
    return json({ detail: "defaults are unsupported for hermes" }, 400);
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

export async function handleStore(binDir: string, imageName: string, env: Env): Promise<Response> {
  const metadataOrResponse = await getMetadata(env);
  if (metadataOrResponse instanceof Response) {
    return metadataOrResponse;
  }
  const metadata = metadataOrResponse;

  const expectedBinDir = metadata.release_id ?? metadata.version_code;
  if (binDir !== expectedBinDir || imageName !== metadata.sysupgrade_name) {
    return json({ detail: "firmware image not found" }, 404);
  }

  let upstream: Response;
  try {
    upstream = await fetch(metadata.sysupgrade_url, {
      method: "GET",
      redirect: "follow",
    });
  } catch {
    return json({ detail: "failed to fetch upstream firmware" }, 502);
  }

  if (!upstream.ok) {
    return json({ detail: `upstream firmware fetch failed: ${upstream.status}` }, 502);
  }

  const headers = new Headers();
  const contentType = upstream.headers.get("content-type") ?? "application/octet-stream";
  headers.set("Content-Type", contentType);

  const contentLength = upstream.headers.get("content-length");
  if (contentLength) {
    headers.set("Content-Length", contentLength);
  }

  headers.set(
    "Content-Disposition",
    `attachment; filename="${metadata.sysupgrade_name.replace(/"/g, "")}"`,
  );
  headers.set("Cache-Control", "public, max-age=3600");

  return new Response(upstream.body, {
    status: 200,
    headers,
  });
}
