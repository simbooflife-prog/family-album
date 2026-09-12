# Deploy checklist

1. Edit in git (`main` on this repo).
2. Deploy **only** to SOT: `/homeassistant/www/family-album`.
3. Bump every Lovelace iframe `?v=` (Overview + digital-frame). Current: `20260912addev1`.
4. If `/config/www/family-album` still exists, md5 both paths. They must match (symlink). Do not keep a second tree.
5. Hard refresh the frame (tablet / companion app / browser).

## Do not

- Deploy or edit `/config/www/family-album` as its own copy.
- Skip the `?v=` bump (HA and tablets cache `frame.html` hard).
- Commit family photos (`*.jpg` / `*.jpeg` / `*.png` / `*.heic` under `photos/` or repo root).

## After HA reboot

Confirm the symlink still exists:

```
readlink -f /config/www/family-album
# expect: /homeassistant/www/family-album
```

If the link died, recreate it. Do not copy files into `/config/www/`.
