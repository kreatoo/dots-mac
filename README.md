<p align="center">
  <img src="https://raw.githubusercontent.com/yunfachi/NixOwOS/master/assets/nixowos-snowflake-colours.svg" width="250px" alt="NixOwOS logo">
</p>

## declarative systems with Nix

This repository contains declarative configurations for macOS (via `nix-darwin` + `home-manager`) and OpenWrt routers (via `openwrt-imagebuilder`), packaged as a Nix flake.

### Highlights
- **macOS**: Apple Silicon setup with `nix-darwin`, `home-manager`, and `nixvim`.
- **Shells**: Zsh and Nushell with Starship; handy aliases; optional "work profile" gating via `WORK_PROFILE`.
- **Editor**: Neovim via `nixvim` (Catppuccin theme, Treesitter, LSP completion, lualine, nvim-tree, dashboard). Optional Neovide GUI.
- **macOS services**: Autokbisw (keyboard language switcher), Colima (Docker on macOS), SpoofDPI (with DoH and patterns); all toggleable.
- **Window management**: Yabai + skhd + sketchybar wiring available (disabled by default).
- **OpenWrt router**: Hermes image for Mercusys MR90X v1 with automated upgrades via `luci-app-attendedsysupgrade`.
- **PPPoE recovery**: Automatic WAN recovery after sysupgrade when PPPoE auth fails.
- **ASU Worker**: Cloudflare Worker that emulates the OpenWrt ASU API, serving prebuilt firmware metadata from GitHub Releases.
- **System tweaks**: Touch ID for sudo, Rosetta AVX advertise, curated fonts, timezone from options.

### Repository layout

```
.
├── flake.nix                 # Entry point and inputs
├── hosts/akiri/              # macOS host config
├── hosts/hermes/             # OpenWrt router image + recovery scripts
├── userConfigurations/       # Home-manager user configs
└── workers/                  # Cloudflare Workers (Hermes ASU shim)
```

## macOS (akiri)

### Prerequisites
- Install Nix or Lix (see the official guide at [nix.dev](https://nix.dev)).
- macOS on Apple Silicon (arm64).
  - Could work with Intel (x86_64) but not tested.

### Install and switch
Clone to `~/.config/nix-darwin`:

```bash
git clone <this-repo> ~/.config/nix-darwin
cd ~/.config/nix-darwin
```

First-time switch (if `nix-darwin` is not yet installed):

```bash
# If flakes aren't enabled yet, add the extra flags:
nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ~/.config/nix-darwin#akiri
```

Subsequent rebuilds:

```bash
darwin-rebuild switch --flake ~/.config/nix-darwin#akiri
# or, from this directory:
darwin-rebuild switch --flake .#akiri
# or, if you use nushell:
rebuild
```

Update flake inputs and rebuild:

```bash
nix flake update
darwin-rebuild switch --flake .#akiri
# or, if you use nushell:
rebuild
```

Rollback the last activation if needed:

```bash
darwin-rebuild switch --flake .#akiri --rollback
```

## OpenWrt (hermes)

Hermes is an OpenWrt image for the Mercusys MR90X v1 router, built with `openwrt-imagebuilder`.

### Building the image

```bash
nix build .#hermes
```

The firmware binary will be in `result/`.

### Flashing

Flash the `*-sysupgrade.bin` file via the router's web interface or `sysupgrade` command.

### Automated upgrades

The image includes `luci-app-attendedsysupgrade` preconfigured to use the custom Hermes ASU endpoint, enabling one-click firmware upgrades from LuCI.

## Hermes ASU Worker

A Cloudflare Worker that emulates the [OpenWrt ASU API](https://github.com/openwrt/asu), serving prebuilt firmware metadata from GitHub Releases instead of building images on demand.

### Why

The official ASU service builds firmware dynamically. For a single-device setup with prebuilt images from CI, this worker provides a lightweight shim that:
- Returns ASU-compatible JSON for LuCI's attended sysupgrade
- Proxies firmware downloads with proper CORS headers
- Caches metadata from GitHub Releases

### Deploying

```bash
cd workers/hermes-asu
bun install
bunx wrangler deploy
```

Configure the metadata URL and cache TTL in `wrangler.toml`:

```toml
[vars]
HERMES_METADATA_URL = "https://github.com/<user>/<repo>/releases/latest/download/hermes-latest.json"
HERMES_CACHE_TTL_SECONDS = "300"
```

### Endpoints

- `GET /health` - Health check
- `GET /json/v1/overview.json` - ASU overview
- `GET /api/v1/overview` - LuCI-compatible overview alias
- `GET /json/v1/releases/<version>/targets/<target>/<profile>.json` - Profile metadata
- `POST /api/v1/build` - Request firmware (returns immediate 200 with prebuilt image)
- `GET /api/v1/build/<hash>` - Poll build status
- `GET /store/<bin_dir>/<image>` - Proxy firmware download

## Feature toggles and customization

<details>
<summary><strong>macOS host options</strong></summary>

Edit `hosts/akiri/options.nix`:
- **Basics**: `hostName`, `userName`, `time.timeZone`, `security.sudo.touchIdAuth`
- **Services**:
  - `services.autokbisw.enable`, `services.autokbisw.startOnLogin`
  - `services.colima.enable`, `services.colima.startOnLogin`
  - `services.spoofdpi.enable`, `services.spoofdpi.enableDoh`, `services.spoofdpi.windowSize`, `services.spoofdpi.startOnLogin`, `services.spoofdpi.patterns`
- **Homebrew**: `homebrew.enable`, `homebrew.autoUpdate`, `homebrew.declarative`
- **Window management**: `yabai.enable`, `yabai.skhd.enable`, `yabai.sketchybar.enable`

</details>

<details>
<summary><strong>User options</strong></summary>

Edit `userConfigurations/<user>/options.nix`:
- `programs.zsh.enable`
- `programs.nushell.enable`
- `programs.starship.enable`
- `programs.nixvim.enable`
- `programs.neovide.enable`

</details>

<details>
<summary><strong>OpenWrt options</strong></summary>

Edit `hosts/hermes/default.nix`:
- Change `profiles.identifyProfile` for a different router
- Modify `packages.nix` to add/remove OpenWrt packages
- Adjust recovery script timeouts via uci-defaults

</details>

## Notable configurations
- **Touch ID for sudo**: enabled in `hosts/akiri/system.nix`.
- **Nix settings**: flakes enabled, weekly GC (Sunday 00:00), automatic optimisation.
- **Fonts**: JetBrains Mono Nerd Font, Hack Nerd Font, Curie.
- **Rosetta**: `ROSETTA_ADVERTISE_AVX=1` for AVX support under Rosetta.
- **Apps as .app**: integrates [`mac-app-util`](https://github.com/hraban/mac-app-util) to improve macOS app handling for Nix-installed apps.

## Helpful shell bits (Nushell)
Defined in `userConfigurations/kreato/nushell/config.nu`:
- **`rebuild`**: `darwin-rebuild switch --flake .#akiri`.
- **`clean-gc`**: `sudo nix-collect-garbage --delete-old`.
- **`shell <pkg>`**: `nix shell` helper with unfree allowed for ephemeral sessions.
- **`ksh`**: Launches an ephemeral Fedora pod in Kubernetes with flexible flags.
- **Work profile**: set `WORK_PROFILE=true` to use separate SSH known_hosts and Git SSH options.

## License
This project is licensed under **AGPL-3.0**. See [`LICENSE`](LICENSE).
