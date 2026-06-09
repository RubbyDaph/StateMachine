#pragma once

#include <QObject>
#include <QAbstractTableModel>
#include <vector>

using std::vector;

enum class Direction{
    BOTH_WAYS = 0,
    TO_NODE,
    FROM_NODE
};

struct Connection{
    int id;
    Direction direction;
};



class Node : public QAbstractTableModel
{
    Q_OBJECT

    struct NodeItem
    {
        int id;
        vector<Connection> connections;

        NodeItem(int count) : id(count) {};
    };
    QList<NodeItem> NodeList;
    QList<QList<int>> matrix;
public:
    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void AddNode();
    Q_INVOKABLE void MakeConnection(int id_from, int id_to, Direction directionType);

    explicit Node(QObject* parent = nullptr) : QAbstractTableModel(parent) {}

private:
    enum Roles
    {
        idRole = Qt::UserRole + 1
    };
    int count = 1;
};
