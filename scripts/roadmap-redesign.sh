#!/usr/bin/env bash
# Creates the "Redesign: Phosphor Mint" issues and adds them to the Qavant Roadmap board.
# Requires: gh CLI logged in with scopes repo + project  (gh auth refresh -s project)
# Usage:    bash scripts/roadmap-redesign.sh
set -euo pipefail

REPO="peterolah-qa/qavant"
OWNER="peterolah-qa"
PROJECT=1
LABEL="redesign"

gh label create "$LABEL" --repo "$REPO" --color 22E58B \
  --description "qavant.dev redesign — Phosphor Mint" 2>/dev/null || true

create() {
  local title="$1" body="$2" url
  url=$(gh issue create --repo "$REPO" --title "$title" --body "$body" --label "$LABEL")
  gh project item-add "$PROJECT" --owner "$OWNER" --url "$url" >/dev/null
  echo "✓ $url"
}

create "Redesign 1/5: Design tokens Phosphor Mint + favicon" \
"Replace hardcoded colors with CSS tokens; new palette (slate \`#090d12\`/\`#131922\`, mint \`#22E58B\` = pass/status + primary CTA only, ice blue \`#38BDF8\` = data/links/syntax, red = fail). New SVG favicon (Q ring + checkmark tail).

**Acceptance**
- [ ] No raw brand hex outside \`:root\`
- [ ] axe-core WCAG 2 AA passes
- [ ] Favicon readable at 16/32 px
- [ ] Existing Playwright + Selenium suites green"

create "Redesign 2/5: Hero — CI/CD DAG pipeline + live HUD" \
"Hero visual = real QA pipeline DAG (Git Push → CI Build → Playwright / Selenium / Newman matrix → k6 quality gate → Release). HUD reads live \`status.json\`, every number links to its report, red run shows red. Remove boot loader.

**Acceptance**
- [ ] No hardcoded test numbers
- [ ] \`prefers-reduced-motion\` + mobile → static SVG
- [ ] Heavy 3D lib lazy-loaded after first paint (LCP unaffected)
- [ ] Text never sits over moving particles"

create "Redesign 3/5: Sections 01–05 new layout" \
"Services grid + discovery CTA; Framework IDE tabs (Selenium/IntelliJ, Newman CLI, Playwright/VS Code — real repo excerpts only, synced title/tabs/code/status bar) + 6-layer architecture matrix; Background metrics + manifesto merged; 4-step process; contact split with service chips (checkboxes, same field names); ISTQB no. 2024-01382 + availability flag in hero. Interlude and second mid-CTA removed. New copy in SK/EN/DE."

create "Redesign 4/5: Keep test contract — selectors, i18n, form, metrics" \
"Redesign must not break qavant-tests (Playwright) and qavant-selenium. Keep IDs / data-i18n keys / form names, or update suites in the same PR.

**Acceptance**
- [ ] 210 Playwright tests green on local build (ENV=qa)
- [ ] 11 Selenium tests green"

create "Redesign 5/5: Verify + ship" \
"Visual check desktop/mobile, Lighthouse, axe, k6 SLO smoke after deploy. Update README + JOURNAL.md, merge \`redesign/phosphor-mint\` → main."

create "Feature: GitHub access request drawer (post-redesign)" \
"Drawer in Framework section letting a visitor request read access to private client-style demo repos. Out of redesign scope (D15)."

