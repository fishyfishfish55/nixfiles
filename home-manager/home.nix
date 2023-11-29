# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "genius";
    homeDirectory = "/home/genius";
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Tokyonight-Dark-BL";
      package = pkgs.tokyo-night-gtk;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

   dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
     "org/gnome/desktop/background" = {
     	picture-uri = "file:///home/genius/.local/share/backgrounds/2023-09-02-17-25-58-citypaper.jpg";
     	picture-uri-dark = "file:///home/genius/.local/share/backgrounds/2023-09-02-17-25-58-citypaper.jpg";
     };
     "org/gnome/shell" = {
       disable-user-extensions = false;
     };
   };
  
  home.packages = with pkgs; [
    bat
    cava
    tldr
    firefox
    reaper
    iosevka
    nerdfonts
    obsidian
    libreoffice-fresh
    discord
    mpv
    youtube-dl
    doomretro
    # Helix packages
    # TODO: move to ExtraPackages
    marksman
    rust-analyzer-unwrapped
    lua-language-server
    nil
  ];

  programs.git = {
    enable = true;
    userName = "fishyfishfish55";
    userEmail = "l.lacossct@gmail.com";
  };

  programs.gh = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
    enableAutosuggestions = true;
    shellAliases = {
      md = "mkdir -p";
      cat = "bat";
      du = "dust";
      df = "duf";
      rf = "rm -rf";
      rd = "rmdir";
      icat = "kitty +kitten icat";
      update = "sudo nixos-rebuild switch";
      musique = "mpv --config=no --quiet --vo=tct --really-quiet --lavfi-complex='[aid1]asplit[ao][a1];[a1]avectorscope=r=25:m=lissajous_xy:bc=100:gc=100:rc=75:bf=5:gf=3:rf=1:zoom=1[vo]'";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "plugins/sudo"; tags = [ "from:oh-my-zsh" ]; }
      ];
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-Space";
    keyMode = "vi";
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = true;
    };
  };

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    shellIntegration.enableZshIntegration = true;
    font = {
    	name = "Iosevka";
    	size = 11;
    };
    settings = {
      hide_window_decorations = true;
      remember_window_size = false;
      initial_window_width = "80c";
      initial_window_height = "24c";
      background_opacity = "0.95";
    };
  };

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
      	cursor-shape = {
      	  insert = "bar";
      	  normal = "block";
      	  select = "underline";
      	};
      	file-picker.hidden = false;
      };
    };
  };

#   programs.eww = {
#    enable = true;
#    package = inputs.eww.packages.${pkgs.system}.default;
#  };

  wayland.windowManager.sway = {
    enable = true;
    package = inputs.swayfx.packages.${pkgs.system}.default.overrideAttrs (old: { passthru.providedSessions = [ "sway" ]; } );
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
