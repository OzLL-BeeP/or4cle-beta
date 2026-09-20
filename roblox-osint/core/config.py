"""Config loader — YAML/JSON"""
import os
import yaml
from pathlib import Path

ROOT = Path(__file__).parent.parent
DEFAULT_CONFIG = ROOT / "config" / "default.yaml"

class Config:
    def __init__(self, path=None):
        self.path = path or DEFAULT_CONFIG
        self.data = self._load()

    def _load(self):
        if not self.path.exists():
            return self._defaults()
        with open(self.path) as f:
            return yaml.safe_load(f) or {}

    def _defaults(self):
        return {
            "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
            "timeout": 15,
            "max_retries": 3,
            "cache_ttl": 3600,
            "output_dir": "output",
            "playwright": {
                "headless": True,
                "timeout": 30000,
            },
            "proxy": {
                "enabled": False,
                "list": [],
            },
        }

    def get(self, key, default=None):
        keys = key.split(".")
        val = self.data
        for k in keys:
            if isinstance(val, dict):
                val = val.get(k)
            else:
                return default
        return val if val is not None else default
