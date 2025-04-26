#!/usr/bin/with-contenv bashio
set -euo pipefail

FLAGS="--path $TS_CONF_PATH --torrentsdir $TS_TORR_DIR --port $TS_PORT"

# Create conf path if not exists
if [ ! -d $TS_CONF_PATH ]; then
  mkdir -p $TS_CONF_PATH
fi

# Create torrents path if not exists
if [ ! -d $TS_TORR_DIR ]; then
  mkdir -p $TS_TORR_DIR
fi

# Build accs.db if httpauth enabled
if [[ "$(bashio::config 'httpauth')" = true ]]
then
  bashio::log.info "HTTPAuth: enabled"
  FLAGS="${FLAGS} --httpauth"
  ACCESS_DB="${TS_CONF_PATH}/accs.db"
  jq_args=(-n )
  for key in $(bashio::config "logins|keys"); do
    USERNAME=$(bashio::config "logins[${key}].username")
    PASSWORD=$(bashio::config "logins[${key}].password")

    # Warning if password is not safe
    if ! bashio::config.is_safe_password "${PASSWORD}"; then
      bashio::log.warning "Password for user '${USERNAME}' is not safe!"
    fi

    jq_args+=( --arg "${USERNAME}" "${PASSWORD}" )
    bashio::log.info "HTTPAuth: Added '${USERNAME}' user"
  done
  jq "${jq_args[@]}" '$ARGS.named' > "$ACCESS_DB"
else
  bashio::log.notice "HTTPAuth: disabled"
fi

# Add M3U_CUSTOM_HOST env
if [[ "$(bashio::config 'm3u_custom_host')" ]]
then
  M3U_CUSTOM_HOST=$(bashio::config "m3u_custom_host")
  export M3U_CUSTOM_HOST
  bashio::log.info "Enable custom m3u host: ${M3U_CUSTOM_HOST}"
else
  bashio::log.notice "Using default m3u host"
fi

# Add tgtoken
if [[ "$(bashio::config 'tgtoken')" ]]
then
  TGTOKEN=$(bashio::config "tgtoken")
  bashio::log.info "Enable telegram bot integration"
  FLAGS="${FLAGS} --tgtoken=${TGTOKEN}"
else
  bashio::log.notice "Telegram bot integration disabled"
fi

# Starting torrserver
export GODEBUG="madvdontneed=1"
bashio::log.info "Starting torrserver..."
bashio::log.info "torrserver ${FLAGS}"
torrserver $FLAGS
