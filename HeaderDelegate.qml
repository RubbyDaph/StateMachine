import QtQuick

Rectangle{
    
    color: "#D9D9D9"
    border.color: "#6FAD88"
    border.width: 1
    
    required property var display
    
    Text{
        text: display
        anchors.centerIn: parent
    }        
}
