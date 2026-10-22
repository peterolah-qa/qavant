# Qavant — Engineering Journal

Chronological log of decisions, changes and verification on qavant.dev.
Newest entries at the bottom. Each entry: **what**, **why**, **how verified**.

---

## 2026-10-22 — Redesign kickoff: "Phosphor Mint"

**Branch:** `redesign/phosphor-mint` · **Roadmap:** issues labelled `redesign` (created by `scripts/roadmap-redesign.sh`)

### Starting point (audit)
- Single `index.html` (~5 700 lines, inline CSS + vanilla JS), `impressum.html`, `privacy.html`, self-hosted fonts, Netlify.
- i18n SK/EN/DE via `data-i18n` (126 keys); live metrics from suites' `status.json`.
- Palette: navy `#0A2540` + blue `#2563EB`, alternating dark/light zones. ~35 raw hex usages of the accent outside `:root`.
- Page order: boot loader → hero → tech marquee → services → IDE showcase → interlude quote → about → manifesto → process → contact.
- Weak spots: page long and wordy (2 mid-CTAs + interlude + manifesto); live test metrics not above the fold.

### Decisions
| # | Decision | Why |
|---|---|---|
| D1 | Direction 1 "Linear Mint / Phosphor" over Direction 2 "Amber Studio" | Amber means *warning* in every CI UI — brand would read as an alert. |
| D2 | Mint `#22E58B` instead of `#10F596` | `#10F596` on large areas slides into crypto/neon look. |
| D3 | **One color = one meaning.** Mint = pass/status + single primary CTA. Ice blue `#38BDF8` = data, numbers, links, syntax. Red = fail. | If brand and "passed" share a color, a live HUD can't communicate a failure. |
| D4 | HUD numbers come only from live `status.json`; each links to its report; red run renders red. | Site's thesis is "no claim without clickable proof". A hardcoded number a recruiter can disprove kills it. |
| D5 | 3D hero lazy-loaded after first paint; static SVG for `prefers-reduced-motion` and mobile; text never over particles. | Zero-dependency page today; protect LCP, contrast and axe-core tests. |
| D6 | Keep existing IDs, `data-i18n` keys and form field names. | Playwright (210) and Selenium (11) suites target them. Goal: redesign without a single red test. |
| D7 | Remove boot loader, interlude and second mid-CTA; merge manifesto into Background. | Less talk between proofs. |
| D8 | Favicon: dark squircle, steel Q ring, mint checkmark as the Q tail; centre dot only ≥ 48 px. | Dot merges into the ring at 16 px. |
| D9 | Framework IDE ("Pohľad pod kapotu"): 3 suite tabs, each with its own editor chrome — Selenium Java (IntelliJ, `BasePage.java`), REST API (Newman CLI), Playwright TS (VS Code). Window title, file tabs, code and status bar switch together. | Shows three stacks as three real tools, not one generic editor. |
| D10 | Active tab = mint indicator + border, not cyan `#00F0FF` glow. | Consistent with D1–D3; no neon glow. |
| D11 | Proposed fintech files (`fintech-auth.postman_collection.json`, `transfer.spec.ts`, SEPA, OTP) **do not exist** in qavant-api-tests / qavant-tests. Today's IDE shows real repo files. → **Resolved: real excerpts from the repos only.** | A "GitHub ↗" link next to code that isn't in the repo is the same proof problem as D4. |
| D12 | ISTQB CTFL v4 badge shows cert no. `2024-01382` (confirmed real by Peter), links to verification. | Verifiable credential > logo. |
| D13 | Availability indicator = one config flag; copy per language, no mixed SK/EN. | "Available ihneď k dispozícii" mixed languages. |
| D14 | Contact form: service chips are styled checkboxes, same field `name`s. | Keeps Netlify Forms + `contact-form.spec.ts` working. |
| D15 | GitHub access request drawer → separate roadmap item after redesign. | New feature, not redesign; keeps scope tight. |
| D17 | Hero pipeline built as HTML nodes + SVG links/particles in CSS perspective, **no Three.js**. | Same depth/parallax effect at 0 kB of dependencies; text stays crisp DOM text (axe-readable, i18n-safe). Revisit only if a real 3D need appears. |
| D18 | Hero HUD lists all 4 suites incl. stale/fail states; release gate = PASS / PASS·stale / BLOCKED derived from them. | Honest state beats a green-only demo. |
| D16 | Rejected from second spec: cyan `#00F0FF` + glow, hardcoded `126 passed in 1.8s`, Geist font. | Conflict with D1–D4; Inter + JetBrains Mono already self-hosted. |

### Constraints noted
- `qavant-tests/tests/visual.spec.ts` = screenshot baselines → will fail by design after redesign; baselines must be regenerated in the same PR.
- No push access from the Claude session → work delivered as a patch, pushed by Peter.

---

## 2026-10-22 — Step 1/5: Design tokens + favicon

**What**
- New `:root` token block (Phosphor Mint): `--bg #090D12`, `--bg-2/--surface #0E131A/#131922`, `--ink #F8FAFC`, `--ink-dim #94A3B8`, `--mint #22E58B`, `--data #38BDF8`, `--fail #F87171`, `--syn-*` for IDE syntax.
- Legacy names (`--accent*`, `--hot`, `--green`) kept as aliases → no rule rewrites needed.
- ~200 hardcoded colors mapped to tokens: hex in CSS / inline `style`, blue + navy `rgba()` → `rgb(var(--data-rgb) / a)` / `rgb(var(--bg-rgb) / a)`. SVG presentation attributes (no `var()` support) mapped to new literals; architecture SVG gets reworked in step 3.
- `.zone-light` light theme removed (~180 lines of overrides); class kept as a hook, now a raised slate band.
- Primary button = mint fill, dark ink; hover slides to ink.
- IDE syntax theme: cool base, warm literals, no mint (mint stays reserved for pass).
- Favicon: `favicon.svg` (16/32), `favicon-large.svg` (≥48, with centre dot), `favicon-32.png`, `apple-touch-icon.png` (180). `theme-color` → `#090D12`.

**Found in test suites (to handle in step 4)**
- `qavant-tests/tests/fixtures/constants.ts` lists section `interlude` → update when interlude is removed (D7).
- `accessibility.spec.ts` waits for `#boot` hidden → still passes after loader removal (absent = hidden), but the comment + wait become dead code.

**Verified**
- Full-page screenshot at 1440 px reviewed: no leftover blue/navy, text contrast OK on all bands.
- Remaining raw hex outside `:root`: LinkedIn brand `#0A66C2`, SVG literals (architecture diagram, step 3).

---

## 2026-10-22 — Step 2/5: Hero — CI/CD DAG + live HUD

**What**
- Removed curtain (1.4 s) and boot loader (2.4 s) + their CSS/JS. Hero text visible on first paint (was hidden ~2.4 s → better LCP).
- Removed old canvas octahedron (`#hero3d` canvas, ~230 lines JS) and scripted fake terminal (`termLines`, hardcoded timings like `3.1s`, `contrast 3.43`).
- New right column `#pipelineCard`:
  - DAG `git push → CI build → Playwright | Selenium | Newman → k6 gate → release`. Wrapper keeps `id="hero3d"` (smoke test expects exactly one; axe excludes it).
  - Links + particles in SVG computed from node layout (`offset*`, so the tilt never skews links). Mint particles = assertions to the gate, blue = telemetry. Failing suite → red node + red link, flow stops, release `blocked`.
  - Mouse tilt ±6°; off for touch, `prefers-reduced-motion`, ≤ 700 px (static diagram, no particles). Animation pauses offscreen / hidden tab.
  - HUD `#terminal` / `#termBody` (ids kept) renders `qavant status --live` from all 4 `status.json`; each row links to that suite's GitHub Actions workflow; stale (> 14 days) shown as stale.
- One shared fetch per suite (`suitesReady`) feeds HUD, DAG and the existing `#liveMetrics` cards. Added Selenium + k6 sources.
- New i18n key `hud.note` (SK/EN/DE).

**Data findings (real status.json, 2026-10-22)**
- playwright 126/126 · newman 27/27 · selenium 11/11 (last run 2026-09-09 → stale) · k6 285/285 checks.
- `qavant-perf` load target is `https://test.k6.io`, not qavant.dev → README's "SLO for qavant.dev" claim does not match. HUD shows only check pass count, no p95. **Todo:** point k6 at qavant.dev (separate perf-repo task).
- "126 passed in 1.8s" from the spec: count is real, duration is not reported by any suite → not shown.

**Verified**
- Screenshots 1440 px + 390 px with mocked real status.json: no console errors.
- Forced failure (newman 127/27): node/link red, flow stops, gate `BLOCKED`.
