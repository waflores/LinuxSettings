let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/7f817b8455a1e9a944ab4392cc16c3ca36dbc83e.tar.gz";
    sha256 = "00ydd0jhx02bbi4q2hcjibqzyv9skyni28zxd5pznwc8ajpgs8i2";
  };
  pkgs = import nixpkgs { };
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/565e5349208fe7d0831ef959103c9bafbeac0681.tar.gz";
    sha256 = "168q6bqi3g7r51hhxb3f4bz1kkj3660dv0dm1zjyilqldcar8d7g";
  };
in
pkgs.testers.nixosTest {
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
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      users.users.alice = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      };

      home-manager.users.alice = {
        home.packages = [
          pkgs.firefox
          pkgs.thunderbird
        ];
        home.stateVersion = "26.05";
      };

      system.stateVersion = "26.05";
    };
  testScript = ''
    machine.start(allow_reboot = True)
    machine.wait_for_unit("default.target")
    machine.succeed("su -- alice -c 'which firefox'")
    machine.fail("su -- root -c 'which firefox'")
  '';

}
