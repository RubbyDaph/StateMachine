import QtQuick
import QtQuick.Layouts 1.15

Item{
    id: root
    
    signal oneWayClicked();
    signal twoWayClicked();
    signal exitConnectionCreate()

    anchors.fill: parent
    ColumnLayout{
        anchors.fill: parent
        spacing: 5
        CustomButton{
            id: oneWayMode
            buttonText:"One way connection"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{
                root.oneWayClicked()
            }
        }
        CustomButton{
            id: bothWaysMode
            buttonText: "Two way connection"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{
                root.twoWayClicked()
            }
        }
        CustomButton{
            id: exitConnectCreation
            buttonText: "<<< Cancel"
            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            onClicked:{
                root.exitConnectionCreate()
            }
        }
    }
}
