{ config, pkgs, userSettings, systemSettings, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    cowsay
    neofetch
    fortune
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

   ".bashrc".source = dotfiles/bashrc;
   "cowsay" = {
     source = builtins.fetchGit {
       url = "https://github.com/paulkaefer/cowsay-files/";
       rev = "d024d40ac3f02659ac82536f6b635e5ae506aaa2";
     };
   };

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/chris/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nano";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  programs = {

  git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
    extraConfig = {
      init.defaultBranch = "main";
      #safe.directory = "/etc/nixos";
      safe.directory = "/home/" + userSettings.username + "/.dotfiles";
    };
  };

  vscode = {
   enable = true;
   package = pkgs.vscodium;
   extensions = with pkgs.vscode-extensions; [
    dracula-theme.theme-dracula
    #vscodevim.vim
    #yzhang.markdown-all-in-one
   ];
  };

  gnome-terminal = {
    enable = true;
    profile."7bd1372f-66a2-4704-8bb5-7d7ed0dd8ac7" = {
      default = true;
      visibleName = "chris";
      font = "JetBrainsMono Nerd Font 12";
    };
  };




  }; #end programs
  


}
