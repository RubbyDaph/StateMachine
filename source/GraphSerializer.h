#pragma once
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QString>
#include "GraphData.h"

class GraphSerializer{
    public:
    GraphSerializer() = default;
    ~GraphSerializer() = default;
    QJsonDocument SerializeGraph(const GraphData& graphData);
    GraphData DeserializeGraph(const QJsonDocument& document);
    QString GraphDeserializeResult(bool success, QString errorMessage);
};
