# Using mkShell from nixpkgs
{ pkgs, packages, ... }:
with pkgs;
mkShell {
  name = "willsBluePrint";
  packages = packages ++ [
    bashInteractive
    python3.pkgs.pytest
    python3.pkgs.mypy
    ruff
    direnv
    nix-output-monitor
    btop
    cmake
    fzf
    jdk8
    ninja
    ncdu
    tree
    vim
  ];
  # shellHook = ''
  #   echo "shell defined in our blueprint!"
  # '';

}
