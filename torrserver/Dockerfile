ARG BUILD_FROM
ARG BUILD_ARCH


FROM $BUILD_FROM AS base
RUN echo $BUILD_ARCH

FROM base AS base-armv7
COPY ./assets/TorrServer-linux-arm7 /torrserver

FROM base AS base-armhf
COPY ./assets/TorrServer-linux-arm7 /torrserver

FROM base AS base-amd64
COPY ./assets/TorrServer-linux-amd64 /torrserver

FROM base AS base-i386
COPY ./assets/TorrServer-linux-386 /torrserver

FROM base AS base-aarch64
COPY ./assets/TorrServer-linux-arm64 /torrserver

FROM base-${BUILD_ARCH}

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Aleksandr Trubilin <aatrubilin@gmail.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="TorrServer Home Assistant addon" \
    org.opencontainers.image.authors="Aleksandr Trubilin <aatrubilin@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/aatrubilin/hassio-torrserver" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

# Environment variables
ENV TS_CONF_PATH="/addon_config/config"
ENV TS_LOG_PATH="/addon_config/log"
ENV TS_TORR_DIR="/addon_config/torrents"
ENV TS_PORT=8090
ENV GODEBUG="madvdontneed=1"

# Create dirs
RUN mkdir -p $TS_CONF_PATH
RUN mkdir -p $TS_LOG_PATH
RUN mkdir -p $TS_TORR_DIR

RUN chmod a+x /torrserver

ENTRYPOINT /torrserver --path $TS_CONF_PATH --logpath $TS_LOG_PATH --torrentsdir $TS_TORR_DIR --port $TS_PORT
