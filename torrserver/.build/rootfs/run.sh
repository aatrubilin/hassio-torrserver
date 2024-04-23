#!/usr/bin/with-contenv bashio
set -euo pipefail

HTTPAUTH="$(bashio::config 'httpauth')"
bashio::log.info "HTTPAUTH: ${HTTPAUTH}"

# Init http creds
for key in $(bashio::config "accs.db|keys"); do
    USERNAME=$(bashio::config "accs.db[${key}].username")
    PASSWORD=$(bashio::config "accs.db[${key}].password")
    echo "${USERNAME}:${PASSWORD}"
done

if [ ! -d $TS_CONF_PATH ]; then
  mkdir -p $TS_CONF_PATH
fi

if [ ! -d $TS_TORR_DIR ]; then
  mkdir -p $TS_TORR_DIR
fi

export GODEBUG="madvdontneed=1"

FLAGS="--path $TS_CONF_PATH --torrentsdir $TS_TORR_DIR --port $TS_PORT"

bashio::log.info "Starting torrserver..."
bashio::log.info "torrserver ${FLAGS}"

torrserver $FLAGS
