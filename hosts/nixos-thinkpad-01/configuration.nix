{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.self.nixosModules.host-shared ];

  # TODO(@waflores - 2025-03-30): need to figure out if we need to add `config.` prefix
  networking.hostName = "nixos-thinkpad-01";
  nix = {
    settings.extra-experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
      "fetch-tree"
      "repl-flake"
    ];
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  system.stateVersion = pkgs.lib.versions.majorMinor pkgs.lib.version; # initial nixos state

  # on nixos this either isNormalUser or isSystemUser is required to create the user.
  users.users.will.isNormalUser = true;
}
