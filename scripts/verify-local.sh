#!/usr/bin/env bash
# Checksums for deploy verification notes (local git tree).
# Compare these digests to md5sum on /homeassistant/www/family-album after copy.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "Family Album local verify — $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "Repo: $ROOT"
echo

need=(frame.html week.json)
for f in "${need[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f" >&2
    exit 1
  fi
done

if command -v md5sum >/dev/null 2>&1; then
  SUM=md5sum
elif command -v md5 >/dev/null 2>&1; then
  SUM="md5 -r"
else
  echo "No md5sum/md5 available" >&2
  exit 1
fi

echo "== checksums (copy these next to HA md5sum output) =="
$SUM frame.html week.json
echo

if [[ -f frame.html ]]; then
  build="$(grep -oE "FRAME_BUILD[[:space:]]*=[[:space:]]*'[^']+'" frame.html | head -1 || true)"
  comment="$(grep -oE 'FRAME_BUILD=[^[:space:]]+' frame.html | head -1 || true)"
  echo "frame.html build marker: ${build:-?(none)} / comment ${comment:-?(none)}"
fi

echo
echo "Deploy target: /homeassistant/www/family-album only"
echo "Remember: bump Lovelace iframe ?v= on Overview + digital-frame"
echo "Symlink check on HA: readlink -f /config/www/family-album"
