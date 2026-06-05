#include "UserController.h"


UserController::~UserController()
{

}

UserController::UserController(QObject* parent)
    : QObject(parent),
      node(new Node(this))
{ 
}

void UserController::AddNode()
{
    node->AddNode();
}
