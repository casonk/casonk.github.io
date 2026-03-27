# AGENTS.md

## Repo Overview

- Static personal site built with Jekyll.
- Main site config: `_config.yml`
- Local overrides: `_config.dev.yml`
- Reference-only config/data examples: `_config.reference.yml`, `_data/navigation_reference.yml`, `_data/authors_reference.yml`

## Build Commands

- Install gems: `bundle install`
- Local serve: `bundle exec jekyll serve --config _config.yml,_config.dev.yml`
- Local build: `bundle exec jekyll build --config _config.yml,_config.dev.yml`
- Health check: `bundle exec jekyll doctor`

## Current Decisions

- GitHub metadata is disabled in `_config.yml` with `github: false`.
- Do not rely on `site.github.*` in templates unless metadata is intentionally re-enabled.
- If GitHub metadata is re-enabled later, prefer authenticated local builds via `JEKYLL_GITHUB_TOKEN`.

## Content Structure

- Homepage: `_pages/about.md`
- CV: `_pages/cv.md`
- Projects: `_portfolio/`
- Software and research outputs: `_publications/`
- Talks and workshops: `_talks/`

## Editing Notes

- Keep the public site minimal and factual.
- Prefer source-backed content over template/demo placeholders.
- When adding new content, preserve existing permalinks and archive page structure.

## Agent Memory

Use `./CHATHISTORY.md` as the standard local handoff file for this repo.

- It is local-only and gitignored; do not publish it.
- Read it after `AGENTS.md` when resuming work.
- Keep entries brief and focused on recent user context, actions, blockers, and next steps.
- Redact any sensitive or private data before writing to it.
