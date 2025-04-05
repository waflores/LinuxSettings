{ pkgs, inputs, ... }:
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];
  # also wrap and install comma
  programs.nix-index-database.comma.enable = true;

  # only available on linux, disabled on macos
  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    # keep-sorted start
    # git-lfs-2_13 # need to override
    # nix-inspect
    tree
    #keep-sorted end
  ];

  home.stateVersion = "24.11"; # initial home-manager state

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
      # TODO (@waflores - 2025-03-28): add tmux support
    };
    git = {
      enable = true;
      userName = "Will Flores";
    };
    # Add home-manager to the shell
    home-manager.enable = true;
    # Add jq and jqp
    jqp.enable = true;
    # Add navi to the shell
    # https://github.com/denisidoro/navi
    navi = {
      enable = true;
      enableBashIntegration = true;
    };
    # TODO (@waflores - 2025-03-28): add keychain support
    # TODO (@waflores - 2025-03-28): add password-store support
    # TODO (@waflores - 2025-03-28): add ssh support
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
