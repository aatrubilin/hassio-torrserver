#!/bin/bash

PLATFORMS=(
  'linux/amd64'
  'linux/arm64'
  'linux/arm7'
  'linux/386'
)

type setopt >/dev/null 2>&1

set_goarm() {
  if [[ "$1" =~ arm([5,7]) ]]; then
    GOARCH="arm"
    GOARM="${BASH_REMATCH[1]}"
    GO_ARM="GOARM=${GOARM}"
  else
    GOARM=""
    GO_ARM=""
  fi
}

GOBIN="go"

$GOBIN version

LDFLAGS="'-s -w'"
FAILURES=""
ROOT=${PWD}
OUTPUT="${ROOT}/dist/TorrServer"

#### Build web
echo "Build web"
export NODE_OPTIONS=--openssl-legacy-provider
export REACT_APP_SERVER_HOST="."
$GOBIN run gen_web.go

#### Build server
echo "Build server"
cd "${ROOT}/server" || exit 1
$GOBIN clean -i -r -cache --modcache
$GOBIN mod tidy

BUILD_FLAGS="-ldflags=${LDFLAGS} -tags=nosqlite -trimpath"

#####################################
### X86 build section
#####

for PLATFORM in "${PLATFORMS[@]}"; do
  GOOS=${PLATFORM%/*}
  BIN_FILENAME="${OUTPUT}-${GOOS}-${GOARM}"
  CMD="GOOS=${GOOS} ${GO_ARM} ${GO_MIPS} ${GOBIN} build ${BUILD_FLAGS} -o ${BIN_FILENAME} ./cmd"
  echo "${CMD}"
  eval "$CMD" || FAILURES="${FAILURES} ${GOOS}/${GOARM}"
done
