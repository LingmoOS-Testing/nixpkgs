{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lingmo-qt-plugins";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-qt-plugins";
    rev = version;
    sha256 = "0kbmqf3knxn5gqdkmarj7vrynjp5cyh7p3ibrgvdl8sdldzdjfi3";
  };

  buildInputs = with pkgs; [
    qt5-quickcontrols2
    qt5-base
    kwindowsystem5
    cmake
    extra-cmake-modules
    qt5-tools
    make
    gcc
    pkgconf
  ];

  buildPhase = ''
    echo "Compiling $pkgname"
    mkdir -pv $out/build && cd $out/build
    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make -j$(nproc) || return 1
  '';

  installPhase = ''
    mkdir -pv $out
    cd $out/build
    make DESTDIR=$out install
  '';

  meta = with lib; {
    description = "LingmoOS - Qt5 Plugins";
    homepage = "https://github.com/lingmoos/lingmo-qt-plugins";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
