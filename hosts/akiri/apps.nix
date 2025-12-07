{ pkgs, lib, ... }:
let
  vars = import ./options.nix;
  spoofdpiArgsList =
    (lib.optionals vars.services.spoofdpi.enableDoh [ "-enable-doh" ])
    ++ [ "-window-size ${toString vars.services.spoofdpi.windowSize}" ]
    ++ (map (p: "-pattern '\\b${p}\\b'") vars.services.spoofdpi.patterns);
  spoofdpiArgs = lib.concatStringsSep " " spoofdpiArgsList;
in
{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    curie
  ];
    
  environment.variables = {
      ROSETTA_ADVERTISE_AVX = "1";
  };

  environment.systemPackages = with pkgs; [
    # CLI (platform-specific or macOS-only)
    spoofdpi
    autokbisw
    colima

    # GUI apps
    google-chrome
    gzdoom
    cyberduck
    scrcpy
    vscode
    localsend
    prismlauncher
    alt-tab-macos
    audacity
    #ice-bar
    iina
    utm
    rectangle
    #soundsource
    the-unarchiver
    mos
    upscayl
    moonlight-qt
    youtube-music
    #signal-desktop
  ];

  # Launchd
  launchd = {
    user = {
      agents = lib.mkMerge [
        (lib.mkIf vars.services.autokbisw.enable {
          autokbisw = {
            command = "${pkgs.autokbisw}/bin/autokbisw --verbose";
            serviceConfig = {
              RunAtLoad = vars.services.autokbisw.startOnLogin;
              KeepAlive = true;
              StandardOutPath = "/tmp/autokbisw.log";
              StandardErrorPath = "/tmp/autokbisw.log";
            };
          };
        })
        (lib.mkIf vars.services.colima.enable {
          # Colima (Docker on macOS)
          colima = {
            command = "${pkgs.colima}/bin/colima start --memory ${vars.services.colima.options.memory} --foreground";
            serviceConfig = {
              Label = "com.colima.default";
              RunAtLoad = vars.services.colima.startOnLogin;
              KeepAlive = true;
              StandardOutPath = "/dev/null";
              StandardErrorPath = "/dev/null";
              EnvironmentVariables = {
                PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
              };
            };
          };
        })
        (lib.mkIf vars.services.spoofdpi.enable {
          # SpoofDPI (DPI spoofing)
          spoofdpi = {
            command = "${pkgs.spoofdpi}/bin/spoofdpi ${spoofdpiArgs}";
            serviceConfig = {
              RunAtLoad = vars.services.spoofdpi.startOnLogin;
              KeepAlive = true;
              StandardOutPath = "/dev/null";
              StandardErrorPath = "/dev/null";
            };
          };
        })
        (lib.mkIf vars.services.ollama.enable {
            # Ollama (Running LLMs)
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
      ];
    };
  };
}
