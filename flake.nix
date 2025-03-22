# Nix-based Home Manager Configuration
# This configuration will setup the following:
#   - vimrc
#   - gitconfig
#   - bash settings
# We should have the bashrc configure colors based on hostnames.
{
  description = "Will's Development System Configurations";

  nixConfig.bash-prompt-suffix = "devshell-env> ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    blueprint = {
      url = "github:numtide/blueprint/7ae8756a68c662d551e354beb537f365b80e5108";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NOTE(@waflores) 2024-11-26: pin the git-lfs for our BitBucket server.
    nixpkgs-git-lfs.url = "github:NixOS/nixpkgs/83667ff60a88e22b76ef4b0bdf5334670b39c2b6";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix/adc195eef5da3606891cedf80c0d9ce2d3190808";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }; # End inputs

  outputs =
    {
      nixpkgs,
      home-manager,
      treefmt-nix,
      ...
    }:
    let
      # Values you should modify
      username = "will"; # $USER

      # There's some hosts where our username is not the same.
      system = "x86_64-linux";

      # See https://nixos.org/manual/nixpkgs/stable for most recent
      stateVersion = "24.11";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [ ];
      };

      homeDirectory = "/home/${username}";

      home = import ./home.nix {
        inherit
          homeDirectory
          pkgs
          stateVersion
          system
          username
          ;
      };

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {

      formatter.${system} = treefmtEval.config.build.wrapper;

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ home ];
      };

      devShells.${system}.default = pkgs.callPackage ./shell.nix {
        packages = [
          pkgs.shellcheck
        ];
      };

    };
}

# TODO(@waflores) 2024-10-23: Check these links:
# https://github.com/Misterio77/nix-starter-configs
# https://github.com/misterio77/nix-config
# https://github.com/the-nix-way/home-manager-config-template
