#pragma once
#include <QList>


struct NodeData{
    int id;
    int x;
    int y;
};

struct ConnectionData{
    int id_from;
    int id_to;
    int direction;
};

struct GraphData{
    QList<NodeData> nodeData;
    QList<ConnectionData> connectionData;
};
