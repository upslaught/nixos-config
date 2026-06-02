{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # plasma-manager = {
    #   url = "github:nix-community/plasma-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";
  };

  outputs = inputs @ { flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        nixosConfigurations =
          let
            mkHost = { hostname, username, stateVersion }: nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs hostname username stateVersion; };
              modules = [
                inputs.disko.nixosModules.disko
                inputs.preservation.nixosModules.preservation
                inputs.stylix.nixosModules.stylix
                inputs.home-manager.nixosModules.home-manager
                ./hosts/${hostname}
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = { inherit inputs username stateVersion; };
                    users.${username} = import ./home.nix;
                    # sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
                  };
                }
              ];
            };
          in
            {
              desktop = mkHost {
                hostname = "desktop";
                username = "dima";
                stateVersion = "26.05";
              };
            };
      };

      perSystem = { pkgs, ... }: {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ alejandra nixd ];
        };
      };
    };
}

