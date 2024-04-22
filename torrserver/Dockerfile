ARG BUILD_FROM

FROM $BUILD_FROM

# Build arguments
ARG BUILD_FROM
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
ENV TS_CONF_PATH="/config"
ENV TS_TORR_DIR="/config/torrents"
ENV TS_PORT=8090
ENV BUILD_ARCH=$BUILD_ARCH
ENV BUILD_FROM=$BUILD_FROM

# Copy files
COPY ./rootfs /

# Add execution permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
