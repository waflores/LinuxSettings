# Using mkShell from nixpkgs
{
  pkgs,
  perSystem ? null,
  ...
}:
pkgs.mkShell {
  name = "willsBluePrint";
  packages =
    with pkgs;
    [
      bashInteractive
      btop
      cachix
      cmake
      direnv
      fzf
      jdk8
      ninja
      nix-output-monitor
      ncdu
      ripgrep
      tree
      ruff
      vim
    ]
    ++ pkgs.lib.options (perSystem != null) [ perSystem.blueprint.default ];
  shellHook = ''
    echo "shell defined in our blueprint!"
  '';
}
