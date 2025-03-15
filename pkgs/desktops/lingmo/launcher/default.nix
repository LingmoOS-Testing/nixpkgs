{ lib, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "launcher";
  version = "2.0.2";
in

pkgs.stdenv.mkDerivation rec {
  inherit version;
  name = "lingmo-${name}";

  src = fetchFromLingmoGitHub {
    inherit name version;
    sha256 = "1dnnbf50zkwq6g0in060gllf5vn8dj7by5v54f0lx16g2x86plvv";
  };

  buildInputs = with pkgs; [
    qt5-quickcontrols2 qt5-base kwindowsystem5 cmake extra-cmake-modules
    qt5-tools make gcc pkgconf
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
    description = "LingmoOS - Launcher";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}