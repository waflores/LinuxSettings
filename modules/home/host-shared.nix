{ pkgs, osConfig, ... }:
{

  # only available on linux, disabled on macos
  services.ssh-agent.enable = true;

  home.packages =
    [ pkgs.ripgrep ];

  home.stateVersion = "24.11"; # initial home-manager state
}
