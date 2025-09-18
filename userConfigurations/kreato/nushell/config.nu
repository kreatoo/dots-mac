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

# Launch an ephemeral Fedora pod and run a command (or an interactive shell) in Kubernetes.
# - If a command is provided, it runs with: sh -c "<command>" inside the pod.
# - If no command is provided, an interactive bash shell is started.
def ksh [
    --node(-n): string # Node name to schedule the pod on (sets spec.nodeName)
    --namespace(-N): string = "default" # Kubernetes namespace to use (defaults to "default")
    --image(-i): string = "fedora:latest"  # Container image to use (defaults to "fedora:latest")
    --ipv6  # Use IPv6 only (sets spec.ipFamilyPolicy to "SingleStack" and spec.ipFamilies to ["IPv6"]) (cannot be used with --ipv4)
    --ipv4  # Use IPv4 only (sets spec.ipFamilyPolicy to "SingleStack" and spec.ipFamilies to ["IPv4"]) (cannot be used with --ipv6)
    --hostNetwork(-H)  # Use host network (sets spec.hostNetwork to true)
    ...command  # Command to run inside the pod. If omitted, starts an interactive bash shell.
] {
    let base = {
        apiVersion: "v1"
        kind: "Pod"
        spec: {
            ipFamilyPolicy: "PreferDualStack"
            ipFamilies: ["IPv4", "IPv6"]
        }
    }

    mut overrides = $base

    if $node != null {
        $overrides = $overrides | upsert spec.nodeName $node
    }
    if $ipv6 and not $ipv4 {
        $overrides = $overrides | upsert spec.ipFamilyPolicy "SingleStack" | upsert spec.ipFamilies ["IPv6"]
    }
    if $ipv4 and not $ipv6 {
        $overrides = $overrides | upsert spec.ipFamilyPolicy "SingleStack" | upsert spec.ipFamilies ["IPv4"]
    }
    if $hostNetwork {
        $overrides = $overrides | upsert spec.hostNetwork true
    }

    let overrides_json = ($overrides | to json)

    if ($command | str join " " | is-not-empty) {
        kubectl run --restart=Never --overrides=($overrides_json) --image $image --namespace $namespace --rm -ti --command -- sh -c ($command | str join " ") err> /dev/null
    } else {
        kubectl run --image $image --overrides=($overrides_json) --namespace $namespace --rm -ti -- bash #err> /dev/null
    }
}
