---
title: "A Review Window for Weekly Posts"
date: 2026-11-22
permalink: /posts/2026/11/review-window-for-weekly-posts/
tags:
  - automation
  - jekyll
  - maintenance
excerpt: "How this site's weekly post workflow separates automated drafting from publication."
---

Authorship note: this post was authored by Codex from the repository's scripts, workflow configuration, and git history.

This site's weekly authoring script now sends each generated post to a dated `blog/weekly-<date>` branch instead of pushing to the protected default branch. The script still works from a temporary clean worktree and runs the repository's validation before it commits the result, but publication proceeds through a pull request.

A separate GitHub Actions workflow checks those branches once a day. It opens a pull request when one is missing, then leaves the post in a three-day review window. Closing the pull request during that period stops publication.

The merge step is deliberately narrow. It accepts only added or modified Markdown files directly under `_posts/`, requires the branch to belong to this repository, and matches the head commit observed during the check before performing a squash merge. Pull requests that touch other paths remain open for manual review.

The workflow also runs only from the default branch on a schedule or manual dispatch; it does not run on pushes and does not check out pull-request content. Together, these constraints keep automated authoring separate from the decision to publish while preserving the existing Jekyll archive and permalink structure.
