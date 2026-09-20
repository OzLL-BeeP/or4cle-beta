"""Export hasil scan ke HTML report"""

from pathlib import Path
from datetime import datetime
from jinja2 import Template


TEMPLATE = """<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>ROBLOX-OSINT Report</title>
<style>
body{font-family:monospace;background:#0a0a0a;color:#0f0;padding:20px}
h1{color:#f00}h2{color:#0ff;border-bottom:1px solid #333}
.flag{background:#300;padding:8px;margin:4px 0;border-left:4px solid #f00}
.node{display:inline-block;padding:4px 8px;margin:2px;background:#111;border:1px solid #0f0}
table{border-collapse:collapse}td{padding:4px 12px;border:1px solid #333}
</style></head><body>
<h1>🕵️ ROBLOX-OSINT REPORT</h1>
<p>Generated: {{ ts }}</p>
<h2>Profile</h2>
<table>
<tr><td>UID</td><td>{{ user.id }}</td></tr>
<tr><td>Username</td><td>{{ user.name }}</td></tr>
<tr><td>Display</td><td>{{ user.displayName }}</td></tr>
<tr><td>Created</td><td>{{ user.created }}</td></tr>
<tr><td>Friends</td><td>{{ friends|length }}</td></tr>
<tr><td>Groups</td><td>{{ groups|length }}</td></tr>
<tr><td>Red Flags</td><td>{{ red_flags|length }}</td></tr>
<tr><td>Laundry Score</td><td>{{ laundry.score }}</td></tr>
</table>
<h2>Red Flags ({{ red_flags|length }})</h2>
{% for f in red_flags %}<div class="flag">⚠️ {{ f.type }} — {{ f.match }} — {{ f.group }}</div>{% endfor %}
<h2>Laundry Flags ({{ laundry.flags|length }})</h2>
{% for f in laundry.flags %}<div class="flag">💰 {{ f.type }}: {{ f.detail }}</div>{% endfor %}
</body></html>
"""


class HtmlReport:
    def __init__(self, cfg):
        self.cfg = cfg
        self.out = Path(cfg["output"]["dir"])
        self.out.mkdir(parents=True, exist_ok=True)

    def save(self, uid, data):
        html = Template(TEMPLATE).render(
            ts=datetime.now().isoformat(),
            user=data["user"],
            friends=data.get("friends", []),
            groups=data.get("groups", []),
            red_flags=data.get("red_flags", []),
            laundry=data.get("laundry", {}),
        )
        path = self.out / f"raptor_{uid}.html"
        with open(path, "w") as f:
            f.write(html)
        return str(path)
