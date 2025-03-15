{ lib, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "texteditor";
  version = "2.0.1";
in

pkgs.stdenv.mkDerivation rec {
  inherit version;
  name = "lingmo-${name}";

  src = fetchFromLingmoGitHub {
    inherit name version;
    sha256 = "03cwx62f24ry9xaa9fcl489knzdgmx8dk7avizs3p8wbvahjaapn";
  };

  buildInputs = with pkgs; [
    qt5-base qt5-quickcontrols qt5-tools syntax-highlighting5
    cmake extra-cmake-modules
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
    description = "LingmoOS - Text Editor";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}