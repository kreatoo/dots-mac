{ hostname, username, ... }:

let
  vars = import ./options.nix;
in
{
  system.primaryUser = "${ vars.userName }";
  networking.hostName = vars.hostName;
  networking.computerName = vars.hostName;
  system.defaults.smb.NetBIOSName = vars.hostName;

  users.users."${vars.userName}" = {
    home = "/Users/${vars.userName}";
    description = vars.userName;
  };

  nix.settings.trusted-users = [ vars.userName ];
}
