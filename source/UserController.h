#pragma once
#include <QObject>
#include "Node.h"

class UserController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Node* node READ GetNode() CONSTANT)

public:
    Q_INVOKABLE Node* GetNode();
    explicit UserController(QObject *parent = nullptr);

private:
    Node* node;
};