# Using mkShell from nixpkgs
{
  pkgs,
  ...
}:
pkgs.mkShell {
  name = "willsBluePrint";
  packages = with pkgs; [
    # keep-sorted start
    bashInteractive
    btop
    cachix
    cmake
    direnv
    fzf
    jdk8
    ninja
    nix-output-monitor
    nix-tree
    nixos-anywhere
    # ncdu  # borked in nixpkgs 25.05
    ripgrep
    ruff
    tree
    vim
    # keep-sorted end
  ];
}

# https://github.com/numtide/blueprint/blob/main/docs/content/guides/configuring_direnv.md
