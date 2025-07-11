#!/usr/bin/with-contenv bashio
set -euo pipefail

write_pem_block() {
  local pem_content="$1"
  local pem_file="$2"
  local pem_type="$3"  # For example: CERTIFICATE, PRIVATE KEY, RSA PRIVATE KEY

  if [[ -z "$pem_content" || -z "$pem_file" || -z "$pem_type" ]]; then
    echo "Usage: write_pem_block <pem_content> <pem_file> <pem_type>" >&2
    return 1
  fi

  echo "$pem_content" | tr -d '\n' | \
    sed -E "s/.*-----BEGIN ${pem_type}----- *//; s/ *-----END ${pem_type}-----.*//" | \
    tr -d ' ' | \
    fold -w 64 | \
    awk "BEGIN { print \"-----BEGIN ${pem_type}-----\" } { print } END { print \"-----END ${pem_type}-----\" }" \
    > "$pem_file"
}

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

# Ssl
if [[ "$(bashio::config 'ssl')" = true ]]
then
  bashio::log.info "ssl: enabled"
  FLAGS="${FLAGS} --ssl --sslport=8091"
  SSL_PATH="${TS_CONF_PATH}/.ssl"
  SSL_CERT=$(bashio::config "ssl_cert")
  if [ ! -d $SSL_CERT ]; then
    mkdir -p $SSL_PATH
    SSL_CERT_PATH="${SSL_PATH}/cert.pem"
    write_pem_block "$SSL_CERT" $SSL_CERT_PATH "CERTIFICATE"
    FLAGS="${FLAGS} --sslcert=${SSL_CERT_PATH}"
    bashio::log.info "ssl: added cert to ${SSL_CERT_PATH}"
  fi
  SSL_KEY=$(bashio::config "ssl_key")
  if [ ! -d $SSL_KEY ]; then
    mkdir -p $SSL_PATH
    SSL_KEY_PATH="${SSL_PATH}/key.pem"
    write_pem_block "$SSL_KEY" $SSL_KEY_PATH "PRIVATE KEY"
    FLAGS="${FLAGS} --sslkey=${SSL_KEY_PATH}"
    bashio::log.info "ssl: added key to ${SSL_KEY_PATH}"
  fi
else
  bashio::log.notice "ssl: disabled"
fi

# Starting torrserver
export GODEBUG="madvdontneed=1"
bashio::log.info "Starting torrserver..."
OBFUSCATED_FLAGS=$(echo $FLAGS | sed 's/\(--tgtoken=\)[^ ]*/\1*******/')
bashio::log.info "torrserver ${OBFUSCATED_FLAGS}"
torrserver $FLAGS
