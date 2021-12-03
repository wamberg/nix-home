{ pkgs, unstablePkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "wamberg";
  home.homeDirectory = "/home/wamberg";

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    firefox
    fzf
    git
    git-crypt
    gnupg
    google-chrome
    neovimWamberg
    nodejs-16_x
    obs-studio
    pinentry_qt
    ripgrep
    rsync
    tdesktop
    tree
    unzip
    wget
    zoom-us
  ];

  programs.alacritty = {
    enable = true;
    # Configure alacritty
    # https://hugoreeves.com/posts/2019/nix-home/
    settings = {
      env.TERM = "alacritty";

      window = {
        dimensions = {
          columns = 0;
          lines = 0;
        };
        decorations = "full";
        startup_mode = "Windowed";
      };

      font = {
        size = 15.0;
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "FiraCode Nerd Font";
          style = "Bold Italic";
        };
      };

      # github Alacritty Colors
      colors = {
        # Default colors
        primary = {
          background = "0xffffff";
          foreground = "0x4d5566";
        };
        # Normal colors
        normal = {
          black =   "0x24292e";
          red =     "0xd73a49";
          green =   "0x22863a";
          yellow =  "0xb08800";
          blue =    "0x0366d6";
          magenta = "0x6f42c1";
          cyan =    "0x1b7c83";
          white =   "0x4d5566";
        };
        # Bright colors
        bright = {
          black =   "0x586069";
          red =     "0xcb2431";
          green =   "0x28a745";
          yellow =  "0xdbab09";
          blue =    "0x2188ff";
          magenta = "0x8a63d2";
          cyan =    "0x1b7c83";
          white =   "0x4d5566";
        };
        indexed_colors = [
          { index = 16; color = "0xd18616"; }
          { index = 17; color = "0xcb2431"; }
        ];
      };


    };
  };

  fonts.fontconfig.enable = true;

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";

  };

  # Neovim
  home.file.".editorconfig" = {
    source = ./editorconfig;
  };

  # Tmux
  home.file.".config/tmux/session-finder.bash" = {
    source = ./session-finder.bash;
    executable = true;
  };
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    defaultKeymap = "viins";

    shellAliases = {
      ahm = "/home/wamberg/dev/nix-home/apply-users.sh";
      asys = "/home/wamberg/dev/nix-home/apply-system.sh";
      g = "git";
      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gcl = "git clone --recurse-submodules";
      gco = "git checkout";
      gd = "git diff";
      ggpull = "git pull origin";
      ggpush = "git push origin";
      glog = "git log --oneline --decorate --graph";
      grb = "git rebase";
      gst = "git status";
      gunwip = "git log -n 1 | grep -q -c '\-\-wip\-\-' && git reset HEAD~1";
      gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m '--wip-- [skip ci]'";
      rs = "rsync -avP";
      upd = "/home/wamberg/dev/nix-home/update.sh";
    };

    initExtra = builtins.readFile ./zshrc;

    plugins = with pkgs; [
      {
        name = "pure";
        src = fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.18.0";
          hash = "sha256-nsmiP1RSG27WtwRJpTZvDi2CvUQExxdBs5my7T5TSKk=";
        };
        file = "pure.plugin.zsh";
      }
    ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
