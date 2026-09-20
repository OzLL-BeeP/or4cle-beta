cmake_minimum_required(VERSION 3.15)
project(roblox_osint_graph CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_TYPE Release)

set(CMAKE_CXX_FLAGS_RELEASE "-O2 -s -DNDEBUG -ffunction-sections -fdata-sections")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-Wl,--gc-sections -s")

add_executable(graph
    src/main.cpp
    src/bfs.cpp
    src/dijkstra.cpp
)

target_include_directories(graph PRIVATE include)
