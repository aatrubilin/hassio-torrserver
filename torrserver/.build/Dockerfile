# Based on https://github.com/YouROK/TorrServer/blob/master/Dockerfile
ARG BUILD_ARCH

### FRONT BUILD START ###
FROM --platform=$BUILDPLATFORM node:16-alpine as front
COPY ./src/web /app
WORKDIR /app

# Relative path for api endpoints
ENV REACT_APP_SERVER_HOST="."

# Build front once upon multiarch build
RUN yarn install && yarn run build
### FRONT BUILD END ###


### BUILD TORRSERVER MULTIARCH START ###
FROM --platform=$BUILDPLATFORM golang:1.22.2-alpine as builder

RUN apk add --update g++

COPY ./src /opt/src
COPY --from=front /app/build /opt/src/web/build

WORKDIR /opt/src

ARG TARGETARCH

# Step for multiarch build with docker buildx
ENV GOARCH=$TARGETARCH

# Build torrserver
RUN go run gen_web.go \
  && cd server \
  && go clean -i -r -cache \
  && go mod tidy \
  && go build -ldflags '-w -s' --o "torrserver" ./cmd
### BUILD TORRSERVER MULTIARCH END ###


### UPX COMPRESSING START ###
FROM --platform=$BUILDPLATFORM aerysinnovation/upx as compressed
COPY --from=builder /opt/src/server/torrserver ./torrserver
RUN upx --best --lzma ./torrserver
### UPX COMPRESSING END ###


### BUILD MAIN IMAGE START ###
FROM ghcr.io/hassio-addons/base/$BUILD_ARCH:15.0.8
RUN apk add --no-cache --update ffmpeg

# Environment variables
ENV TS_CONF_PATH="/config"
ENV TS_TORR_DIR="/config/torrents"
ENV TS_PORT=8090

# Copy files
COPY --from=compressed ./torrserver /usr/bin/torrserver
COPY ./rootfs /

# Add execution permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
### BUILD MAIN IMAGE end ###
