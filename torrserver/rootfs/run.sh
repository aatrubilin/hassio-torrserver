#!/usr/bin/with-contenv bashio
set -euo pipefail

DEBUG="$(bashio::config 'debug')"

echo "Build arch: ${BUILD_ARCH}"

if [[ "$DEBUG" = true ]]
then
    wget --version
    curl --version
    curl -svL https://api.github.com/repos/YouROK/TorrServer/releases/latest
fi

declare -A ARCH_MAP="( [armv7]=arm7 [amd64]=amd64 [i386]=386 [aarch64]=arm64 )"

TS_SOURCE="TorrServer-linux-${ARCH_MAP[${BUILD_ARCH}]}"
echo "TS_SOURCE=${TS_SOURCE}"

TS_URL="https://github.com/YouROK/TorrServer/releases/latest/download/${TS_SOURCE}"
echo "TS_URL=${TS_URL}"

TS_VERSION="$(curl -sL https://api.github.com/repos/YouROK/TorrServer/releases/latest | jq -r '.tag_name')"
echo "TS_VERSION=${TS_VERSION}"

TS_RUNFILE="/share/torrserver/TorrServer-${TS_VERSION}"
echo "TS_RUNFILE=${TS_RUNFILE}"

echo "Checking existed torrserver"

if [[ ! -f "$TS_RUNFILE" ]]
then
    echo "rm -f TorrServer-*"
		rm -f TorrServer-*
		echo "Downloading ${TS_SOURCE}-${TS_VERSION}..."
		wget -O $TS_RUNFILE $TS_URL -nv
fi

echo "Change mode"
chmod a+x $TS_RUNFILE

# On linux systems you need to set the environment variable before run
export GODEBUG=madvdontneed=1

echo "Starting TorrServer-${TS_VERSION}..."
$TS_RUNFILE
