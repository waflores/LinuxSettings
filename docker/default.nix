# home-manager-tetser.nix - environment to test out our changes to our dotfiles
{ pkgs ? import <nixpkgs> { config = { }; overlays = [ ]; }
}:
let
  inherit (pkgs) bashInteractive cacert coreutils dockerTools lib writeText;
  shell = "${bashInteractive}/bin/bash";

  staticPath = ''${dirOf shell}:${lib.makeBinPath [ coreutils ]}'';

  # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/globals.hh#L464-L465
  sandboxBuildDir = "/build";

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

  nixconf = writeText "nix-config" ''
    extra-experimental-features = flakes nix-command ca-derivations
  '';

  homeDirectory = "/home/will";
  # Environment variables set in the image
  envVars = {

    # Root certificates for internet access
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1027-L1030
    # PATH = "/path-not-set";
    # Allows calling bash and `buildDerivation` as the Cmd
    PATH = staticPath;

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1032-L1038
    HOME = homeDirectory;

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1040-L1044
    NIX_STORE = builtins.storeDir;

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1046-L1047
    # TODO: Make configurable?
    NIX_BUILD_CORES = "4";

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1008-L1010
    NIX_BUILD_TOP = sandboxBuildDir;

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1012-L1013
    TMPDIR = sandboxBuildDir;
    TEMPDIR = sandboxBuildDir;
    TMP = sandboxBuildDir;
    TEMP = sandboxBuildDir;

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1015-L1019
    PWD = sandboxBuildDir;

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1071-L1074
    # We don't set it here because the output here isn't handled in any special way
    # NIX_LOG_FD = "2";

    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1076-L1077
    TERM = "xterm-256color";

    # Give us a locale
    LANG = "en_US.UTF-8";
  };


in
dockerTools.buildLayeredImageWithNixDb {
  name = "home-manager-testenv";
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
      home-manager
      jq
      nixVersions.latest
      (fakeNss.override
        {
          extraPasswdLines = [ "will:x:1000:1000:Will:/home/will:/bin/bash" ];
          extraGroupLines = [ "will:x:1000:" ];

        })
      nix-output-monitor
    ];

  # We need fakeRootCommands to change the permissions of the nix store and our homeDirectory
  fakeRootCommands = ''
    ${pkgs.dockerTools.shadowSetup}
    groupadd -r will
    useradd -r -g will will
    chown -Rv will:will /nix
    mkdir -p ${homeDirectory}
    chown -Rv will:will ${homeDirectory}
    ln -s ${rcfile.outPath} /etc/bashrc
    mkdir -p /etc/nix
    ln -s ${nixconf.outPath} /etc/nix/nix.conf
  '';
  enableFakechroot = true;
  # End /nix and homeDirectory creation

  config = {
    Cmd = [ shell "--rcfile" rcfile ];
    WorkingDir = homeDirectory;
    User = "will:will";
    Env = lib.mapAttrsToList (name: value: "${name}=${value}") envVars;
  };
  maxLayers = 2;
}
