{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs ? import <nixpkgs> {},
}:
stdenv.mkDerivation rec {
  pname = "lingmo-videoplayer";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-videoplayer";
    rev = version;
    sha256 = "1gw784bqsvxidn8wlxylpg84bjbh5flpzsnmqrxn321x6vihya93";
  };

  buildInputs = with pkgs; [
    mpv
    qt5-base
    qt5-quickcontrols2
    qt5-tools
    cmake
    extra-cmake-modules
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
    description = "LingmoOS - Video Player";
    homepage = "https://github.com/lingmoos/lingmo-videoplayer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}

