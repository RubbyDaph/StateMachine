#pragma once

#include <QJsonDocument>
#include <QString>

class FileManager{
public:
    FileManager() = default;
    ~FileManager() = default;

    bool saveJsonDocument(const QString& filePath, const QJsonDocument& document);
    bool loadJsonDocument(const QString& filePath, QJsonDocument& document);

    QString lastError() const;

private:
    QString m_lastError;

};
