{ pkgs, lib, ... }:
let
  vars = import ../../hosts/akiri/options.nix;
in
{
  launchd.user.agents = lib.mkIf vars.services.colima.enable {
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
  };
}
