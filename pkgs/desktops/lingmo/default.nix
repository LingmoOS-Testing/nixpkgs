{ pkgs, makeScope, libsForQt5 }:

makeScope libsForQt5.newScope (self: with self; {
  lingmoUpdateScript = { name, version }: pkgs.genericUpdater {
    inherit version;
    pname = "lingmo-${name}";
    attrPath = "lingmo.${name}";
    versionLister = "${pkgs.common-updater-scripts}/bin/list-git-tags https://github.com/LingmoOS/${name}";
  };

  fetchFromLingmoGitHub = { name, version, sha256 }: pkgs.fetchFromGitHub {
    inherit sha256;
    owner = "LingmoOS";
    repo = name;
    rev = version;
  };

  calculator = callPackage ../../applications/lingmo/calculator { };
  core = callPackage ./core { };
  dock = callPackage ./dock { };
  filemanager = callPackage ./filemanager { };
  lingmoui = callPackage ../../development/libraries/lingmo/lingmoui { };
  icons = callPackage ./icons { };
  kwin-plugins = callPackage ./kwin-plugins { };
  launcher = callPackage ./launcher { };
  liblingmo = callPackage ../../development/libraries/lingmo/liblingmo { };
  qt-plugins = callPackage ./qt-plugins { };
  screenlocker = callPackage ./screenlocker { };
  sddm-theme = callPackage ./sddm-theme { };
  settings = callPackage ./settings { };
  statusbar = callPackage ./statusbar { };
  terminal = callPackage ../../applications/lingmo/terminal { };
  wallpapers = callPackage ./wallpapers { };
  texteditor = callPackage ./texteditor { };
  videoplayer = callPackage ./videoplayer { };
})