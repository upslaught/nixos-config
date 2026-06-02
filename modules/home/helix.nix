{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };

    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = "${pkgs.alejandra}/bin/alejandra";
          args = ["--quiet"];
        };
      }
    ];
  };
}
