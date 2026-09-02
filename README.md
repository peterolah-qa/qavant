# Qavant.dev — QA Automation & Test Engineering Showcase

Official repository of **Qavant** — a production portfolio site, designed, built and continuously tested from scratch as a live showcase of my **QA Automation / Test Engineering** work.

> 🎯 **Project Purpose:** qavant.dev is the *system under test*. The site is intentionally simple; the engineering is in the test infrastructure around it — **four independent suites, four technologies, four CI pipelines**, with live pass-rate metrics fed back onto the page. No claim without clickable proof.

---

## 🚀 Live Demo & Production

* **Production:** [qavant.dev](https://qavant.dev)
* **Languages:** Slovak / English / German (auto-detected, switchable, persisted)
* **Audience:** QA / SDET hiring · fintech & DACH

---

## 🏗️ Architecture & QA Strategy (Proof of Work)

The site itself is a single static `index.html` (inline CSS + vanilla JS, no framework, no backend) on Netlify, auto-deployed from `main`. Everything below tests *that* site, automation-first, from four separate repositories.

[![Playwright](https://github.com/peterolah-qa/qavant-tests/actions/workflows/playwright.yml/badge.svg)](https://github.com/peterolah-qa/qavant-tests/actions/workflows/playwright.yml)
[![Newman](https://github.com/peterolah-qa/qavant-api-tests/actions/workflows/api-tests.yml/badge.svg)](https://github.com/peterolah-qa/qavant-api-tests/actions/workflows/api-tests.yml)
[![Selenium](https://github.com/peterolah-qa/qavant-selenium/actions/workflows/selenium.yml/badge.svg)](https://github.com/peterolah-qa/qavant-selenium/actions/workflows/selenium.yml)
[![k6](https://github.com/peterolah-qa/qavant-perf/actions/workflows/k6.yml/badge.svg)](https://github.com/peterolah-qa/qavant-perf/actions/workflows/k6.yml)

### 1. End-to-End (E2E) Testing
* **Frameworks:** Playwright (TypeScript) and Selenium 4 (Java / TestNG) — the same site covered by two stacks.
* **Design Pattern:** Page Object Model (POM); explicit waits only, no `sleep`.
* **Coverage:** Critical journeys — language switching (SK/EN/DE), contact form, responsive layout, accessibility (axe-core / WCAG 2 AA), live-metrics widget, ISTQB badge link contract, plus data-driven validation and an API↔UI consistency check. 210 Playwright tests across 5 browser projects (Chromium, Firefox, WebKit, Pixel 5, iPhone 13) + 11 Selenium tests.
* **Environment-aware:** one variable points the suite at the right target — `ENV=prod` (live site, the default) or `ENV=qa` (local build) — with a prod-safe fallback for unknown values and a `BASE_URL` override for one-off runs.

### 2. API & Integration Testing
* **Framework:** Postman / Newman.
* **Coverage:** REST CRUD, authentication, JSON schema and negative tests, plus an HTTP contract check on qavant.dev. 27 assertions.

### 3. Performance Testing
* **Framework:** k6 (Grafana).
* **Honest scope:** qavant.dev is static behind a CDN, so this is a **performance smoke / SLO check**, not a vanity stress number. Under light, realistic load it asserts availability and latency SLOs — **p95 < 800 ms**, **error rate < 1%** — and a content check that the page serves real markup, not an error shell.
* **Quality gate:** a breached threshold fails the build; the published numbers reflect reality even on a red run.

### 4. CI/CD Pipeline
* **Tool:** GitHub Actions.
* **Workflow:** Each suite runs on every push to `main` and daily on a schedule, headless across browsers. After each run it publishes a `status.json` (read by the site for live metrics) and an HTML / Allure report to GitHub Pages — including failed runs.

| Repository | Stack | Coverage |
|---|---|---|
| [qavant-tests](https://github.com/peterolah-qa/qavant-tests) | Playwright / TypeScript | 210 tests (×5 browsers) |
| [qavant-api-tests](https://github.com/peterolah-qa/qavant-api-tests) | Postman / Newman | 27 assertions |
| [qavant-selenium](https://github.com/peterolah-qa/qavant-selenium) | Java 17 / Selenium 4 / TestNG / Maven | 11 tests |
| [qavant-perf](https://github.com/peterolah-qa/qavant-perf) | k6 (Grafana) | SLO smoke — p95 & error-rate gates |

Planning is public too — backlog, priorities and issue→commit traceability on the [Qavant Roadmap board](https://github.com/users/peterolah-qa/projects/1).

---

## 🛠️ Tech Stack

* **Site:** HTML5, CSS3, vanilla JavaScript (single file, no bundler), trilingual i18n, JSON-LD, Netlify Forms.
* **Testing:** Playwright, Selenium, Postman/Newman, k6 (performance), axe-core (accessibility).
* **CI/CD:** GitHub Actions, Allure & HTML reporting on GitHub Pages.
* **Hosting:** Netlify (auto-deploy from `main`).

---

## ⚙️ Run Locally

The site is static — no dependencies, no build:

```bash
git clone https://github.com/peterolah-qa/qavant.git
cd qavant
npx serve .
```

The automated suites live in their own repos. Example for the Playwright suite:

```bash
git clone https://github.com/peterolah-qa/qavant-tests.git
cd qavant-tests
npm install
npm test                 # runs against production (https://qavant.dev)
npm run test:qa          # runs against a local copy on :8000
npm run report           # open the last HTML report
```

---

## 📬 Contact

**Peter Oláh** — QA Automation Engineer · ISTQB® Certified Tester (CTFL v4)
[peterolah@qavant.dev](mailto:peterolah@qavant.dev) · [qavant.dev](https://qavant.dev) · [LinkedIn](https://www.linkedin.com/in/peter-olah-8ab858137/)
