{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}: let
  c = config.lib.stylix.colors;

  mkScript = name: text:
    pkgs.writeShellScriptBin name text;

  # Full binary paths — used both in scripts (Nix-interpolated) and inline sway config
  fuzzel    = "${pkgs.fuzzel}/bin/fuzzel";
  foot      = "${pkgs.foot}/bin/foot";
  grim      = "${pkgs.grim}/bin/grim";
  slurp     = "${pkgs.slurp}/bin/slurp";
  wlCopy    = "${pkgs.wl-clipboard}/bin/wl-copy";
  wlPaste   = "${pkgs.wl-clipboard}/bin/wl-paste";
  cliphist  = "${pkgs.cliphist}/bin/cliphist";
  xdgOpen   = "${pkgs.xdg-utils}/bin/xdg-open";
  notify    = "${pkgs.libnotify}/bin/notify-send";
  swaymsg   = "${pkgs.sway}/bin/swaymsg";
  nh        = "${pkgs.nh}/bin/nh";
  ppctl     = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl";

  # ── swaylock script ────────────────────────────────────────────────────────
  # Defined as a derivation so the path is a clean single string usable
  # in sway mode bindings, swayidle events, and keybindings.
  scriptLock = mkScript "sway-lock" ''
    exec ${pkgs.swaylock-effects}/bin/swaylock \
      --screenshots \
      --clock \
      --indicator \
      --indicator-radius 120 \
      --indicator-thickness 7 \
      --effect-blur 7x5 \
      --effect-vignette 0.5:0.5 \
      --color "${c.base00}" \
      --key-hl-color "${c.base0D}" \
      --bs-hl-color "${c.base08}" \
      --ring-color "${c.base02}" \
      --ring-ver-color "${c.base0D}" \
      --ring-wrong-color "${c.base08}" \
      --ring-clear-color "${c.base0B}" \
      --inside-color "${c.base01}cc" \
      --inside-ver-color "${c.base0D}33" \
      --inside-wrong-color "${c.base08}33" \
      --inside-clear-color "${c.base0B}33" \
      --line-color "${c.base01}" \
      --line-ver-color "${c.base0D}" \
      --line-wrong-color "${c.base08}" \
      --line-clear-color "${c.base0B}" \
      --separator-color "${c.base02}" \
      --text-color "${c.base06}" \
      --text-ver-color "${c.base06}" \
      --text-wrong-color "${c.base08}" \
      --text-clear-color "${c.base0B}" \
      --font "${config.stylix.fonts.sansSerif.name}" \
      --fade-in 0.1
  '';
  lock = "${scriptLock}/bin/sway-lock";

  # ── Utility scripts ────────────────────────────────────────────────────────

  # Clipboard history picker
  scriptClipboard = mkScript "sway-clipboard" ''
    ${cliphist} list \
      | ${fuzzel} --dmenu --placeholder "clipboard…" \
      | ${cliphist} decode \
      | ${wlCopy}
  '';

  # Region screenshot → file + clipboard
  scriptScreenshot = mkScript "sway-screenshot" ''
    sel=$(${slurp}) || exit 0
    dest="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
    mkdir -p "$HOME/Pictures/Screenshots"
    ${grim} -g "$sel" - | tee "$dest" | ${wlCopy} -t image/png
    ${notify} -t 2000 -i camera "Screenshot" "Region saved and copied"
  '';

  # Region screenshot → tesseract OCR → clipboard
  scriptOcr = mkScript "sway-ocr" ''
    sel=$(${slurp}) || exit 0
    tmp=$(mktemp --suffix=.png)
    ${grim} -g "$sel" "$tmp"
    text=$(${pkgs.tesseract}/bin/tesseract "$tmp" stdout 2>/dev/null)
    rm -f "$tmp"
    if [ -n "$text" ]; then
      printf '%s' "$text" | ${wlCopy}
      ${notify} -t 2000 "OCR" "Text copied to clipboard"
    else
      ${notify} -u critical -t 3000 "OCR" "No text recognised"
    fi
  '';

  # File search (fd → fuzzel → xdg-open)
  scriptFileOpen = mkScript "sway-file-open" ''
    file=$(${pkgs.fd}/bin/fd \
        --type f \
        --hidden \
        --follow \
        --exclude .git \
        --exclude node_modules \
        --exclude target \
        . "$HOME" \
      | ${fuzzel} --dmenu --placeholder "open file…") || exit 0
    [ -n "$file" ] && ${xdgOpen} "$file"
  '';

  # Emoji picker → clipboard
  scriptEmoji = mkScript "sway-emoji" ''
    choice=$(printf '%s\n' \
      "😀 grinning" "😂 joy" "😍 heart eyes" "😎 sunglasses" \
      "😭 cry" "😱 scream" "🤔 think" "🤣 rofl" \
      "😴 sleep" "😡 angry" "🥺 plead" "🤯 explode" \
      "🎉 party" "🔥 fire" "✨ sparkles" "💯 hundred" \
      "👍 thumbs up" "👎 thumbs down" "👏 clap" "🙏 pray" \
      "❤️ heart" "💙 blue heart" "💚 green heart" "🖤 black heart" \
      "🐛 bug" "🦀 crab" "🐧 penguin" "🦊 fox" "🐍 snake" \
      "🚀 rocket" "⭐ star" "🌙 moon" "☀️ sun" "⚡ lightning" \
      "💀 skull" "👻 ghost" "🤖 robot" "👾 alien" \
      "🍕 pizza" "🍺 beer" "☕ coffee" "🍜 ramen" \
      "📦 package" "🔧 wrench" "🔑 key" "📎 clip" \
      "✅ check" "❌ cross" "⚠️ warn" "ℹ️ info" \
      | ${fuzzel} --dmenu --placeholder "emoji…") || exit 0
    emoji=$(printf '%s' "$choice" | cut -d' ' -f1)
    [ -n "$emoji" ] && printf '%s' "$emoji" | ${wlCopy}
    ${notify} -t 1500 "Emoji" "$emoji copied"
  '';

  # Fish history picker → clipboard
  scriptFishHistory = mkScript "sway-fish-history" ''
    choice=$(${pkgs.fish}/bin/fish -c 'builtin history' \
      | ${fuzzel} --dmenu --placeholder "history…") || exit 0
    [ -n "$choice" ] && printf '%s' "$choice" | ${wlCopy}
    ${notify} -t 1500 "Copied" "Command copied to clipboard"
  '';

  # nix run a package (opens in foot)
  scriptNixRun = mkScript "sway-nix-run" ''
    pkg=$(printf '''' | ${fuzzel} --dmenu \
      --placeholder "nix run nixpkgs#…") || exit 0
    [ -z "$pkg" ] && exit 0
    ${foot} ${pkgs.fish}/bin/fish -c \
      "nix run nixpkgs#$pkg; echo; read -P 'Press Enter to close'"
  '';

  # Run arbitrary shell command in foot
  scriptRunCmd = mkScript "sway-run-cmd" ''
    cmd=$(printf '''' | ${fuzzel} --dmenu \
      --placeholder "run command…") || exit 0
    [ -z "$cmd" ] && exit 0
    ${foot} ${pkgs.fish}/bin/fish -c \
      "$cmd; echo; read -P 'Press Enter to close'"
  '';

  # Power profile switcher
  scriptPowerProfile = mkScript "sway-power-profile" ''
    choice=$(printf 'performance\nbalanced\npower-saver\n' \
      | ${fuzzel} --dmenu --placeholder "power profile…") || exit 0
    [ -n "$choice" ] && ${ppctl} set "$choice"
    ${notify} -t 2000 "Power" "Profile: $choice"
  '';

  # ── Mode label strings ─────────────────────────────────────────────────────
  modeSystem = "system: [l]ock  [e]xit  [s]leep  [r]eboot  [p]oweroff";
  modeNix    = "nix: [r]ebuild  [t]est  [b]oot  [u]pdate";
in {
  # Hand-theme everything that touches sway colours
  stylix.targets.sway.enable = false;
  stylix.targets.i3status-rust.enable = false;
  stylix.targets.swaylock.enable = false;

  home.packages = with pkgs; [
    cliphist
    wl-clipboard
    libnotify
    tesseract
    swaylock-effects
    power-profiles-daemon
    # scripts available on PATH (useful for manual invocation too)
    scriptLock
    scriptClipboard
    scriptScreenshot
    scriptOcr
    scriptFileOpen
    scriptEmoji
    scriptFishHistory
    scriptNixRun
    scriptRunCmd
    scriptPowerProfile
  ];

  # ── swayidle ───────────────────────────────────────────────────────────────
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = lock;
      }
      {
        timeout = 600;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
    ];
    events = [
      { event = "before-sleep"; command = lock; }
      { event = "lock";         command = lock; }
    ];
  };

  # ── i3status-rust ─────────────────────────────────────────────────────────
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      blocks = [
        { block = "music"; }
        {
          block = "net";
          format = " ⇡ $speed_up ⇣ $speed_down ";
          interval = 1;
        }
        {
          block = "cpu";
          format = " $icon  $utilization ";
          interval = 1;
        }
        {
          block = "memory";
          format = " $icon  $mem_used.eng(w:1)/$mem_total.eng(w:1) ";
          format_alt = " $icon  $mem_used_percents.eng(w:1) ";
          interval = 1;
        }
        {
          block = "weather";
          format = " $icon  $weather, $temp ";
          autolocate = true;
          service.name = "metno";
        }
        { block = "sound"; }
        {
          block = "time";
          format = " $icon  $timestamp.datetime(f:'%m/%d/%y %R') ";
          interval = 60;
        }
      ];

      settings = {
        theme = {
          theme = "plain";
          overrides = {
            idle_bg     = "#${c.base01}";
            idle_fg     = "#${c.base06}";
            info_bg     = "#${c.base0D}";
            info_fg     = "#${c.base00}";
            good_bg     = "#${c.base0B}";
            good_fg     = "#${c.base00}";
            warning_bg  = "#${c.base0A}";
            warning_fg  = "#${c.base00}";
            critical_bg = "#${c.base08}";
            critical_fg = "#${c.base00}";
            separator   = " ";
          };
        };
        icons.icons = "material-nf";
      };
    };
  };

  # ── swayosd ───────────────────────────────────────────────────────────────
  services.swayosd = {
    enable = true;
    topMargin = 0.9;
  };

  # ── sway ──────────────────────────────────────────────────────────────────
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";

      window.border = 1;

      # Clipboard history daemon — full paths, no ambiguity
      startup = [
        { command = "${wlPaste} --watch ${cliphist} store"; }
      ];
      # Note: swayidle is managed by services.swayidle above (systemd unit),
      # so no need to launch it from startup.

      # ── Colors ──────────────────────────────────────────────────────────
      colors = lib.mkForce {
        focused = {
          border      = "#${c.base0D}";
          background  = "#${c.base02}";
          text        = "#${c.base06}";
          indicator   = "#${c.base0D}";
          childBorder = "#${c.base0D}";
        };
        focusedInactive = {
          border      = "#${c.base02}";
          background  = "#${c.base01}";
          text        = "#${c.base06}";
          indicator   = "#${c.base02}";
          childBorder = "#${c.base02}";
        };
        unfocused = {
          border      = "#${c.base02}";
          background  = "#${c.base01}";
          text        = "#${c.base04}";
          indicator   = "#${c.base02}";
          childBorder = "#${c.base02}";
        };
        urgent = {
          border      = "#${c.base08}";
          background  = "#${c.base08}";
          text        = "#${c.base00}";
          indicator   = "#${c.base08}";
          childBorder = "#${c.base08}";
        };
      };

      # ── Bar ─────────────────────────────────────────────────────────────
      bars = [
        {
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = {
            names = [
              config.stylix.fonts.sansSerif.name
              config.stylix.fonts.monospace.name
            ];
            size = 10.0;
          };
          position    = "top";
          trayOutput  = "primary";
          trayPadding = 4;
          colors = {
            background = "#${c.base01}";
            statusline = "#${c.base06}";
            separator  = "#${c.base02}";
            focusedWorkspace = {
              border     = "#${c.base0D}";
              background = "#${c.base02}";
              text       = "#${c.base06}";
            };
            activeWorkspace = {
              border     = "#${c.base02}";
              background = "#${c.base01}";
              text       = "#${c.base06}";
            };
            inactiveWorkspace = {
              border     = "#${c.base01}";
              background = "#${c.base01}";
              text       = "#${c.base06}";
            };
            urgentWorkspace = {
              border     = "#${c.base08}";
              background = "#${c.base08}";
              text       = "#${c.base01}";
            };
          };
        }
      ];

      # ── Output / input ───────────────────────────────────────────────────
      output."DP-1".mode = "1920x1080@179.998Hz";

      input."*" = {
        xkb_layout   = "us";
        repeat_delay = "200";
        repeat_rate  = "40";
      };

      # ── Modes ────────────────────────────────────────────────────────────
      modes = lib.mkOptionDefault {
        "${modeSystem}" = {
          l      = "exec ${lock}, mode default";
          e      = "exec ${swaymsg} exit, mode default";
          s      = "exec systemctl suspend, mode default";
          r      = "exec systemctl reboot, mode default";
          p      = "exec systemctl poweroff, mode default";
          Escape = "mode default";
          Return = "mode default";
        };

        "${modeNix}" = {
          r      = "exec ${foot} ${nh} os switch, mode default";
          t      = "exec ${foot} ${nh} os test, mode default";
          b      = "exec ${foot} ${nh} os boot, mode default";
          u      = "exec ${foot} ${nh} os switch --update, mode default";
          Escape = "mode default";
          Return = "mode default";
        };
      };

      # ── Keybindings ──────────────────────────────────────────────────────
      keybindings = lib.mkOptionDefault {
        # Launcher / apps
        "${modifier}+d"       = "exec ${fuzzel}";
        "${modifier}+w"       = "exec ${pkgs.brave}/bin/brave";
        "${modifier}+Return"  = "exec ${foot}";

        # Clipboard history
        "${modifier}+v"       = "exec ${scriptClipboard}/bin/sway-clipboard";

        # Screenshot / capture
        "${modifier}+Shift+s" = "exec ${scriptScreenshot}/bin/sway-screenshot";
        "${modifier}+Shift+c" = "exec ${scriptOcr}/bin/sway-ocr";

        # Fuzzel-based pickers
        "${modifier}+Shift+f" = "exec ${scriptFileOpen}/bin/sway-file-open";
        "${modifier}+Shift+e" = "exec ${scriptEmoji}/bin/sway-emoji";
        "${modifier}+Shift+h" = "exec ${scriptFishHistory}/bin/sway-fish-history";
        "${modifier}+Shift+n" = "exec ${scriptNixRun}/bin/sway-nix-run";
        "${modifier}+Shift+r" = "exec ${scriptRunCmd}/bin/sway-run-cmd";
        "${modifier}+Shift+p" = "exec ${scriptPowerProfile}/bin/sway-power-profile";

        # Lock
        "${modifier}+Shift+l" = "exec ${lock}";

        # Modes
        "${modifier}+BackSpace" = ''mode "${modeSystem}"'';
        "${modifier}+F1"        = ''mode "${modeNix}"'';

        # Brightness
        "XF86MonBrightnessUp"   = "exec ${pkgs.swayosd}/bin/swayosd-client --brightness +10";
        "XF86MonBrightnessDown" = "exec ${pkgs.swayosd}/bin/swayosd-client --brightness -10";

        # Playback
        "XF86AudioPlay" = "exec ${pkgs.swayosd}/bin/swayosd-client --playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.swayosd}/bin/swayosd-client --playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.swayosd}/bin/swayosd-client --playerctl previous";

        # Volume
        "XF86AudioRaiseVolume" = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume 5 --max-volume 100";
        "XF86AudioLowerVolume" = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume -5 --max-volume 100";
        "XF86AudioMute"        = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
        "XF86AudioMicMute"     = "exec ${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";

        # Caps lock indicator
        "Caps_Lock" = "exec ${pkgs.swayosd}/bin/swayosd-client --caps-lock";
      };
    };
  };
}
