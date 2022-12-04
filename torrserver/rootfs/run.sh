#!/usr/bin/with-contenv bashio

echo "Prepare download"
echo "Build arch: ${BUILD_ARCH}"

declare -A ARCH_MAP="( [armv7]=arm7 [amd64]=amd64 [i386]=386 [aarch64]=arm64 )"

TS_SOURCE="TorrServer-linux-${ARCH_MAP[${BUILD_ARCH}]}"
TS_URL="https://github.com/YouROK/TorrServer/releases/latest/download/${TS_SOURCE}"
TS_VERSION="$(curl -sL https://api.github.com/repos/YouROK/TorrServer/releases/latest | jq -r '.tag_name')"
TS_RUNFILE="/share/torrserver/TorrServer-${TS_VERSION}"

if [[ ! -f "$TS_RUNFILE" ]]
then
		rm -f TorrServer-*
		echo "Downloading ${TS_SOURCE}-${TS_VERSION}..."
		wget -O $TS_RUNFILE $TS_URL -v
		chmod a+x $TS_RUNFILE
fi

# On linux systems you need to set the environment variable before run
export GODEBUG=madvdontneed=1

echo "Starting TorrServer-${TS_VERSION}..."
$TS_RUNFILE
