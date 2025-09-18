let
  vars = import ./options.nix;
in
{
  security.pam.services.sudo_local.touchIdAuth = vars.security.sudo.touchIdAuth;
  system.defaults.CustomUserPreferences = {
  		"com.apple.security.authorization" = {
  			"ignoreArd" = true;
  		};
  	};

  # Timezone from common settings
  time.timeZone = vars.time.timeZone;

  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
