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
      dockerTools.binSh
      jq
      nixVersions.latest
      (fakeNss.override
        {
          extraPasswdLines = [ "newuser:x:9001:9001:new user:/var/empty:/bin/sh" ];
          extraGroupLines = [ "newuser:x:9001:" ];

        })
      nix-output-monitor

    ];
    pathsToLink = [ "/bin" ];

  };
  config = {
    # Cmd = [ "${pkgs.hello}/bin/hello" ];
    # WorkingDir = "/data";
    # Volumes = { "/data" = { }; }
  };
}
