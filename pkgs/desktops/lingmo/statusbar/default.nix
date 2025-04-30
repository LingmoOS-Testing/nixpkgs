{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lingmo-statusbar";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-statusbar";
    rev = version;
    sha256 = "0k3as2rp6ryj0v4kbbi2h73hihmc1fib01p45khs82c66qq0s3hy";
  };

  buildInputs = with pkgs; [
    kwindowsystem5
    qt5-base
    qt5-x11extras
    qt5-quickcontrols2
    qt5-tools
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
    description = "LingmoOS - Status Bar";
    homepage = "https://github.com/lingmoos/lingmo-statusbar";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
