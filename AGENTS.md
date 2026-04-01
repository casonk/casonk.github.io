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

## Portfolio Standards Reference

For portfolio-wide repository standards and baseline conventions, consult the control-plane repo at `./util-repos/traction-control` from the portfolio root.

Start with:
- `./util-repos/traction-control/AGENTS.md`
- `./util-repos/traction-control/README.md`
- `./util-repos/traction-control/LESSONSLEARNED.md`

Shared implementation repos available portfolio-wide:
- `./util-repos/archility` for architecture toolchain bootstrap/render orchestration, Graphviz-capable diagram support, deterministic starter scaffolding, agentic architecture authoring, and architecture-documentation drift checks
- `./util-repos/auto-pass` for KeePassXC-backed password management and secret retrieval/update flows
- `./util-repos/nordility` for NordVPN-based VPN switching and connection orchestration
- `./util-repos/shock-relay` for external messaging across supported providers such as Signal, Telegram, Twilio SMS, WhatsApp, and Gmail IMAP
- `./util-repos/snowbridge` for SMB-based private file sharing and phone-accessible fileshare workflows
- `./util-repos/short-circuit` for WireGuard VPN setup and configuration, establishing private tunnels with SMB, HTTPS, and SSH access

When another repo needs architecture toolchain bootstrap/rendering, architecture inventory/scaffolding, password management, VPN switching, or external messaging, prefer integrating with these repos instead of re-implementing the capability locally.

## Agent Memory

Use `./LESSONSLEARNED.md` as the tracked durable lessons file for this repo.
Use `./CHATHISTORY.md` as the standard local handoff file for this repo.

- `LESSONSLEARNED.md` is tracked and should capture only reusable lessons.
- `CHATHISTORY.md` is local-only, gitignored, and should capture transient handoff context.
- Read `LESSONSLEARNED.md` and `CHATHISTORY.md` after `AGENTS.md` when resuming work.
- Add durable lessons to `LESSONSLEARNED.md` when they should influence future sessions.
- Keep transient entries brief and focused on recent user context, actions, blockers, and next steps.
- Redact sensitive or private source material before writing to `CHATHISTORY.md`.
