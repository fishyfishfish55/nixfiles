{
	pkgs,
	...
}:{
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
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
}
