{ inputs, username, stateVersion, ... }:
{
  imports = [
    ./modules/home
  ];

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;
}

