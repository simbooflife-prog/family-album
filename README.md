# Family Album digital frame

Source of truth for the Home Assistant Family Album iframe used on Overview and the dedicated digital-frame dashboard.

**GitHub:** https://github.com/simbooflife-prog/family-album

## Source-of-truth path

**Only this path is the live tree on Home Assistant:**

```
/homeassistant/www/family-album
```

Served as:

```
/local/family-album/
```

Live URL base:

```
https://1loiy6aum6qt4x1pp4isn1o6fbott58q.ui.nabu.casa/local/family-album/
```

Current in-file `FRAME_BUILD`: `20260912-ui1` (bump Lovelace `?v=` on HA to match on deploy).

Example:

```
/local/family-album/frame.html?v=20260912-ui1
```

## Symlink — do not treat as a second tree

`/config/www/family-album` is a **symlink** to `/homeassistant/www/family-album`.

- Never copy, edit, or deploy into `/config/www/family-album` as if it were its own folder.
- Dual-path md5 checks are only to confirm the symlink still points at SOT, not to keep two copies in sync.
- **Reboot risk:** a HA OS / Supervisor reboot or restore can drop the symlink. After reboot, confirm `/config/www/family-album` still links to `/homeassistant/www/family-album` before assuming `/local/family-album/` is live. If the link is gone, recreate the symlink; do not start a second copy of the files under `/config/www/`.

## Deploy checklist

1. **Edit in git** (this repo). Commit on `main`.
2. **Deploy ONLY to the SOT path** `/homeassistant/www/family-album`.
3. **Bump the Lovelace `?v=`** cache buster on every iframe that loads `frame.html` (Overview + digital-frame).
4. **md5 verify both paths if dual** — if you still see `/config/www/family-album`, md5 `frame.html` (and any changed JSON) through the symlink *and* the SOT path. They must match. If they do not, the symlink is broken; fix the link, do not “sync” a second tree.
5. **Hard refresh** the tablet / browser (and the HA companion app webview if used).

Never treat `/config/www/family-album` as a separate tree.

Shorter copy + md5 one-liners: see [DEPLOY.md](DEPLOY.md). Local: `./scripts/verify-local.sh` or `make verify`.

## What’s in this repo

Fetched from live Nabu Casa `/local/family-album/` on 2026-09-12 (no auth required for `/local`):

| File | Role |
| --- | --- |
| `frame.html` | Self-contained frame UI (inline CSS/JS). See `FRAME_BUILD` inside. |
| `week.json` | Generated week calendar feed |
| `forecast.json` | Generated weather feed |
| `images.json` | Slideshow manifest (filenames only; photos not in git) |
| `layout.json` | HUD / guide layout flags |
| `calendar.json` | Calendar overlay scale/opacity |
| `clock.json` | Clock overlay scale/opacity |
| `motion.json` | Ken Burns / motion + nested standby/calendar/clock |
| `standby.json` | Standby / night-dim settings |

`current.json`, standalone CSS/JS, and an HA-side README were **not** present (HTTP 404). CSS and JS live inside `frame.html`.

Family photos (`IMG_*.jpg`, `filler_*.jpg`, etc.) stay on HA under SOT and are gitignored. Keep JSON templates and code here.

`week.json` / `forecast.json` are generated HA feeds (calendar entity names, weather). Treat them as live snapshots, not secrets, but do not add extra household PII.

## Feature roadmap

Build in this order:

1. **Calendar** — week strip, add-event, swipe-weeks (in progress on the live frame)
2. **Tasks**
3. **Lists**
4. **Meals + recipes**
5. **Message board**
6. **Child lock + sleep**
