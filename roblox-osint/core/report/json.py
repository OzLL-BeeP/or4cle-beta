import json
from pathlib import Path

class JSONReport:
    def __init__(self, output_dir="output"):
        self.dir = Path(output_dir)
        self.dir.mkdir(parents=True, exist_ok=True)

    def save(self, username, data):
        path = self.dir / f"{username}.json"
        with open(path, "w") as f:
            json.dump(data, f, indent=2, default=str)
        return str(path)
