#include "FileManager.h"

#include <QFile>
#include <QIODevice>
#include <QJsonParseError>

bool FileManager::saveJsonDocument(const QString& filePath, const QJsonDocument& document)
{
    m_lastError.clear();

    if(filePath.isEmpty())
    {
        m_lastError = "File path is empty";
        return false;
    }

    QFile file(filePath);
    if(!file.open(QIODevice::WriteOnly | QIODevice::Truncate))
    {
        m_lastError = file.errorString();
        return false;
    }

    const qint64 bytesWritten = file.write(document.toJson(QJsonDocument::Indented));
    if(bytesWritten == -1)
    {
        m_lastError = file.errorString();
        return false;
    }

    if(!file.flush())
    {
        m_lastError = file.errorString();
        return false;
    }

    return true;
}

bool FileManager::loadJsonDocument(const QString& filePath, QJsonDocument& document)
{
    m_lastError.clear();

    if(filePath.isEmpty())
    {
        m_lastError = "File path is empty";
        return false;
    }

    QFile file(filePath);
    if(!file.open(QIODevice::ReadOnly))
    {
        m_lastError = file.errorString();
        return false;
    }

    const QByteArray fileData = file.readAll();
    if(fileData.isEmpty())
    {
        m_lastError = "File is empty";
        return false;
    }

    QJsonParseError parseError;
    const QJsonDocument parsedDocument = QJsonDocument::fromJson(fileData, &parseError);

    if(parseError.error != QJsonParseError::NoError)
    {
        m_lastError = parseError.errorString();
        return false;
    }

    if(!parsedDocument.isObject())
    {
        m_lastError = "JSON root is not an object";
        return false;
    }

    document = parsedDocument;
    return true;
}

QString FileManager::lastError() const
{
    return m_lastError;
}
