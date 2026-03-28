# Cason Konzer Website

Source for <https://casonk.github.io>.

This repo is a Jekyll-based personal portfolio site. Its real architecture is a content-and-theme assembly flow:

- content sources in `_pages/`, `_portfolio/`, `_publications/`, `_talks/`, `_teaching/`, and `_posts/`
- configuration and structured data in `_config.yml`, `_config.dev.yml`, and `_data/*.yml`
- presentation templates in `_layouts/`, `_includes/`, `_sass/`, and `assets/`
- optional manual generators in `markdown_generator/`, `scripts/extract_education.py`, and `talkmap.py`
- rendered site output in `_site/`

The live site has been reduced to a minimal state. Template defaults and sample configuration were moved out of the active path and kept only as references in:

- `_config.reference.yml`
- `_data/navigation_reference.yml`
- `_data/authors_reference.yml`

GitHub metadata is intentionally disabled in the active config for now to keep local builds simple.

## Repository Architecture Notes

- `_config.yml` is the production build contract; `_config.dev.yml` is the local override layer for local development.
- `_layouts/` and `_includes/` are the page-assembly layer that turns collection entries and `_pages/` content into the published site.
- `markdown_generator/` is a sidecar authoring lane for generating publication and talk markdown from TSV or notebook inputs.
- `scripts/extract_education.py` is a local-only preprocessing helper that derives sanitized `_data/education.yml` content from `private_data/`; `private_data/` itself is not part of the public site.
- `talkmap.py` and `talkmap/` are an optional map-generation lane and are currently excluded from the active site build.
- `_site/` is a rendered artifact, not the source of truth for edits.

## Local Development

Serve locally:

```bash
bundle exec jekyll serve --config _config.yml,_config.dev.yml
```

Build locally:

```bash
bundle exec jekyll build --config _config.yml,_config.dev.yml
```

Health check:

```bash
bundle exec jekyll doctor
```

This requires Bundler plus the system Ruby development headers (`ruby-dev` or `ruby-devel`).
