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
      inputs.cl-nix-lite.url = "github:kreatoo/cl-nix-lite/url-fix";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-2511 = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    openwrt-imagebuilder = {
      url = "github:astro/nix-openwrt-imagebuilder";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-2511,
      mac-app-util,
      nixvim,
      jovian,
      openwrt-imagebuilder,
      ...
    }:
    let
      systemName = "akiri";
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#akiri
      darwinConfigurations.${systemName} = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit nixpkgs-2511; };
        modules = [
          #mac-app-util.darwinModules.default
          ./hosts/akiri/apps.nix
          ./hosts/akiri/homebrew.nix
          ./hosts/akiri/nix.nix
          ./hosts/akiri/system.nix
          ./hosts/akiri/users.nix
          ./hosts/akiri/yabai.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.sharedModules = [
              #mac-app-util.homeManagerModules.default
              nixvim.homeModules.nixvim
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kreato = import ./userConfigurations/kreato/main.nix;
            home-manager.extraSpecialArgs = {
              inherit systemName;
            };
          }
        ];
      };

      # Build NixOS flake using:
      # $ sudo nixos-rebuild build --flake .#ludus
      nixosConfigurations.ludus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          jovian.nixosModules.jovian
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kreato = import ./userConfigurations/ludus/kreato/main.nix;
          }
          ./hosts/ludus/system.nix
          ./hosts/ludus/users.nix
          ./hosts/ludus/jovian.nix
          {
            nixpkgs.overlays = [ jovian.overlays.default ];
          }
        ];
      };

      packages.x86_64-linux.hermes = import ./hosts/hermes {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inherit openwrt-imagebuilder;
      };
    };
}
