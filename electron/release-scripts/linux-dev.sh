#!/bin/bash -e

# & Usage: ./linux-dev.sh RELEASE_VERSION [RELEASE_PATH]
# ** RELEASE_VERSION: The version string for the release.
#    RELEASE_PATH (optional): The directory where release artifacts will be stored.

# * Parse arguments
RELEASE_VERSION="$1"
RELEASE_PATH="${2:-$(pwd)/release_artifacts/linux/$RELEASE_VERSION}"

if [ -z "$RELEASE_VERSION" ]; then
  echo "Usage: $0 RELEASE_VERSION [RELEASE_PATH]"
  exit 1
fi

# & Sets our paths
REPO_ROOT="$(git rev-parse --show-toplevel)"
DIST_PATH="$REPO_ROOT/electron/dist/"

# & Ensure we're at the root of the repo
cd "$REPO_ROOT"

# & Install dependencies
pnpm install --frozen-lockfile

# & Clean previous builds
rm -rf "$DIST_PATH"

# & Build the project
cd electron
rm -rf app dist
mkdir -p "$DIST_PATH"
pnpm build:dev:linux

# & Prepare release directory
mkdir -p "$RELEASE_PATH"

# & Copy artifacts for release
cp "$DIST_PATH"/*.AppImage "$RELEASE_PATH"/ 2>/dev/null || true
