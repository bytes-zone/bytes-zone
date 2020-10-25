{ ... }:
let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs { };
in nixpkgs.stdenv.mkDerivation {
  name = "bytes.zone";
  src = ./.;

  buildInputs = [ nixpkgs.zola ];
  buildPhase = ''
    zola build
  '';

  installPhase = ''
    mkdir -p $out/share
    mv public $out/share/bytes.zone
  '';
}
