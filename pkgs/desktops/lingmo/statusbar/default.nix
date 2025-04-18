{ lib, stdenv, pkgs ? import <nixpkgs> {} }:


  stdenv.mkDerivation rec {
    name = "lingmo-statusbar-${version}";
    version = "2.0.1";
    owner = "LingmoOS";
    repo = "lingmo-statusbar";
    rev = "refs/tags/v${version}";
    sha256 = "0k3as2rp6ryj0v4kbbi2h73hihmc1fib01p45khs82c66qq0s3hy";
  };

  buildInputs = with pkgs; [
    kwindowsystem5 qt5-base qt5-x11extras
    qt5-quickcontrols2 qt5-tools
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
    description = "LingmoOS - Status Bar";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
