{ config, lib, uopts, ... }:

lib.mkIf uopts.programs.opnix.enable {
  programs.onepassword-secrets = {
    enable = true;
    tokenFile = "${config.home.homeDirectory}/.config/opnix/token";

    secrets = {
      crofApiKey = {
        reference = "op://Nix/OpenCode/crof-api-key";
        path = ".config/opencode/crof-api-key";
        mode = "0600";
      };

      githubPat = {
        reference = "op://Nix/OpenCode/github-pat";
        path = ".config/opencode/github-pat";
        mode = "0600";
      };

      crofApiKeyLibreTurks = {
        reference = "op://Nix/OpenCode/crof-api-key-libreturks";
        path = ".config/opencode/crof-api-key-libreturks";
        mode = "0600";
      };

      commandcodeApiKey = {
        reference = "op://Nix/OpenCode/commandcode-api-key";
        path = ".config/opencode/commandcode-api-key";
        mode = "0600";
      };
    };
  };
}
