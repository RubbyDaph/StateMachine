#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include<QDir>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("StateMachine", "Main");

    return app.exec();
}
