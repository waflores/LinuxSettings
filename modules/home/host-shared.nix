{ pkgs, ... }:
{

  # only available on linux, disabled on macos
  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    ripgrep
    btop
    cmake
    direnv # May collide
    fzf
    # git-lfs-2_13 # need to override
    jdk8
    ninja
    # ncdu # borked in nixpkgs 25.05
    tree
    vim
  ];

  home.stateVersion = "24.11"; # initial home-manager state

  programs = {

    bash = {
      /**
        Other shell options
        shellAliases
        sessionVariables
        history
      */
      enable = true;

      enableCompletion = false; # XXX keep the System configured verison

      # We took our original ~/.profile and renamed it to ~/.oldprofile
      # This runs first
      profileExtra = ''
        if [ -f ~/.oldprofile ]; then
          . ~/.oldprofile
        fi
      '';

      # We took our original ~/.bashrc and renamed it to ~/.oldbashrc
      # This runs second
      bashrcExtra = ''
        if [ -f ~/.oldbashrc ]; then
          . ~/.oldbashrc
        fi
        alias use-direnv='unset LD_LIBRARY_PATH && eval "$(ssh-agent)" && ssh-add ~/.ssh/id_rsa && eval "$(direnv hook bash)" && direnv allow'
        umask 002
      '';

      # initExtra runs third, then, bashrc run, finally initExtra runs.
      initExtra = ''
        # See - https://bugs.archlinux.org/task/78828
        unset NIX_PATH
      '';
    };

    starship = {
      enable = true;
      settings = {
        # We need 1 second to allow git to run on the monorepo
        command_timeout = 5000;
      };
    };

    # Add navi to the shell
    # https://github.com/denisidoro/navi
    navi = {
      enable = true;
      enableBashIntegration = true;
    };

    # Add fzf to the eshell
    # https://github.com/junegunn/fzf
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

  }; # End programs
}
