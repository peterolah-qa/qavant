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
| D16 | Rejected from second spec: cyan `#00F0FF` + glow, hardcoded `126 passed in 1.8s`, Geist font. | Conflict with D1–D4; Inter + JetBrains Mono already self-hosted. |

### Constraints noted
- `qavant-tests/tests/visual.spec.ts` = screenshot baselines → will fail by design after redesign; baselines must be regenerated in the same PR.
- No push access from the Claude session → work delivered as a patch, pushed by Peter.
