{ lib, stdenv, pkgs ? import <nixpkgs> {} }:


  stdenv.mkDerivation rec {
    name = "lingmo-videoplayer-${version}";
    version = "2.0.1";
    owner = "LingmoOS";
    repo = "lingmo-videoplayer";
    rev = "refs/tags/v${version}";
    sha256 = "1gw784bqsvxidn8wlxylpg84bjbh5flpzsnmqrxn321x6vihya93";
  };

  buildInputs = with pkgs; [
    mpv qt5-base qt5-quickcontrols2 qt5-tools
    cmake extra-cmake-modules
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
    description = "Open source video player built using Qt/QML and libmpv.";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
