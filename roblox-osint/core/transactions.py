"""Tracker transaksi user — aliran robux / item"""

from core._base import BaseScraper


class TransactionsTracker(BaseScraper):
    def get_inventory(self, uid):
        url = f"{self.api['inventory']}/users/{uid}/assets/collectibles"
        r = self._get(url, params={"limit": 100})
        return r.json().get("data", []) if r and r.status_code == 200 else []

    def get_trades(self, uid):
        url = f"{self.api['trades']}/users/{uid}/trades"
        r = self._get(url, params={"limit": 50, "sortOrder": "Desc"})
        return r.json().get("data", []) if r and r.status_code == 200 else []

    def get_transactions(self, uid):
        url = f"{self.api['economy']}/users/{uid}/transactions"
        r = self._get(url, params={"limit": 100, "transactionType": "Purchase"})
        return r.json().get("data", []) if r and r.status_code == 200 else []
