import QtQuick
import QtQuick.Layouts 1.15

Item{
    id: root
    anchors.fill: parent


    signal exitEditNode();

    ColumnLayout{
        anchors.fill: parent
        spacing: 5
        CustomButton{
            id: deleteButton
            buttonText: "Delete node"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{

            }
        }
        CustomButton{
            id: exit
            buttonText:"Cancel"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{
                root.exitEditNode()
            }
        }
    }
}
