{ pkgs, ... }:

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
    pinentry_qt
    ripgrep
    rsync
    tree
    unzip
    wget
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

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    extraConfig = ''
      # Double a takes us to the last window
      unbind a
      bind-key a last-window

      # 'l' takes us to the last session
      unbind l
      bind-key l switch-client -l

      # 'X' kill current session
      bind X confirm-before kill-session

      # split keys
      bind | split-window -h
      bind - split-window -v

      # NeoVim :CheckHealth
      set-option -sg escape-time 10
      set -g default-terminal tmux-256color
      set -g terminal-overrides ",alacritty:RGB"

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"
      
      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      # Github colors for Tmux
      
      set -g mode-style "fg=#24292e,bg=#babbbd"
      
      set -g message-style "fg=#24292e,bg=#babbbd"
      set -g message-command-style "fg=#24292e,bg=#babbbd"
      
      set -g pane-border-style "fg=#e1e4e8"
      set -g pane-active-border-style "fg=#0451a5"
      
      set -g status "on"
      set -g status-justify "left"
      
      set -g status-style "fg=#0451a5,bg=#f6f8fa"
      
      set -g status-left-length "100"
      set -g status-right-length "100"
      
      set -g status-left-style NONE
      set -g status-right-style NONE
      
      set -g status-left "#[fg=#f6f8fa,bg=#0451a5,bold] #S #[fg=#0451a5,bg=#f6f8fa,nobold,nounderscore,noitalics]"
      set -g status-right ""
      
      setw -g window-status-activity-style "underscore,fg=#586069,bg=#f6f8fa"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#ffffff,bg=#f6f8fa"
      setw -g window-status-format "#[fg=#f6f8fa,bg=#f6f8fa,nobold,nounderscore,noitalics]#[fg=#666666,bg=#f6f8fa,nobold,nounderscore,noitalics] #I  #W #F #[fg=#f6f8fa,bg=#f6f8fa,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#f6f8fa,bg=#babbbd,nobold,nounderscore,noitalics]#[fg=#697179,bg=#babbbd,bold] #I  #W #F #[fg=#babbbd,bg=#f6f8fa,nobold,nounderscore,noitalics]"
    '';
  };

  home.file.".config/zsh/.zprofile" = {
    source = ./zprofile.zsh;
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
      upd = "/home/wamberg/dev/nix-home/update.sh";
    };

    initExtra = ''
      PURE_GIT_UNTRACKED_DIRTY=0
      autoload -U promptinit; promptinit; prompt off; prompt pure
      # Eliminate vi-mode normal mode delay
      KEYTIMEOUT=1
    '';

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
