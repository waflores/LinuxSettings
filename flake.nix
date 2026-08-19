{
  description = "Will's Development System Configurations";

  nixConfig.bash-prompt-suffix = "devshell-env> ";
  inputs = {
    # keep-sorted start

    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    blueprint.url = "https://github.com/numtide/blueprint/archive/56131e8628f173d24a27f6d27c0215eff57e40dd.tar.gz";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "https://github.com/numtide/devshell/archive/255a2b1725a20d060f566e4755dbf571bbbb5f76.tar.gz";
    # disko provides installTest for nixosConfiguration
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "https://github.com/nix-community/disko/archive/ff8702b4de27f72b4c78573dfb89ec74e36abdf1.tar.gz"; # 2026-07-28
    # NOTE (@waflores - 2025-03-29): key configuration version data as follows:
    # home.stateVersion is set in: modules/home/host-shared.nix
    # system.stateVersion is set in:  hosts/*/configuration.nix
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "https://github.com/nix-community/home-manager/archive/f404edbfa4117810c96b97048299242fc50e5362.tar.gz"; # master - 2026-08-11
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "https://github.com/Mic92/nix-index-database/archive/14d55b8069119e3b88da7aa2f6c97f86a2cd3cd6.tar.gz";
    # Framework to remotely deploy new configurations
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";
    nixos-anywhere.url = "https://github.com/nix-community/nixos-anywhere/archive/036bd2423203b1432f36621404289832183cfecd.tar.gz";
    nixos-hardware.url = "https://github.com/NixOS/nixos-hardware/archive/6ed13b1d888d5cb07dbb0723eb1df86bbacd0b9c.tar.gz";
    nixpkgs-git-lfs.url = "https://github.com/NixOS/nixpkgs/archive/83667ff60a88e22b76ef4b0bdf5334670b39c2b6.tar.gz"; # git-lfs 2.13
    nixpkgs-llvm_18.url = "https://github.com/NixOS/nixpkgs/archive/b5befb85475250e7849341cc2d10233415c2a528.tar.gz";
    nixpkgs.url = "https://github.com/NixOS/nixpkgs/archive/422591dcb6727393ce7f69556ccfaa11dc850543.tar.gz"; # master - 2026-08-11
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "https://github.com/nix-community/srvos/archive/eea7edde7682348647d46e1b92ecae5c1de7da11.tar.gz";
    systems.url = "github:nix-systems/triplet";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "https://github.com/numtide/treefmt-nix/archive/ae7910970dddc408fe6ab1c8e4b277bb21d72dc0.tar.gz";

    # keep-sorted end
  }; # End inputs

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate =
        pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [ "vscode" ];
    };
}
