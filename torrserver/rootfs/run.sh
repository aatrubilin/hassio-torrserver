#!/usr/bin/with-contenv bashio

TS_RUNFILE="/TorrServer"
TS_VERSION="$(curl -sL https://api.github.com/repos/YouROK/TorrServer/releases/latest | jq -r '.tag_name')"

echo "Downloading TorrServer" $TS_VERSION

wget -O $TS_RUNFILE https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-$BUILD_ARCH
chmod a+x $TS_RUNFILE

export GODEBUG=madvdontneed=1

echo "Starting TorrServer..."
$TS_RUNFILE
