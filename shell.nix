{
  pkgs ? import <nixpkgs> { },
  packages ? [ ],
}:

with pkgs;
mkShell {
  name = "DevShell";
  packages = packages ++ [
    python3.pkgs.pytest
    python3.pkgs.mypy
    ruff
    direnv
    nix-output-monitor
  ];
}
