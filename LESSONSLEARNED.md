# LESSONSLEARNED.md

Tracked durable lessons for `casonk.github.io`.
Unlike `CHATHISTORY.md`, this file should keep only reusable lessons that should change how future sessions work in this repo.

## How To Use

- Read this file after `AGENTS.md` and before `CHATHISTORY.md` when resuming work.
- Add lessons that generalize beyond a single session.
- Keep entries concise and action-oriented.
- Do not use this file for transient status updates or full session logs.

## Lessons

- Document the repository around its real execution, curation, or integration flow instead of only the top-level folder list.
- Keep local-only, private, reference-only, or generated boundaries explicit so published or runtime behavior is not confused with offline material or non-committable inputs.
- Re-run repo-appropriate validation after changing generated artifacts, diagrams, workflows, or other CI-facing files so formatting and compatibility issues are caught before push.

- Jekyll portfolio sites should be diagrammed around the content collections, config/data overlays, theme/layout rendering, optional offline generators, and the rendered `_site/` output rather than around whichever helper folder happened to be detected first.
- Keep local-only source boundaries such as `private_data/`, reference configs, and optional generators like `talkmap.py` explicit in the architecture so the published site flow is not confused with offline authoring helpers.
- In this repo, `pre-commit run --all-files` currently normalizes whitespace and EOF markers across many untouched legacy scaffold files; use file-scoped hooks for targeted site edits during iteration, but expect a broader formatting sweep before any push that relies on all-files validation.
