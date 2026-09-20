#include "../include/graph.hpp"
#include <unordered_set>
#include <algorithm>

namespace roblox_osint {

std::unordered_map<std::string, double> Graph::dijkstra(const std::string& start) const {
    std::unordered_map<std::string, double> dist;
    using P = std::pair<double, std::string>;
    std::priority_queue<P, std::vector<P>, std::greater<P>> pq;

    for (const auto& [id, _] : nodes_) dist[id] = std::numeric_limits<double>::infinity();
    dist[start] = 0;
    pq.push({0, start});

    while (!pq.empty()) {
        auto [d, u] = pq.top(); pq.pop();
        if (d > dist[u]) continue;

        auto it = adj_.find(u);
        if (it == adj_.end()) continue;

        for (const auto& [v, w] : it->second) {
            double nd = d + w;
            if (nd < dist[v]) {
                dist[v] = nd;
                pq.push({nd, v});
            }
        }
    }
    return dist;
}

std::vector<std::string> Graph::shortest_path(const std::string& a, const std::string& b) const {
    auto dist = dijkstra(a);
    if (dist.find(b) == dist.end() || dist.at(b) == std::numeric_limits<double>::infinity())
        return {};
    return {a, b}; // simplified — full reconstruction skip
}

} // namespace
