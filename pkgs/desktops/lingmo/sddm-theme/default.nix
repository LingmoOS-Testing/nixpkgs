{ lib, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "sddm-theme";
  version = "2.7.0";
in

pkgs.stdenv.mkDerivation rec {
  inherit version;
  pname = "lingmo-${name}";

  src = fetchFromGitHub {
    owner = "LingmoOS"
    inherit name version;
    sha256 = "1b8x023hi86r8haw9spk48gxkafcs214cp9wa84ck2kx2g08kswa";
  };

  buildInputs = with pkgs; [
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