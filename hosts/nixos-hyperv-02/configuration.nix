{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.mixins-tracing
    inputs.srvos.nixosModules.mixins-terminfo
    inputs.self.nixosModules.host-shared
  ];

  # for testing purposes only, remove on bootable hosts.
  boot.loader.grub.enable = pkgs.lib.mkDefault false;
  fileSystems."/".device = pkgs.lib.mkDefault "/dev/null";
  networking.hostName = "nixos-hyperv-02";
  nixpkgs.hostPlatform.system = "x86_64-linux";
  system.stateVersion = pkgs.lib.versions.majorMinor pkgs.lib.version; # initial nixos state

  # on nixos this either isNormalUser or isSystemUser is required to create the user.
  users.users.will = {
    isNormalUser = true;
    description = "Will Flores";
    hashedPassword = "$6$a69Ua5IWrM6vFPtk$olkZzNeti8MosldO2.ijOSEcH713NHVeBBFk5lVoXjRj8xdu9QwLT1VFaXoU4L71JsbuMIAtcsG1PHHbD1DUb1";
    extraGroups = [
      "networkmanager"
      "wheel"
      "tss"
    ];
  };
}
