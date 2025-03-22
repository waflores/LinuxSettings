{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.default ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # for testing purposes only, remove on bootable hosts.
  boot.loader.grub.enable = pkgs.lib.mkDefault false;
  fileSystems."/".device = pkgs.lib.mkDefault "/dev/null";

  system.stateVersion = "24.11"; # initial nixos state
}
