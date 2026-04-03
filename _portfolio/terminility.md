---
title: "terminility"
excerpt: "Install, configure, and supercharge tmux with automatic session save/restore on Linux or macOS."
collection: portfolio
permalink: /portfolio/terminility/
date: 2026-03-21
---
`terminility` is a shell-based setup tool that installs and fully configures [tmux](https://github.com/tmux/tmux) on any Linux or macOS machine with a single command.

## What it does

- Detects the system package manager and installs tmux automatically
- Deploys [TPM](https://github.com/tmux-plugins/tpm) and a batteries-included `~/.tmux.conf`:
  - Mouse support, 256-color / true-color
  - Vim-style pane navigation (`h/j/k/l`) and resize (`H/J/K/L`)
  - Intuitive split shortcuts (`|` / `-`)
- Wires in [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) and [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) for sessions that survive reboots (auto-save every 15 minutes)
- Scans a configurable git repo base directory and creates a dedicated named tmux session per repository
- Generates shell aliases — type the session name to jump in immediately

## Supported platforms

| OS | Package manager |
|----|----------------|
| Debian / Ubuntu | `apt` |
| Fedora / RHEL / CentOS | `dnf` |
| Arch Linux | `pacman` |
| openSUSE | `zypper` |
| macOS | `brew` |

## Session management

`sessions.sh` reconciles sessions across runs: repos that moved are recreated at their new path, and sessions for repos that disappeared are removed. Aliases are written to `~/.terminility_aliases` and sourced automatically from `~/.bashrc` / `~/.zshrc`.

Links:

- [GitHub repository](https://github.com/casonk/terminility)
