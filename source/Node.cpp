#include "Node.h"

int Node::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return nodeList.count();
}

QVariant Node::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= nodeList.size())
        return QVariant();
    const NodeItem& node = nodeList.at(index.row());

    switch (role)
    {
        case valueRole:
            return node.value;
            break;
        case idRole:
            return node.id;
            break;
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> Node::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[valueRole] = "value";
    roles[idRole] = "id";
    return roles;
}

void Node::AddNode(const int &value)
{
    beginInsertRows(QModelIndex(), nodeList.size(), nodeList.size());
    nodeList.append(NodeItem(value));
    endInsertRows();
}
