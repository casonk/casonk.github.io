---
title: "K3s as an Optional Deployment Mode"
date: 2026-11-15
permalink: /posts/2026/11/k3s-as-an-optional-deployment-mode/
tags:
  - k3s
  - cilium
  - security
  - automation
excerpt: "What moving a home server's scheduled jobs and small services into a single-node K3s cluster bought, what it cost, and what deliberately stayed on the host."
---

Authorship note: this post was drafted with Claude Code from the repositories' documentation, tests and git history. It covers public repositories only.

Over the past few weeks a handful of long-running pieces of this portfolio moved from systemd units on one workstation into a single-node [K3s](https://k3s.io) cluster running [Cilium](https://cilium.io). The rule that shaped everything: **K3s is optional**. Every moved project still runs with one command and no cluster, and switching is one setting.

## One setting, three modes

Each moved repository carries a `deploy/deploy.sh` with the same contract. The mode is `dev` (run it in the foreground), `host` (the systemd user service or timer it always had) or `k3s`, chosen by a flag, an environment variable or a gitignored config file. Only `k3s` needs a cluster. Switching is verified before it takes effect, rolled back by a single command, and never moves the data. The contract, its tests and a checker live in [traction-control](https://github.com/casonk/traction-control); a scaffold generates the same shape for the next project, so a new deployment starts from a tested skeleton instead of a copy of the last one.

## What it bought

**Network least privilege that is enforced, not hoped for.** Each workload gets a default-deny network policy with an allow-list of the few hosts it actually needs. The data-refresh jobs ([zillow-public-data](https://github.com/casonk/zillow-public-data), [fred-public-data](https://github.com/casonk/fred-public-data)) can reach one public file host and nothing else. The mail digest sender ([shock-relay](https://github.com/casonk/shock-relay)) can reach its mail provider. A pod that needs no network, such as the sandbox below, gets none.

**Isolation for the risky step.** [intake](https://github.com/casonk/intake) parses untrusted receipt files (PDF, photos, now HEIC). Only that parsing step runs in a pod with no network, no secrets and none of the host's files, and a bad document fails closed rather than reaching the rest of the service.

**Smaller blast radius for credentials.** Pods cannot reach the password vault. Credentials are resolved on the host and handed in as short-lived or narrowly scoped secrets: the [tradility](https://github.com/casonk/tradility) analysis pod receives a market-data token that lives about half an hour, while long-lived refresh tokens and exchange keys stay on the host, which also owns the order history. Pods run as an unprivileged user with a read-only root filesystem, no capabilities and no API token.

**Checks that can fail.** Every deployment ships a `verify.sh` that probes the policy from a pod carrying the same labels: allowed paths must open, forbidden ones (the internet, the host's SSH port, the Kubernetes API, other services) must stay closed. A probe that cannot run counts as a failure, not a pass. Hand-over to the pod happens only after verification passes.

**Reproducible images.** Pods run what is committed. The build refuses uncommitted source, so the host and the pod can no longer silently disagree about what the code is.

**Visibility.** Cilium's Hubble and Prometheus show every allowed and denied connection. They are how several real problems were found, below.

**Scheduling that keeps its guard rails.** For jobs that already ran under the machine's job guard and resource limits, the timer stays on the host and only the work moves: a removable systemd drop-in replaces the unit's start command with a small script that runs one Kubernetes Job and reports its status. The guards, schedule and post-steps keep working, and removing the drop-in puts everything back.

## Problems the checks caught

Each of these was found by a probe, a test or a policy verdict rather than in production:

- A resolver library that gives up on the first refused DNS lookup, which broke a market-data client until the pod was told to ask for the real hostname first.
- Two Cilium entities that include the host on a single node, so denying them also denied the one host port a web UI needed. The policy now relies on the default deny plus a port-limited allow, and the probes cover the ports that matter.
- A systemd drop-in that was silently overridden by a unit's own override file, so the hand-over reported success while the old command kept running. The hand-over now reads back the effective start command and undoes itself if it is not the new one.
- A password containing quotes that a Kubernetes secret file format would have mangled; secrets are now written one file per value.
- A job that overwrote an order-history export with an empty one when every source was unavailable. It now keeps the previous file, and the pod does not fetch orders at all.

Most of these are now lessons in the control-plane repository, so the next deployment does not rediscover them.

## What stayed on the host, on purpose

Not everything belongs in a pod. Hardware monitors, the VPN and ingress layer and the file shares read or control the machine itself. Jobs that run AI agents with write access to repositories gain nothing from a container. A report generator that needs a folder labelled for another container's private categories would have forced a relabel that breaks the other container. A network snapshot that measures the host's own interfaces would only see the pod's. Credential-heavy jobs such as the newsletter digest would hold more secrets in the cluster than they would protect. Those decisions are recorded in the repositories' backlogs rather than left implicit.

## What it cost

More moving parts: an image registry, a loopback forwarder per service, per-workload policy and a one-time root step to point the container runtime at the in-cluster registry. It is a single node, so it adds isolation and repeatability, not high availability. And every pattern needed tests and a checker so that the optional mode does not rot into a private fork of each project. That scaffolding is the part that makes the next move cheaper: the latest deployments (a torrent web UI that talks to a host-side download daemon through a single policy-allowed port, and a daily economic-data refresh) were generated from it and then filled in, rather than written from scratch.
