export type HermesProfile = "hermes";

export type CanonicalMetadata = {
  openwrt_version: string;
  version_code: string;
  target: string;
  profile: HermesProfile;
  supported_devices: string[];
  sysupgrade_name: string;
  sysupgrade_url: string;
  sha256: string;
  manifest: Record<string, string>;
  build_at: string;
  release_id?: string;
};

export type MetadataLoadError =
  | {
      kind: "fetch_error";
      message: string;
      cause?: unknown;
    }
  | {
      kind: "validation_error";
      message: string;
      issues: string[];
    };

export type MetadataLoadResult =
  | {
      ok: true;
      data: CanonicalMetadata;
      cached: boolean;
      cacheKey: string;
    }
  | {
      ok: false;
      error: MetadataLoadError;
    };
