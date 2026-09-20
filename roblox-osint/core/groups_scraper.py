"""Ambil grup user"""

from core._base import BaseScraper


class GroupsScraper(BaseScraper):
    def get_groups(self, uid):
        url = f"{self.api['groups']}/users/{uid}/groups/roles"
        r = self._get(url)
        return r.json().get("data", []) if r and r.status_code == 200 else []

    def get_group_info(self, group_id):
        url = f"{self.api['groups']}/groups/{group_id}"
        r = self._get(url)
        return r.json() if r and r.status_code == 200 else None
