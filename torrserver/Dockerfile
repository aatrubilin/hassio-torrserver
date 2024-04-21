FROM inutano/wget as download

ARG BUILD_FROM
ARG BUILD_ARCH
ARG TS_VERSION

RUN echo "test"
RUN echo $BUILD_ARCH
RUN echo $TS_VERSION

ENV BUILD_ARCH=$BUILD_ARCH
ENV TS_VERSION=$TS_VERSION

RUN echo $BUILD_ARCH
RUN echo $TS_VERSION

RUN wget -O /torrserver https://github.com/aatrubilin/hassio-torrserver/releases/download/${TS_VERSION}/TorrServer-${BUILD_ARCH} -nv

FROM $BUILD_FROM

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

# Copy torrserver
COPY --from=download /torrserver /torrserver

# Environment variables
ENV TS_CONF_PATH="/addon_config/config"
ENV TS_LOG_PATH="/addon_config/log"
ENV TS_TORR_DIR="/addon_config/torrents"
ENV TS_PORT=8090
ENV GODEBUG="madvdontneed=1"
ENV BUILD_ARCH=$BUILD_ARCH

# Install ffmpeg
RUN apk add --no-cache --update ffmpeg

# Copy files
COPY ./.build/run.sh /run.sh
COPY ./assets/VERSION /VERSION

# Add execution permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
