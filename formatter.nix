{ pkgs, inputs, ... }:
inputs.treefmt-nix.lib.mkWrapper pkgs {
  # Used to find the project root
  projectRootFile = ".git/config";

  programs = {
    deadnix.enable = true;
    deno.enable = true;
    mypy.enable = true;
    ruff.check = true;
    ruff.format = true;
    nixfmt.enable = true;
    nixfmt.package = pkgs.nixfmt-rfc-style;
    shellcheck.enable = true;
    shfmt.enable = true;
    statix.enable = true;
    yamlfmt.enable = true;
  };

  settings.global.excludes = [
    "LICENSE"
    # let's not mess with the test folder
    "test/*"
    # unsupported extensions
    "*.{gif,png,svg,tape,mts,lock,mod,sum,toml,env,envrc,gitignore,pages}"
  ];

  # settings.formatter = {
  #   shellcheck.includes = [ "direnvrc" ];
  #   shfmt.includes = [ "direnvrc" ];
  # };
}
