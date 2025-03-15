{ lib, fetchFromLingmoGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "kwin-plugins";
  version = "1.2.4";
in

pkgs.stdenv.mkDerivation rec {
  inherit version;
  name = "lingmo-${name}";

  src = fetchFromLingmoGitHub {
    inherit name version;
    sha256 = "0mph04qc24rjz5pdv20kfzfcj9q7w3j560b5x1q2cx69ddw81v7p";
  };

  buildInputs = with pkgs; [
    qt5-declarative qt5-base kwin kdecoration cmake extra-cmake-modules
    kwindowsystem kwayland kguiaddons kcoreaddons kconfigwidgets kconfig make gcc git
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
    description = "LingmoOS - Kwin Plugins";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}