{
  description = "Will's Development System Configurations";

  nixConfig.bash-prompt-suffix = "devshell-env> ";
  nixConfig.extra-trusted-substituters = [
    "https://cache.garnix.io"
    "https://ai.cachix.org"
    "https://nixpkgs-wayland.cachix.org"
    "https://yash-garg.cachix.org"
    "https://cache.nixos.org"
    "https://raspberry-pi-nix.cachix.org"
    "https://cosmic.cachix.org/"
  ];

  nixConfig.extra-trusted-public-keys = [
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    "yash-garg.cachix.org-1:sHcKOvVej+RlINvt4XVAOE/Cnho3hnrHHRv0uq1u7Xs="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
    "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
  ];

  inputs = {
    # keep-sorted start
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    blueprint.url = "https://github.com/numtide/blueprint/archive/7ae8756a68c662d551e354beb537f365b80e5108.tar.gz";
    # NOTE (@waflores - 2025-03-29): key configuration version data as follows:
    # home.stateVersion is set in: modules/home/host-shared.nix
    # system.stateVersion is set in:  hosts/*/configuration.nix
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "https://github.com/nix-community/home-manager/archive/693840c01b9bef9e54100239cef937e53d4661bf.tar.gz"; # 25.05 - 2025-03-26
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "https://github.com/Mic92/nix-index-database/archive/b3696bfb6c24aa61428839a99e8b40c53ac3a82d.tar.gz";
    # Framework to remotely deploy new configurations
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";
    nixos-anywhere.url = "https://github.com/nix-community/nixos-anywhere/archive/d48c8a01968afc8870b5afcba43b7739c943f7f8.tar.gz";
    nixos-hardware.url = "https://github.com/NixOS/nixos-hardware/archive/de6fc5551121c59c01e2a3d45b277a6d05077bc4.tar.gz";
    nixpkgs-git-lfs.url = "https://github.com/NixOS/nixpkgs/archive/83667ff60a88e22b76ef4b0bdf5334670b39c2b6.tar.gz"; # git-lfs 2.13
    nixpkgs-llvm_18.url = "https://github.com/NixOS/nixpkgs/archive/b5befb85475250e7849341cc2d10233415c2a528.tar.gz";
    nixpkgs.url = "https://github.com/NixOS/nixpkgs/archive/b107b36e150478e05bd06d50bcc4f2218df0257f.tar.gz"; # 25.05 - 2025-03-26
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "https://github.com/nix-community/srvos/archive/7a4dc5c1112b2cde72ab05f70f522cfecb9c48d1.tar.gz";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "https://github.com/numtide/treefmt-nix/archive/adc195eef5da3606891cedf80c0d9ce2d3190808.tar.gz";

    # keep-sorted end
  }; # End inputs

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      nixpkgs.config.allowUnfreePredicate =
        pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [ "vscode" ];
      systems = [ "x86_64-linux" ];
    };
}
