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

  manual.manpages.enable = false;

  home = {
    username = "genius";
    homeDirectory = "/home/genius";
  };

  home.packages = with pkgs; [
    cava
    tldr
    firefox
    reaper
    iosevka
    nerdfonts
    # unstable.obsidian
    # discord
    libreoffice-fresh
    mpv
    youtube-dl
    doomretro
    # Helix packages
    # TODO: move to ExtraPackages
    marksman
    rust-analyzer
    lua-language-server
    nil
    clang-tools
    inputs.steam-tui.packages.${pkgs.system}.default
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
      update = "sudo nixos-rebuild switch --update-input nixpkgs --commit-lock-file --show-trace";
      musique = "mpv --config=no --quiet --vo=tct --really-quiet --lavfi-complex='[aid1]asplit[ao][a1];[a1]avectorscope=r=25:m=lissajous_xy:bc=100:gc=100:rc=75:bf=5:gf=3:rf=1:zoom=1[vo]'";
      # Old nix commands - reevaluate.
      nix-channel = "echo 'whoa there, buddy.  Use flake inputs instead'";
      nix-env = "echo 'whoa there, buddy. Did you mean nix profile?'";
      nix-shell = "echo 'whoa there, buddy. Do some research first - check nix develop, nix shell, and nix run'";
      nix-build = "echo 'whoa there, buddy. Did you mean nix build'";
      nix-collect-garbage = "echo 'whoa there, buddy. Did you mean nix store gc --debug?'";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "vi-mode"
        "zsh-interactive-cd"
        "zsh-navigation-tools"
      ];
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
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
    # theme = "Nord";
    shellIntegration.enableZshIntegration = true;
    settings = {
      hide_window_decorations = true;
      remember_window_size = false;
      initial_window_width = "80c";
      initial_window_height = "24c";
    };
  };

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    settings = {
      # theme = "nord-night";
      editor = {
        line-number = "relative";
        cursorline = true;
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
    package = pkgs.unstable.swayfx;
    systemd.enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty";
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
      input = {
        "*" = { 
          natural_scroll = "enabled";
          tap = "enabled";
         };
      };
      keybindings = lib.mkOptionDefault {
        # Launcher
        "${modifier}+space" = "exec fuzzel";
        # Lock screen
        "${modifier}+Shift+l" = "swaylock -fF";
        "${modifier}+w" = "kill";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+f" = "floating toggle";
        # Brightness
        "XF86MonBrightnessDown" = "exec light -U 2";
        "XF86MonBrightnessUp" = "exec light -A 2";
         # Volume
         "XF86AudioRaiseVolume" = "exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0'";
         "XF86AudioLowerVolume" = "exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1.0'";
         "XF86AudioMute" = "exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
      };
      floating.criteria = [
        {
          class = "kitty";
        }
      ];
      window.titlebar = false;
      gaps.inner = 5;
      bars = [     
        {
          id = "waybar";
          command = "waybar";
        }      
      ];
    };
    extraConfig = ''
      blur enable
      blur_passes 3
      blur_radius 5
      corner_radius 5
      shadows enable
      scratchpad_minimize enable
    '';
  };

  programs.swaylock = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.${pkgs.system}.swaylock-effects;
  };

  services.swayidle = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.${pkgs.system}.swayidle;
    extraArgs = [ "-w" ]; # wait for before-sleep command to finish executing
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
      { event = "after-resume"; command = "swaymsg 'output * power on'"; }
    ];
    timeouts = [
      { timeout = 600; command = "swaymsg 'output * power off'"; }
    ];
  };

  services.mako = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.${pkgs.system}.mako;
    # backgroundColor = "#434c5eff";
    # textColor = "#eceff4ff";
    # borderColor = "#d8dee9ff";
    # progressColor = "#ebcb8bff";
  };

  # Battery warning
  services.batsignal = {
    enable = true;
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      colors = {
        # background = "434c5eff";
        # text = "eceff4ff";
        # match = "ebcb8bff";
        # selection = "d8dee9ff";
        # selection-text = "2e3440ff";
        # selection-match = "ebcb8bff";
      };
    };
  };

  programs.waybar = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.${pkgs.system}.waybar;
    # systemd = {
    #   enable = true;
    #   target = "sway-session.target";
    # };
    settings.waybar = {
      id = "waybar";
      ipc = true;
      layer = "top";
      position = "top";
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "clock" "wireplumber" "battery" "tray" ];
      "sway/workspaces" = {
        format-icons = {
          default = "○";
          focused = "◎";
        };
        format = "{icon}";
      };
      clock = {
        interval = 1;
        format = "{:%I:%M:%S}";
        tooltip-format = "{:%d.%m.%y}";
      };
      backlight = {
        format = "{icon}";
        format-icons = [ "󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠" ];
      };
      wireplumber = {
        format = "{icon} {volume}%";
        format-muted = "󰝟  {volume}%";
        format-icons = [ "󰕿" "󰖀" "󰕾" ];
      };
      battery = {
        format = "{icon}  {capacity}%";
        format-charging = "{icon}󱐋 {capacity}%";
        interval = 2;
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
      };
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    git = true;
    icons = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
