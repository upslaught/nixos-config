{ pkgs, lib, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "rust"
    ];
    userSettings = {
      helix_mode = true;
      ui_font_size = lib.mkForce 17;
      buffer_font_size = lib.mkForce 24;
      telemetry.metrics = false;
    };
  };

  home.packages = with pkgs; [
    nixd
    nil
  ];
}
