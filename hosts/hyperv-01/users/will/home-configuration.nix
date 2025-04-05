{ flake, ... }:
{

  imports = [ flake.homeModules.host-shared ];
  programs.git = {
    userEmail = "waflores956+hyperv-01@gmail.com";
  };
}
