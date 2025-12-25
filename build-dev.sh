#!/bin/bash
set -e

# This script builds the TorrServer Docker image locally for testing.
# It is based on the .github/workflows/deploy.yaml workflow.

# --- CONFIGURATION ---
# Build architecture. Change if needed.
ARCH="amd64"
PLATFORM="linux/amd64"
# Local image name
IMAGE_NAME="local/torrserver"

# --- PREPARATION ---
echo "▶️ Preparing environment variables..."
# Change to the script's directory so paths are correct
cd "$(dirname "$0")"

VERSION=$(grep '^version: ' torrserver/config.yaml | sed 's/^.*: //')
VERSION_TS=$(echo "$VERSION" | cut -d "-" -f 2)

if [ -z "$VERSION" ] || [ -z "$VERSION_TS" ]; then
  echo "❌ Failed to determine VERSION or VERSION_TS from torrserver/config.yaml"
  exit 1
fi

echo "  Add-on version: ${VERSION}"
echo "  TorrServer version: ${VERSION_TS}"
echo "  Architecture: ${ARCH}"
echo "  Platform: ${PLATFORM}"

# --- SOURCE PREPARATION ---
echo "▶️ Preparing source code..."
BUILD_DIR="torrserver/.build"
SRC_DIR="${BUILD_DIR}/src"

echo "  Removing old source code directory..."
rm -rf "${SRC_DIR}"

echo "  Cloning TorrServer repository (version ${VERSION_TS})..."
git clone --depth 1 --branch "${VERSION_TS}" https://github.com/YouROK/TorrServer.git "${SRC_DIR}"

echo "  Copying custom files..."
cp -r "${BUILD_DIR}/customize/"* "${SRC_DIR}/"

# --- BUILD ---
echo "▶️ Building Docker image using buildx..."

# The TMDB API key is optional. An empty string is passed by default.
# If you need to pass a key, you can change this line:
# TMDB_API_KEY_VALUE="YOUR_TMDB_API_KEY"
TMDB_API_KEY_VALUE=""

# This Dockerfile requires buildx. We specify the platform for the current host (M1 Mac).
docker buildx build \
    --platform "${PLATFORM}" \
    --build-arg BUILD_ARCH="${ARCH}" \
    --build-arg BUILD_TYPE=debug \
    --build-arg TMDB_API_KEY="${TMDB_API_KEY_VALUE}" \
    -t "${IMAGE_NAME}:${VERSION}-${ARCH}" \
    --load \
    "${BUILD_DIR}"

echo "✅ Build completed successfully!"
echo "Images created:"
echo "  - ${IMAGE_NAME}:${VERSION}-${ARCH}"

echo "To run locally, execute:"
echo "  docker run -p 8090:8090 -it --rm \"${IMAGE_NAME}:${VERSION}-${ARCH}\"
