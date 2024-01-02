{
	inputs,
	pkgs,
	...
}:{
  programs.waybar = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.${pkgs.system}.waybar;
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
}
