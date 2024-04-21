#!/usr/bin/with-contenv bashio
set -euo pipefail

echo "Starting TorrServer-$(cat /VERSION), arch: ${BUILD_ARCH}"

ls -la /

chmod a+x /torrserver
/torrserver --path $TS_CONF_PATH --logpath $TS_LOG_PATH --torrentsdir $TS_TORR_DIR --port $TS_PORT
