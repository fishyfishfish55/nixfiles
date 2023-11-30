{
  pkgs,
  ...
}: {
  stylix.image = /home/genius/Pictures/wallpaper/cyberpunk.png;
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.overpass;
      name = "Overpass";
    };

    monospace = {
      package = pkgs.iosevka;
      name = "Iosevka";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
}
