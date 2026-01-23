{ config, pkgs, pkgs-stable, ... }:

{
  home = let
    stable = with pkgs-stable; [

    ];

    unstable = with pkgs; [
      rusty-path-of-building
      steamtinkerlaunch
    ];
  in {
    packages = stable ++ unstable;
  };

  xdg.dataFile = {
    "Steam/compatibilitytools.d/SteamTinkerLaunch/compatibilitytool.vdf".text = ''
      "compatibilitytools"
      {
        "compat_tools"
        {
          "Proton-stl" // Internal name of this tool
          {
            "install_path" "."
            "display_name" "Steam Tinker Launch"

            "from_oslist"  "windows"
            "to_oslist"    "linux"
          }
        }
      }
    '';
    "Steam/compatibilitytools.d/SteamTinkerLaunch/steamtinkerlaunch".source =
      config.lib.file.mkOutOfStoreSymlink "${pkgs.steamtinkerlaunch}/bin/steamtinkerlaunch";
    "Steam/compatibilitytools.d/SteamTinkerLaunch/toolmanifest.vdf".text = ''
      "manifest"
      {
        "commandline" "/steamtinkerlaunch run"
        "commandline_waitforexitandrun" "/steamtinkerlaunch waitforexitandrun"
      }
    '';
  };
}
