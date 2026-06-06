{
  config,
  pkgs,
  hostname,
  stateVersion,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../shared.nix
    ../../modules/system/preservation.nix
    ../../modules/system/kdeconnect.nix
    ../../modules/system/stylix.nix
    ../../modules/system/brave-policies
    ../../modules/system/warp.nix
    ../../modules/system/nh.nix
    ../../modules/system/niri.nix
    ../../modules/system/ld.nix
  ];

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    power-profiles-daemon.enable = true;
  };

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.limine.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = stateVersion;
}
