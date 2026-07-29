{
  pkgs,
  ...
}:
{
  # only available on linux, disabled on macos
  services.ssh-agent.enable = true;

  home.packages = [
    # keep-sorted start
    pkgs.tree
    #keep-sorted end
  ];

  home.stateVersion = "26.05"; # initial home-manager state

  programs = {
    # keep-sorted start block=yes
    bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = {
        reload-home-manager-config = "${pkgs.lib.getExe pkgs.home-manager} switch --flake . -b 'bak' && exec bash";
        use-direnv = ''unset LD_LIBRARY_PATH && eval "$(ssh-agent)" && ssh-add ~/.ssh/id_rsa && eval "$(direnv hook bash)" && direnv allow'';
      };

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
        umask 002
      '';

      # initExtra runs third, then, bashrc run, finally initExtra runs.
      initExtra = ''
        # See - https://bugs.archlinux.org/task/78828
        unset NIX_PATH
      '';
    }; # End bash config
    btop.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    }; # End direnv config
    # Add fzf to the shell
    # https://github.com/junegunn/fzf
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    git = {
      enable = true;
      settings.user.name = "Will Flores";
    };
    gpg = {
      enable = true;
    };
    # Add home-manager to the shell
    home-manager.enable = true;
    # Add jq and jqp
    jqp.enable = true;
    keychain.enable = true;
    # Add navi to the shell
    # https://github.com/denisidoro/navi
    navi = {
      enable = true;
      enableBashIntegration = true;
    };
    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
    pay-respects = {
      enable = true;
      enableBashIntegration = true;
    };
    ripgrep-all.enable = true;
    ripgrep.enable = true;
    # Add ssh support
    starship = {
      enable = true;
      settings = {
        # We need 1 second to allow git to run on the monorepo
        command_timeout = 10000;
      };
    };
    vim = {
      enable = true;
      extraConfig = ''
        set showcmd
        set smartindent
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set bg=dark
        set ruler
        set backspace=indent,eol,start
        set hlsearch
        syntax on
      '';
    };
    # keep-sorted end
  }; # End programs
}
