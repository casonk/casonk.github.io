---
title: "Source-Backed Maintenance Notes"
date: 2026-09-01
permalink: /posts/2026/09/source-backed-maintenance-notes/
tags:
  - maintenance
  - jekyll
  - automation
excerpt: "A concise note on keeping this site's maintenance posts tied to checked-in repository evidence."
---

Authorship note: this post was authored by Codex from the repository configuration, guidance files, existing post archive, and git history.

There are no newer commits in this checkout after the July weekly post commits, so this entry is a maintenance note rather than a changelog. The visible repository state still supports a narrow public update: Jekyll posts live as dated Markdown files under `_posts/`, with explicit front matter and stable `/posts/YYYY/MM/.../` permalinks.

The site's source boundary is also explicit. `_config.yml` keeps GitHub metadata disabled with `github: false`, defines the public content collections, and excludes reference material, legacy demo posts, and local tooling inputs from the rendered site. That keeps published content tied to checked-in Markdown and configuration instead of live repository metadata.

The agent guidance reinforces the same pattern. `AGENTS.md` asks for minimal, factual public content, preserved archive structure, and local validation before any push. `LESSONSLEARNED.md` records that scheduled repo-writing agents should work from temporary clean worktrees and that validation should match the repository's Jekyll and pre-commit workflow.

For this portfolio site, that is enough to publish a small factual update. The post archive can reflect routine maintenance without claiming a new release, changing navigation, or expanding the public site beyond what the repository currently shows.
