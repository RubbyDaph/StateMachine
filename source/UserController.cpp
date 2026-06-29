#include "UserController.h"

#include <QVariantMap>


UserController::~UserController()
{

}

UserController::UserController(QObject* parent)
    : QObject(parent),
      node(new Node(this))
{ 
}

void UserController::AddNode(int x, int y)
{
    node->AddNode(x, y);
}

bool UserController::MakeConnection(int id_from, int id_to, Direction directionType) 
{
   return node->MakeConnection(id_from, id_to, directionType);
}

bool UserController::SaveGraph(const QUrl& fileUrl)
{
    const QString filePath = fileUrl.toLocalFile();
    const GraphData graphData = node->collectGraphData();
    const QJsonDocument document = graphSerializer.SerializeGraph(graphData);

    return fileManager.saveJsonDocument(filePath, document);
}

bool UserController::LoadGraph(const QUrl& fileUrl)
{
    const QString filePath = fileUrl.toLocalFile();
    QJsonDocument document;
    if(!fileManager.loadJsonDocument(filePath, document))
    {
        return false;
    }

    const GraphData graphData = graphSerializer.DeserializeGraph(document);
    node->loadGraphData(graphData);

    return true;
}

void UserController::ClearGraph()
{
    node->clearGraph();
}

QVariantList UserController::GraphNodes() const
{
    QVariantList nodes;
    const GraphData graphData = node->collectGraphData();

    for(const NodeData& nodeData : graphData.nodeData)
    {
        QVariantMap nodeMap;
        nodeMap["id"] = nodeData.id;
        nodeMap["x"] = nodeData.x;
        nodeMap["y"] = nodeData.y;

        nodes.append(nodeMap);
    }

    return nodes;
}

QVariantList UserController::GraphConnections() const
{
    QVariantList connections;
    const GraphData graphData = node->collectGraphData();

    for(const ConnectionData& connectionData : graphData.connectionData)
    {
        QVariantMap connectionMap;
        connectionMap["id_from"] = connectionData.id_from;
        connectionMap["id_to"] = connectionData.id_to;
        connectionMap["direction"] = connectionData.direction;

        connections.append(connectionMap);
    }

    return connections;
}

QString UserController::LastError() const
{
    return fileManager.lastError();
}
