# Using mkShell from nixpkgs
{
  pkgs,
  perSystem,
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

  shellHook = ''
    echo "shell defined in our blueprint!"
  '';
}

# https://github.com/numtide/blueprint/blob/main/docs/content/guides/configuring_direnv.md