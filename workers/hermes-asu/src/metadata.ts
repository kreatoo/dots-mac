import { safeParseCanonicalMetadata } from "./schema";
import type { CanonicalMetadata, MetadataLoadResult } from "./types";

const cache = new Map<string, { value: CanonicalMetadata; expiresAt: number }>();

type LoadMetadataOptions = {
  url: string;
  ttlSeconds: number;
  fetchImpl?: (input: string) => Promise<Response>;
};

export function clearMetadataCache(): void {
  cache.clear();
}

export async function loadCanonicalMetadata(options: LoadMetadataOptions): Promise<MetadataLoadResult> {
  const cacheKey = options.url;
  const now = Date.now();
  const cachedEntry = cache.get(cacheKey);

  if (cachedEntry && cachedEntry.expiresAt > now) {
    return { ok: true, data: cachedEntry.value, cached: true, cacheKey };
  }

  const fetchImpl = options.fetchImpl ?? fetch;
  let response: Response;

  try {
    response = await fetchImpl(options.url);
  } catch (error) {
    return {
      ok: false,
      error: {
        kind: "fetch_error",
        message: "failed to fetch metadata",
        cause: error,
      },
    };
  }

  if (!response.ok) {
    return {
      ok: false,
      error: {
        kind: "fetch_error",
        message: `metadata request failed with status ${response.status}`,
      },
    };
  }

  let payload: unknown;
  try {
    payload = await response.json();
  } catch (error) {
    return {
      ok: false,
      error: {
        kind: "fetch_error",
        message: "failed to parse metadata JSON",
        cause: error,
      },
    };
  }

  const parsed = safeParseCanonicalMetadata(payload);
  if (!parsed.success) {
    return {
      ok: false,
      error: {
        kind: "validation_error",
        message: "metadata schema validation failed",
        issues: parsed.error.issues.map((issue) => issue.message),
      },
    };
  }

  const safeTtlSeconds = Number.isFinite(options.ttlSeconds) ? Math.max(0, options.ttlSeconds) : 0;
  const ttlMs = safeTtlSeconds * 1000;
  cache.set(cacheKey, {
    value: parsed.data,
    expiresAt: now + ttlMs,
  });

  return {
    ok: true,
    data: parsed.data,
    cached: false,
    cacheKey,
  };
}
