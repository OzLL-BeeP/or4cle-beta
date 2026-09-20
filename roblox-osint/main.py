#!/usr/bin/env python3
"""ROBLOX-OSINT — Main CLI v3 (all-in-one)"""

import argparse
import os
import subprocess
import sys
import json
import yaml
from pathlib import Path
from datetime import datetime

# ── Optional rich (fallback kalau gak ada)
try:
    from rich.console import Console
    from rich.table import Table
    from rich.progress import Progress, SpinnerColumn, TextColumn
    HAS_RICH = True
    console = Console()
except ImportError:
    HAS_RICH = False
    console = None


VERSION = "1.0.0"
INSTALL_DIR = Path(__file__).parent.resolve()


# ═══════════════════════════════════════════════════════
# HELPERS
# ═══════════════════════════════════════════════════════
def out(msg=""):
    if HAS_RICH:
        console.print(msg)
    else:
        # strip rich tags
        import re
        print(re.sub(r"\[/?[^\]]+\]", "", msg))


def print_banner():
    out("")
    out("[bold red]╔══════════════════════════════════════════════════╗[/]")
    out("[bold red]║   🕵️  ROBLOX-OSINT — RAPTOR EYE                  ║[/]")
    out("[bold red]║   Pelacakan Oknum di Roblox                      ║[/]")
    out("[bold red]╚══════════════════════════════════════════════════╝[/]")
    out("")


def print_help():
    print_banner()
    out("[bold cyan]USAGE:[/]")
    out("  [green]roblox[/] <username>                 Scan user langsung")
    out("  [green]roblox[/] scan <username>            Scan user")
    out("  [green]roblox[/] scan <username> --report html")
    out("  [green]roblox[/] graph <username>           Build network graph")
    out("  [green]roblox[/] graph <username> --depth 2")
    out("  [green]roblox[/] report                     Lihat report")
    out("  [green]roblox[/] report --format html")
    out("  [green]roblox[/] check                      Cek file kosong/isi")
    out("  [green]roblox[/] install                    Install deps")
    out("  [green]roblox[/] update                     Update deps")
    out("  [green]roblox[/] info                       Info config")
    out("  [green]roblox[/] --help                     Bantuan ini")
    out("")
    out("[bold cyan]CONTOH:[/]")
    out("  [yellow]roblox TidakTakutMat1[/]")
    out("  [yellow]roblox TidakTakutMat1 --report html[/]")
    out("  [yellow]roblox graph TidakTakutMat1 --depth 2[/]")
    out("")
    out("[bold cyan]INFO:[/]")
    out(f"  Version : {VERSION}")
    out(f"  Install : {INSTALL_DIR}")
    out("")


def load_config(path=None):
    if path is None:
        path = INSTALL_DIR / "config.yaml"
    with open(path) as f:
        return yaml.safe_load(f)


# ═══════════════════════════════════════════════════════
# COMMAND: SCAN
# ═══════════════════════════════════════════════════════
def cmd_scan(target, report_format="json"):
    from core.user_lookup import UserLookup
    from core.friends_scraper import FriendsScraper
    from core.groups_scraper import GroupsScraper
    from core.badges_scraper import BadgesScraper
    from core.avatar_scraper import AvatarScraper
    from analysis.red_flag_detector import RedFlagDetector
    from analysis.money_laundry import MoneyLaundryDetector
    from report.json_export import JsonExport
    from report.html_report import HtmlReport

    cfg = load_config()

    print_banner()
    out(f"[bold red]🎯 TARGET: {target}[/]\n")

    if HAS_RICH:
        with Progress(SpinnerColumn(), TextColumn("[cyan]{task.description}"), console=console) as prog:
            t = prog.add_task("Resolve user...", total=None)
            lookup = UserLookup(cfg)
            user = lookup.resolve(target)
            if not user:
                prog.stop()
                out("[red]✗ Target tidak ditemukan[/]")
                return 1
            uid = user["id"]
            prog.update(t, description=f"[green]✓ UID: {uid} | {user.get('name')}[/]")

            prog.update(t, description="Fetch friends...")
            friends = FriendsScraper(cfg).get_friends(uid)

            prog.update(t, description="Fetch groups...")
            groups = GroupsScraper(cfg).get_groups(uid)

            prog.update(t, description="Fetch badges...")
            badges = BadgesScraper(cfg).get_badges(uid)

            prog.update(t, description="Fetch avatar...")
            avatar = AvatarScraper(cfg).get_avatar(uid)

            prog.update(t, description="Analyze red flags...")
            flags = RedFlagDetector(cfg).detect(groups)
            name_flags = RedFlagDetector(cfg).scan_username(user)

            prog.update(t, description="Analyze laundering...")
            laundry = MoneyLaundryDetector(cfg).analyze(user, groups, friends)

            prog.update(t, description="[green]✓ Selesai[/]")
    else:
        lookup = UserLookup(cfg)
        user = lookup.resolve(target)
        if not user:
            out("[red]✗ Target tidak ditemukan[/]")
            return 1
        uid = user["id"]
        friends = FriendsScraper(cfg).get_friends(uid)
        groups = GroupsScraper(cfg).get_groups(uid)
        badges = BadgesScraper(cfg).get_badges(uid)
        avatar = AvatarScraper(cfg).get_avatar(uid)
        flags = RedFlagDetector(cfg).detect(groups)
        name_flags = RedFlagDetector(cfg).scan_username(user)
        laundry = MoneyLaundryDetector(cfg).analyze(user, groups, friends)

    # ── Profile
    if HAS_RICH:
        t = Table(title=f"📋 Profile: {user.get('name')}", show_header=False)
        t.add_column("Field", style="cyan bold")
        t.add_column("Value", style="white")
        t.add_row("UID", str(uid))
        t.add_row("Username", str(user.get("name")))
        t.add_row("Display Name", str(user.get("displayName")))
        t.add_row("Created", str(user.get("created")))
        t.add_row("Description", str(user.get("description", "-")[:80]))
        console.print(t)

        s = Table(title="📊 Stats")
        s.add_column("Metric", style="cyan")
        s.add_column("Count", style="yellow", justify="right")
        s.add_row("Friends", str(len(friends)))
        s.add_row("Groups", str(len(groups)))
        s.add_row("Badges", str(len(badges)))
        s.add_row("Red Flags", str(len(flags)))
        s.add_row("Laundry Score", f"{laundry.get('score', 0)}/100")
        console.print(s)

        if flags:
            rf = Table(title=f"🚨 Red Flags ({len(flags)})")
            rf.add_column("Type", style="red")
            rf.add_column("Match", style="yellow")
            rf.add_column("Group", style="white")
            for f in flags[:10]:
                rf.add_row(f.get("type", "-"), f.get("match", "-"), f.get("group", "-")[:40])
            console.print(rf)

        if laundry.get("flags"):
            lf = Table(title=f"💰 Laundry Flags (score: {laundry['score']})")
            lf.add_column("Type", style="magenta")
            lf.add_column("Detail", style="white")
            for f in laundry["flags"]:
                lf.add_row(f.get("type", "-"), f.get("detail", "-"))
            console.print(lf)
    else:
        out(f"UID: {uid} | Name: {user.get('name')} | Created: {user.get('created')}")
        out(f"Friends: {len(friends)} | Groups: {len(groups)} | Badges: {len(badges)}")
        out(f"Red Flags: {len(flags)} | Laundry Score: {laundry.get('score', 0)}")

    if name_flags:
        out(f"[red]⚠️  Red flag di username: {', '.join(name_flags)}[/]")

    # ── Save report
    result = {
        "meta": {
            "generated": datetime.now().isoformat(),
            "version": VERSION,
            "target": target,
        },
        "user": user,
        "friends": friends,
        "groups": groups,
        "badges": badges,
        "avatar": avatar,
        "red_flags": flags,
        "name_flags": name_flags,
        "laundry": laundry,
    }

    if report_format == "html":
        path = HtmlReport(cfg).save(uid, result)
    else:
        path = JsonExport(cfg).save(uid, result)

    out(f"\n[bold green]✓ Report tersimpan: {path}[/]")
    return 0


# ═══════════════════════════════════════════════════════
# COMMAND: GRAPH
# ═══════════════════════════════════════════════════════
def cmd_graph(target, depth=2):
    from core.user_lookup import UserLookup
    from analysis.network_graph import NetworkGraph

    cfg = load_config()
    print_banner()
    out(f"[bold red]🕸️  NETWORK GRAPH: {target}[/]\n")

    lookup = UserLookup(cfg)
    user = lookup.resolve(target)
    if not user:
        out("[red]✗ Target tidak ditemukan[/]")
        return 1

    out(f"[green]✓ UID: {user['id']} | {user.get('name')}[/]")
    out(f"[cyan]Building graph (depth={depth})...[/]")

    ng = NetworkGraph(cfg)
    graph = ng.build(user["id"], depth=depth)
    path = ng.export(graph, user["id"])

    out(f"[bold green]✓ Graph: {path}[/]")
    out(f"[cyan]Nodes: {graph.number_of_nodes()} | Edges: {graph.number_of_edges()}[/]")
    return 0


# ═══════════════════════════════════════════════════════
# COMMAND: REPORT
# ═══════════════════════════════════════════════════════
def cmd_report(fmt="json"):
    cfg = load_config()
    print_banner()
    out_dir = INSTALL_DIR / cfg["output"]["dir"]
    reports = sorted(out_dir.glob(f"*.{fmt}"), key=lambda p: p.stat().st_mtime, reverse=True)

    out(f"[cyan]📁 Folder: {out_dir}[/]")
    out(f"[cyan]📄 Format: {fmt}[/]")
    out(f"[cyan]Total: {len(reports)}[/]\n")

    if not reports:
        out("[yellow]! Belum ada report. Jalanin: roblox <username>[/]")
        return 0

    if HAS_RICH:
        t = Table(title="Daftar Report")
        t.add_column("#", style="cyan", justify="right")
        t.add_column("File", style="white")
        t.add_column("Size", style="yellow", justify="right")
        t.add_column("Modified", style="green")
        for i, r in enumerate(reports[:20], 1):
            size = r.stat().st_size
            mtime = datetime.fromtimestamp(r.stat().st_mtime).strftime("%Y-%m-%d %H:%M")
            t.add_row(str(i), r.name, f"{size}B", mtime)
        console.print(t)
    else:
        for i, r in enumerate(reports[:20], 1):
            out(f"{i}. {r.name} ({r.stat().st_size}B)")
    return 0


# ═══════════════════════════════════════════════════════
# COMMAND: CHECK (delegate ke check_all.sh)
# ═══════════════════════════════════════════════════════
def cmd_check(args):
    script = INSTALL_DIR / "check_all.sh"
    if not script.exists():
        out("[red]✗ check_all.sh gak ada[/]")
        return 1
    return subprocess.call(["bash", str(script)] + args)


# ═══════════════════════════════════════════════════════
# COMMAND: INSTALL (delegate ke install.sh)
# ═══════════════════════════════════════════════════════
def cmd_install():
    script = INSTALL_DIR / "install.sh"
    if not script.exists():
        out("[red]✗ install.sh gak ada[/]")
        return 1
    return subprocess.call(["bash", str(script)])


# ═══════════════════════════════════════════════════════
# COMMAND: UPDATE (pip upgrade)
# ═══════════════════════════════════════════════════════
def cmd_update():
    out("[cyan][*] Update deps...[/]")
    req = INSTALL_DIR / "requirements.txt"
    rc = subprocess.call([sys.executable, "-m", "pip", "install", "--upgrade", "-r", str(req)])
    if rc == 0:
        out("[green]✓ Update selesai[/]")
    return rc


# ═══════════════════════════════════════════════════════
# COMMAND: INFO
# ═══════════════════════════════════════════════════════
def cmd_info():
    cfg = load_config()
    print_banner()
    if HAS_RICH:
        t = Table(show_header=False)
        t.add_column("Key", style="cyan bold")
        t.add_column("Value", style="white")
        t.add_row("Version", VERSION)
        t.add_row("Install dir", str(INSTALL_DIR))
        t.add_row("Config", str(INSTALL_DIR / "config.yaml"))
        t.add_row("Output dir", cfg["output"]["dir"])
        t.add_row("Rate limit", f"{cfg['rate_limit']['requests_per_second']} req/s")
        t.add_row("Red flags", f"{len(cfg['red_flags']['keywords'])} keywords")
        console.print(t)
    else:
        out(f"Version: {VERSION}")
        out(f"Install: {INSTALL_DIR}")
    return 0


# ═══════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════
KNOWN_COMMANDS = {"scan", "graph", "report", "check", "install", "update", "info", "help", "--help", "-h", "--version"}


def main():
    argv = sys.argv[1:]

    # No args → help
    if not argv:
        print_help()
        return 0

    cmd = argv[0]
    rest = argv[1:]

    # --help / -h
    if cmd in ("help", "--help", "-h"):
        print_help()
        return 0

    if cmd == "--version":
        out(f"ROBLOX-OSINT v{VERSION}")
        return 0

    # COMMAND: scan
    if cmd == "scan":
        if not rest:
            out("[red]✗ Butuh username: roblox scan <username>[/]")
            return 1
        target = rest[0]
        report = "json"
        if "--report" in rest:
            idx = rest.index("--report")
            if idx + 1 < len(rest):
                report = rest[idx + 1]
        return cmd_scan(target, report)

    # COMMAND: graph
    if cmd == "graph":
        if not rest:
            out("[red]✗ Butuh username: roblox graph <username>[/]")
            return 1
        target = rest[0]
        depth = 2
        if "--depth" in rest:
            idx = rest.index("--depth")
            if idx + 1 < len(rest):
                try:
                    depth = int(rest[idx + 1])
                except ValueError:
                    pass
        return cmd_graph(target, depth)

    # COMMAND: report
    if cmd == "report":
        fmt = "json"
        if "--format" in rest:
            idx = rest.index("--format")
            if idx + 1 < len(rest):
                fmt = rest[idx + 1]
        return cmd_report(fmt)

    # COMMAND: check
    if cmd == "check":
        return cmd_check(rest)

    # COMMAND: install
    if cmd == "install":
        return cmd_install()

    # COMMAND: update
    if cmd == "update":
        return cmd_update()

    # COMMAND: info
    if cmd == "info":
        return cmd_info()

    # AUTO-DETECT: kalau bukan command keyword, anggap username → auto scan
    if cmd not in KNOWN_COMMANDS:
        target = cmd
        report = "json"
        if "--report" in rest:
            idx = rest.index("--report")
            if idx + 1 < len(rest):
                report = rest[idx + 1]
        return cmd_scan(target, report)

    # Fallback
    print_help()
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        out("\n[yellow]! Dibatalkan[/]")
        sys.exit(130)
    except Exception as e:
        out(f"[red]✗ Error: {e}[/]")
        sys.exit(1)
