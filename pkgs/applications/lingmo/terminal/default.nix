{ lib, fetchFromGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "terminal";
  version = "2.0.0";
in

pkgs.stdenv.mkDerivation rec {
  name = "lingmo-${name}";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    inherit name version;
    sha256 = "18zkllkj9s5s5a27sa8n4sq2cq18kx0mk09p982zim6d4frk5nq2";
  };

  buildInputs = with pkgs; [
    qt5-base qt5-declarative qt5-tools qt5-quickcontrols2
    qt5-graphicaleffects lingmoui cmake extra-cmake-modules
    qt5-x11extras make gcc pkgconf
  ];

  phases = [ "unpack" "build" "install" ];
  
  unpack = pkgs.runCommand "unpack-source" {} ''
      mkdir -p $out
      unzip -d $out $src
      cd $out/lingmo-${name}-${version}
      mkdir build
    '';

  build = pkgs.runCommand "build" {} ''
      cd $out/lingmo-${name}-${version}/build
      cmake -DCMAKE_INSTALL_PREFIX=/usr ..
      make -j$(nproc)
    '';

  install = pkgs.runCommand "install" {} ''
      cd $out/lingmo-${name}-${version}/build
      make DESTDIR=$out install
    '';

  meta = with lib; {
    description = "LingmoOS - Terminal";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}