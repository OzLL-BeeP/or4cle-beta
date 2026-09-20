"""Resolve username / display name -> user info"""

from core._base import BaseScraper


class UserLookup(BaseScraper):
    def resolve(self, target):
        info = self._by_username(target)
        if info:
            return info
        matches = self._by_display(target)
        return matches[0] if matches else None

    def _by_username(self, username):
        url = f"{self.api['base']}/usernames/users"
        r = self._post(url, json={"usernames": [username], "excludeBannedUsers": False})
        if not r or r.status_code != 200:
            return None
        data = r.json().get("data", [])
        return data[0] if data else None

    def _by_display(self, display_name):
        url = f"{self.api['base']}/users/search"
        r = self._get(url, params={"keyword": display_name, "limit": 100})
        if not r or r.status_code != 200:
            return None
        results = r.json().get("data", [])
        return [u for u in results if u.get("displayName", "").lower() == display_name.lower()]

    def by_uid(self, uid):
        url = f"{self.api['base']}/users/{uid}"
        r = self._get(url)
        return r.json() if r and r.status_code == 200 else None
