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
    jq
    nixVersions.latest
    (fakeNss.override
      {
        extraPasswdLines = [ "will:x:1000:1000:Will:/home/will:/bin/bash" ];
        extraGroupLines = [ "will:x:1000:" ];

      })
    nix-output-monitor
  ];
  config = {
    # Cmd = [ "${pkgs.hello}/bin/hello" ];
    WorkingDir = "/home/will";
    User = "will";
    # Volumes = { "/data" = { }; }
  };
  maxLayers = 2;
}
