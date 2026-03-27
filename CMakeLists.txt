cmake_minimum_required(VERSION 3.16)

project(StateMachine VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml Gui)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appStateMachine
    main.cpp
)

qt_add_qml_module(appStateMachine
    URI StateMachine
    VERSION 1.0
    QML_FILES
        Main.qml
)

target_link_libraries(appStateMachine PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appStateMachine
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
