#include "../include/graph.hpp"
#include <unordered_set>

namespace roblox_osint {

std::vector<std::string> Graph::bfs(const std::string& start) const {
    std::vector<std::string> order;
    std::unordered_set<std::string> visited;
    std::queue<std::string> q;

    auto it = adj_.find(start);
    if (it == adj_.end()) return order;

    q.push(start);
    visited.insert(start);

    while (!q.empty()) {
        std::string cur = q.front(); q.pop();
        order.push_back(cur);

        auto ait = adj_.find(cur);
        if (ait == adj_.end()) continue;

        for (const auto& [next, _] : ait->second) {
            if (!visited.count(next)) {
                visited.insert(next);
                q.push(next);
            }
        }
    }
    return order;
}

} // namespace
