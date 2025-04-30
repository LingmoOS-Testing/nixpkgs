{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lib_lingmo";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lib_lingmo";
    rev = version;
    sha256 = "17dcgivspa3sk29x0ps1jzbj67q4m9smwpwi4kabz2cykc3b16lg";
  };

  buildInputs = with pkgs; [
    qt5-quickcontrols2
    libsForQt5.qt5.qtbase
    modemmanager
    libsForQt5.qt5.qtsensors
    libsForQt5.networkmanager-qt
    libsFirQt5.libkscreen
    libsForQt5.bluez-qt
    libsForQt5.kio
    cmake
    extra-cmake-modules
    libsForQt5.qt5.qtdeclarative
    libsForQt5.qt5.qttools
    libpulseaudio
    libcanberra
    ];

  buildPhase = ''
    echo "Compiling ${pname}"
    mkdir -pv $out/build && cd $out/build
    cmake ..
    make -j$(nproc) || return 1
  '';

  installPhase = ''
    mkdir -pv $out
    cd $out/build
    make DESTDIR=$out install
  '';

  meta = with lib; {
    description = "LingmoOS System Library";
    homepage = "https://github.com/lingmoos/lib_lingmo";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [arkimium_76];
  };
}
