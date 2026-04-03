---
title: "dyno-lab"
excerpt: "Portfolio-wide test bench utilities: reusable fixtures, mocks, assertions, and smoke-test scaffolding for Python projects."
collection: portfolio
permalink: /portfolio/dyno-lab/
date: 2026-04-01
---
`dyno-lab` is a shared Python library providing reusable testing infrastructure drawn from patterns across every tested repository in the portfolio. It is designed to be installed as a local editable dependency and used as a drop-in test harness.

## Modules

| Module | Purpose |
|--------|---------|
| `dyno_lab.base` | `DynoTestCase` — `unittest.TestCase` with extra assertions |
| `dyno_lab.proc` | Subprocess mocking (`ProcessRecorder`, `SubprocessPatch`) |
| `dyno_lab.env` | Environment patching (`EnvPatch`, `patched_env`) |
| `dyno_lab.fs` | Filesystem fixtures (`TempWorkdir`, `make_tree`) |
| `dyno_lab.cli` | CLI output capture (`capture_cli`, `CLITestMixin`, `CliResult`) |
| `dyno_lab.http` | HTTP session mocking (`SequenceSession`, `StaticSession`, `RaisingSession`) |
| `dyno_lab.schema` | Schema/contract parity helpers (`assert_parity`, `assert_row_width`) |
| `dyno_lab.module` | Dynamic module loading (`load_module_by_path`) |
| `dyno_lab.markers` | Shared pytest markers (`unit`, `integration`, `smoke`, `parity`, `slow`, `external`) |
| `dyno_lab.fixtures` | Pytest fixtures (`dyno_tmp`, `dyno_env`, `dyno_proc`, `dyno_cli`) |
| `dyno_lab.smoke` | Smoke test scaffolding (`SmokeTest`, `SmokeRunner`, `SmokeResult`) |

## Highlights

- **Subprocess mocking** — record and assert exact commands passed to `subprocess.run` without side effects
- **Environment and filesystem isolation** — ephemeral patches that roll back automatically
- **CLI capture** — run a `main()` entry point and inspect stdout/stderr/exit code in-process
- **HTTP mocking** — serve canned responses in sequence or raise controlled errors
- **Schema parity** — assert that multiple provider implementations produce identical row shapes
- **Smoke scaffolding** — lightweight pass/fail health checks with a composable runner

Released under the MIT license.

Links:

- [GitHub repository](https://github.com/casonk/dyno-lab)
