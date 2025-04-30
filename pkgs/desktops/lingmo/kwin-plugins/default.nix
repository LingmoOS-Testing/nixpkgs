{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lingmo-kwin-plugins";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-kwin-plugins";
    rev = version;
    sha256 = "0mph04qc24rjz5pdv20kfzfcj9q7w3j560b5x1q2cx69ddw81v7p";
  };

  buildInputs = with pkgs; [
    qt5-declarative
    qt5-base
    kwin
    kdecoration
    cmake
    extra-cmake-modules
    kwindowsystem
    kwayland
    kguiaddons
    kcoreaddons
    kconfigwidgets
    kconfig
    make
    gcc
    git
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
    description = "LingmoOS - KWin Plugins";
    homepage = "https://github.com/lingmoos/lingmo-kwin-plugins";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
