{ lib, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "qt-plugins";
  version = "2.0.1";
in

pkgs.stdenv.mkDerivation rec {
  inherit version;
  name = "lingmo-${name}";

  src = fetchFromLingmoGitHub {
    inherit name version;
    sha256 = "0kbmqf3knxn5gqdkmarj7vrynjp5cyh7p3ibrgvdl8sdldzdjfi3";
  };

  buildInputs = with pkgs; [
    qt5-base qt5-tools qt5-x11extras libxdg libxcb
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
    description = "LingmoOS - Qt Plugins";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}