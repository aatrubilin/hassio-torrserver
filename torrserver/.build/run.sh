#!/usr/bin/with-contenv bashio
set -euo pipefail

export GODEBUG="madvdontneed=1"

TS_VERSION=$(grep '\s*TS_VERSION: \w' /etc/build.yaml | sed 's/^.*: //')

echo "Starting TorrServer-${TS_VERSION}, arch: ${BUILD_ARCH}"

chmod a+x /torrserver

FLAGS="--path $TS_CONF_PATH --logpath $TS_LOG_PATH --port $TS_PORT --torrentsdir $TS_TORR_DIR"

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
