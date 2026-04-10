#!/usr/bin/env bash
set -euo pipefail

OUT="betterlist.xdc"
FILES=("index.html" "langs.js" "icon.png" "manifest.toml")

# Ensure zip is available
command -v zip >/dev/null 2>&1 || { echo "zip not found" >&2; exit 2; }

# Create/overwrite archive with maximum compression
zip -9 -j -q -r "$OUT" "${FILES[@]}"
