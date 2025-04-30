{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lingmo-terminal";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-terminal";
    rev = version;
    sha256 = "18zkllkj9s5s5a27sa8n4sq2cq18kx0mk09p982zim6d4frk5nq2";
  };

  buildInputs = with pkgs; [
    qt5-base 
    qt5-declarative 
    qt5-tools 
    qt5-quickcontrols2
    qt5-graphicaleffects 
    lingmoui 
    cmake 
    extra-cmake-modules
    qt5-x11extras 
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
    description = "LingmoOS - Terminal";
    homepage = "https://github.com/lingmoos/lingmo-terminal";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
