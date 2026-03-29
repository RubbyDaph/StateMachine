import QtQuick
import QtQuick.Controls

Button{
    id: control

    property string buttonText: ""

    background: Rectangle{
        color: control.down ? "#adadad" : "#6FAD88"
        radius: 8
    }
    contentItem: Text{
        text: control.buttonText
        font.pixelSize: 14
        font.bold: true
        color: "#212020"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}