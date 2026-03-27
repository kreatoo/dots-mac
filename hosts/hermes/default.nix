{
  pkgs,
  openwrt-imagebuilder,
}:

let
  profiles = openwrt-imagebuilder.lib.profiles { inherit pkgs; };
  packages = import ./packages.nix;

  files = pkgs.runCommand "hermes-files" { } ''
    mkdir -p $out/etc/dropbear
    cat > $out/etc/dropbear/authorized_keys <<'EOF'
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTwUZKUW4g1E9OW8kJ0bAC0uFQ5LS1a25YXhf13e7RV hi@krea.to
    EOF
    chmod 600 $out/etc/dropbear/authorized_keys
  '';

in
openwrt-imagebuilder.lib.build (
  profiles.identifyProfile "mercusys_mr90x-v1"
  // {
    inherit packages files;
  }
)
