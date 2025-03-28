{
  homeDirectory,
  pkgs,
  stateVersion,
  system,
  username,
}:

let
  packages = import ./packages.nix { inherit pkgs; };
in
{
  home = {
    inherit
      homeDirectory
      packages
      stateVersion
      username
      ;

    shellAliases = {
      # TODO(@waflores) 2024-10-04: Add the backup option here
      # Existing file '/home/will/.profile' is in the way of '/nix/store/yrbcigb2qzd9znvd4fkn0vyi8rviaq6q-home-manager-files/.profile'
      # Existing file '/home/will/.bashrc' is in the way of '/nix/store/yrbcigb2qzd9znvd4fkn0vyi8rviaq6q-home-manager-files/.bashrc'
      # Please do one of the following:
      # - Move or remove the above files and try again.
      # - In standalone mode, use 'home-manager switch -b backup' to back up
      #   files automatically.
      # - When used as a NixOS or nix-darwin module, set
      #     'home-manager.backupFileExtension'
      #   to, for example, 'backup' and rebuild.
      reload-home-manager-config = "home-manager switch --flake ${builtins.toString ./.}";
    };
  };

  nixpkgs = {
    config = {
      inherit system;
      allowUnfree = true;
      allowUnsupportedSystem = true;
      experimental-features = "nix-command flakes";
    };
  };

  programs = import ./programs.nix;
}
