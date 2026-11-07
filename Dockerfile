FROM caddy:2.11.7-alpine
COPY public /public
CMD ["caddy", "file-server", "--root", "/public"]
