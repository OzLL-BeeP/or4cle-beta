import html
import json
from pathlib import Path
from datetime import datetime

TEMPLATE = """<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ROBLOX-OSINT — {username}</title>
<style>
  * {{ box-sizing: border-box; }}
  body {{
    background: #0a0a0f; color: #e0e0e0;
    font-family: 'SF Mono', 'Consolas', monospace;
    margin: 0; padding: 24px;
  }}
  h1 {{
    color: #00d9ff; text-shadow: 0 0 10px #00d9ff;
    border-bottom: 2px solid #00d9ff; padding-bottom: 8px;
  }}
  .grid {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 16px; margin-top: 24px; }}
  .card {{
    background: #13131a; border: 1px solid #2a2a3a;
    border-radius: 8px; padding: 16px;
  }}
  .card h2 {{ color: #ff00aa; margin-top: 0; font-size: 14px; text-transform: uppercase; letter-spacing: 2px; }}
  .row {{ display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px solid #1a1a24; }}
  .row:last-child {{ border-bottom: none; }}
  .label {{ color: #8888aa; }}
  .value {{ color: #ffcc00; font-weight: bold; }}
  .value.ok {{ color: #00ff88; }}
  .value.warn {{ color: #ffaa00; }}
  .value.bad {{ color: #ff3344; }}
  pre {{ background: #0a0a0f; padding: 12px; border-radius: 4px; overflow-x: auto; color: #00d9ff; }}
</style>
</head>
<body>
<h1>🕵️ ROBLOX-OSINT — {username}</h1>
<p style="color:#888">Generated: {timestamp}</p>
<div class="grid">
{cards}
</div>
</body>
</html>
"""

def make_card(title, rows):
    body = ""
    for k, v in rows.items():
        v_str = html.escape(str(v))
        cls = "value"
        if isinstance(v, bool):
            cls = "value ok" if v else "value bad"
        body += f'<div class="row"><span class="label">{html.escape(k)}</span><span class="{cls}">{v_str}</span></div>'
    return f'<div class="card"><h2>{html.escape(title)}</h2>{body}</div>'


class HTMLReport:
    def __init__(self, output_dir="output"):
        self.dir = Path(output_dir)
        self.dir.mkdir(parents=True, exist_ok=True)

    def save(self, username, data):
        cards = []

        profile = {k: v for k, v in data.items()
                   if not isinstance(v, (list, dict))}
        cards.append(make_card("Profile", profile))

        if data.get("groups"):
            cards.append(make_card("Groups", {
                "Count": len(data["groups"]),
                "Sample": ", ".join(g.get("group", {}).get("name", "?") for g in data["groups"][:5])
            }))

        if data.get("games"):
            cards.append(make_card("Games", {
                "Count": len(data["games"]),
                "Sample": ", ".join(g.get("name", "?") for g in data["games"][:5])
            }))

        if data.get("presence"):
            cards.append(make_card("Presence", data["presence"]))

        html_out = TEMPLATE.format(
            username=html.escape(username),
            timestamp=datetime.now().isoformat(),
            cards="\n".join(cards)
        )

        path = self.dir / f"{username}.html"
        with open(path, "w") as f:
            f.write(html_out)
        return str(path)
