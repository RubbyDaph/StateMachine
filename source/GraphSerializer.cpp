#include "GraphSerializer.h"

QJsonDocument GraphSerializer::SerializeGraph(const GraphData& graphData)
{
   QJsonObject rootObject;

    rootObject["version"] = 1;

    QJsonArray nodesArray;
    for(const NodeData& node : graphData.nodeData)
    {
        QJsonObject nodeObject;
        nodeObject["id"] = node.id;
        nodeObject["x"] = node.x;
        nodeObject["y"] = node.y;

        nodesArray.append(nodeObject);
    }

    QJsonArray connectionsArray;
    for(const ConnectionData& connection : graphData.connectionData)
    {
        QJsonObject connectionObject;
        connectionObject["id_from"] = connection.id_from;
        connectionObject["id_to"] = connection.id_to;
        connectionObject["direction"] = connection.direction;

        connectionsArray.append(connectionObject);
    }

    rootObject["nodes"] = nodesArray;
    rootObject["connections"] = connectionsArray;

    return QJsonDocument(rootObject);
}

GraphData GraphSerializer::DeserializeGraph(const QJsonDocument& document)
{
    GraphData graphData;

    if(!document.isObject()) return graphData;

    QJsonObject rootObject = document.object();

    QJsonValue nodesValue = rootObject.value("nodes");
    if(nodesValue.isArray())
    {
        QJsonArray nodesArray = nodesValue.toArray();

        for(const QJsonValue& nodeValue : nodesArray)
        {
            if(!nodeValue.isObject())
            {
                continue;
            }

            QJsonObject nodeObject = nodeValue.toObject();
            
            NodeData nodeData;
            nodeData.id = nodeObject.value("id").toInt();
            nodeData.x = nodeObject.value("x").toInt();
            nodeData.y = nodeObject.value("y").toInt();

            graphData.nodeData.append(nodeData);
        }
    }

    QJsonValue connectionsValue = rootObject.value("connections");
    if(connectionsValue.isArray())
    {
        QJsonArray connectionArray = connectionsValue.toArray();
        for(const QJsonValue& connectionValue : connectionArray)
        {
            if(!connectionValue.isObject()) continue;

            QJsonObject connectionObject = connectionValue.toObject();

            ConnectionData connectionData;
            connectionData.id_from = connectionObject.value("id_from").toInt();
            connectionData.id_to = connectionObject.value("id_to").toInt();
            connectionData.direction = connectionObject.value("direction").toInt();

            graphData.connectionData.append(connectionData);
        }
    }

    return graphData;
}
