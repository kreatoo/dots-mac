# Hermes OpenWrt Image Builder Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add hermes host configuration to build reproducible OpenWrt firmware for Mercusys MR90X v1 router.

**Architecture:** Add openwrt-imagebuilder flake input, create hosts/hermes directory with package list and image config, output firmware image as flake package.

**Tech Stack:** Nix Flakes, nix-openwrt-imagebuilder, OpenWrt 25.12.1

---

## File Structure

| File | Purpose |
|------|---------|
| `hosts/hermes/packages.nix` | Extra packages list for image |
| `hosts/hermes/default.nix` | Image builder config + SSH keys derivation |
| `flake.nix` (modify) | Add openwrt-imagebuilder input, hermes package output |

---

## Prerequisites

**Reference spec:** `docs/superpowers/specs/2026-03-27-hermes-openwrt-design.md`

---

### Task 1: Create packages.nix

**Files:**
- Create: `hosts/hermes/packages.nix`

- [ ] **Step 1: Create packages.nix with package list**

```nix
[
  "btop"
  "https-dns-proxy"
  "luci-app-https-dns-proxy"
  "luci-app-attendedsysupgrade"
  "luci-app-sqm"
  "luci-app-irqbalance"
  "luci-ssl"
  "irqbalance"
  "sqm-scripts"
]
```

- [ ] **Step 2: Commit**

```bash
git add hosts/hermes/packages.nix
git commit -m "feat(hermes): add packages list"
```

---

### Task 2: Create default.nix with image config

**Files:**
- Create: `hosts/hermes/default.nix`

- [ ] **Step 1: Create default.nix with image builder configuration**

```nix
{
  pkgs,
  openwrt-imagebuilder,
}:

let
  profiles = openwrt-imagebuilder.lib.profiles { inherit pkgs; };
  packages = import ./packages.nix;

  files = pkgs.runCommand "hermes-files" {} ''
    mkdir -p $out/etc/dropbear
    cat > $out/etc/dropbear/authorized_keys <<'EOF'
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTwUZKUW4g1E9OW8kJ0bAC0uFQ5LS1a25YXhf13e7RV hi@krea.to
    EOF
    chmod 600 $out/etc/dropbear/authorized_keys
  '';

in
openwrt-imagebuilder.lib.build (
  profiles.identifyProfile "mercusys_mr90x-v1" // {
    inherit packages files;
  }
)
```

- [ ] **Step 2: Commit**

```bash
git add hosts/hermes/default.nix
git commit -m "feat(hermes): add image builder configuration"
```

---

### Task 3: Modify flake.nix

**Files:**
- Modify: `flake.nix` (lines 4-46 for inputs, lines 48-106 for outputs)

- [ ] **Step 1: Add openwrt-imagebuilder input**

Add after line 44 (after `nixpkgs-2511` input block):

```nix
    openwrt-imagebuilder = {
      url = "github:astro/nix-openwrt-imagebuilder";
    };
```

- [ ] **Step 2: Add hermes package output**

Modify outputs function to include `openwrt-imagebuilder` in inputs attrset and add package output.

Change line 48-58 to:

```nix
  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-2511,
      mac-app-util,
      nixvim,
      jovian,
      openwrt-imagebuilder,
      ...
    }:
```

Add after line 105 (after `nixosConfigurations.ludus` block, before closing brace):

```nix

      packages.x86_64-linux.hermes = import ./hosts/hermes {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inherit openwrt-imagebuilder;
      };
```

- [ ] **Step 3: Verify flake syntax**

```bash
nix flake check --no-build
```

Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add flake.nix
git commit -m "feat(hermes): add openwrt-imagebuilder input and package output"
```

---

### Task 4: Build and verify image

- [ ] **Step 1: Build hermes image**

```bash
nix build .#hermes
```

Expected: Build completes without errors, produces `result/` symlink

- [ ] **Step 2: Verify output file exists**

```bash
ls -la result/
```

Expected: File named `openwrt-*-sysupgrade.bin` present

- [ ] **Step 3: Check file details**

```bash
file result/openwrt-*-sysupgrade.bin
```

Expected: Shows as data or squashfs image

---

### Task 5: Final commit

- [ ] **Step 1: Ensure all changes committed**

```bash
git status
```

Expected: Clean working tree

---

## Summary

Total: 5 tasks, ~10 steps

Build command: `nix build .#hermes`
Output: OpenWrt sysupgrade image for Mercusys MR90X v1