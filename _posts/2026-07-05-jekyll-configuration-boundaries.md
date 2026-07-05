---
title: "Jekyll Configuration Boundaries"
date: 2026-07-05
permalink: /posts/2026/07/jekyll-configuration-boundaries/
tags:
  - architecture
  - jekyll
  - maintenance
excerpt: "A concise note on the production configuration, local overrides, and public content boundaries used by this Jekyll site."
---

Authorship note: this post was authored by Codex from the repository configuration, documentation, and recent git history.

This site keeps its build configuration in two small layers. `_config.yml` is the production contract: it defines the public URL, content collections, permalink patterns, default layouts, and the files excluded from the rendered site. `_config.dev.yml` supplies local-only overrides for the development URL, disabled analytics, and expanded Sass output.

Local builds load both files in order with `bundle exec jekyll build --config _config.yml,_config.dev.yml`. The scheduled blog workflow uses that same command after creating a temporary clean worktree, so validation exercises the tracked site configuration without depending on a maintainer's active checkout.

The production configuration also sets `github: false`. Templates therefore do not need runtime `site.github.*` metadata; public details remain in checked-in Markdown and configuration. Reference examples and legacy demo entries are explicitly excluded rather than treated as published portfolio content.

These boundaries keep local development convenient while making the source of public content clear. They also allow maintenance posts like this one to use the existing post archive and permalink structure without changing navigation, layouts, or collection definitions.
