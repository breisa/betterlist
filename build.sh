#!/usr/bin/env bash
set -euo pipefail

OUT="betterlist.xdc"
FILES=("./src/index.html" "./src/langs.js" "./res/icon.png" "manifest.toml" "version.js")

# Write version file that exports APP_VERSION
APP_VERSION="unknown"
if git rev-parse --git-dir >/dev/null 2>&1; then
  # Try an exact tag pointing at HEAD
  if tag="$(git describe --tags --exact-match 2>/dev/null || true)"; then
    if [ -n "$tag" ]; then
      APP_VERSION="$tag"
    else
      # Fallback to short commit hash
      APP_VERSION="$(git rev-parse --short HEAD)"
    fi
  else
    APP_VERSION="$(git rev-parse --short HEAD)"
  fi
fi
cat > ./version.js <<EOF
// generated during build
const APP_VERSION = ${APP_VERSION@Q};
EOF

# Ensure zip is available
command -v zip >/dev/null 2>&1 || { echo "zip not found" >&2; exit 2; }

# Create/overwrite archive with maximum compression
zip -9 -j -q -r "$OUT" "${FILES[@]}"
