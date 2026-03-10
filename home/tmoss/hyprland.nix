{ pkgs, pkgs-stable, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = {
        gaps_in = "8";
        gaps_out = "12";
        border_size = "3";

        "col.active_border" = "rgba(6e2470ee) rgba(187129ee) rgba(187129ee) 30deg";
        "col.inactive_border" = "rgba(187129ee)";

        resize_on_border = true;

        layout = "dwindle";
      };

      debug = {
        disable_logs = false;
      };

      misc = {
        enable_anr_dialog = false;
      };

      decoration = {
        rounding = "12";
        rounding_power = "3";

        shadow = {
          enabled = "true";
          range = "4";
          render_power = "3";
          color = "rgba(1a1a1aee)";
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      scrolling = {
        column_width = 0.7; 
        explicit_column_widths = "0.25, 0.333, 0.5, 0.666, 0.75, 1.0";
      };

      "$mod" = "SUPER";
      "$terminal" = "wezterm";

      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, C, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, R, exec, rofi -show run"
        "$mod CTRL, SPACE, togglefloating"
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        "$mod, ESCAPE, workspace, previous"
        "$mod, S, togglespecialworkspace, socials"
        "$mod, N, togglespecialworkspace, scratch"
        "$mod, M, togglespecialworkspace, music"
        "$mod, T, togglespecialworkspace, term"
        "$mod, G, togglegroup"
        "$mod SHIFT CTRL, H, movewindoworgroup, l"
        "$mod SHIFT CTRL, J, movewindoworgroup, d"
        "$mod SHIFT CTRL, K, movewindoworgroup, u"
        "$mod SHIFT CTRL, L, movewindoworgroup, r"
        "$mod CTRL, J, changegroupactive, b"
        "$mod CTRL, K, changegroupactive, f"
        "$mod, v, exec, wezterm -n --config 'color_scheme=\"Sparky (Gogh)\"' --config enable_tab_bar=false start --class clipse -e clipse"
        "$mod, comma, layoutmsg, move -col"
        "$mod, period, layoutmsg, move +col"
        "$mod, tab, layoutmsg, togglefit"
        "$mod, equal, layoutmsg, colresize +0.05"
        "$mod, minus, layoutmsg, colresize -0.05"
        "$mod SHIFT, equal, layoutmsg, colresize +conf"
        "$mod SHIFT, minus, layoutmsg, colresize -conf"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          )
          9)
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

    };
    extraConfig = ''
      exec-once = waybar
      exec-once = swaync
      exec-once = clipse -listen

      windowrule = match:class .*, suppress_event maximize
      windowrule = match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0", no_focus 1

      windowrule = match:class (org.wezfurlong.wezterm), workspace special:term
      windowrule = match:class (obsidian), workspace special:scratch
      windowrule = match:class (org.qutebrowser.qutebrowser), match:title (.*)(\[music\])(.*), workspace special:music

      windowrule = tag +social, match:class signal|discord|Element
      windowrule = match:tag social, workspace special:socials, group set socials

      windowrule = tag +dialog, match:class Rofi|clipse
      windowrule = match:tag dialog, pin 1, stay_focused 1
      windowrule = match:class clipse, float 1, size 922 852

      windowrule = tag +game, match:class ^steam_app_\d+
      windowrule = match:tag game, fullscreen 0, immediate 0, rounding 0, decorate 0, border_size 0

      workspace = 1, layout:scrolling
      workspace = 3, layout:scrolling, gapsout:0, gapsin:0

      bind = $mod, A, submap, leader
      submap = leader
      bind = , C, submap, browser_container
      submap = browser_container
      bind = , escape, submap, reset
      bind = , O, exec, hyprctl dispatch submap reset && /home/tmoss/.config/qutebrowser/userscripts/container-open
      bind = , A, exec, hyprctl dispatch submap reset && /home/tmoss/.config/qutebrowser/userscripts/container-add
      bind = , D, exec, hyprctl dispatch submap reset && /home/tmoss/.config/qutebrowser/userscripts/container-rm
      submap = leader
      bind = , escape, submap, reset
      submap = reset
    '';
  };

  programs.waybar = {
    settings = {
      layer = "top";

      modles-left = [
        "hyprland/workspace"
      ];

      modules-center = [
        "hyprland/window"
        "clock"
      ];

      modules-right = [
        "privacy"
        "hyprland/submap"
        "tray"
      ];
    };

    style = ''

    '';
  };
}
