{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lingmo-texteditor";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-texteditor";
    rev = version;
    sha256 = "03cwx62f24ry9xaa9fcl489knzdgmx8dk7avizs3p8wbvahjaapn";
  };

  buildInputs = with pkgs; [
    qt5-base
    qt5-quickcontrols
    qt5-tools
    syntax-highlighting5
    cmake
    extra-cmake-modules
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
    description = "LingmoOS - Texteditor";
    homepage = "https://github.com/lingmoos/lingmo-texteditor";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
