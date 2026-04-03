---
title: "nordility"
excerpt: "A small Python utility for automating NordVPN connect, disconnect, and server-rotation workflows."
collection: portfolio
permalink: /portfolio/nordility/
date: 2026-03-21
---
`nordility` is a focused Python package extracted from [citegres](https://github.com/casonk/citegres) that automates NordVPN actions through a clean CLI and Python API.

## Features

- Connect, disconnect, and rotate to a new country or server group
- **Windows** backend (`NordVPN.exe`) and **Linux/macOS** backend (`nordvpn` CLI), selectable at runtime
- Fast (filtered) and full country pool modes for randomized server rotation
- No third-party runtime dependencies
- Backward-compatible shims that preserve original function names from `citegres`

## CLI usage

```bash
nordility connect
nordility disconnect
nordility change --speed fast
nordility change --group United_States
nordility list-groups --speed full
```

## Python API

```python
from nordility import change_vpn_server, connect_vpn_server, disconnect_vpn_server

connect_vpn_server()
change_vpn_server(speed="fast")
disconnect_vpn_server()
```

Links:

- [GitHub repository](https://github.com/casonk/nordility)
