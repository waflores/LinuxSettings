{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    btop
    dmidecode
    nix-output-monitor
    tree
    vim
    # keep-sorted end
  ];

  home-manager = {
    backupFileExtension = "bak";
    verbose = true;
  };

}
