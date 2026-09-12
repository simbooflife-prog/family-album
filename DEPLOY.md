# Deploy checklist — Family Album frame

**Source of truth (only):** `/homeassistant/www/family-album`  
Served as `/local/family-album/`. Do **not** treat `/config/www/family-album` as a second tree (it should be a symlink).

Internal build id lives in `frame.html` as `FRAME_BUILD` (also in the HTML comment). **Lovelace `?v=` is separate** — HA must bump it on every deploy or tablets keep the old iframe.

## Steps

1. Edit in git (`main` on this repo). Commit + push.
2. Copy changed files **only** to SOT: `/homeassistant/www/family-album`.
3. Bump every Lovelace iframe `?v=` (Overview + digital-frame). Suggested next: match `FRAME_BUILD` (currently `20260912-ui4`).
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
- Example: `/local/family-album/frame.html?v=20260912-ui4`

## Calendar webhooks (create + delete)

Same-origin from the frame iframe on HA:

| Action | Method | Path | Body |
| --- | --- | --- | --- |
| Create | `POST` | `/api/webhook/fa_cal_evt_7c3a91e2b4d06f18a9e55c21` | `{ title, date, time?, duration_minutes, calendar_id? }` |
| Delete | `POST` | `/api/webhook/fa_cal_del_7c3a91e2b4d06f18a9e55c21` | `{ uid, recurrence_id? }` |

**Delete verification (do not trust HTTP 200 alone):** after the delete POST, the frame checks `/local/family-album/last_delete_status.json` (defensive `success` / `ok` / `deleted` / `status` fields) **and/or** re-fetches `/local/family-album/week.json` until the event `uid` is gone (short retry). UI only updates after verification. **Edit is not supported** (no HA update webhook).


## Layout edit (digital-frame only)

- **Overview mini** iframe (no `?standby=1`): overlays are **always locked** — no drag / move / resize. Gear hidden.
- **Full digital-frame** (`?standby=1`, often with `?ha=1`): layout locked by default. Tap the **⚙** gear (top-left HUD) to enter edit mode; tap **Done** (or gear again) to re-lock.
- Detection: `URLSearchParams` `standby=1` → full frame; absent/false → Overview mini.

## Do not

- Deploy or edit `/config/www/family-album` as its own copy.
- Skip the `?v=` bump.
- Commit family photos (`*.jpg` / `*.jpeg` / `*.png` / `*.heic` under `photos/` or repo root).
- Implement calendar **edit** from the frame (no HA update support yet).
