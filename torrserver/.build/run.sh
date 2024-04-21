#!/usr/bin/with-contenv bashio
set -euo pipefail

ARCH="$(bashio::config 'arch')"

ls -la /

if [[ "$ARCH" = "auto" ]]
then
    ARCH=$BUILD_ARCH
fi

TS_VERSION=$(cat TS_VERSION)
#TS_VERSION=$(grep '\s*TS_VERSION: \w' /etc/build.yaml | sed 's/^.*: //')
TS_EXEC="/addon_config/TorrServer-${ARCH}"

echo "TorrServer version: ${TS_VERSION}"
echo "TorrServer exec: ${TS_EXEC}"
echo "Build arch: ${BUILD_ARCH}"
echo "Selected arch: ${ARCH}"

if [[ ! -f "$TS_EXEC" ]]
then
		echo "Downloading TorrServer-${TS_VERSION}..."
		wget -O $TS_EXEC "https://github.com/aatrubilin/hassio-torrserver/releases/download/${TS_VERSION}/TorrServer-${ARCH}" -nv
		chmod a+x $TS_EXEC
fi

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

echo "Starting ${TS_EXEC} ${FLAGS}"

$TS_EXEC $FLAGS
