# LESSONSLEARNED.md

Tracked durable lessons for `casonk.github.io`.
Unlike `CHATHISTORY.md`, this file should keep only reusable lessons that should change how future sessions work in this repo.

## How To Use

- Read this file after `AGENTS.md` and before `CHATHISTORY.md` when resuming work.
- Add lessons that generalize beyond a single session.
- Keep entries concise and action-oriented.
- Do not use this file for transient status updates or full session logs.

## Lessons

- Jekyll portfolio sites should be diagrammed around the content collections, config/data overlays, theme/layout rendering, optional offline generators, and the rendered `_site/` output rather than around whichever helper folder happened to be detected first.
- Keep local-only source boundaries such as `private_data/`, reference configs, and optional generators like `talkmap.py` explicit in the architecture so the published site flow is not confused with offline authoring helpers.
