# StateMachine

StateMachine is a desktop application for building simple unweighted graphs for state-machine style modeling.

The program provides an interactive canvas where you can create graph nodes and connect them with one-way or two-way connections. The graph can be saved to a file and loaded back later.

## Features

- Create unweighted graph nodes on a canvas.
- Create one-way and two-way connections between nodes.
- View the graph as an adjacency matrix.
- Save a graph to a JSON file.
- Load a graph from a JSON file.
- Clear the current graph.

## Technology Stack

- C++
- Qt 6
- QML / Qt Quick
- CMake

## Platform

The project was developed and built for Linux.

Other platforms may work if Qt 6 and a compatible C++ toolchain are installed, but they are not the primary target environment for this project.

## Requirements

- Linux
- CMake 3.16 or newer
- Qt 6.8 or newer
- C++ compiler supported by Qt 6

## Build and Run

From the project root:

```bash
cmake -S . -B build
cmake --build build
./build/appStateMachine
```

You can also open the project in Qt Creator or another CMake-compatible IDE, configure a Qt 6 kit, build the `appStateMachine` target, and run it.

## Graph Files

Graphs are saved as JSON files. The repository includes `graph.json` as an example graph file that can be loaded in the application.
