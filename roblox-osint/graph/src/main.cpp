#include "../include/graph.hpp"
#include <iostream>
#include <sstream>
#include <string>

using namespace roblox_osint;

void Graph::add_node(const Node& n) {
    nodes_[n.id] = n;
    adj_[n.id];  // ensure entry
}

void Graph::add_edge(const Edge& e) {
    edges_.push_back(e);
    adj_[e.from].push_back({e.to, e.weight});
    adj_[e.to].push_back({e.from, e.weight});
}

int main(int argc, char** argv) {
    std::string start;
    std::string input;
    std::string line;

    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];
        if (arg == "--start" && i + 1 < argc) start = argv[++i];
        else if (arg == "--input" && i + 1 < argc) input = argv[++i];
    }

    // Read graph from stdin
    Graph g;
    while (std::getline(std::cin, line)) {
        std::istringstream iss(line);
        std::string from, to;
        double w = 1.0;
        if (iss >> from >> to) {
            iss >> w;
            g.add_node({from, "node", from});
            g.add_node({to, "node", to});
            g.add_edge({from, to, w});
        }
    }

    std::cout << "{\n";
    std::cout << "  \"nodes\": " << g.node_count() << ",\n";
    std::cout << "  \"edges\": " << g.edge_count() << ",\n";

    if (!start.empty()) {
        auto bfs_order = g.bfs(start);
        std::cout << "  \"bfs_from\": \"" << start << "\",\n";
        std::cout << "  \"bfs_count\": " << bfs_order.size() << ",\n";
    }

    std::cout << "  \"status\": \"ok\"\n";
    std::cout << "}\n";
    return 0;
}
