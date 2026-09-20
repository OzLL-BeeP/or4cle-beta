# ROBLOX-OSINT — RAPTOR EYE

Polyglot OSINT toolkit for Roblox. Multi-language, modular, extensible.

---

## Table of Contents

- Overview
- Features
- Architecture
- Project Structure
- Installation
- Usage
- Modules
- Lua Plugins
- Configuration
- License
- Disclaimer

---

## Overview

ROBLOX-OSINT is an OSINT toolkit for tracking and analyzing Roblox accounts.
Built with a multi-language approach: each module uses the most optimal
language for its role.

Main goals:
- Track Roblox profiles in detail
- Analyze network (friends, groups, games)
- Detect red flags and suspicious activity
- Generate HTML/CSV/JSON reports

---

## Features

- Profile scanner — UID, username, display name, description, created date
- Friends analysis — count, list, network mapping
- Groups analysis — count, list, red flag detection
- Games analysis — games created by user
- Badges tracking — collectible badges
- Presence detection — online/offline status
- Avatar data — current avatar state
- Red flag detection — suspicious keywords and groups
- Laundry detection — money laundering patterns
- Network graph — BFS, Dijkstra, community detection
- Multi-format report — HTML, CSV, JSON
- Plugin system — Lua-based custom scanners
- Cache system — SQLite for fast repeat scans

---

## Architecture

    +----------------------+
    |   USER (CLI)         |
    +----------+-----------+
               |
               v
    +----------------------+
    |  PYTHON CORE         |
    |  Orchestrator + CLI  |
    +----------+-----------+
               |
       +-------+-------+-------+
       v       v       v       v
    +------+ +------+ +------+ +------+
    | NODE | | GO   | | RUST | | C++  |
    | PW   | | Fetch| | Anti | | Graph|
    | Scrape| | API  | | TLS  | | BFS  |
    +------+ +------+ +------+ +------+
               |
               v
    +----------------------+
    |  LUA PLUGINS         |
    |  Custom scanners     |
    +----------------------+

Communication:
- Python spawns subprocess
- Returns JSON via stdout
- Merges in Python orchestrator

---

## Project Structure

    roblox-osint/
    |-- core/              # Python orchestrator
    |   |-- main.py
    |   |-- cli.py
    |   |-- config.py
    |   |-- report/
    |   `-- cache/
    |-- scraper/           # Node.js + Playwright
    |   |-- package.json
    |   `-- src/
    |-- fetcher/           # Go concurrent fetcher
    |   |-- go.mod
    |   |-- cmd/
    |   `-- internal/
    |-- antidetect/        # Rust TLS/JA3
    |   |-- Cargo.toml
    |   `-- src/
    |-- graph/             # C++ network analysis
    |   |-- CMakeLists.txt
    |   |-- src/
    |   `-- include/
    |-- plugins/           # Lua plugins
    |   |-- scanner/
    |   |-- rules/
    |   `-- output/
    |-- scripts/           # Bash automation
    |-- config/            # YAML config
    `-- docs/

---

## Installation

### Requirements

| Tool      | Version | Description         |
|-----------|---------|---------------------|
| Python    | 3.10+   | Core orchestrator   |
| Node.js   | 18+     | Playwright scraper  |
| Go        | 1.21+   | Concurrent fetcher  |
| Rust      | 1.70+   | Antidetect          |
| C++       | C++17   | Graph analysis      |
| CMake     | 3.15+   | C++ build           |
| Chromium  | Latest  | Browser automation  |

### Install (Termux)

    pkg update
    pkg install python nodejs golang rust cmake chromium firefox
    cd ~/roblox-osint
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    npm install --prefix scraper
    go build -C fetcher -o bin/fetcher ./cmd/fetcher
    cargo build --release --manifest-path antidetect/Cargo.toml
    cmake -B graph/build -S graph
    cmake --build graph/build

---

## Usage

### Scan user

    roblox <username>

### Scan with HTML report

    roblox <username> --report html

### Build network graph

    roblox graph <username> --depth 2

### Check reports

    roblox report
    roblox report --format html

### Info & help

    roblox info
    roblox check
    roblox --help

---

## Modules

| Module     | Language  | Role                         |
|------------|-----------|------------------------------|
| core       | Python    | CLI, orchestration, report   |
| scraper    | Node.js   | Playwright browser scraping  |
| fetcher    | Go        | Concurrent API fetcher       |
| antidetect | Rust      | JA3 spoof, TLS fingerprint   |
| graph      | C++       | Network analysis, BFS        |
| plugins    | Lua       | Custom scanner runtime       |

---

## Lua Plugins

Example plugins/scanner/red_flags.lua:

    plugin = {
        name = "red_flags",
        version = "1.0",
        type = "scanner"
    }

    function scan(profile)
        local findings = {}
        if profile.friends_count > 500 then
            table.insert(findings, {
                type = "MASS_FRIENDS",
                score = 30
            })
        end
        return findings
    end

---

## Configuration

Edit config/default.yaml:

    user_agent: "Mozilla/5.0 ..."
    timeout: 15
    cache_ttl: 3600
    output_dir: "output"

    playwright:
      headless: true
      browser: chromium

    features:
      node_scraper: true
      go_fetcher: true
      rust_antidetect: false
      cpp_graph: true
      lua_plugins: true

---

## License

MIT License - see LICENSE file.

---

## Disclaimer

ROBLOX-OSINT is created for security research, education, and testing
your own systems. Usage for stalking, doxxing, or illegal activities
is the user's responsibility. The author is not responsible for any
misuse.

