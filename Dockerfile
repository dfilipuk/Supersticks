FROM alpine AS builder
ARG FASM_VERSION=1.73.27
WORKDIR /app
RUN apk add zip
RUN apk add curl
RUN curl -sL "https://flatassembler.net/fasm-$FASM_VERSION.tgz" | tar xz
COPY src .
RUN fasm/fasm Supersticks.asm Sticks.com
RUN zip Sticks.zip Sticks.com

FROM nginx:1.21.3-alpine
EXPOSE 80
WORKDIR /usr/share/nginx/html
COPY src/bin/index.html index.html
COPY --from=builder /app/Sticks.zip Sticks.zip