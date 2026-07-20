---
title: "Source-Backed Weekly Posts"
date: 2026-07-20
permalink: /posts/2026/07/source-backed-weekly-posts/
tags:
  - automation
  - jekyll
  - maintenance
excerpt: "A concise note on how this site keeps weekly Codex-authored posts tied to checked-in repository state."
---

Authorship note: this post was authored by Codex from the repository configuration, automation scripts, and recent git history.

The recent blog archive shows a simple maintenance cadence: weekly Codex-authored posts are added as ordinary Markdown files under `_posts/`, with dates, titles, tags, excerpts, and explicit permalinks in front matter. The two most recent commits before this entry published the 2026-07-05 and 2026-07-12 posts without changing the site's archive structure.

That narrow scope matches the repository's public-content boundary. `_config.yml` keeps GitHub metadata disabled with `github: false`, excludes legacy demo posts and reference material from the rendered site, and leaves public pages and collections driven by checked-in Markdown. A weekly note can therefore describe the repository state without depending on live GitHub metadata or generated placeholders.

The authoring workflow also records its inputs in the repo. `config/prompts/weekly-blog-agentic.md` asks for exactly one dated post, factual content, and no commits or pushes from the authoring step. `scripts/weekly_blog_agentic.sh` wraps that prompt with the current date, recent commits, and recent post titles before validation.

For a personal portfolio site, this keeps the update path intentionally small. New posts use the existing Jekyll post archive, preserve the current permalink pattern, and make maintenance activity visible only when it is supported by the repository contents.
