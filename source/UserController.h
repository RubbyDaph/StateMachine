#pragma once
#include <QObject>
#include <QUrl>
#include <QVariantList>
#include "Node.h"
#include "FileManager.h"
#include "GraphSerializer.h"

class UserController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Node* node READ GetNode CONSTANT)
public:
    explicit UserController(QObject *parent = nullptr);
    ~UserController();
    Q_INVOKABLE Node* GetNode() const {return node;}
    Q_INVOKABLE void AddNode(int x, int y);
    Q_INVOKABLE bool MakeConnection(int id_from, int id_to, Direction directionType);
    Q_INVOKABLE bool SaveGraph(const QUrl& fileUrl);
    Q_INVOKABLE bool LoadGraph(const QUrl& fileUrl);
    Q_INVOKABLE void ClearGraph();
    Q_INVOKABLE QVariantList GraphNodes() const;
    Q_INVOKABLE QVariantList GraphConnections() const;
    Q_INVOKABLE QString LastError() const;
private:
    Node* node;
    FileManager fileManager;
    GraphSerializer graphSerializer;
};
