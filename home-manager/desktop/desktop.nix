{
	inputs,
	pkgs,
	...
}:{

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

}
