FROM ghcr.io/getzola/zola:v0.17.1 AS zola

COPY . /app
WORKDIR /app
RUN ["zola", "build"]
