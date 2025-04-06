{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    btop
    dmidecode
    git
    ncdu
    netsniff-ng # all sorts of networking introspection
    nix-output-monitor
    pciutils # provides lspci and setpci
    screen
    tree
    vim
    vscode
    # keep-sorted end
  ];
  # NOTE (@waflores - 2025-04-05): we can make the package point to the old git-lfs
  programs.git.lfs.package = perSystem.nixpkgs-git-lfs.git-lfs;
  programs.git.lfs.enable = true;

  home-manager = {
    backupFileExtension = "bak";
    verbose = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables

  ## Localization defaults
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
}
