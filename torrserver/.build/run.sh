#!/usr/bin/with-contenv bashio
set -euo pipefail

echo "Arch: ${BUILD_ARCH}"
echo "Starting TorrServer-$(cat /VERSION)"
ls -la /
/torrserver
