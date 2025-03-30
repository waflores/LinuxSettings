{ pkgs, inputs, ... }:
inputs.treefmt-nix.lib.mkWrapper pkgs {
  # Used to find the project root
  projectRootFile = ".git/config";

  programs = {
    # keep-sorted start
    deadnix.enable = true;
    dos2unix.enable = true;
    keep-sorted.enable = true;
    # mdformat.enable = true;
    mdsh.enable = true;
    nixfmt.enable = true;
    nixfmt.package = pkgs.nixfmt-rfc-style;
    ruff.check = true;
    ruff.format = true;
    shellcheck.enable = true;
    shfmt.enable = true;
    statix.enable = true;
    typos.enable = true;
    yamlfmt.enable = true;
    # keep-sorted end
  };

  settings.global.excludes = [
    "LICENSE"
    # let's not mess with the test folder
    "test/*"
    # unsupported extensions
    "*.{gif,png,svg,tape,mts,lock,mod,sum,gitignore,pages}"
  ];

  # settings.formatter = {
  #   shellcheck.includes = [ "direnvrc" ];
  #   shfmt.includes = [ "direnvrc" ];
  # };
}
