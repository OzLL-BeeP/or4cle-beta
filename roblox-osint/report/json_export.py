"""Export hasil scan ke JSON"""

import json
from pathlib import Path
from datetime import datetime


class JsonExport:
    def __init__(self, cfg):
        self.cfg = cfg
        self.out = Path(cfg["output"]["dir"])
        self.out.mkdir(parents=True, exist_ok=True)

    def save(self, uid, data):
        ts = int(datetime.now().timestamp())
        path = self.out / f"raptor_{uid}_{ts}.json"
        with open(path, "w") as f:
            json.dump(data, f, indent=2, default=str)
        return str(path)
