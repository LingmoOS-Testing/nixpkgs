{ lib, stdenv, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} } :

  stdenv.mkDerivation rec {
    name = "lingmo-core-${version}";
    version = "2.0.2";
    owner = "LingmoOS";
    repo = "lingmo-core";
    rev = "refs/tags/v${version}";
    sha256 = "0v65zhm59xli70xgif3yrynqmmjy77dcsz4f975ggxa3ylj77p2g";
  };

  buildInputs = with pkgs; [
    qt5-tools qt5-quickcontrols2 cmake extra-cmake-modules
    kcoreaddons5 libxcursor qt5-x11extras qt5-graphicaleffects
    kwindowsystem5 kidletime5 polkit polkit-qt5 xorg-server-devel xf86-input-libinput
    xf86-input-synaptics make gcc pkgconf
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
    description = "LingmoOS - Core";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
