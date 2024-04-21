#!/usr/bin/with-contenv bashio
set -euo pipefail

TS_VERSION=$(grep '\s*TS_VERSION: \w' build.yaml | sed 's/^.*: //')

echo "Starting TorrServer-${TS_VERSION}, arch: ${BUILD_ARCH}"

chmod a+x /torrserver

FLAGS="--path $TS_CONF_PATH --logpath $TS_LOG_PATH --port $TS_PORT --torrentsdir $TS_TORR_DIR"
if [[ "$TS_HTTPAUTH" -eq 1 ]]; then FLAGS="${FLAGS} --httpauth"; fi
if [[ "$TS_RDB" -eq 1 ]]; then FLAGS="${FLAGS} --rdb"; fi
if [[ "$TS_DONTKILL" -eq 1 ]]; then FLAGS="${FLAGS} --dontkill"; fi

if [ ! -d $TS_CONF_PATH ]; then
  mkdir -p $TS_CONF_PATH
fi

if [ ! -d $TS_TORR_DIR ]; then
  mkdir -p $TS_TORR_DIR
fi

if [ ! -f $TS_LOG_PATH ]; then
  touch $TS_LOG_PATH
fi

echo "Running with: ${FLAGS}"

/torrserver $FLAGS
