{
  inputs,
  pkgs,
  flake,
  ...
}:
{
  imports = [
    inputs.srvos.nixosModules.desktop
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t420
    flake.nixosModules.host-shared
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-thinkpad-01";

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
      # "repl-flake"
    ];
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  system.stateVersion = pkgs.lib.versions.majorMinor pkgs.lib.version; # initial nixos state

  # Set our timezone
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
