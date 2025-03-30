{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.self.nixosModules.host-shared ];
  # keep-sorted start

  # for testing purposes only, remove on bootable hosts.
  boot.loader.grub.enable = pkgs.lib.mkDefault false;
  fileSystems."/".device = pkgs.lib.mkDefault "/dev/null";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = pkgs.lib.versions.majorMinor pkgs.lib.version; # initial nixos state
  # on nixos this either isNormalUser or isSystemUser is required to create the user.
  users.users.will.isNormalUser = true;
  # keep-sorted end
}
