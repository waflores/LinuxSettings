{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.self.nixosModules.host-shared ];

  # for testing purposes only, remove on bootable hosts.
  nixpkgs.hostPlatform.system = "x86_64-linux";
  system.stateVersion = pkgs.lib.versions.majorMinor pkgs.lib.version; # initial nixos state

  nix = {
    settings.extra-experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
      "fetch-tree"
      "repl-flake"
    ];
  };

  # on nixos this either isNormalUser or isSystemUser is required to create the user.
  users.users.will.isNormalUser = true;
}
