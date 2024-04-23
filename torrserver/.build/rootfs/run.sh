#!/usr/bin/with-contenv bashio
set -euo pipefail

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
  ACCESS_DB="${TS_CONF_PATH}/accs.db"
  jq_args=(-n )
  for key in $(bashio::config "logins|keys"); do
    USERNAME=$(bashio::config "logins[${key}].username")
    PASSWORD=$(bashio::config "logins[${key}].password")

    # Validate if username & password are not empty
    if bashio::config.is_empty "logins[${key}].username" || \
      bashio::config.is_empty "logins[${key}].password"
    then
      bashio::log.fatal
      bashio::log.fatal 'Configuration of logins is incomplete.'
      bashio::log.fatal
      bashio::log.fatal "username[${key}]: '${USERNAME}'"
      bashio::log.fatal "password[${key}]: '${PASSWORD}'"
      bashio::log.fatal
      bashio::log.fatal 'Please be sure to set not empty'
      bashio::log.fatal 'username and password for http auth!'
      bashio::log.fatal
      bashio::exit.nok
    fi

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

# Starting torrserver
export GODEBUG="madvdontneed=1"
FLAGS="--path $TS_CONF_PATH --torrentsdir $TS_TORR_DIR --port $TS_PORT"
bashio::log.info "Starting torrserver..."
bashio::log.info "torrserver ${FLAGS}"
torrserver $FLAGS
