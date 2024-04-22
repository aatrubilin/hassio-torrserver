#!/usr/bin/with-contenv bashio
set -euo pipefail

if [ ! -d $TS_CONF_PATH ]; then
  mkdir -p $TS_CONF_PATH
fi

if [ ! -d $TS_TORR_DIR ]; then
  mkdir -p $TS_TORR_DIR
fi

export GODEBUG="madvdontneed=1"

FLAGS="--path $TS_CONF_PATH --torrentsdir $TS_TORR_DIR --port $TS_PORT"

echo "Starting torrserver ${FLAGS}"

torrserver $FLAGS
