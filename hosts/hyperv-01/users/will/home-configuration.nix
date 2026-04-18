{ flake, ... }:
{

  imports = [ flake.homeModules.host-shared ];

  # NOTE: We can override our git configuration here
  programs.git = {
    settings.user.email = "waflores956+hyperv-01@gmail.com";
    lfs.enable = true;
  };
}
