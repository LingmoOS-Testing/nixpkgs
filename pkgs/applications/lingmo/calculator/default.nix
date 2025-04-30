{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lingmo-calculator";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-calculator";
    rev = version;
    sha256 = "18r4wpd7467rspdbnkvzsq87gd09jxxjl5ifwvnp8j41lx9s8lmz";
  };

  buildInputs = with pkgs; [
    qt5-tools
    qt5-quickcontrols2
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
    description = "LingmoOS - Calculator";
    homepage = "https://github.com/lingmoos/lingmo-calculator";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
