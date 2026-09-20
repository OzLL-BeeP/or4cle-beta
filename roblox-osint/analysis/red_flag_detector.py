"""Deteksi red flag di grup / username user"""


class RedFlagDetector:
    def __init__(self, cfg):
        self.cfg = cfg
        self.keywords = [k.lower() for k in cfg["red_flags"]["keywords"]]

    def detect(self, groups):
        flags = []
        for g in groups:
            gname = g.get("group", {}).get("name", "").lower()
            for kw in self.keywords:
                if kw in gname:
                    flags.append({
                        "type": "RED_FLAG_GROUP",
                        "match": kw,
                        "group": g.get("group", {}).get("name"),
                        "group_id": g.get("group", {}).get("id"),
                    })
        return flags

    def scan_username(self, user):
        name = (user.get("name", "") + " " + user.get("displayName", "")).lower()
        hits = [kw for kw in self.keywords if kw in name]
        return hits
