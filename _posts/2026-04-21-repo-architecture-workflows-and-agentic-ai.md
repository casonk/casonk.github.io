---
title: "Repo Architecture, Workflows, and Agentic AI Integration"
date: 2026-04-21
permalink: /posts/2026/04/repo-architecture-workflows-and-agentic-ai/
tags:
  - architecture
  - workflows
  - jekyll
  - ai
excerpt: "How this Jekyll portfolio repo is structured, how changes move from source to published site, and where agentic AI fits into the maintenance loop."
---

This site is a small Jekyll repository, but its working shape is more deliberate than a default personal-site scaffold. The public surface is intentionally minimal, while the repository itself is organized around a repeatable content workflow, a documented architecture, and an explicit agent-maintenance loop.

Authorship note: this post was authored by Codex after reading the repository's source, contributor architecture blueprint, workflow files, and repo-local agent guidance.

## The Repository Architecture

The core architecture is a content-and-theme assembly pipeline.

- `_pages/` holds the main public entry pages such as the homepage, CV, project index, publications index, and talks index.
- `_portfolio/`, `_publications/`, `_talks/`, `_teaching/`, and `_posts/` are the main Jekyll collections and content groups.
- `_config.yml`, `_config.dev.yml`, and `_data/*.yml` define the site behavior, navigation, author metadata, and structured content that templates consume.
- `_layouts/`, `_includes/`, `_sass/`, and `assets/` make up the rendering layer that turns content and data into the published HTML, CSS, and JavaScript.
- `_site/` is the generated output, not the editing surface.

That split matters because the repo is not just a pile of markdown files. It is a layered system with clear responsibilities: content, configuration, presentation, and rendered output.

## The Supporting Workflows

The main workflow is intentionally simple.

For local development, the normal path is:

```bash
bundle exec jekyll serve --config _config.yml,_config.dev.yml
```

For local verification, the important commands are:

```bash
bundle exec jekyll doctor
bundle exec jekyll build --config _config.yml,_config.dev.yml
pre-commit run --all-files
```

The GitHub Actions workflow is lightweight by design. It checks out the repo, installs Ruby with Bundler caching, and runs a Jekyll build. That makes the hosted workflow a narrow confirmation that the site still renders cleanly after a push.

The repo also has a few sidecar authoring workflows that are separate from the core Jekyll build:

- `markdown_generator/` can regenerate markdown content from TSV or notebook inputs.
- `scripts/extract_education.py` can derive sanitized education data from local-only source material.
- `talkmap.py` can generate map artifacts from talk metadata.

Those helper paths are part of the repository architecture, but they are intentionally not confused with the main runtime path that publishes the site.

## Architecture Documentation As First-Class Repo Content

One of the more useful changes in this repository is that the architecture is now documented directly in the repo instead of being left implicit.

- `docs/contributor-architecture-blueprint.md` explains the site as a real execution flow rather than a generic folder tour.
- `docs/diagrams/repo-architecture.puml` and `docs/diagrams/repo-architecture.drawio` capture the same structure visually.
- Supplemental generated diagrams document tooling integrations and code-introspection surfaces.

This is not just documentation polish. It makes the repo easier to maintain because content generation, configuration boundaries, and rendered outputs are visible up front.

## Where Agentic AI Fits

The agentic AI integration in this repo is operational rather than user-facing. The site itself is not an AI product. Instead, the repository is designed so agents can work on it safely and with context.

That integration currently shows up in a few places:

- `AGENTS.md` defines repo-specific instructions, build commands, content boundaries, and publishing expectations.
- `LESSONSLEARNED.md` stores tracked durable lessons that should affect future maintenance behavior.
- `CHATHISTORY.md` is the local-only handoff log for transient context between sessions.
- The architecture blueprint and diagrams give both humans and agents a shared map of the repo.

Taken together, those files create a workflow where an agent does not have to infer everything from scratch on every run. The repo carries forward its own operating context.

## The Practical AI Pattern Here

The practical pattern is straightforward:

1. Read the repo guidance and continuity files.
2. Inspect the active content, config, and workflow surfaces.
3. Make focused changes in source files, not in generated output.
4. Rebuild and re-run validation.
5. Record any durable operational lesson for future sessions.

That is a much better fit for this site than bolting an AI widget onto the public frontend. The higher-value integration is faster maintenance, better architectural recall, and less drift between what the repo does and what its docs claim it does.

## Why This Matters For A Small Site

Small repositories often accumulate hidden workflow complexity. This one already has public content, structured data, reference-only examples, local-only preprocessing, generated diagrams, CI, and explicit repo-governance files. Treating that as real architecture instead of "just a website" makes the maintenance path cleaner.

In practice, that means:

- keeping public and local-only inputs separate
- preserving stable permalinks
- documenting optional generators without pretending they are part of the main runtime
- validating before push
- letting agent tooling inherit enough repo context to make safe edits

For this repository, that is the useful version of agentic AI integration: not novelty on the page, but higher-quality maintenance around the page.
