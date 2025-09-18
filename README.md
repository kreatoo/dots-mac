<p align="center">
  <img src="https://raw.githubusercontent.com/yunfachi/NixOwOS/master/assets/nixowos-snowflake-colours.svg" width="250px" alt="NixOwOS logo">
</p>

## my macOS dotfiles with nix-darwin + home-manager

Declarative macOS setup for Apple Silicon using `nix-darwin` and `home-manager`, packaged as a flake.
The current host is `akiri` for user `kreato`.

### Highlights
- **Shells**: Zsh and Nushell with Starship; handy aliases; optional "work profile" gating via `WORK_PROFILE`.
- **Editor**: Neovim via `nixvim` (Catppuccin theme, Treesitter, LSP completion, lualine, nvim-tree, dashboard). Optional Neovide GUI.
- **Launch agents**: Autokbisw (Keyboard language switcher), Colima (Docker on macOS), SpoofDPI (with DoH and patterns); all toggleable.
- **Window management**: Yabai + skhd + sketchybar wiring available (disabled by default). More coming soon.
- **System tweaks**: Touch ID for sudo, Rosetta AVX advertise, curated fonts (JetBrains Mono Nerd Font, Hack Nerd Font, Curie), timezone from options.

### Repository layout
| Path | Purpose |
| - | - |
| `flake.nix` | Inputs (`nixpkgs-unstable`, `nix-darwin`, `home-manager`, `nixvim`, `treefmt-nix`, `mac-app-util`) and `darwinConfigurations.akiri` module stack. |
| `hosts/akiri/options.nix` | Central host options and feature toggles (hostname, username, time, services, Homebrew, Yabai). |
| `hosts/akiri/system.nix` | System defaults (Touch ID sudo, timezone, platform, stateVersion). |
| `hosts/akiri/nix.nix` | Nix settings (flakes, GC schedule, optimise, package pin). |
| `hosts/akiri/apps.nix` | Fonts, environment variables, system packages, launchd agents for Autokbisw, Colima, SpoofDPI. |
| `hosts/akiri/homebrew.nix` | Homebrew taps/casks; supports declarative cleanup. |
| `hosts/akiri/users.nix` | Primary user, host/computer name, SMB NetBIOS, trusted Nix users. |
| `hosts/akiri/yabai.nix` | Yabai/skhd/sketchybar toggles and configs (disabled by default). |
| `hosts/akiri/userConfigurations/kreato/main.nix` | Home-manager entry (packages; shells; Starship; Nushell config/env; conditional Nixvim import). |
| `hosts/akiri/userConfigurations/kreato/options.nix` | Per-user feature toggles (zsh, nushell, starship, nixvim, neovide). |
| `hosts/akiri/userConfigurations/kreato/neovim.nix` | Detailed `nixvim` setup (Catppuccin, Treesitter, cmp, lualine, nvim-tree, dashboard; Avante disabled). |
| `hosts/akiri/userConfigurations/kreato/nushell/config.nu` | Functions/aliases (`clean-gc`, `shell`, `ksh`), optional work profile SSH handling. |

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

<details>
<summary><strong>Feature toggles and customization</strong></summary>

- **Host options (edit `hosts/akiri/options.nix`)**:
  - **Basics**:
    - `hostName` (string)
    - `userName` (string)
    - `time.timeZone` (string)
    - `security.sudo.touchIdAuth` (bool)
  - **Services**:
    - `services.autokbisw.enable` (bool), `services.autokbisw.startOnLogin` (bool)
    - `services.colima.enable` (bool), `services.colima.startOnLogin` (bool)
    - `services.spoofdpi.enable` (bool), `services.spoofdpi.enableDoh` (bool), `services.spoofdpi.windowSize` (int), `services.spoofdpi.startOnLogin` (bool)
    - `services.spoofdpi.patterns` (list of strings; regex word-boundary matched)
  - **Homebrew**:
    - `homebrew.enable` (bool), `homebrew.autoUpdate` (bool), `homebrew.declarative` (bool; controls cleanup mode)
  - **Window management**:
    - `yabai.enable` (bool), `yabai.skhd.enable` (bool), `yabai.sketchybar.enable` (bool)
- **User options (edit `hosts/akiri/userConfigurations/kreato/options.nix`)**:
  - `programs.zsh.enable`, `programs.nushell.enable`, `programs.starship.enable`, `programs.nixvim.enable`, `programs.neovide.enable`
- **Lists you can customize**:
  - `hosts/akiri/options.nix`: `services.spoofdpi.patterns` (list of domains/keywords)
  - `hosts/akiri/apps.nix`:
    - `fonts.packages` (list)
    - `environment.systemPackages` (list)
  - `hosts/akiri/homebrew.nix`:
    - `homebrew.taps` (list)
    - `homebrew.casks` (list)
  - `hosts/akiri/userConfigurations/kreato/main.nix`:
    - `home.packages` (list)
- **Neovim**: customize plugins in `hosts/akiri/userConfigurations/kreato/neovim.nix`.

Example: add a SpoofDPI site pattern in `hosts/akiri/options.nix`:

```nix
services.spoofdpi.patterns = [
  "discord"
  "your-new-domain"
];
```

</details>

### Notable configurations
- **Touch ID for sudo**: enabled in `hosts/akiri/system.nix`.
- **Nix settings**: flakes enabled, weekly GC (Sunday 00:00), automatic optimisation.
- **Fonts**: JetBrains Mono Nerd Font, Hack Nerd Font, Curie.
- **Rosetta**: `ROSETTA_ADVERTISE_AVX=1` for AVX support under Rosetta.
- **Apps as .app**: integrates [`mac-app-util`](https://github.com/hraban/mac-app-util) to improve macOS app handling for Nix-installed apps.

### Helpful shell bits (Nushell)
Defined in `hosts/akiri/userConfigurations/kreato/nushell/config.nu`:
- **`rebuild`**: `darwin-rebuild switch --flake .#akiri`.
- **`clean-gc`**: `sudo nix-collect-garbage --delete-old`.
- **`shell <pkg>`**: `nix shell` helper with unfree allowed for ephemeral sessions.
- **`ksh`**: Launches an ephemeral Fedora pod in Kubernetes with flexible flags (node, namespace, IP family, host network).
- **Work profile**: set `WORK_PROFILE=true` to use separate SSH known_hosts and Git SSH options.

### License
This project is licensed under **AGPL-3.0**. See `LICENSE`.
