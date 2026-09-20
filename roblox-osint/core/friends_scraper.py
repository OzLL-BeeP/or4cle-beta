"""Ambil daftar teman user"""

from core._base import BaseScraper


class FriendsScraper(BaseScraper):
    def get_friends(self, uid):
        url = f"{self.api['friends']}/users/{uid}/friends"
        r = self._get(url)
        return r.json().get("data", []) if r and r.status_code == 200 else []

    def get_count(self, uid):
        url = f"{self.api['friends']}/users/{uid}/friends/count"
        r = self._get(url)
        return r.json().get("count", 0) if r and r.status_code == 200 else 0

    def get_followers(self, uid):
        url = f"{self.api['friends']}/users/{uid}/followers"
        r = self._get(url)
        return r.json().get("data", []) if r and r.status_code == 200 else []
