{
  pkgs ? import <nixpkgs> { },
}:

import ./devshells/default.nix { inherit pkgs; }
