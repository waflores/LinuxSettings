{
  description = "Will's Development System Configurations";

  nixConfig.bash-prompt-suffix = "devshell-env> ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/2bcb5a3c7cc0d62862f7d5f6ab6c589adac106fe";  # 24.11
    # nixpkgs.url = "https://github.com/NixOS/nixpkgs/archive/2bcb5a3c7cc0d62862f7d5f6ab6c589adac106fe.tar.gz"
    blueprint = {
      url = "github:numtide/blueprint/7ae8756a68c662d551e354beb537f365b80e5108";
      # url = "https://github.com/numtide/blueprint/archive/7ae8756a68c662d551e354beb537f365b80e5108.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/0948aeedc296f964140d9429223c7e4a0702a1ff";  # 24.11
      # url = "https://github.com/nix-community/home-manager/archive/0948aeedc296f964140d9429223c7e4a0702a1ff.tar.gz";  # 24.11
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NOTE(@waflores) 2024-11-26: pin the git-lfs for our BitBucket server.
    nixpkgs-git-lfs.url = "github:NixOS/nixpkgs/83667ff60a88e22b76ef4b0bdf5334670b39c2b6";
    # nixpkgs-git-lfs.url = "https://github.com/NixOS/nixpkgs/archive/83667ff60a88e22b76ef4b0bdf5334670b39c2b6.tar.gz";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix/adc195eef5da3606891cedf80c0d9ce2d3190808";
      # url = "https://github.com/numtide/treefmt-nix/archive/adc195eef5da3606891cedf80c0d9ce2d3190808.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }; # End inputs

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      systems = [ "x86_64-linux" ];
    };
}

# TODO(@waflores) 2024-10-23: Check these links:
# https://github.com/Misterio77/nix-starter-configs
# https://github.com/misterio77/nix-config
# https://github.com/the-nix-way/home-manager-config-template
