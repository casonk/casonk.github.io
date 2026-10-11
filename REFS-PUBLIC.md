# REFS-PUBLIC.md - Public References

> Record external public repositories, datasets, documentation, APIs, or other
> public resources that this repository utilizes or depends on.
> This file is tracked and intentionally kept free of private or local-only details.

## Public Repositories

- https://github.com/jekyll/jekyll - static-site engine used for local builds and GitHub Pages-compatible output
- https://github.com/mmistakes/minimal-mistakes - upstream Jekyll theme retained by the site assets and npm build metadata

## Public Datasets and APIs

- https://scholar.google.com/ - publication generator emits title-search links for generated publication pages

## Documentation and Specifications

- https://jekyllrb.com/docs/ - Jekyll build, collection, data-file, and layout reference
- https://docs.github.com/en/pages - GitHub Pages publishing model for the deployed site
- http://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/what_is_jupyter.html - Jupyter Notebook background linked by the markdown generator notebooks and helper scripts
- https://casonk.github.io/ - live site generated from this repository
- https://pandas.pydata.org/docs/ - pandas DataFrame reference used by offline markdown-generator helpers
- https://www.npmjs.com/package/npm-run-all - npm script orchestration used by the asset build metadata
- https://www.npmjs.com/package/onchange - file-watch helper used by the npm asset build metadata
- https://www.npmjs.com/package/uglify-js - JavaScript minifier used by the npm asset build metadata

## Notes

- When new generators or imported data sources become part of the build, record their public docs here rather than leaving them implicit in scripts.
