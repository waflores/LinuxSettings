# home-manager-tetser.nix - environment to test out our changes to our dotfiles
{ pkgs ? import <nixpkgs> { config = { }; overlays = [ ]; }
}:
pkgs.dockerTools.buildImageWithNixDb
{
  name = "home-manager-testenv";
  # tag = "20250315";
  # uid = 1000;
  # gid = 1000;
  copyToRoot = pkgs.buildEnv {
    name = "home-manager-root";
    paths = with pkgs; [
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
    pathsToLink = [ "/bin" "/etc" "/var" "/home" ];
  };

  config = {
    # Cmd = [ "${pkgs.hello}/bin/hello" ];
    # WorkingDir = "/data";
    # Volumes = { "/data" = { }; }
  };
}
