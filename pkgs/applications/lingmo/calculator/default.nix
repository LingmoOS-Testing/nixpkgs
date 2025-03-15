{ lib, fetchFromGitHub, pkgs ? import <nixpkgs> {} }:

let
  name = "calculator";
  version = "0.6.3";
in

pkgs.stdenv.mkDerivation rec {
  name = "lingmo-${name}";

  src = fetchFromGitHub {
    owner = "LingmoOS"
    inherit name version;
    sha256 = "18r4wpd7467rspdbnkvzsq87gd09jxxjl5ifwvnp8j41lx9s8lmz";
  };

  buildInputs = with pkgs; [
    qt5-tools qt5-quickcontrols2 cmake extra-cmake-modules
    make gcc pkgconf
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
    description = "LingmoOS - Calculator";
    homepage = "https://lingmo.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkimium_76 ];
  };
}