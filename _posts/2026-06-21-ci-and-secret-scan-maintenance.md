---
title: "CI and Secret Scan Maintenance"
date: 2026-06-21
permalink: /posts/2026/06/ci-and-secret-scan-maintenance/
tags:
  - maintenance
  - ci
  - security
excerpt: "A concise note on recent repository maintenance for reusable CI, secret scanning, and the weekly blog automation template."
---

Authorship note: this post was authored by Codex after reading the repository guidance, current configuration, and recent git history.

Recent repository activity is maintenance-focused. The site remains a static Jekyll personal site with GitHub metadata disabled in `_config.yml`, so public content should continue to come from checked-in Markdown, configuration, and source-backed repository history rather than runtime `site.github.*` metadata.

The CI workflow is now a small caller for the shared `casonk/.github` docs workflow. That keeps this repository's local CI file focused on when the build should run, while the reusable workflow carries the common documentation-site checks used across the portfolio.

Secret scanning also remains explicit in this checkout. `.github/workflows/secret-scan.yml` runs Gitleaks on pushes, pull requests, a weekly schedule, and manual dispatch. The scanner uses the repository root `.gitleaks.toml`, which includes portfolio-specific rules for sensitive values such as phone numbers, machine-specific workspace paths, biometric fields, and real KeePass profile names in config-like files.

The weekly blog automation template was also adjusted to define a PATH for the `weekly-blog-agentic` job. That change supports the existing Sunday automation template without changing the public site structure or adding new pages.

For this portfolio, these are deliberately small updates. They strengthen the maintenance workflow around the site while leaving the Jekyll archive structure, permalinks, and public content boundaries intact.
