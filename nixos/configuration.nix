# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd
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

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    # nix.settings = {
    #   # add binary caches
    #   trusted-public-keys = [
    #     "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #     "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    #   ];
    #   substituters = [
    #     "https://cache.nixos.org"
    #     "https://nixpkgs-wayland.cachix.org"
    #   ];
    # };
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    curl
    git
    distrobox
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.gesture-improvements
    gnomeExtensions.rounded-window-corners
    fd
    ripgrep
    jq
    fzf
    du-dust
    duf
    btop
    neofetch
    python3
    inputs.home-manager.packages.${pkgs.system}.default
    (retroarch.override {
      cores = with libretro; [
        bsnes
      	nestopia
      	genesis-plus-gx
        dolphin
      ];
    })
    jdk17
    wireshark
    zip
    unzip
    spotify
    config.nur.repos.milahu.spotify-adblock
    unstable.papirus-nord
    nerdfonts
  ];
  # enable man cache
  documentation.man.generateCaches = true;

  programs.light.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses

  # Z Shell
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # Hostname
  networking.hostName = "midnight";
  networking.extraHosts = ''
    23.215.223.144 media.steampowered.com
  '';
  networking.networkmanager.enable = true;

  services.nscd = {
    enableNsncd = true;
  };

  # Date and time
  services.chrony.enable = true;
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Desktop environment
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.sessionPackages = [ pkgs.sway ]; # TODO: swayfx

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;  
  };

  # Bootloader stuff
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-4e035de1-8190-4e3f-8eb8-4ff52729addb".device = "/dev/disk/by-uuid/4e035de1-8190-4e3f-8eb8-4ff52729addb";
  boot.initrd.luks.devices."luks-4e035de1-8190-4e3f-8eb8-4ff52729addb".keyFile = "/crypto_keyfile.bin";

  # Plymouth
  boot.plymouth = {
    enable = true;
  };

  # Services
  # Polkit
  security.polkit.enable = true;  
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # PAM
  security.pam.services.swaylock = {};

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.udev.extraRules = ''
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
  '';

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"   ; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio" ; type = "-"   ; value = "99"       ; }
    { domain = "@audio"; item = "nofile" ; type = "soft"; value = "99999"    ; }
    { domain = "@audio"; item = "nofile" ; type = "hard"; value = "524288"    ; }
  ];

  # Flatpak
  services.flatpak.enable = true;  

  # Configure your system-wide user settings (groups, etc)
  users.users = {
    genius = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "genius";
      extraGroups = [ "networkmanager" "wheel" "wireshark" "audio" "video" ];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      genius = import ../home-manager/home.nix;
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
