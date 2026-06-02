{ pkgs, ... }:
{
  services = {
    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
    kwin-x11
    kate
    qrca
    discover
    khelpcenter
    plasma-workspace-wallpapers
  ];

  # optional
  environment.systemPackages = [ pkgs.kdePackages.partitionmanager ];
}
