{
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.CustomUserPreferences = {
  		"com.apple.security.authorization" = {
  			"ignoreArd" = true;
		};
	};
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
