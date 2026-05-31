{
  pkgs,
  lib,
  ...
}:
let
  vars = import ../../hosts/akiri/options.nix;
in
{
  launchd.user.agents = lib.mkMerge [
    (lib.mkIf vars.services.ollama.enable {
      ollama = {
        command = "${pkgs.ollama}/bin/ollama serve";
        serviceConfig = {
          RunAtLoad = vars.services.ollama.startOnLogin;
          KeepAlive = true;
          StandardOutPath = "/dev/null";
          StandardErrorPath = "/dev/null";
        };
      };
    })
    (lib.mkIf vars.services.lmstudio.enable {
      lmstudio = {
        command = "/Applications/LM\\ Studio.app/Contents/Resources/app/.webpack/lms daemon up && /Applications/LM\\ Studio.app/Contents/Resources/app/.webpack/lms server start --port ${toString vars.services.lmstudio.port}";
        serviceConfig = {
          RunAtLoad = vars.services.lmstudio.startOnLogin;
          KeepAlive = true;
          StandardOutPath = "/tmp/lmstudio.log";
          StandardErrorPath = "/tmp/lmstudio.log";
          EnvironmentVariables = {
            LM_STUDIO_MODELS_PATH = vars.services.lmstudio.modelDir;
          };
        };
      };
    })
  ];
}
