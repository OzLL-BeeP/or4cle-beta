"""Build friends network graph"""

import networkx as nx
from pathlib import Path
from core.friends_scraper import FriendsScraper


class NetworkGraph:
    def __init__(self, cfg):
        self.cfg = cfg
        self.fs = FriendsScraper(cfg)
        self.graph = nx.Graph()

    def build(self, root_uid, depth=2):
        self.graph.add_node(root_uid)
        current = [root_uid]
        for _ in range(depth):
            next_layer = []
            for uid in current:
                for f in self.fs.get_friends(uid):
                    fid = f["id"]
                    if not self.graph.has_node(fid):
                        self.graph.add_node(fid, name=f.get("name"), display=f.get("displayName"))
                        next_layer.append(fid)
                    self.graph.add_edge(uid, fid)
            current = next_layer
        return self.graph

    def export(self, graph, root_uid):
        out = Path(self.cfg["output"]["dir"]) / f"graph_{root_uid}.gexf"
        out.parent.mkdir(parents=True, exist_ok=True)
        nx.write_gexf(graph, out)
        return str(out)

    def centrality(self, graph):
        return sorted(nx.degree_centrality(graph).items(), key=lambda x: -x[1])
