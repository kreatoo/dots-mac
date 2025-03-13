{
  description = "nix-darwin system flake";

  inputs = {
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      mac-app-util,
      nixvim,
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#akiri
      darwinConfigurations."akiri" = nix-darwin.lib.darwinSystem {
        modules = [
          mac-app-util.darwinModules.default
          ./hosts/akiri/apps.nix
          ./hosts/akiri/nix.nix
          ./hosts/akiri/system.nix
          ./hosts/akiri/users.nix
		  ./hosts/akiri/yabai.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
                nixvim.homeManagerModules.nixvim
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kreato = import ./hosts/akiri/userConfigurations/kreato/main.nix;
          }
        ];
      };
    };
}
