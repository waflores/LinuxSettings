{
  description = "Will's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO(@waflores) 2024-10-04: We should create a hosts folder to determine which hosts can do what

  outputs = { self, nixpkgs, home-manager }:
    let
      # Values you should modify
      username = "change-me-plz"; # $USER
      system = "x86_64-linux"; # x86_64-linux, aarch64-multiplatform, etc.
      stateVersion =
        "24.05"; # See https://nixos.org/manual/nixpkgs/stable for most recent

      pkgs = import nixpkgs {
        inherit system;

        config = { allowUnfree = true; };
      };

      homeDirPrefix =
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      homeDirectory = "/${homeDirPrefix}/${username}";

      home = (import ./home.nix {
        inherit homeDirectory pkgs stateVersion system username;
      });
    in {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;

      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ home ];
        };
    };
}

# TODO(@waflores) 2024-10-23: Check these links:
# https://github.com/Misterio77/nix-starter-configs
# https://github.com/misterio77/nix-config
# https://github.com/the-nix-way/home-manager-config-template
