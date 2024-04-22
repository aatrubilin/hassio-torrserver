#!/usr/bin/with-contenv bashio

echo "Base image: ${BUILD_FROM}"

set -euo pipefail

if [ ! -d $TS_CONF_PATH ]; then
  mkdir -p $TS_CONF_PATH
fi

if [ ! -d $TS_TORR_DIR ]; then
  mkdir -p $TS_TORR_DIR
fi

if [ ! -f $TS_LOG_PATH ]; then
  touch $TS_LOG_PATH
fi

export GODEBUG="madvdontneed=1"

FLAGS="--path $TS_CONF_PATH --logpath $TS_LOG_PATH --port $TS_PORT --torrentsdir $TS_TORR_DIR"

echo "Starting torrserver ${FLAGS}"

torrserver $FLAGS
