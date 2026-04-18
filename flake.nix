{
  description = "Will's Development System Configurations";

  nixConfig.bash-prompt-suffix = "devshell-env> ";
  # nixConfig.extra-trusted-substituters = [
  #   "https://cache.garnix.io"
  #   "https://ai.cachix.org"
  #   "https://nixpkgs-wayland.cachix.org"
  #   "https://yash-garg.cachix.org"
  #   "https://cache.nixos.org"
  #   "https://raspberry-pi-nix.cachix.org"
  #   "https://cosmic.cachix.org/"
  # ];

  # nixConfig.extra-trusted-public-keys = [
  #   "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  #   "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
  #   "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
  #   "yash-garg.cachix.org-1:sHcKOvVej+RlINvt4XVAOE/Cnho3hnrHHRv0uq1u7Xs="
  #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #   "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
  #   "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
  # ];

  inputs = {
    # keep-sorted start

    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    blueprint.url = "https://github.com/numtide/blueprint/archive/56131e8628f173d24a27f6d27c0215eff57e40dd.tar.gz";
    devshell.url = "github:numtide/devshell";
    # disko provides installTest for nixosConfiguration
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "https://github.com/nix-community/disko/archive/5ad85c82cc52264f4beddc934ba57f3789f28347.tar.gz"; # 2026-04-17
    # NOTE (@waflores - 2025-03-29): key configuration version data as follows:
    # home.stateVersion is set in: modules/home/host-shared.nix
    # system.stateVersion is set in:  hosts/*/configuration.nix
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "https://github.com/nix-community/home-manager/archive/565e5349208fe7d0831ef959103c9bafbeac0681.tar.gz"; # master - 2026-04-17
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "https://github.com/Mic92/nix-index-database/archive/bedba5989b04614fc598af9633033b95a937933f.tar.gz";
    # Framework to remotely deploy new configurations
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";
    nixos-anywhere.url = "https://github.com/nix-community/nixos-anywhere/archive/92f82c5196a5f8588be4967e535c4cfd35e85902.tar.gz";
    nixos-hardware.url = "https://github.com/NixOS/nixos-hardware/archive/c775c2772ba56e906cbeb4e0b2db19079ef11ff7.tar.gz";
    nixpkgs-git-lfs.url = "https://github.com/NixOS/nixpkgs/archive/83667ff60a88e22b76ef4b0bdf5334670b39c2b6.tar.gz"; # git-lfs 2.13
    nixpkgs-llvm_18.url = "https://github.com/NixOS/nixpkgs/archive/b5befb85475250e7849341cc2d10233415c2a528.tar.gz";
    nixpkgs.url = "https://github.com/NixOS/nixpkgs/archive/7f817b8455a1e9a944ab4392cc16c3ca36dbc83e.tar.gz"; # master - 2026-04-17
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "https://github.com/nix-community/srvos/archive/01d98209264c78cb323b636d7ab3fe8e7a8b60c7.tar.gz";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "https://github.com/numtide/treefmt-nix/archive/790751ff7fd3801feeaf96d7dc416a8d581265ba.tar.gz";
    # keep-sorted end
  }; # End inputs

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      systems = [ "x86_64-linux" ];
      nixpkgs.config.allowUnfreePredicate =
        pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [ "vscode" ];
    };
}
