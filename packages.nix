{ pkgs }:

let nixTools = with pkgs; [ cachix direnv ];
in nixTools
