{
  description = "bytes.zone website";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        # `nix build`
        packages.bytes-zone-public = pkgs.stdenv.mkDerivation {
          name = "bytes.zone-public";
          src = builtins.filterSource
            (path: type: builtins.match ".+(png|css|js|woff2|nix)$" path == null) ./.;

          buildInputs = [ pkgs.zola pkgs.nodePackages.html-minifier ];
          buildPhase = ''
            zola build

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
          '';

          installPhase = ''
            mkdir -p $out/share
            mv public $out/share/bytes.zone
          '';
        };

        packages.bytes-zone-css = pkgs.stdenv.mkDerivation {
          name = "bytes.zone-css";
          src = builtins.filterSource (path: type:
            type == "directory" || builtins.match ".+css$" path != null)
            ./static;

          buildInputs = [ pkgs.nodePackages.clean-css-cli ];

          buildPhase = ''
            for file in $(find . -type f -name '*.css'); do
              cleancss -O 1 -o $file.min $file
              printf '%s: %db -> %db\n' "$file" "$(wc -c $file | cut -d ' ' -f 1)" "$(wc -c $file.min | cut -d ' ' -f 1)"
              mv $file.min $file
            done
          '';

          installPhase = ''
            mkdir -p $out/share/bytes.zone
            for file in $(find . -type f); do
              mkdir -p $out/share/bytes.zone/$(dirname $file)
              mv $file $out/share/bytes.zone/$file
            done
          '';
        };

        packages.bytes-zone-js = pkgs.stdenv.mkDerivation {
          name = "bytes.zone-js";
          src = builtins.filterSource (path: type:
            type == "directory" || builtins.match ".+js$" path != null)
            ./static;

          buildInputs = [ pkgs.nodePackages.uglify-js ];

          buildPhase = ''
            for file in $(find . -type f -name '*.js'); do
              uglifyjs -o $file.min $file
              printf '%s: %db -> %db\n' "$file" "$(wc -c $file | cut -d ' ' -f 1)" "$(wc -c $file.min | cut -d ' ' -f 1)"
              mv $file.min $file
            done
          '';

          installPhase = ''
            mkdir -p $out/share/bytes.zone
            for file in $(find . -type f); do
              mkdir -p $out/share/bytes.zone/$(dirname $file)
              mv $file $out/share/bytes.zone/$file
            done
          '';
        };

        packages.bytes-zone-fonts = pkgs.stdenv.mkDerivation {
          name = "bytes.zone-fonts";
          src = builtins.filterSource (path: type:
            type == "directory" || builtins.match ".+woff2$" path != null)
            ./static;

          buildPhase = ''
            true
          '';

          installPhase = ''
            mkdir -p $out/share/bytes.zone
            for file in $(find . -type f); do
              mkdir -p $out/share/bytes.zone/$(dirname $file)
              mv $file $out/share/bytes.zone/$file
            done
          '';
        };

        packages.bytes-zone-pngs = pkgs.stdenv.mkDerivation {
          name = "bytes.zone-pngs";
          src = builtins.filterSource (path: type:
            type == "directory" || builtins.match ".+png$" path != null)
            ./static;

          buildInputs = [ pkgs.pngcrush ];
          buildPhase = ''
            find . -type f -name '*.png' | xargs -n 1 pngcrush -ow -rem alla -reduce -m 7
          '';

          installPhase = ''
            mkdir -p $out/share/bytes.zone
            for file in $(find . -type f); do
              mkdir -p $out/share/bytes.zone/$(dirname $file)
              mv $file $out/share/bytes.zone/$file
            done
          '';
        };

        packages.bytes-zone = pkgs.symlinkJoin {
          name = "bytes.zone";
          paths = [
            packages.bytes-zone-css
            packages.bytes-zone-fonts
            packages.bytes-zone-js
            packages.bytes-zone-pngs
            packages.bytes-zone-public
          ];
        };

        defaultPackage = packages.bytes-zone;
        overlay = final: prev: { bytes-zone = packages.bytes-zone; };

        # `nix develop`
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ zola pngcrush vale ]; };
      });
}
