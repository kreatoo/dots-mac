{ 
  config,
  pkgs,
  lib,
  ...
}:
let
  uopts = import ./options.nix;
in
{
  home.stateVersion = "24.11";

  # Packages
  home.packages = with pkgs; [
    nodejs
    fzf
    luarocks
    nixfmt-rfc-style
    hyfetch
    talosctl
    opentofu
    kubecolor
    kubectl
    kubectl-klock
    sbarlua
  ];

  # ZSH (gated by user options)
  programs.zsh = lib.mkIf uopts.programs.zsh.enable {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.path = "${config.home.homeDirectory}/\${PROFILE_HISTFILE:-/.zsh_history}";
    shellAliases = {
      ls = "eza";
      cat = "bat";
      e = "gh copilot explain";
      r = "gh copilot suggest";
      k = "kubecolor";
      ksh = "kubectl run --image fedora:latest --rm -ti -- bash";
      kubectl = "kubecolor";
      clean-gc = "nix-collect-garbage --delete-old && sudo nix-collect-garbage --delete-old";
    };
    initContent = ''
      if [[ "$WORK_PROFILE" = "true" ]]; then  
          alias ssh="ssh -o UserKnownHostsFile=~/.ssh/known_hosts_work"
          alias scp="scp -o UserKnownHostsFile=~/.ssh/known_hosts_work"
          export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=~/.ssh/known_hosts_work"
      fi
     
      path=(
      ${config.home.homeDirectory}/.nix-profile/bin
      /etc/profiles/per-user/${config.home.username}/bin
      /run/current-system/sw/bin
      /nix/var/nix/profiles/default/bin
      /usr/local/bin
      /opt/homebrew/bin
      ${config.home.homeDirectory}/.krew/bin
      ${config.home.homeDirectory}/.local/bin
      $path
      )
      '';
  };

  # Starship (gated)
  programs.starship = lib.mkIf uopts.programs.starship.enable {
    enable = true;
    enableZshIntegration = uopts.programs.zsh.enable;
  };

  # Nushell (gated)
  programs.nushell = lib.mkIf uopts.programs.nushell.enable {
    enable = true;
    shellAliases = {
      cat = "bat";
      rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin#akiri";
      e = "gh copilot explain";
      r = "gh copilot suggest";
      fastfetch = "hyfetch";
      neofetch = "hyfetch";
      k = "kubecolor";
      kubectl = "kubecolor";
    };

    configFile = {
      source = ./nushell/config.nu;
    };

    envFile.text = ''
      for item in ["${config.home.homeDirectory}/.nix-profile/bin" "/etc/profiles/per-user/${config.home.username}/bin" "/run/current-system/sw/bin" "/nix/var/nix/profiles/default/bin" "/usr/local/bin" "/opt/homebrew/bin" "${config.home.homeDirectory}/.krew/bin"  "${config.home.homeDirectory}/.local/bin"] {
          $env.Path = ($env.Path | append $item)
      }

      $env.config.buffer_editor = "nvim"
      $env.config.show_banner = false
    '';
  };

  programs.neovide = lib.mkIf uopts.programs.neovide.enable {
    enable = true;
    settings = {
      wsl = false;
    };
  };

  
  imports = lib.optionals uopts.programs.nixvim.enable [ ./neovim.nix ];
}
