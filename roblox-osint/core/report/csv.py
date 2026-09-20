import csv
from pathlib import Path

class CSVReport:
    def __init__(self, output_dir="output"):
        self.dir = Path(output_dir)
        self.dir.mkdir(parents=True, exist_ok=True)

    def save(self, username, data):
        path = self.dir / f"{username}.csv"
        with open(path, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["Field", "Value"])
            for key, value in data.items():
                if isinstance(value, (list, dict)):
                    value = str(value)[:100]
                writer.writerow([key, value])
        return str(path)
