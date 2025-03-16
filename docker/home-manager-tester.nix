# home-manager-tetser.nix - environment to test out our changes to our dotfiles
{ pkgs ? import <nixpkgs> { config = { }; overlays = [ ]; }
}:
pkgs.dockerTools.buildLayeredImageWithNixDb {
  name = "home-manager-testenv";
  # tag = "20250315";
  uid = 1000;
  gid = 1000;
  uname = "will";
  gname = "will";
  contents = with pkgs; [
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
    # Cmd = [ "${pkgs.hello}/bin/hello" ];
    WorkingDir = "/home/will";
    User = "will:will";
    # Volumes = { "/data" = { }; }
  };
  maxLayers = 2;
}
