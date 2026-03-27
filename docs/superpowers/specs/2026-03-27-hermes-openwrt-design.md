# Hermes OpenWrt Image Builder Design

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a reproducible OpenWrt firmware image for Mercusys MR90X v1 router using nix-openwrt-imagebuilder.

**Architecture:** Add hermes host configuration to existing nix-darwin flake. Use nix-openwrt-imagebuilder's profile detection to auto-identify target/variant. Package selection mirrors current router setup. UCI defaults script minimal since sysupgrade preserves existing config. SSH authorized keys included for immediate access.

**Tech Stack:** Nix Flakes, nix-openwrt-imagebuilder, OpenWrt 25.12.1, mediatek/filogic target

---

## Hardware Profile

- **Device:** MERCUSYS MR90X v1
- **Profile Name:** `mercusys_mr90x-v1`
- **OpenWrt Release:** 25.12.1
- **Target:** mediatek/filogic (auto-detected via profiles.identifyProfile)
- **Architecture:** aarch64_cortex-a53

---

## File Structure

```
hosts/hermes/
  packages.nix       # Extra packages list
  config.nix         # UCI defaults script derivation
  default.nix        # Image builder configuration

flake.nix            # Modified: add openwrt-imagebuilder input, hermes package output
```

---

## Flake Integration

### Input Addition

```nix
openwrt-imagebuilder = {
  url = "github:astro/nix-openwrt-imagebuilder";
};
```

### Package Output

```nix
packages.x86_64-linux.hermes = openwrt-imagebuilder.lib.build (
  profiles.identifyProfile "mercusys_mr90x-v1" // {
    packages = [ ... ];
    files = configFiles;
  }
);
```

Build system is x86_64-linux (image builder runs on build machine, produces aarch64 firmware).

---

## Package Selection

Packages beyond profile defaults (user-installed on current router):

| Package | Purpose |
|---------|---------|
| `btop` | System monitoring |
| `https-dns-proxy` | DNS-over-HTTPS proxy |
| `luci-app-https-dns-proxy` | LuCI UI for DoH |
| `luci-app-attendedsysupgrade` | Firmware upgrade via LuCI |
| `luci-app-sqm` | Smart Queue Management UI |
| `luci-app-irqbalance` | IRQ balance UI |
| `luci-ssl` | HTTPS for LuCI |
| `irqbalance` | Interrupt balancing daemon |
| `sqm-scripts` | SQM/qdisc backend |

All kernel modules, libraries, and base packages come with profile defaults.

---

## Configuration Files

### UCI Defaults Strategy

Sysupgrade preserves existing configuration (network, wireless, firewall, dhcp, credentials). UCI defaults script should be minimal - only settings that must be ensured:

- SSH authorized keys (immediate access)
- Any package-specific service enables if needed

### Files Derivation

```nix
files = pkgs.runCommand "hermes-files" {} ''
  mkdir -p $out/etc/dropbear
  cat > $out/etc/dropbear/authorized_keys <<'EOF'
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTwUZKUW4g1E9OW8kJ0bAC0uFQ5LS1a25YXhf13e7RV hi@krea.to
  EOF
  chmod 600 $out/etc/dropbear/authorized_keys
'';
```

No `/etc/uci-defaults` needed since sysupgrade preserves config. If future needs arise for forced settings, add uci-defaults script.

---

## Build and Flash Workflow

### Build Command

```bash
nix build .#hermes
```

Output: `result/openwrt-25.12.1-mediatek-filogic-mercusys_mr90x-v1-sysupgrade.bin`

### Flash Methods

1. **Attended Sysupgrade (recommended):**
   - Access LuCI at 192.168.1.1
   - Go to System → Attended Sysupgrade
   - Upload built image
   - Existing config preserved automatically

2. **Manual sysupgrade:**
   ```bash
   scp result/openwrt-*-sysupgrade.bin root@192.168.1.1:/tmp/
   ssh root@192.168.1.1 'sysupgrade -v /tmp/openwrt-*-sysupgrade.bin'
   ```

---

## Testing

After implementation:

1. Build image: `nix build .#hermes`
2. Verify output file exists and has correct naming
3. Flash via attended sysupgrade
4. Verify SSH access works with authorized key
5. Verify packages installed: `apk info -v | grep btop`
6. Verify preserved config: hostname, wireless, network settings unchanged

---

## Security Notes

- No secrets in image (sysupgrade preserves credentials)
- SSH key included for admin access
- PPPoE credentials, WiFi passwords, DHCP static leases preserved by sysupgrade