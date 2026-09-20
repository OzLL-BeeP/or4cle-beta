"""Ambil badge user"""

from core._base import BaseScraper


class BadgesScraper(BaseScraper):
    def get_badges(self, uid):
        url = f"{self.api['badges']}/users/{uid}/badges"
        r = self._get(url, params={"limit": 100})
        return r.json().get("data", []) if r and r.status_code == 200 else []
