# Contributor Architecture Blueprint

This document is a concise map of how `casonk.github.io` turns Jekyll source content, structured data, and optional offline generators into the published portfolio site.

## Current Architecture Flow

1. Public content is authored in `_pages/` plus the Jekyll collections `_portfolio/`, `_publications/`, `_talks/`, `_teaching/`, and `_posts/`.
2. `_config.yml`, `_config.dev.yml`, and `_data/*.yml` define the build behavior, navigation, author metadata, and other structured content consumed by templates.
3. `_layouts/`, `_includes/`, `_sass/`, and `assets/` render those sources into HTML, CSS, and JS for the published site.
4. Optional offline helper paths can update source material before the site build:
   - `markdown_generator/` can regenerate collection markdown from TSV or notebook inputs.
   - `scripts/extract_education.py` can derive sanitized `_data/education.yml` content from local `private_data/`.
   - `talkmap.py` can turn talk metadata into `talkmap/` artifacts.
   - `scripts/weekly_blog_agentic.sh` can author and publish a new blog post through Codex from a temporary clean worktree, with the schedule rendered via `config/clockwork/weekly-blog-agentic.toml.template`.
5. `bundle exec jekyll build --config _config.yml,_config.dev.yml` produces `_site/`, which is the rendered output surface.
6. `.github/workflows/ci.yml` validates the site build in GitHub Actions with a Ruby/Jekyll build step.

## Source Layers

### Content Layer

- `_pages/about.md` is the published homepage.
- `_pages/cv.md`, `_pages/portfolio.html`, `_pages/publications.md`, `_pages/talks.html`, and `_pages/teaching.html` are the main public index pages.
- `_portfolio/`, `_publications/`, `_talks/`, `_teaching/`, and `_posts/` hold the collection entries that those pages surface.
- Stable permalinks matter because the site is already public.

### Configuration And Data Layer

- `_config.yml` is the active production site configuration.
- `_config.dev.yml` is the local-only override layer for localhost development and relaxed analytics behavior.
- `_data/navigation.yml`, `_data/authors.yml`, `_data/education.yml`, and related data files feed templates and profile components.
- `_config.reference.yml`, `_data/navigation_reference.yml`, and `_data/authors_reference.yml` are reference-only examples, not active runtime inputs.

### Presentation Layer

- `_layouts/` defines page and archive layout structure.
- `_includes/` contains reusable rendering fragments such as archive cards, author profile blocks, masthead, footer, and SEO helpers.
- `_sass/` and `assets/` own the visual theme and static asset surface.
- `package.json` is a sidecar asset-maintenance path for JS minification; it is not the main site orchestration path today.

### Offline Helper Layer

- `markdown_generator/publications.py` and the related notebook/TSV files are a manual content-authoring lane for publications and related entries.
- `scripts/extract_education.py` is a local-only preprocessing helper; it reads `private_data/` and emits sanitized YAML that can be checked into `_data/`.
- `talkmap.py` and `talkmap/` are an optional mapping lane derived from talk metadata, and that output is currently excluded from the active site build.
- `scripts/weekly_blog_agentic.sh` plus `config/clockwork/weekly-blog-agentic.toml.template` form an optional scheduled authoring lane that uses Codex to draft a post from a clean temporary worktree instead of the live checkout.
- These helper paths are important to the repository architecture, but they are separate from the Jekyll build itself.

### Build And Validation Layer

- `bundle exec jekyll serve --config _config.yml,_config.dev.yml` is the local preview path.
- `bundle exec jekyll build --config _config.yml,_config.dev.yml` is the main local verification path.
- `bundle exec jekyll doctor` is the quick health-check path for configuration issues.
- `_site/` is the build output and should not be treated as the canonical editing surface.

## Change Guidance

- Keep the public site minimal and factual.
- Preserve existing permalinks when editing content structure.
- Keep reference-only config and sample content clearly separate from active runtime inputs.
- Treat `private_data/` as a local-only source boundary even when it informs sanitized published content.
- Update this blueprint and the paired architecture diagrams when content-generation helpers, build inputs, or the active page surface change materially.

## Validation

```bash
bundle install
bundle exec jekyll doctor
bundle exec jekyll build --config _config.yml,_config.dev.yml
```
