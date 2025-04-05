{ flake, perSystem, ... }:
{

  imports = [ flake.homeModules.host-shared ];

  # NOTE: We can override our git configuration here
  programs.git = {
    userEmail = "waflores956+hyperv-01@gmail.com";
    lfs = {
      enable = true;
      package = perSystem.nixpkgs-git-lfs.git-lfs;
    };
  };
}
