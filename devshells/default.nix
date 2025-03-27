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
      # home-manager  # llvm_18 is borked for some reason...
      jdk8
      ninja
      nix-output-monitor
      nix-tree
      ncdu
      ripgrep
      tree
      ruff
      vim
    ];
    # TODO (@waflores - 2025-03-22): perSystem.blueprint.default is not a valid attribute
    #   need to debug why.
    # ++ (pkgs.lib.optionals (perSystem != null) [ perSystem.blueprint ]);
  shellHook = ''
    echo "shell defined in our blueprint!"
  '';
}
