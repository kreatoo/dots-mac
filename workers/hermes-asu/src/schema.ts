import { z } from "zod";

import type { CanonicalMetadata } from "./types";

const canonicalMetadataSchema = z
  .object({
    openwrt_version: z.string().min(1),
    version_code: z.string().min(1),
    target: z.string().min(1),
    profile: z.literal("hermes"),
    supported_devices: z.array(z.string().min(1)).min(1),
    sysupgrade_name: z.string().min(1),
    sysupgrade_url: z.string().url(),
    sha256: z.string().regex(/^[a-f0-9]{64}$/i),
    manifest: z.record(z.string().min(1), z.string().min(1)),
    build_at: z.string().datetime({ offset: true }),
    release_id: z.string().min(1).optional(),
  })
  .strict();

export function parseCanonicalMetadata(input: unknown): CanonicalMetadata {
  return canonicalMetadataSchema.parse(input);
}

export function safeParseCanonicalMetadata(input: unknown) {
  return canonicalMetadataSchema.safeParse(input);
}
