#pragma once
#include <QObject>
#include <QString>
#include <QList>
#include <QAbstractListModel>

class Node : public QAbstractListModel
{
    Q_OBJECT
    int count = 0;
    struct NodeItem
    {
        int value;
        int id;

        NodeItem(const int &value):
            value(value),
            id(++count)
        {};
    };
    QList<NodeItem> nodeList;

public:
    explicit Node(QObject* parent = nullptr) : QAbstractListModel(parent) {}

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    enum roles
    {
        valueRole = Qt::UserRole + 1,
        idRole
    };
public slots:
    void AddNode(const int &value);
};