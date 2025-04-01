let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/release-24.11.tar.gz";
    sha256 = "1fhvpxccnd8zgamk90k09smp7bwal73l6w8z6qp7q1rxg854i8yi";
  };
  pkgs = import nixpkgs { };
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
    sha256 = "13mmmf5apnd6ima3a1zzybax5nyxfw0kaljk8znyrr7zqz7gllnc";
  };
in
pkgs.nixosTest {
  name = "test1";
  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        (import "${home-manager}/nixos")
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      services.xserver.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      users.users.alice = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      };

      home-manager.users.alice = {
        home.packages = [
          pkgs.firefox
          pkgs.thunderbird
        ];
        home.stateVersion = "24.11";
      };

      system.stateVersion = "24.11";
    };
  testScript = ''
    machine.start(allow_reboot = True)
    machine.wait_for_unit("default.target")
    machine.succeed("su -- alice -c 'which firefox'")
    machine.fail("su -- root -c 'which firefox'")
  '';

}
