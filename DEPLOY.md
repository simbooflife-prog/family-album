# Deploy checklist — Family Album frame

**Source of truth (only):** `/homeassistant/www/family-album`  
Served as `/local/family-album/`. Do **not** treat `/config/www/family-album` as a second tree (it should be a symlink).

Internal build id lives in `frame.html` as `FRAME_BUILD` (also in the HTML comment). **Lovelace `?v=` is separate** — HA must bump it on every deploy or tablets keep the old iframe.

## Steps

1. Edit in git (`main` on this repo). Commit + push.
2. Copy changed files **only** to SOT: `/homeassistant/www/family-album`.
3. Bump every Lovelace iframe `?v=` (Overview + digital-frame). Suggested next: match `FRAME_BUILD` (currently `20260912-ui1`).
4. Verify checksums (see below). If `/config/www/family-album` still exists, md5 **both** paths — they must match (symlink).
5. Hard refresh the frame (tablet / companion app / browser).

## md5 one-liners (on HA host)

```bash
# After deploy — SOT
md5sum /homeassistant/www/family-album/frame.html /homeassistant/www/family-album/week.json

# Symlink path (must match SOT byte-for-byte)
md5sum /config/www/family-album/frame.html /config/www/family-album/week.json

# Quick equality check
md5sum /homeassistant/www/family-album/frame.html /config/www/family-album/frame.html
```

Local git tree (before copy):

```bash
# From repo root
./scripts/verify-local.sh
# or: make verify
```

Compare the local script output to the HA `md5sum` lines after copy.

## Symlink note

```bash
readlink -f /config/www/family-album
# expect: /homeassistant/www/family-album
```

If the link died after reboot/restore, recreate the symlink. **Do not** copy a second tree into `/config/www/`.

## Lovelace `?v=` reminder

HA and tablets cache `frame.html` hard. Changing `FRAME_BUILD` inside the file is **not** enough by itself.

- Overview iframe: bump `?v=`
- digital-frame dashboard iframe: bump `?v=`
- Example: `/local/family-album/frame.html?v=20260912-ui1`

## Do not

- Deploy or edit `/config/www/family-album` as its own copy.
- Skip the `?v=` bump.
- Commit family photos (`*.jpg` / `*.jpeg` / `*.png` / `*.heic` under `photos/` or repo root).
- Wire new live create/edit/delete HA webhooks until the calendar contract is stable.
