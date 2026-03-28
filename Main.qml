import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window

Window {
    id: root
    minimumWidth: 820
    minimumHeight: 650
    maximumWidth: 820
    maximumHeight: 650
    visible: true
    color: "#6FAD88"
    property color baseColor: "#D9D9D9"

    property var circles: []

    RowLayout{
        id: mainLayout
        anchors.fill: parent
        spacing: 15
        Rectangle {
            id: canvasRect
            color: root.baseColor
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 529
            Layout.topMargin: 15
            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Canvas {
                id: graphCanvas
                anchors.fill: parent
                onPaint:{
                    var ctx = getContext("2d");

                    ctx.clearRect(0, 0, graphCanvas.width, graphCanvas.height)

                    for(var i = 0; i < root.circles.length; i++){
                        ctx.beginPath()
                        ctx.arc(root.circles[i].x, root.circles[i].y, root.circles[i].radius, 0, Math.PI * 2)
                        ctx.fillStyle = root.baseColor
                        ctx.fill()
                        ctx.stroke()
                    }
                }
                function addCircle(x, y , radius){
                    root.circles.push({x: x, y: y, radius: radius});
                    requestPaint()
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: (mouse) =>{
                        graphCanvas.addCircle(mouse.x, mouse.y, 25)
                    }

                }

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
                color: root.baseColor
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: Layout.prefferedWidth * 1
                Layout.minimumWidth: 246
                Layout.minimumHeight: 246
                ListView{
                    id: mainList
                    ListView{
                        id: cellList

                    }
                }
            }
            Rectangle{
                id: graphOptions
                color: root.baseColor
                Layout.fillWidth: true
                Layout.minimumHeight: 163
            }
            Rectangle{
                id: fileOptions
                color: root.baseColor
                Layout.fillWidth: true
                Layout.minimumHeight: 181
            }
        }
    }
}