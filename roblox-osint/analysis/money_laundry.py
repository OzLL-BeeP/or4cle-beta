"""Deteksi pola cuci uang robux"""

from datetime import datetime


class MoneyLaundryDetector:
    def __init__(self, cfg):
        self.cfg = cfg
        self.flags = []
        self.score = 0

    def analyze(self, user, groups, friends):
        # 1. Akun baru + banyak teman/grup
        created = user.get("created", "")
        if created:
            try:
                age = (datetime.now() - datetime.fromisoformat(created.replace("Z", ""))).days
                if age < 60 and len(groups) > 30:
                    self.flags.append({"type": "NEW_ACCOUNT_MASS_GROUPS",
                                       "detail": f"Umur {age} hari, {len(groups)} grup"})
                    self.score += 30
                if age < 30 and len(friends) > 100:
                    self.flags.append({"type": "NEW_ACCOUNT_MASS_FRIENDS",
                                       "detail": f"Umur {age} hari, {len(friends)} teman"})
                    self.score += 25
            except Exception:
                pass

        # 2. Banyak grup mencurigakan
        suspicious = [g for g in groups
                      if any(k in g.get("group", {}).get("name", "").lower()
                             for k in ["mule", "launder", "dark", "blackmarket"])]
        if suspicious:
            self.flags.append({"type": "SUSPICIOUS_GROUPS", "detail": f"{len(suspicious)} grup"})
            self.score += 20 * len(suspicious)

        # 3. Akun punya banyak grup developer (indikasi monetisasi)
        dev_groups = [g for g in groups
                      if any(k in g.get("group", {}).get("name", "").lower()
                             for k in ["studio", "dev", "production", "games"])]
        if len(dev_groups) > 20:
            self.flags.append({"type": "MASS_DEV_GROUPS", "detail": f"{len(dev_groups)} grup dev"})
            self.score += 15

        return {"score": min(self.score, 100), "flags": self.flags}
