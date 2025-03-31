{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    vim
    tree
  ];

  home-manager = {
    backupFileExtension = "bak";
    verbose = true;
  };

}
