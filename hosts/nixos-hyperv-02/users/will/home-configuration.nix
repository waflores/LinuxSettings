{ flake, ... }:
{

  imports = [ flake.homeModules.host-shared ];

  # NOTE: We can override our git configuration here
  programs.git = {
    userEmail = "waflores956+nixos-hyperv-02@gmail.com";
    lfs.enable = true;
  };
}
