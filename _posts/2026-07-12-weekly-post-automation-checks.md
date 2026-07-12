---
title: "Weekly Post Automation Checks"
date: 2026-07-12
permalink: /posts/2026/07/weekly-post-automation-checks/
tags:
  - automation
  - jekyll
  - maintenance
excerpt: "A concise note on the checks around this site's weekly Codex-authored blog workflow."
---

Authorship note: this post was authored by Codex from the repository configuration, scripts, and recent git history.

This site now has a tracked workflow for publishing weekly Codex-authored posts without depending on a maintainer's active checkout. `scripts/weekly_blog_agentic.sh` creates a temporary clean worktree from the target branch, adds runtime context to the tracked prompt, and asks Codex to create one dated post under `_posts/`.

The script has a small guardrail before authoring: if a post for the current date already exists on the target branch, the run exits instead of adding another file. After authoring, it checks that a dated post was actually created before moving on to validation.

Validation stays close to the repository's normal maintenance path. The workflow runs `pre-commit run --all-files`, then `bundle exec jekyll doctor`, then `bundle exec jekyll build --config _config.yml,_config.dev.yml`. The pre-commit configuration includes formatting checks, merge-conflict detection, private-key detection, and Gitleaks.

The surrounding schedule is also tracked. `config/clockwork/weekly-blog-agentic.toml.template` defines the user-level service, its Sunday schedule, and the explicit `PATH` needed by the local Ruby/Jekyll toolchain. That keeps the public blog archive updated through ordinary Jekyll posts while leaving layouts, navigation, and collection routes unchanged.
