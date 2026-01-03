{
  config,
  lib,
  uopts,
  systemName,
  ...
}: {
  programs.nushell = lib.mkIf uopts.programs.nushell.enable {
    enable = true;
    shellAliases = {
      cat = "bat";
      rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin#${systemName}";
      e = "gh copilot explain";
      r = "gh copilot suggest";
      fastfetch = "hyfetch";
      neofetch = "hyfetch";
      k = "kubecolor";
      kubectl = "kubecolor";
      gc = "git commit";
      gitc = "git commit";
    };

    configFile.source = ./nushell/config.nu;

    envFile.text = ''
      for item in ["${config.home.homeDirectory}/.nix-profile/bin" "/etc/profiles/per-user/${config.home.username}/bin" "/run/current-system/sw/bin" "/nix/var/nix/profiles/default/bin" "/usr/local/bin" "/opt/homebrew/bin" "${config.home.homeDirectory}/.krew/bin"  "${config.home.homeDirectory}/.local/bin"] {
          $env.Path = ($env.Path | append $item)
      }

      $env.config.buffer_editor = "nvim"
      $env.config.show_banner = false
    '';
  };

  programs.carapace = {
      enable = lib.mkIf uopts.programs.nushell.enable true;
      enableNushellIntegration = true;
  };

  # Carapace spec to map kubecolor to kubectl completions via Cobra bridge
  # macOS uses ~/Library/Application Support/carapace/ instead of ~/.config/carapace/
  home.file."Library/Application Support/carapace/specs/kubecolor.yaml" = lib.mkIf uopts.programs.nushell.enable {
    text = ''
      name: kubecolor
      description: kubecolor wraps kubectl with colors
      completion:
        positionalany: ["$carapace.bridge.Cobra([kubecolor])"]
    '';
  };
}
