{ config, lib, pkgs, ... }:

with lib;

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.lingmo;

in

{
  options = {
    services.xserver.desktopManager.lingmo.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Lingmo Desktop manager";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.sessionPackages = [ pkgs.lingmo.core ];
    services.xserver.displayManager.sddm.theme = mkDefault "lingmo";
    services.accounts-daemon.enable = true;

    environment.pathsToLink = [ "/share" ];
    environment.systemPackages =
      let
        lingmoPkgs = with pkgs.lingmo; [
          core
          lingmoui
          texteditor
          terminal
          videoplayer
          wallpapers
          statusbar
          settings
          sddm-theme
          screenshots
          screenlocker
          qt-plugins
          launcher
          kwin-plugins
          filemanager
          dock
          calculator
          liblingmo
        ];
        plasmaPkgs = with pkgs.libsForQt5; [
          kglobalaccel
          kinit
          kwin
        ];
      in lingmoPkgs ++ plasmaPkgs;
  };
}