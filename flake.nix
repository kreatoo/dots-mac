{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
      # Ensure mac-app-util's treefmt-nix also follows our root nixpkgs
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      mac-app-util,
      nixvim,
      ...
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#akiri
      darwinConfigurations."akiri" = nix-darwin.lib.darwinSystem {
        modules = [
          mac-app-util.darwinModules.default
          ./hosts/akiri/apps.nix
          ./hosts/akiri/homebrew.nix
          ./hosts/akiri/nix.nix
          ./hosts/akiri/system.nix
          ./hosts/akiri/users.nix
		  ./hosts/akiri/yabai.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
                nixvim.homeModules.nixvim
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kreato = import ./hosts/akiri/userConfigurations/kreato/main.nix;
          }
        ];
      };
    };
}
