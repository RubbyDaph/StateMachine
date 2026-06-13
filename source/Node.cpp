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

void Node::AddNode()
{
    beginResetModel();
    NodeList.append(NodeItem(count));
    
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


void Node::MakeConnection(int id_from, int id_to, Direction directionType)
{
    
}
