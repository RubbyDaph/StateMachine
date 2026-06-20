#pragma once
#include <QObject>
#include "Node.h"

class UserController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Node* node READ GetNode CONSTANT)
public:
    explicit UserController(QObject *parent = nullptr);
    ~UserController();
    Q_INVOKABLE Node* GetNode() const {return node;}
    Q_INVOKABLE void AddNode();
    Q_INVOKABLE bool MakeConnection(int id_from, int id_to, Direction directionType);
private:
    Node* node;
};
