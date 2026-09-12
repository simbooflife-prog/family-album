# Settings information architecture

**Scope:** Family hub Settings tab only (no lights / AC / house controls).  
**Build:** `FRAME_BUILD` in `frame.html` (ship target: `20260912-ui13`).  
**Layout edit:** stays on the Home **gear** (PIN-gated when lock is on) — not duplicated as a Settings control.  
**Researcher brief:** `/workspace/research-family-album-settings-ia-2026.md` (2026-09-12). Minimal v1 ship order cited below.

## Research summary (practical)

| Source | Pattern taken |
|--------|----------------|
| **Researcher brief (2026)** | Named sections, frequent/protective first, destructive last. Minimal v1: **Lock/PIN → Sleep/dim → Idle → Fun → Profiles → About → Danger**. Sleep ≠ Idle. Weak PINs blocked (Greenlight). Profiles glanceable; Display/Calendars/Photos deferred. |
| **iOS Settings** | Grouped list with short section headers; one idea per row; About last; destructive red + confirm at bottom; task-specific UI stays in-context |
| **Skylight** | Parental Lock (PIN) first-class; Sleep Mode as its own display/schedule concern + Sleep now; inactivity re-lock separate from sleep |
| **Cozyla** | Settings → Parental Lock drill-down; Sleep Mode + Screen Saver as display peers; don’t dump profiles into lock |
| **Greenlight** | 4-digit admin PIN; **blocks common PINs** (0000, 1234); profiles in setup + revisit in Settings |
| **Internal UX brief** (`research-family-album-feature-ux-2026.md`) | `settings.json` owns PIN / sleep / idle / `fun_unlocked`; profiles & rewards live in their own JSON + tabs |

## Categories (shipped — researcher order)

1. **Lock / PIN**  
   - `pin_enabled`, set / change / clear PIN  
   - Progressive disclosure: toggle + badge always visible; **Manage PIN** fields collapsed until opened (auto-opens when no PIN yet)  
   - **Weak PINs rejected** (Greenlight-style): `0000`, `1234`, `1111`, `9999` — clear status error, no webhook write

2. **Sleep / dim** *(separate from Idle)*  
   - `sleep.enabled`, `sleep.start`, `sleep.end`, `sleep.dim`  
   - Schedule + dim only shown while sleep is **on** (progressive disclosure)  
   - **Sleep now** — client-side force veil until tap-wake (does not change `settings.json`)

3. **Idle** *(separate from Sleep)*  
   - `idle_home_seconds` — return to Home / photos after inactivity  
   - Named “Return to Home”, not auto-dim  
   - Note that layout edit remains on the Home gear

4. **Fun**  
   - `fun_unlocked` — gate for the Fun tab (not a full parental-lock matrix)

5. **Profiles**  
   - Read-only list from `profiles.json` (name, color, role)  
   - Full add/edit stays on Tasks / `profiles.json` — **no profile write webhook invented**

6. **About**  
   - Frame name + `FRAME_BUILD` version string

7. **Danger** *(bottom, collapsed)*  
   - **Reset Fun scores** stub — scores live in `games_state.json`; no reset webhook  
   - **Clear local queue UI state** — drops pending/optimistic overlays on this tablet only; does **not** POST or wipe HA JSON  
   - No factory wipe from the frame (docs pointer only)

Deferred (researcher §§6–10): Display, Calendars & sync, Photos, Reminders, hub defaults — add when those prefs exist. Do not invent house/HA device controls.

## Why not more top-level groups?

- Researcher cheat-sheet: cut to Lock → Sleep → Idle → Fun → Profiles → About → Danger so Settings stays one glance, not a mega-card.  
- Profiles / rewards are high-frequency **feature** surfaces — Apple HIG + our tab IA keep editing on Tasks / Fun. Settings only lists people.  
- Gear layout edit is contextual to Home HUD chrome; putting it in Settings would duplicate PIN UX and clutter the scroll.  
- Future items (notifications, calendar sync, denser parental locks) should land under **Lock**, **Sleep**, or a later Display pane before inventing extra top-level sections.

## Webhooks (do not rename)

- Update: `fa_set_upd_34332b41ce03c5d48a94a605`
- PIN verify: `fa_set_pin_9959ced132bab609265c8787`

Behavior for PIN gate, sleep veil, and idle → Home must stay intact across UI-only IA changes.

## Touch / iPad notes

- Section cards with ≥44px toggles and action buttons  
- Clear uppercase section headers with light icons  
- Scrollable body above bottom hub nav; Overview mini still hides Settings  
