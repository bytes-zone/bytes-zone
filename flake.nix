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
        # `nix fmt`
        formatter = pkgs.nixpkgs-fmt;

        # `nix build`
        packages.bytes-zone-public = pkgs.stdenv.mkDerivation {
          name = "bytes.zone-public";
          srcs = [
            ./content
            ./syntaxes
            ./templates
            ./config.toml
          ];

          unpackPhase = ''
            for src in $srcs; do
              tgt=$(stripHash $src)

              if test -d $src; then
                cp -r $src $tgt
              elif test -f $src; then
                cp $src $tgt
              fi
            done
          '';

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
          src = builtins.filterSource
            (path: type:
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
          src = builtins.filterSource
            (path: type:
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
          src = builtins.filterSource
            (path: type:
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
          src = builtins.filterSource
            (path: type:
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

        packages.nginx-conf = pkgs.writeTextFile {
          name = "nginx.conf";
          destination = "/etc/nginx/nginx.conf";
          text = ''
            user nobody nobody;
            daemon off;
            error_log /dev/stdout info;
            pid /dev/null;
            events {}

            http {
              include ${pkgs.nginx}/conf/mime.types;
              types_hash_max_size 4096;

              # optimization
              sendfile on;
              tcp_nopush on;
              tcp_nodelay on;
              keepalive_timeout 65;

              gzip on;
              gzip_static on;
              gzip_vary on;
              gzip_comp_level 5;
              gzip_min_length 256;
              gzip_types application/atom+xml application/geo+json application/javascript application/json application/ld+json application/manifest+json application/rdf+xml application/vnd.ms-fontobject application/wasm application/x-rss+xml application/x-web-app-manifest+json application/xhtml+xml application/xliff+xml application/xml font/collection font/otf font/ttf image/bmp image/svg+xml image/vnd.microsoft.icon text/cache-manifest text/calendar text/css text/csv text/javascript text/markdown text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/xml;

              access_log /dev/stdout;

              server {
                listen 0.0.0.0:80 default_server;
                listen [::0]:80;
                http2 on;

                root ${packages.bytes-zone}/share/bytes.zone;

                add_header Strict-Transport-Security max-age=15768000 always;
                add_header Content-Security-Policy "default-src 'none'; child-src https:; script-src 'self' https://stats.bytes.zone; style-src 'self' 'unsafe-inline'; img-src 'self' data: https://stats.bytes.zone/count; manifest-src 'self'; font-src 'self'" always;
                add_header X-Frame-Options "SAMEORIGIN" always;
                add_header X-Content-Type-Options "nosniff" always;
                add_header X-XSS-Protection "1; mode=block" always;
              }
            }
          '';
        };

        # for debugging, if needed
        # packages.container = pkgs.dockerTools.buildLayeredImage {
        packages.container = pkgs.dockerTools.streamLayeredImage {
          name = "bytes.zone";

          # make /var/log/nginx so Nginx doesn't fail trying to open it (which
          # it does no matter what you say in log settings, apparently.
          extraCommands = ''
            mkdir -p tmp/nginx_client_body
            mkdir -p var/log/nginx
          '';

          contents = [
            pkgs.fakeNss
            pkgs.nginxMainline
            packages.bytes-zone
            packages.nginx-conf

            # for debugging, if needed
            # pkgs.dockerTools.binSh
            # pkgs.coreutils
          ];

          config = {
            "ExposedPorts"."80/tcp" = { };
            Entrypoint = "nginx";
            Cmd = [ "-c" "/etc/nginx/nginx.conf" ];

            # for debugging, if needed
            # Entrypoint = "/bin/sh";
          };
        };

        packages.pushContainer = pkgs.writeShellApplication {
          name = "push-container";
          runtimeInputs = [ pkgs.skopeo pkgs.jq pkgs.gzip ];
          text = ''
            ${packages.container} | gzip --fast > container.tar.gz

            CONTAINER="docker-archive:container.tar.gz"
            skopeo login "$DOCKER_REGISTRY" --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
            TAG="$(skopeo list-tags "$CONTAINER" | jq -r '.Tags[0]')"
            DEST="docker://$DOCKER_REGISTRY/$TAG"
            skopeo copy "$CONTAINER" "$DEST"

            echo "$TAG"
          '';
        };

        defaultPackage = packages.bytes-zone;
        overlay = final: prev: { bytes-zone = packages.bytes-zone; };

        # `nix develop`
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ zola pngcrush vale ]; };
      });
}
