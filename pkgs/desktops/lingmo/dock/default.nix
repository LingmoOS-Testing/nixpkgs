{ lib, stdenv, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:

  stdenv.mkDerivation rec {
    name = "lingmo-dock-${version}";
    version = "2.0.3";
    owner = "LingmoOS";
    repo = "lingmo-dock";
    rev = "refs/tags/v${version}";
    sha256 = "1458gn8fh6lzwspqdr89b8c3lk4iqhjyxhsgjj136v8jr10x14a5";
  };

  buildInputs = with pkgs; [
    qt5-tools qt5-quickcontrols2 cmake extra-cmake-modules
    qt5-x11extras make gcc pkgconf
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
    description = "LingmoOS - Dock";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
