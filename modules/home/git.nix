{ ... }:
{
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Upslaught";
        email = "upslaught@tuta.io";
      };

      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
}
