"""Base scraper — shared HTTP client + rate limit"""

import time
import requests
from pathlib import Path


class BaseScraper:
    def __init__(self, cfg):
        self.cfg = cfg
        self.api = cfg["api"]
        self.rl = cfg["rate_limit"]
        self.session = requests.Session()
        self.session.headers.update({
            "User-Agent": "Mozilla/5.0 (Linux; Android 10) ROBLOX-OSINT/1.0",
            "Accept": "application/json",
        })
        self._last = 0
        self._cache_dir = Path(cfg["output"]["cache_dir"])
        self._cache_dir.mkdir(parents=True, exist_ok=True)

    def _throttle(self):
        gap = 1.0 / self.rl["requests_per_second"]
        elapsed = time.time() - self._last
        if elapsed < gap:
            time.sleep(gap - elapsed)
        self._last = time.time()

    def _get(self, url, **kwargs):
        self._throttle()
        for attempt in range(self.rl["retry"]):
            try:
                r = self.session.get(url, timeout=self.rl["timeout"], **kwargs)
                if r.status_code == 429:
                    time.sleep(self.rl["retry_delay"] * (attempt + 1))
                    continue
                return r
            except Exception:
                time.sleep(self.rl["retry_delay"])
        return None

    def _post(self, url, **kwargs):
        self._throttle()
        for attempt in range(self.rl["retry"]):
            try:
                r = self.session.post(url, timeout=self.rl["timeout"], **kwargs)
                if r.status_code == 429:
                    time.sleep(self.rl["retry_delay"] * (attempt + 1))
                    continue
                return r
            except Exception:
                time.sleep(self.rl["retry_delay"])
        return None
