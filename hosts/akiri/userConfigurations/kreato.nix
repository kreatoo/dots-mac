{ config, pkgs, lib, ... }:

{
    home-manager.users.kreato = {
        home.stateVersion = "24.05";

        programs.bash.enable = true;
    };
}
