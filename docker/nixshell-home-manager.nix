# home-manager-tester.nix - environment to test out our changes to our dotfiles with a prebaked NixShell
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
    ];

    # setup nix.conf
    config = {
      nix.settings.trusted-users = [ "@wheel" ];
      nix.extra-substituters = [ "/build" ];
      nix.extra-substitute-fallbacks = true;
    };
  };
  # Replace nixbld with username for ownership
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
