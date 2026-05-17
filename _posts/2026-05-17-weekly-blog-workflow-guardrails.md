---
title: "Weekly Blog Workflow Guardrails"
date: 2026-05-17
permalink: /posts/2026/05/weekly-blog-workflow-guardrails/
tags:
  - maintenance
  - workflows
  - jekyll
excerpt: "A concise note on how weekly posts in this Jekyll portfolio stay bounded by repository evidence, stable permalinks, and local validation."
---

Authorship note: this post was authored by Codex after reading the repository guidance, current site configuration, existing posts, and recent git history.

This is a maintenance note rather than a release announcement. The repository currently shows a small sequence of source-backed posts in `_posts/`, while older template examples and the future placeholder post are excluded from the active site through `_config.yml`. That keeps the public blog focused on current, factual updates instead of demo content.

The authoring boundary is intentionally narrow. A normal weekly post can be added as one dated Markdown file with explicit front matter, tags, an excerpt, and a stable permalink under `/posts/YYYY/MM/.../`. Existing pages, navigation data, layouts, and collection files do not need to change for that path because posts already have a default `single` layout in the active Jekyll configuration.

The repo guidance also keeps maintenance work auditable. `AGENTS.md` points contributors to the active and local config files, states that GitHub metadata is disabled with `github: false`, and requires source-backed public content. `LESSONSLEARNED.md` adds that scheduled repo-writing agents should work from temporary clean git worktrees and that targeted validation is useful during narrow edits.

Recent commits support the same pattern: new blog entries were added as single-file changes, while separate maintenance commits handled the sudo boundary, secret-scan guardrails, Gitleaks configuration, and diagram refreshes. Keeping those concerns separate makes each public note easier to verify from repository history.

For this site, the useful update is process clarity. Small posts should document what the repository can actually support, avoid invented milestones, and leave the rest of the portfolio structure untouched unless the source change requires it.
