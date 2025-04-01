# home-manager-tetser.nix - environment to test out our changes to our dotfiles with a prebaked NixShell
{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
let
  inherit (pkgs) dockerTools mkShellNoCC;
in
dockerTools.buildNixShellImage {
  name = "home-manager-testshell";
  drv = mkShellNoCC {
    packages = with pkgs; [
      coreutils
      bash
      dockerTools.binSh
      dockerTools.caCertificates
      jq
      nixVersions.latest
      # (fakeNss.override
      #   {
      #     extraPasswdLines = [ "will:x:1000:1000:Will:/home/will:/bin/bash" ];
      #     extraGroupLines = [ "will:x:1000:" ];

      #   })
      nix-output-monitor
      # TODO @(WFlores - 2025-03-15): setup nix.conf
    ];
  };
  # TODO (@WFlores - 2025-03-16): we need to make sure that nixbld can be replaced by my username.
  uid = 1000;
  gid = 1000;
  homeDirectory = "/home/will";
  run = ''
    if [[ "$HOME" != "$(eval "echo ~$(whoami)")" ]]; then
      echo "\$HOME ($HOME) is not the same as ~\$(whoami) ($(eval "echo ~$(whoami)"))"
      exit 1
    fi

    if ! touch $HOME/test-file; then
      echo "home directory is not writable"
      exit 1
    fi
    echo "home directory is writable"
  '';

}
