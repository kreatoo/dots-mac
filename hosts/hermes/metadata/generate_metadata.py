import json
import os
from pathlib import Path


def main() -> None:
    template = json.loads(Path("hosts/hermes/metadata/hermes-latest.template.json").read_text())
    profile_seed = json.loads(Path("hosts/hermes/metadata/profile.json").read_text())

    openwrt_version = os.environ["OPENWRT_VERSION"]
    version_code = os.environ["VERSION_CODE"]
    target = os.environ["TARGET"]
    profile = os.environ["PROFILE"]
    supported_devices = json.loads(os.environ["SUPPORTED_DEVICES"])
    firmware_name = os.environ["FIRMWARE_NAME"]
    firmware_sha256 = os.environ["FIRMWARE_SHA256"]
    build_at = os.environ["BUILD_AT"]
    commit_sha = os.environ["GITHUB_SHA"]
    public_base_url = os.environ["PUBLIC_BASE_URL"].rstrip("/")

    firmware_url = f"{public_base_url}/releases/{commit_sha}/firmware/{firmware_name}"

    canonical = {
        **template,
        "openwrt_version": openwrt_version,
        "version_code": version_code,
        "target": target,
        "profile": profile,
        "supported_devices": supported_devices,
        "sysupgrade_name": firmware_name,
        "sysupgrade_url": firmware_url,
        "sha256": firmware_sha256,
        "manifest": {firmware_name: firmware_sha256},
        "build_at": build_at,
        "release_id": commit_sha,
    }

    profile_json = {
        **profile_seed,
        "id": profile,
        "target": target,
        "version_code": version_code,
        "supported_devices": supported_devices,
        "images": [
            {
                "type": "sysupgrade",
                "name": firmware_name,
                "sha256": firmware_sha256,
                "filesystem": "squashfs",
                "url": firmware_url,
            }
        ],
    }

    Path("dist/metadata/hermes-latest.json").write_text(json.dumps(canonical, indent=2) + "\n")

    target_path = Path("dist/metadata/json/v1/releases") / openwrt_version / "targets" / Path(target)
    target_path.mkdir(parents=True, exist_ok=True)
    (target_path / f"{profile}.json").write_text(json.dumps(profile_json, indent=2) + "\n")


if __name__ == "__main__":
    main()
