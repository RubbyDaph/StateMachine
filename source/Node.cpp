#include "Node.h"
#include <qnamespace.h>

int Node::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent);
    return NodeList.size();
}

int Node::columnCount(const QModelIndex &parent) const
{
    return NodeList.size();
}

QVariant Node::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) return QVariant();

    int row = index.row();
    int col = index.column();

    if(row < 0 || row >= matrix.size()) return QVariant();
    if(col < 0 || col >= matrix[row].size()) return QVariant();

    switch (role)
    {
        case Qt::DisplayRole:
        {
            return matrix[row][col];
        }
        case Qt::TextAlignmentRole:
        {
            return Qt::AlignCenter;
        }
    }

    return QVariant();
}

QVariant Node::headerData(int section, Qt::Orientation orientation, int role) const
{

    if (role != Qt::DisplayRole) return QVariant();

    if (orientation == Qt::Horizontal)
    {
        return QString::number(NodeList[section].id);
    }
    else
    {
        return QString::number(NodeList[section].id);
    }
}

QHash<int, QByteArray> Node::roleNames() const
{
    QHash<int, QByteArray> roles;

roles[idRole] = "id";
roles[Qt::DisplayRole] = "display";
    
    return roles;
}

void Node::AddNode(int x, int y)
{
    beginResetModel();
    NodeList.append(NodeItem(count, x , y));
    
    for(auto& row : matrix)
    {
        row.append(0);
    }
    
    QList<int> newRow;
    for(int i = 0; i < NodeList.size(); ++i)
    {
        newRow.append(0);
    }

    matrix.append(newRow);
    count++;
    endResetModel();
}


bool Node::MakeConnection(int id_from, int id_to, Direction directionType)
{
   if(id_from <= 0 || id_to <= 0) return false;

    int fromIndex = id_from - 1;
    int toIndex = id_to - 1;

    if(fromIndex >= matrix.size() || toIndex >= matrix.size()) return false;
    
    for(auto it = connections.begin(); it != connections.end(); ++it)
    {
        Connection& connection = *it;
        if(directionType == Direction::BOTH_WAYS)
        {
            if((connection.id_from == id_from && connection.id_to == id_to) ||
                (connection.id_from == id_to && connection.id_to == id_from))
            {
                return false;
            }
        }
        else
        {
            if(connection.id_from == id_from && connection.id_to == id_to) return false;
            else if(connection.id_from == id_to && connection.id_to == id_from)
            {
                connections.erase(it);
                directionType = Direction::BOTH_WAYS; 
                break;
            }
        }
    }

    connections.append({id_from, id_to, directionType});

    switch(directionType)
    {
        case Direction::BOTH_WAYS:
        {
            matrix[fromIndex][toIndex] = 1;
            matrix[toIndex][fromIndex] = 1;
            break;
        }
        case Direction::ONE_WAY:
        {
            matrix[fromIndex][toIndex] = 1;
            if(matrix[toIndex][fromIndex] == 1) break;
            matrix[toIndex][fromIndex] = 0;
            break;
        }
    }
    emit dataChanged(index(fromIndex, toIndex), index(fromIndex, toIndex));
    emit dataChanged(index(toIndex, fromIndex), index(toIndex, fromIndex));
    return true;
}

GraphData Node::collectGraphData() const
{
    GraphData data;
    for(auto it = NodeList.begin(); it != NodeList.end(); it++)
    {
        const NodeItem& node = *it;
        if(node.id <= 0) continue;
        data.nodeData.append({node.id, node.x, node.y});
    }
    for(auto it = connections.begin(); it != connections.end(); it++)
    {
        const Connection& connection = *it;
        if(connection.id_from <= 0 || connection.id_to <= 0) continue;
        if(connection.id_from == connection.id_to) continue;
        if(connection.id_from > NodeList.size() || connection.id_to > NodeList.size()) continue;

        data.connectionData.append({connection.id_from, connection.id_to, static_cast<int>(connection.direction)});
    }
    return data;
}

void Node::loadGraphData(const GraphData& graphData)
{
    beginResetModel();

    NodeList.clear();
    connections.clear();
    matrix.clear();
    count = 1;

    for(const NodeData& nodeData : graphData.nodeData)
    {
        if(nodeData.id <= 0) continue;
        if(nodeData.id != count) continue;

        NodeList.append(NodeItem(nodeData.id, nodeData.x, nodeData.y));
        count++;
    }

    for(int row = 0; row < NodeList.size(); ++row)
    {
        QList<int> matrixRow;
        for(int col = 0; col < NodeList.size(); ++col)
        {
            matrixRow.append(0);
        }
        matrix.append(matrixRow);
    }

    for(const ConnectionData& connectionData : graphData.connectionData)
    {
        if(connectionData.id_from <= 0 || connectionData.id_to <= 0) continue;
        if(connectionData.id_from == connectionData.id_to) continue;

        int fromIndex = connectionData.id_from - 1;
        int toIndex = connectionData.id_to - 1;

        if(fromIndex < 0 || fromIndex >= NodeList.size()) continue;
        if(toIndex < 0 || toIndex >= NodeList.size()) continue;

        Direction direction = static_cast<Direction>(connectionData.direction);
        if(direction != Direction::BOTH_WAYS && direction != Direction::ONE_WAY) continue;

        connections.append(Connection(connectionData.id_from, connectionData.id_to, direction));

        switch(direction)
        {
            case Direction::BOTH_WAYS:
            {
                matrix[fromIndex][toIndex] = 1;
                matrix[toIndex][fromIndex] = 1;
                break;
            }
            case Direction::ONE_WAY:
            {
                matrix[fromIndex][toIndex] = 1;
                break;
            }
        }
    }

    endResetModel();
}

void Node::clearGraph()
{
    beginResetModel();

    NodeList.clear();
    connections.clear();
    matrix.clear();
    count = 1;

    endResetModel();
}
