{ lib, stdenv, pkgs ? import <nixpkgs> {} }:


  stdenv.mkDerivation rec {
    name = "lingmo-settings-${version}";
    version = "2.0.2";
    owner = "LingmoOS";
    repo = "lingmo-settings";
    rev = "refs/tags/v${version}";
    sha256 = "05y0vbcxf9x6j9fs8zsj2j9m2an896ra3p90gnikf4a0kqkq9x3l";
  };

  buildInputs = with pkgs; [
    qt5-base qt5-quickcontrols2 qt5-x11extras freetype2
    fontconfig networkmanager-qt modemmanager-qt libqtxdg
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
    description = "LingmoOS - Settings";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
