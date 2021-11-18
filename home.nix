{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "wamberg";
  home.homeDirectory = "/home/wamberg";

  home.packages = with pkgs; [
    firefox
    git
    stow
    tmux
    unzip
    wget
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 15; 
    };
  };

  programs.neovim.enable = true;
  programs.neovim.viAlias = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;

    initExtra = ''
      autoload -U promptinit; promptinit
      prompt pure

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
