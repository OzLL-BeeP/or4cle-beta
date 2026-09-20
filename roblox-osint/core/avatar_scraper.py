"""Ambil avatar & thumbnail user"""

from core._base import BaseScraper


class AvatarScraper(BaseScraper):
    def get_avatar(self, uid):
        url = f"{self.api['thumbnails']}/users/avatar"
        r = self._get(url, params={"userIds": uid, "size": "420x420", "format": "Png"})
        return r.json().get("data", []) if r and r.status_code == 200 else []

    def get_headshot(self, uid):
        url = f"{self.api['thumbnails']}/users/avatar-headshot"
        r = self._get(url, params={"userIds": uid, "size": "150x150", "format": "Png"})
        return r.json().get("data", []) if r and r.status_code == 200 else []
