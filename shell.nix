{ ... }:
let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs { };
  niv = import sources.niv { };
  pa11y = import ./nix/pkgs/pa11y { pkgs = nixpkgs; };
in with nixpkgs;
stdenv.mkDerivation {
  name = "bytes.zone";
  buildInputs = [ niv.niv git zola pa11y.pa11y pngcrush ];
}
