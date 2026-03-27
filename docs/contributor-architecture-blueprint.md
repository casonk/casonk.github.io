# Contributor Architecture Blueprint

This document is a concise map of how the Jekyll site assembles content, data, and configuration into the published portfolio.

## High-Level Layers

1. Content layer (`_pages/`, `_portfolio/`, `_publications/`, `_talks/`)
   - Markdown files and collection entries define the public content.
   - Stable permalinks and archive structure matter because the site is already published.
2. Data and configuration layer (`_config.yml`, `_config.dev.yml`, `_data/`)
   - `_config.yml` is the production configuration.
   - `_config.dev.yml` is the local override layer for local-only behavior.
   - `_data/` holds structured content that templates can reuse across pages.
3. Theme and layout layer (`_layouts/`, `_includes/`, assets)
   - Layouts and includes determine how collection content is rendered.
   - Shared assets and theme choices should stay consistent across pages.
4. Build and validation layer (Bundler + Jekyll)
   - `bundle exec jekyll build --config _config.yml,_config.dev.yml` is the primary local build check.
   - `bundle exec jekyll doctor` is the fast health-check path for configuration problems.

## Key Entry Points

- `_pages/about.md`: homepage/about content
- `_pages/cv.md`: public CV page
- `_config.yml`: production site configuration
- `_config.dev.yml`: local development overrides
- `.github/workflows/ci.yml`: GitHub Actions build validation

## Change Guidance

- Keep the public site minimal and factual.
- Preserve existing permalinks when editing content structure.
- Treat local-only source material as private even when it informs published summaries.

## Validation

```bash
bundle install
bundle exec jekyll build --config _config.yml,_config.dev.yml
bundle exec jekyll doctor
```
