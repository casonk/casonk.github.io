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

## Agent memory

A local file, CHATHISTORY.md, is used to store recent chat exchanges and memory for the local assistant. CHATHISTORY.md is intentionally added to .gitignore and must not be committed or published. It stores brief notes from recent user-agent messages to help local development and debugging.

Location: ./CHATHISTORY.md

