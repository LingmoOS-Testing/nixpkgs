{ lib, stdenv, pkgs ? import <nixpkgs> {} }:


  stdenv.mkDerivation rec {
    name = "lingmo-screenlocker-${version}";
    version = "2.0.2";
    owner = "LingmoOS";
    repo = "lingmo-screenlocker";
    rev = "refs/tags/v${version}";
    sha256 = "1nb26lrmspn522r7hwghk5za9h0rl2bcds8n8ayfnmpvx73vr4b5";
  };

  buildInputs = with pkgs; [
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
    description = "LingmoOS - Screenlocker";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}
