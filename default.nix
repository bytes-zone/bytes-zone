{ ... }:
let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  gitignore = import sources.gitignore { };
in pkgs.stdenv.mkDerivation {
  name = "bytes.zone";
  src = gitignore.gitignoreSource ./.;

  buildInputs =
    [ pkgs.zola pkgs.yuicompressor pkgs.nodePackages.html-minifier ];
  buildPhase = ''
    zola build

    echo "compressing CSS"
    find public \
      -type f -name '*.css' \
      -exec yuicompressor -o {}.min {} \; \
      -exec mv {}.min {} \;

    echo "compressing HTML"
    html-minifier --collapse-whitespace --decode-entities --remove-comments --remove-attribute-quotes --remove-redundant-attributes --remove-optional-tags --remove-script-type-attributes --remove-style-link-type-attributes --input-dir public --output-dir public
  '';

  installPhase = ''
    mkdir -p $out/share
    mv public $out/share/bytes.zone
  '';
}
