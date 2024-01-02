{
	pkgs,
	lib,
	...
}:{
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
        {command = "autotiling"; always = true;}
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
          app_id = "kitty";
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
}
