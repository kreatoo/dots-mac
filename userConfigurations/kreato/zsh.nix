{
  config,
  lib,
  uopts,
  ...
}: {
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
}
