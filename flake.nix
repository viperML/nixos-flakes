{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs self;};
      pkgs = self.legacyPackages."x86_64-linux";
      modules = [
        ./nixosModules/configuration.nix
        ./nixosModules/hardware-configuration.nix
        ./nixosModules/channels-to-flakes.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [
            ./homeModules/home.nix
          ];
        }
      ];
    };

    legacyPackages."x86_64-linux" = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
      overlays = [
        (import ./overlay)
      ];
    };

    # Export some modules to be used by others
    nixosModules = {
      channels-to-flakes = import ./nixosModules/channels-to-flakes.nix;
    };
    homeModules = {
      channels-to-flakes = import ./homeModules/channels-to-flakes.nix;
    };

    devShells."x86_64-linux".default = self.legacyPackages."x86_64-linux".callPackage ./bootstrap {};
  };
}
