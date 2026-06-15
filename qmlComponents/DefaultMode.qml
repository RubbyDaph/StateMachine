import QtQuick
import QtQuick.Layouts 1.15

Item{
    id: root

    signal nodeCreateClicked();
    signal connectionCreateClicked();
    signal editNodeClicked();
    signal freeHandClicked();

    anchors.fill: parent
    ColumnLayout{
        anchors.fill: parent
        spacing: 5
        CustomButton{
            id:createNodeButton
            buttonText:"Create Node"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{
                root.nodeCreateClicked()
            }
        }
        CustomButton{
            id:createConnectionButton
            buttonText:"Create connection"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{
                root.connectionCreateClicked()
            }
        }
        CustomButton{
            id:editNodeButton
            buttonText:"Edit node"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{
               root.editNodeClicked()
            } 
        }
        CustomButton{
            id: defaultMode
            buttonText:"Free hand"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{
               root.freeHandClicked()
            }
        }

    }
}
