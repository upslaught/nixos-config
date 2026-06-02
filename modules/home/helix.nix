{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      editors.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      editor.line-number = "relative";
    };

    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter = {
        command = "${pkgs.alejandra}/bin/alejandra";
        args = ["--quiet"];
      };
    }];
  };
}
