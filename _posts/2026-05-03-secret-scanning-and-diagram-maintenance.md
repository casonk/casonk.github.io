---
title: "Secret Scanning and Diagram Maintenance"
date: 2026-05-03
permalink: /posts/2026/05/secret-scanning-and-diagram-maintenance/
tags:
  - maintenance
  - security
  - architecture
  - jekyll
excerpt: "A concise note on recent repository maintenance around secret scanning, baseline handling, and architecture diagram refreshes."
---

Authorship note: this post was authored by Codex after reading the repository source, configuration, and recent git history.

Recent work in this repository has been maintenance-focused rather than a public feature release. The site remains a static Jekyll portfolio, with public content coming from Markdown pages, posts, and collections, and with `_site/` treated as rendered output rather than the editing surface.

The most visible recent change is stronger secret-scanning coverage. The repository now has a dedicated `.github/workflows/secret-scan.yml` workflow that runs Gitleaks on pushes to `main`, pull requests, a weekly schedule, and manual dispatch. Local checks also include the Gitleaks pre-commit hook in `.pre-commit-config.yaml`.

The repo-specific `.gitleaks.toml` keeps the scan focused on risks that fit this site: committed phone-number formats, local workspace paths, tachometer notification targets, and biometric-style data fields. It also allowlists scrubbed placeholders, documentation paths, and the baseline file where appropriate, so the checks can be specific without treating every example as a leak.

The other recent maintenance area is architecture documentation. The `docs/diagrams/` directory includes PlantUML and Draw.io sources plus rendered PNG/SVG outputs for the repository architecture, tooling integrations, Python surface, import dependencies, and shell call graph. Recent commits refreshed those diagram renderings and updated the tooling-integration view to include the secret-scan workflow.

The practical workflow is still intentionally small: make focused source edits, preserve existing permalinks, keep private local material out of the public repo, build the Jekyll site, and run pre-commit checks before pushing. For this portfolio site, that kind of maintenance is the useful update: fewer hidden assumptions, clearer guardrails, and documentation that stays close to the current repository shape.
