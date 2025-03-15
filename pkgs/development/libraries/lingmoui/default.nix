{ lib, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "LingmoUI";
  version = "3.1.1";
in

pkgs.stdenv.mkDerivation rec {
  inherit version;
  pname = "lingmo-${name}";

  src = fetchFromLingmoGitHub {
    inherit name version;
    sha256 = "1gjkd6yy6m69gcqf6vypds99j039x2bjxjyjz54qpcm3b4w3rgj8";
  };

  buildInputs = with pkgs; [
    qt5-quickcontrols2 qt5-x11extras kwindowsystem5
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
    description = "LingmoUI is a GUI library based on QQC2 (Qt Quick Controls 2), every Lingmo application uses it.";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}