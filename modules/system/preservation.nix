{username, ...}: {
  boot.tmp.useTmpfs = true;

  preservation = {
    enable = true;

    preserveAt."/persist" = {
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/bluetooth"
        "/etc/NetworkManager/system-connections"
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];

      users.${username} = {
        home = "/home/${username}";

        directories = [
          ".config"
          ".local/share"
          ".local/state"
          ".ssh"
          ".gnupg"
        ];
      };
    };
  };
}
