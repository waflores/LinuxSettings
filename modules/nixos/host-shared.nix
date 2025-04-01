{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    btop
    dmidecode
    git
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
  
  services.avahi.enable = true;
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
}
