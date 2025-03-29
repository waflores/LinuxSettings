{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.btop
  ];

  home-manager = {
    backupFileExtension = "bak";
    verbose = true;
  };

}
