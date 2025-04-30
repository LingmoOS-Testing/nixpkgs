{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lingmo-launcher";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-launcher";
    rev = version;
    sha256 = "1dnnbf50zkwq6g0in060gllf5vn8dj7by5v54f0lx16g2x86plvv";
  };

  buildInputs = with pkgs; [
    qt5-quickcontrols2
    qt5-base
    kwindowsystem5
    cmake
    extra-cmake-modules
    qt5-tools
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
    description = "LingmoOS - Launcher";
    homepage = "https://github.com/lingmoos/lingmo-launcher";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [arkimium_76];
  };
}
