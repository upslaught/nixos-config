{
  pkgs,
  username,
  ...
}: let
  passwordHash = "$6$HvHy5GuCqk8N/a9y$rSFWcM1W8n2FHffTeS07ge5QPfqWtBIQ/71QioG1bD/q.0o7FfZt2F9mAuRtDoJYiS.oRVI1HYO7y9eOiRrXd0";
in {
  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_GB.UTF-8";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.fish.enable = true;

  security.sudo-rs.enable = true;

  users = {
    mutableUsers = false;

    users.${username} = {
      isNormalUser = true;
      hashedPassword = passwordHash;
      extraGroups = ["wheel" "networkmanager"];
      shell = pkgs.fish;
    };

    users.root.hashedPassword = passwordHash;
  };
}
