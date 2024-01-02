{
	config,
	...
}:{
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
}
