#pragma once
#include <string>
#include <vector>
#include <unordered_map>
#include <queue>
#include <limits>

namespace roblox_osint {

struct Node {
    std::string id;
    std::string type;  // user, group, game
    std::string name;
};

struct Edge {
    std::string from;
    std::string to;
    double weight = 1.0;
};

class Graph {
public:
    void add_node(const Node& n);
    void add_edge(const Edge& e);

    std::vector<std::string> bfs(const std::string& start) const;
    std::unordered_map<std::string, double> dijkstra(const std::string& start) const;
    std::vector<std::string> shortest_path(const std::string& a, const std::string& b) const;

    size_t node_count() const { return nodes_.size(); }
    size_t edge_count() const { return edges_.size(); }

private:
    std::unordered_map<std::string, Node> nodes_;
    std::vector<Edge> edges_;
    std::unordered_map<std::string, std::vector<std::pair<std::string, double>>> adj_;
};

} // namespace
