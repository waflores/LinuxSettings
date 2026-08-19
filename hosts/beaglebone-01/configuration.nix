{
  inputs,
  pkgs,
  flake,
  ...
}:
{

  imports = [
    inputs.srvos.nixosModules.server
    flake.nixosModules.host-shared
    ./hardware-configuration.nix
  ];

  # for testing purposes only, remove on bootable hosts.
  boot.loader.grub.enable = pkgs.lib.mkDefault false;
  fileSystems."/".device = pkgs.lib.mkDefault "/dev/null";
  fileSystems."/".fsType = pkgs.lib.mkDefault "none";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-beaglebone-01";

  # Enable networking
  networking.networkmanager.enable = true;

  nix = {
    enable = true;
    settings.trusted-users = [ "@wheel" ];
    settings.extra-experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
      "fetch-tree"
    ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;

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
      "docker"
    ];
  };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };
}
