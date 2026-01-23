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

      "$mod" = "SUPER";
      "$terminal" = "wezterm";

      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, C, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, R, exec, rofi -show run"
        "$mod CTRL, SPACE, togglefloating"
        "$mod, P, pseudo"
        "$mod CTRL, P, togglesplit"
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        "$mod, ESCAPE, workspace, previous"
        "$mod, S, togglespecialworkspace, socials"
        "$mod, N, togglespecialworkspace, scratch"
        "$mod, M, togglespecialworkspace, music"
        "$mod, T, togglespecialworkspace, term"
        "$mod SHIFT, N, movetoworkspace, special:magic"
        "$mod, G, togglegroup"
        "$mod SHIFT CTRL, H, movewindoworgroup, l"
        "$mod SHIFT CTRL, J, movewindoworgroup, d"
        "$mod SHIFT CTRL, K, movewindoworgroup, u"
        "$mod SHIFT CTRL, L, movewindoworgroup, r"
        "$mod CTRL, J, changegroupactive, b"
        "$mod CTRL, K, changegroupactive, f"
        "$mod, v, exec, wezterm -n --config 'color_scheme=\"Sparky (Gogh)\"' --config enable_tab_bar=false start --class clipse -e clipse"
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
      windowrule = match:class (Signal), workspace special:socials
      windowrule = match:class (Signal), group set socials
      windowrule = match:class (discord), workspace special:socials
      windowrule = match:class (discord), group set socials
      windowrule = match:class (org.qutebrowser.qutebrowser), match:title (.*)(\[music\])(.*), workspace special:music
      windowrule = match:class (Rofi), pin 1
      windowrule = match:class (Rofi), stay_focused 1
      windowrule = match:class clipse, pin 1
      windowrule = match:class clipse, float 1
      windowrule = match:class clipse, size 922 852
      windowrule = match:class clipse, stay_focused 1

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
}
