{
  pkgs ? import <nixpkgs> { },
  packages ? [ ],
}:

import ./devshells/default.nix { inherit pkgs packages; }
