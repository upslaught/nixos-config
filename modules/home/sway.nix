{pkgs, ...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      output = {
        "DP-1" = {
          mode = "1920x1080@179.998Hz"; # where did my other .002 hz go :C
        };
      };
    };
  };
}
