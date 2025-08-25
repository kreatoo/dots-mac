{
  config,
  pkgs,
  lib,
  ...
}:

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
  ];

  # ZSH
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.autosuggestion.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.history.path = "/Users/kreato/\${PROFILE_HISTFILE:-/.zsh_history}";
  programs.zsh.shellAliases = {
    ls = "eza";
	cat = "bat";
    e = "gh copilot explain";
    r = "gh copilot suggest";
    k = "kubecolor";
    ksh = "kubectl run --image fedora:latest --rm -ti -- bash";
    kubectl = "kubecolor";
    clean-gc = "nix-collect-garbage --delete-old && sudo nix-collect-garbage --delete-old";
  };

  programs.zsh.initContent = ''
    if [[ "$WORK_PROFILE" = "true" ]]; then  
        alias ssh="ssh -o UserKnownHostsFile=~/.ssh/known_hosts_work"
        alias scp="scp -o UserKnownHostsFile=~/.ssh/known_hosts_work"
        export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=~/.ssh/known_hosts_work"
    fi
   
    path=(
    /Users/kreato/.nix-profile/bin
    /etc/profiles/per-user/kreato/bin
    /run/current-system/sw/bin
    /nix/var/nix/profiles/default/bin
    /usr/local/bin
    /opt/homebrew/bin
    /Users/kreato/.krew/bin
    /Users/kreato/.local/bin
    $path
    )
    '';

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Nushell
  programs.nushell = {
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
        for item in ["/Users/kreato/.nix-profile/bin" "/etc/profiles/per-user/kreato/bin" "/run/current-system/sw/bin" "/nix/var/nix/profiles/default/bin" "/usr/local/bin" "/opt/homebrew/bin" "/Users/kreato/.krew/bin"  "/Users/kreato/.local/bin"] {
            $env.Path = ($env.Path | append $item)
        }

        $env.config.buffer_editor = "nvim"
        $env.config.show_banner = false
    '';
  };

  home.file."./.config/sketchybar/" = {
  	source = ./sketchybar;
	recursive = true;
  };

  programs.neovide = {
      enable = true;
      settings = {
          wsl = false;
      };
  };

  
  imports = [ ./neovim.nix ];
}
