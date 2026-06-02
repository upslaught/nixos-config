{pkgs, ...}: {
  programs.ssh = {
    enable = true;
    settings = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}
