#!/usr/bin/env bash
set -euo pipefail

OUT="betterlist.xdc"
VERSION_FILE="version.js"
FILES=("./src/index.html" "./src/langs.js" "./res/icon.png" "manifest.toml" "$VERSION_FILE")

# Make sure zip is available
command -v zip >/dev/null 2>&1 || { echo "zip not found" >&2; exit 2; }

# Determine version: prefer exact tag, fall back to short commit hash
APP_VERSION="unknown"
if git rev-parse --git-dir >/dev/null 2>&1; then
  APP_VERSION=$(git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD)
fi

# Write version file; remove it if anything below fails
trap 'rm -f "$VERSION_FILE"' ERR
printf '// generated during build\nconst APP_VERSION = %s;\n' "${APP_VERSION@Q}" > "$VERSION_FILE"

zip -9 -j -q "$OUT" "${FILES[@]}"
rm -f "$VERSION_FILE"