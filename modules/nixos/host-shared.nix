{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    btop
    git
    dmidecode
    nix-output-monitor
    screen
    tree
    vim
    # keep-sorted end
  ];

  home-manager = {
    backupFileExtension = "bak";
    verbose = true;
  };

}
