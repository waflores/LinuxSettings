{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.mixins-systemd-boot
    inputs.srvos.nixosModules.mixins-tracing
    inputs.srvos.nixosModules.mixins-terminfo
    inputs.self.nixosModules.host-shared
  ];

  # for testing purposes only, remove on bootable hosts.
  boot.loader.grub.enable = pkgs.lib.mkDefault false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  boot.consoleLogLevel = 7;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_0;
  fileSystems."/".device = pkgs.lib.mkDefault "/dev/null";
  fileSystems."/".fsType = pkgs.lib.mkDefault "none";
  networking.hostName = "hyperv-01";
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

  # QEMU VM configuration - see:
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/qemu-vm.nix
  # https://nix.dev/tutorials/nixos/nixos-configuration-on-vm

  # Graphical User Interfaces!
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

}
