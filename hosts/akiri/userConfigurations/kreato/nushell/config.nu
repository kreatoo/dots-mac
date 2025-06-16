if $env.WORK_PROFILE? == true {
    alias ssh = ssh -o UserKnownHostsFile=~/.ssh/known_hosts_work
    alias scp = scp -o UserKnownHostsFile=~/.ssh/known_hosts_work
    $env.GIT_SSH_COMMAND = "ssh -o UserKnownHostsFile=~/.ssh/known_hosts_work"
    #$env.config.history_file = $"($env.HOME)/.local/share/work_history"
    #} else {
    #$env.config.history_file = $"($env.HOME)/.local/share/history"
}

def clean-gc [] {
    sudo nix-collect-garbage --delete-old
}

def shell [package] {
    $env.NIX_ALLOW_UNFREE = 1
    nix shell --impure nixpkgs#($package)
}
