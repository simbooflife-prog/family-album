# Settings information architecture

**Scope:** Family hub Settings tab only (no lights / AC / house controls).  
**Build:** `FRAME_BUILD` in `frame.html` (ship target for this redesign: `20260912-ui12`).  
**Layout edit:** stays on the Home **gear** (PIN-gated when lock is on) — not duplicated as a Settings control.

## Research summary (practical)

| Source | Pattern taken |
|--------|----------------|
| **iOS Settings** | Grouped list with short section headers; one idea per row; About last; task-specific UI stays in-context |
| **Skylight** | Parental Lock (PIN) under General; Sleep Mode as its own display/schedule concern; inactivity re-lock separate from sleep |
| **Cozyla** | Settings → Parental Lock drill-down; Sleep Mode + Screen Saver as display peers; don’t dump profiles into lock |
| **Internal UX brief** (`research-family-album-feature-ux-2026.md`) | `settings.json` owns PIN / sleep / idle / `fun_unlocked`; profiles & rewards live in their own JSON + tabs |

## Categories (shipped)

1. **Security & Privacy**  
   - `pin_enabled`, set / change / clear PIN  
   - Progressive disclosure: toggle + badge always visible; **Manage PIN** fields collapsed until opened (auto-opens when no PIN yet)

2. **Display & Sleep**  
   - `sleep.enabled`, `sleep.start`, `sleep.end`, `sleep.dim`  
   - Schedule + dim only shown while sleep is **on** (progressive disclosure)

3. **Home & Idle**  
   - `idle_home_seconds` — return to Home / photos after inactivity  
   - Note that layout edit remains on the Home gear

4. **Fun & Kids**  
   - `fun_unlocked` — gate for the Fun tab (not a full parental-lock matrix)

5. **Advanced** (collapsed by default)  
   - Pointers only: **Profiles**, **Rewards**, **Layout edit**  
   - Keeps Settings from overcrowding as hub features grow; real editing stays on Tasks / Fun / gear

6. **About**  
   - Frame name + `FRAME_BUILD` version string

## Why not more top-level groups?

- Profiles / rewards are high-frequency **feature** surfaces, not rare app-wide prefs — Apple HIG + our tab IA prefer them on Tasks / Fun.  
- Gear layout edit is contextual to Home HUD chrome; putting it in Settings would duplicate PIN UX and clutter the scroll.  
- Future items (notifications, calendar sync, denser parental locks) should land under **Security**, **Display**, or **Advanced** before inventing new top-level sections.

## Webhooks (do not rename)

- Update: `fa_set_upd_34332b41ce03c5d48a94a605`
- PIN verify: `fa_set_pin_9959ced132bab609265c8787`

Behavior for PIN gate, sleep veil, and idle → Home must stay intact across UI-only IA changes.

## Touch / iPad notes

- Section cards with ≥44px toggles and action buttons  
- Clear uppercase section headers with light icons  
- Scrollable body above bottom hub nav; Overview mini still hides Settings  
