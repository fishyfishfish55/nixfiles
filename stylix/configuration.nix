{
  pkgs,
  ...
}: {
  stylix = {
    image = /home/genius/Pictures/wallpaper/citypaper.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    cursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 16;
    };
    fonts = {
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
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 11;
      };
    };
    targets = {
      plymouth.blackBackground = true;
    };
  };
}
