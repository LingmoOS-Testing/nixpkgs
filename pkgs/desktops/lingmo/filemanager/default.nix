{ lib, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:


  stdenv.mkDerivation rec {
    name = "lingmo-filemanager-${version}";
    version = "0.8.1";
    owner = "LingmoOS";
    repo = "lingmo-filemanager";
    rev = "refs/tags/v${version}";
    sha256 = "0a12cddik4dkjzr1n2yavmys9j0ji1pyxiks8syvll90dyikm2sj";
  };

  buildInputs = with pkgs; [
    qt5-quickcontrols2 cmake extra-cmake-modules
    kwindowsystem5 kio5 make gcc pkgconf
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
    description = "LingmoOS - File Manager";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
