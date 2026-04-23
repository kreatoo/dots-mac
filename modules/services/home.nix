{
  pkgs,
  lib,
  nixpkgs-2511,
  ...
}:
let
  vars = import ../../hosts/akiri/options.nix;
  pkgs-2511 = nixpkgs-2511.legacyPackages.${pkgs.system};
  spoofdpiArgsList =
    (lib.optionals vars.services.spoofdpi.enableDoh [ "-enable-doh" ])
    ++ [ "-window-size ${toString vars.services.spoofdpi.windowSize}" ]
    ++ (map (p: "-pattern '\\b${p}\\b'") vars.services.spoofdpi.patterns);
  spoofdpiArgs = lib.concatStringsSep " " spoofdpiArgsList;
in
{
  launchd.user.agents = lib.mkMerge [
    (lib.mkIf vars.services.spoofdpi.enable {
      spoofdpi = {
        command = "${pkgs-2511.spoofdpi}/bin/spoofdpi ${spoofdpiArgs}";
        serviceConfig = {
          RunAtLoad = vars.services.spoofdpi.startOnLogin;
          KeepAlive = true;
          StandardOutPath = "/dev/null";
          StandardErrorPath = "/dev/null";
        };
      };
    })
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
