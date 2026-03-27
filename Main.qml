import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window

Window {
    minimumWidth: 820
    minimumHeight: 650
    maximumWidth: 820
    maximumHeight: 650
    visible: true
    color: "#6FAD88"
    RowLayout{
        id: mainLayout
        anchors.fill: parent
        spacing: 15
        Rectangle {
            color: "#D9D9D9"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 529
            Layout.topMargin: 15
            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Canvas {
                id: graphCanvas
                anchors.fill: parent

            }
        }
        ColumnLayout{
            id: rightLayout
            Layout.minimumWidth: 246
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 15
            Layout.bottomMargin: 15
            Layout.rightMargin: 15
            spacing: 15
            Rectangle{
                id: matrixWindow
                color: "#D9D9D9"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: Layout.prefferedWidth * 1
                Layout.minimumWidth: 246
                Layout.minimumHeight: 246
            }
            Rectangle{
                id: graphOptions
                color: "#D9D9D9"
                Layout.fillWidth: true
                Layout.minimumHeight: 163
            }
            Rectangle{
                id: fileOptions
                color: "#D9D9D9"
                Layout.fillWidth: true
                Layout.minimumHeight: 181
            }
        }
    }
}