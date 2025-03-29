{
  description = "Will's Development System Configurations";

  nixConfig.bash-prompt-suffix = "devshell-env> ";

  inputs = {
    nixpkgs.url = "https://github.com/NixOS/nixpkgs/archive/b107b36e150478e05bd06d50bcc4f2218df0257f.tar.gz"; # 25.05 - 2025-03-26
    blueprint = {
      url = "https://github.com/numtide/blueprint/archive/7ae8756a68c662d551e354beb537f365b80e5108.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NOTE (@waflores - 2025-03-29): key configuration version data as follows:
    # home.stateVersion is set in: modules/home/host-shared.nix
    # system.stateVersion is set in:  hosts/*/configuration.nix
    home-manager = {
      url = "https://github.com/nix-community/home-manager/archive/693840c01b9bef9e54100239cef937e53d4661bf.tar.gz"; # 25.05 - 2025-03-26
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-git-lfs.url = "https://github.com/NixOS/nixpkgs/archive/83667ff60a88e22b76ef4b0bdf5334670b39c2b6.tar.gz"; # git-lfs 2.13
    nixpkgs-llvm_18.url = "https://github.com/NixOS/nixpkgs/archive/b5befb85475250e7849341cc2d10233415c2a528.tar.gz";

    treefmt-nix = {
      url = "https://github.com/numtide/treefmt-nix/archive/adc195eef5da3606891cedf80c0d9ce2d3190808.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }; # End inputs

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      nixpkgs.config.allowUnfree = true;
      # TODO(@waflores - 2025-03-28): figure out how to deal with backing up automatically our config
      systems = [ "x86_64-linux" ];
    };
}

# TODO(@waflores) 2024-10-23: Check these links:
# https://github.com/Misterio77/nix-starter-configs
# https://github.com/misterio77/nix-config
# https://github.com/the-nix-way/home-manager-config-template
