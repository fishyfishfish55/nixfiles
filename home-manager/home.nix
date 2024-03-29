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

    ./cli/cli.nix
    ./cli/helix.nix
    ./cli/tmux.nix
    ./cli/zsh.nix
    ./desktop/desktop.nix
    ./desktop/sway.nix
    ./desktop/waybar.nix
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

  # Extra packages with no config
  home.packages = with pkgs; [
    cava
    tldr
    firefox
    reaper
    iosevka
    nerdfonts
    libreoffice-fresh
    mpv
    octave
    youtube-dl
    doomretro
    autotiling
    weechat
    # Helix packages
    # TODO: move to ExtraPackages
    marksman
    rust-analyzer
    lua-language-server
    nil
    clang-tools
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
