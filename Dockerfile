FROM ghcr.io/getzola/zola:v0.17.1 AS zola
COPY content /app/content
COPY static /app/static
COPY syntaxes /app/syntaxes
COPY templates /app/templates
COPY config.toml /app/config.toml
WORKDIR /app
RUN ["zola", "build"]

FROM oven/bun:1.2.21 AS bun
COPY package.json bun.lock /app/
WORKDIR /app
RUN bun install

FROM oven/bun:1.2.21 AS html
COPY --from=bun /app/node_modules /app/node_modules
COPY --from=zola /app/public /app/public
WORKDIR /app
RUN node_modules/.bin/html-minifier \
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

FROM oven/bun:1.2.21 AS css
COPY --from=bun /app/node_modules /app/node_modules
COPY static/style.css /app/public/style.css
WORKDIR /app
RUN ./node_modules/.bin/cleancss -O 1 -o public/style.css public/style.css

FROM alpine:3.22.1 AS png
RUN apk add --no-cache pngcrush
COPY static /app/public
RUN find /app/public -type f -not -name '*.png' -delete
RUN find /app/public -type f -name "*.png" -exec pngcrush -rem alla -reduce -m 7 {} \;

FROM alpine:3.22.1 AS jpeg
RUN apk add --no-cache jpegoptim
COPY static/images/*/*.jpeg /app/public/images/
RUN find /app/public -type f -not -name '*.jpeg' -delete
RUN find /app/public -type f -name "*.jpeg" -exec jpegoptim --max=90 --strip-all --all-progressive --overwrite {} \;

FROM alpine:latest
COPY --from=html /app/public /public/
COPY --from=css /app/public /public/
COPY --from=png /app/public /public/
COPY --from=jpeg /app/public /public/
