{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, mtl, network, stdenv, text
      }:
      mkDerivation {
        pname = "hstatsd";
        version = "0.1";
        src = ./.;
        libraryHaskellDepends = [ base bytestring mtl network text ];
        homepage = "https://github.com/mokus0/hstatsd";
        description = "Quick and dirty statsd interface";
        license = stdenv.lib.licenses.publicDomain;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
