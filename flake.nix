{
  description = "bytes.zone website";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        # `nix build`
        packages.bytes-zone = pkgs.stdenv.mkDerivation {
          name = "bytes.zone";
          src = ./.;

          buildInputs = [
            pkgs.zola
            pkgs.nodePackages.html-minifier
            pkgs.nodePackages.clean-css-cli
            pkgs.nodePackages.uglify-js
            pkgs.pngcrush
          ];
          buildPhase = ''
            zola build

            echo "compressing CSS"
            find public \
              -type f -name '*.css' \
              -exec cleancss -O 1 -o {}.min {} \; \
              -exec mv {}.min {} \;

            echo "compressing JS"
            find public \
              -type f -name '*.js' \
              -exec uglifyjs -o {}.min {} \; \
              -exec mv {}.min {} \;

            echo "compressing HTML"
            html-minifier \
              --collapse-whitespace \
              --decode-entities \
              --remove-comments \
              --remove-attribute-quotes \
              --remove-redundant-attributes \
              --remove-optional-tags \
              --remove-script-type-attributes \
              --remove-style-link-type-attributes \
              --file-ext html \
              --input-dir public \
              --output-dir public

            echo "compressing images"
            find public -type f -name '*.png' | xargs -n 1 pngcrush -ow -brute
          '';

          installPhase = ''
            mkdir -p $out/share
            mv public $out/share/bytes.zone
          '';
        };
        defaultPackage = packages.bytes-zone;
        overlay = final: prev: { bytes-zone = packages.bytes-zone; };

        # `nix develop`
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ zola pngcrush ]; };
      });
}
