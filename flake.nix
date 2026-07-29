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
    home-manager.url = "https://github.com/nix-community/home-manager/archive/36662afed2fa1c9b69bdd03edb92ad572202ca20.tar.gz"; # master - 2026-07-28
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "https://github.com/Mic92/nix-index-database/archive/11665045df8b9938ef811a3bfdc65cffb02b4b70.tar.gz";
    # Framework to remotely deploy new configurations
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";
    nixos-anywhere.url = "https://github.com/nix-community/nixos-anywhere/archive/91fc9b70fc295258c366cce8627efb6f185fd9fb.tar.gz";
    nixos-hardware.url = "https://github.com/NixOS/nixos-hardware/archive/2e790b0a6be8ec2b76174ac0931b8ff11919ec98.tar.gz";
    nixpkgs-git-lfs.url = "https://github.com/NixOS/nixpkgs/archive/83667ff60a88e22b76ef4b0bdf5334670b39c2b6.tar.gz"; # git-lfs 2.13
    nixpkgs-llvm_18.url = "https://github.com/NixOS/nixpkgs/archive/b5befb85475250e7849341cc2d10233415c2a528.tar.gz";
    nixpkgs.url = "https://github.com/NixOS/nixpkgs/archive/019e5d2c6611235e3f2cce7ed25156a659bbeb53.tar.gz"; # master - 2026-07-28
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "https://github.com/nix-community/srvos/archive/1ae1c0c562ef21aabdc88624bafb387fb4da7847.tar.gz";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "https://github.com/numtide/treefmt-nix/archive/df3c0640565d04a0261253cdd89fce78ec50168a.tar.gz";
    # keep-sorted end
  }; # End inputs

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      systems = [ "x86_64-linux" ];
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate =
        pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [ "vscode" ];
    };
}
