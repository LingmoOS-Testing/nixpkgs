{ lib, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "lib_lingmo";
  version = "1.10.1";
in

pkgs.stdenv.mkDerivation rec {
  pname = "lingmo-${name}";

  src = fetchFromLingmoGitHub {
    inherit name version;
    sha256 = "17dcgivspa3sk29x0ps1jzbj67q4m9smwpwi4kabz2cykc3b16lg";
  };

  buildInputs = with pkgs; [
    qt5-quickcontrols2 networkmanager-qt5 modemmanager-qt5 bluez-qt5
    libkscreen5 kio5 qt5-sensors
    cmake extra-cmake-modules make gcc pkgconf
  ];

  buildPhase = ''
    echo "Compiling ${pname}"
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
    description = "LingmoOS - Screenlocker";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}