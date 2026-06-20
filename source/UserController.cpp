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

bool UserController::MakeConnection(int id_from, int id_to, Direction directionType) 
{
   return node->MakeConnection(id_from, id_to, directionType);
}
