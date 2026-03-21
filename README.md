# Cason Konzer Website

Source for <https://casonk.github.io>.

The live site has been reduced to a minimal state. Template defaults and sample configuration were moved out of the active path and kept as reference in:

- `_config.reference.yml`
- `_data/navigation_reference.yml`
- `_data/authors_reference.yml`

GitHub metadata is intentionally disabled in the active config for now to keep local builds simple.
Future work:

- re-enable metadata only if the site needs `site.github.*` values again
- use `JEKYLL_GITHUB_TOKEN` for local authenticated metadata lookups if that is turned back on

Local development:

```bash
bundle exec jekyll serve --config _config.yml,_config.dev.yml
```

This requires Bundler plus the system Ruby development headers (`ruby-dev` or `ruby-devel`).
