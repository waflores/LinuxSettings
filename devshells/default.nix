# Using mkShell from nixpkgs
{ pkgs, ... }:
with pkgs;
mkShell {
  name = "willsBluePrint";
  packages = [
    bashInteractive
  ];
}
