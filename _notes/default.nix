# This file provides backward compatibility to nix < 2.4 clients
let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  inherit (lock.nodes.nixpkgs.locked)
    owner
    repo
    rev
    narHash
    ;

  nixpkgs = fetchTarball {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = narHash;
  };

  pkgs = import nixpkgs { };
in
 pkgs.mkShellNoCC {
   packages = with pkgs; [
     cowsay
   ];

  GREETING = "Hello, from default.nix!";
 }
