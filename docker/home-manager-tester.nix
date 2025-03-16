# home-manager-tetser.nix - environment to test out our changes to our dotfiles
{ pkgs ? import <nixpkgs> { config = { }; overlays = [ ]; }
}:
let
  inherit (pkgs) bashInteractive coreutils dockerTools lib writeText;
  shell = "${bashInteractive}/bin/bash";

  staticPath = ''${dirOf shell}:${lib.makeBinPath [ coreutils ]}'';
  # https://github.com/NixOS/nix/blob/2.8.0/src/nix-build/nix-build.cc#L493-L526
  rcfile = writeText "nix-shell-rc" ''
    unset PATH
    dontAddDisableDepTrack=1
    # TODO: https://github.com/NixOS/nix/blob/2.8.0/src/nix-build/nix-build.cc#L506
    [ -e $stdenv/setup ] && source $stdenv/setup
    PATH=${staticPath}:"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    SHELL=${lib.escapeShellArg shell}
    BASH=${lib.escapeShellArg shell}
    set +e
    [ -n "$PS1" -a -z "$NIX_SHELL_PRESERVE_PROMPT" ] && PS1='\n\[\033[1;32m\][mgr-sh:\w]\$\[\033[0m\] '
    if [ "$(type -t runHook)" = function ]; then
      runHook shellHook
    fi
    unset NIX_ENFORCE_PURITY
    shopt -u nullglob
    shopt -s execfail
  '';

in
dockerTools.buildLayeredImageWithNixDb {
  name = "home-manager-testenv";
  # tag = "20250315";
  uid = 1000;
  gid = 1000;
  uname = "will";
  gname = "will";
  contents = with pkgs;
    [
      coreutils
      bash
      dockerTools.binSh
      dockerTools.caCertificates
      jq
      nixVersions.latest
      (fakeNss.override
        {
          extraPasswdLines = [ "will:x:1000:1000:Will:/home/will:/bin/bash" ];
          extraGroupLines = [ "will:x:1000:" ];

        })
      nix-output-monitor
      # TODO @(WFlores - 2025-03-15): setup nix.conf
    ];
  # We need fakeRootCommands to change the permissions
  fakeRootCommands = ''
    ${pkgs.dockerTools.shadowSetup}
    groupadd -r will
    useradd -r -g will will
    chown -Rv will:will /nix
    mkdir -p /home/will
    chown -Rv will:will /home/will
  '';
  enableFakechroot = true;
  # End /nix and homedir creation

  config = {
    Cmd = [ shell "--rcfile" rcfile ];
    WorkingDir = "/home/will";
    User = "will:will";
    # Volumes = { "/data" = { }; }
  };
  maxLayers = 2;
}
