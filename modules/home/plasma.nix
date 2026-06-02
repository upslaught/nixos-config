{ pkgs, inputs, ... }:
{
  programs.plasma = {
    enable = true;
    configFile."kdeglobals"."General"."XftSubPixel" = "rgb";
  };
}
