import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window
import StateMachine 1.0

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
    property var connections: []

    UserController{
        id: userController
    }
    
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
                    
                    // circle draw
                    for(var i = 0; i < root.circles.length; i++){
                        var circle = circles[i]
                        ctx.beginPath()
                        ctx.arc(circle.x, circle.y, circle.radius, 0, Math.PI * 2)
                        ctx.fillStyle = root.baseColor
                        ctx.opacity = 0
                        ctx.fill()
                        ctx.stroke()

                        ctx.font = (circle.radius) + "px Arial";
                        ctx.fillStyle = "black"
                        ctx.textAlign = "center"
                        ctx.textBaseline = "middle"
                        ctx.fillText((i+1).toString(), circle.x, circle.y);
                    }
                    // connection draw
                    for(var i = 0; i < root.connections.length; i++)
                    {
                        var connection = connections[i];
                        var circle_from = root.circles[connection.id_from]; 
                        var circle_to = root.circles[connection.id_to]; 
                         
                        var dx = circle_to.x - circle_from.x;
                        var dy = circle_to.y - circle_from.y;

                        var d = Math.sqrt(dx * dx + dy * dy);

                        var nx = dx / d;
                        var ny = dy / d;

                        var start_x = circle_from.x + nx * circle_from.radius;
                        var end_x = circle_to.x - nx * circle_to.radius;

                        var start_y = circle_from.y + ny * circle_from.radius;
                        var end_y = circle_to.y - ny * circle_to.radius;


                        ctx.beginPath();
                        ctx.moveTo(start_x, start_y);
                        ctx.lineTo(end_x, end_y);
                        ctx.stroke();
                    }
                }
                function addCircle(x, y , radius){
                    root.circles.push({x: x, y: y, radius: radius});
                    requestPaint()
                }

                function addConnection(id_from, id_to, connectionType)
                {
                    root.connections.push({id_from: id_from, id_to: id_to, type: connectionType});
                    requestPaint();
                }

                property int id_from: -1;
                property int id_to: -1;
                property int selected: 0;
                MouseArea {
                    anchors.fill: parent
                    onClicked: (mouse) =>{
                        if(graphOptions.nodeCreate === true)
                        {
                            graphCanvas.addCircle(mouse.x, mouse.y, 20)
                            userController.AddNode()
                        }
                        else if(graphOptions.connectionCreate === true)
                        {
                            var clickedId = -1;
                            for(var i = 0; i < root.circles.length; i++)
                            {
                                var circle = root.circles[i];
                                var dx = mouse.x - circle.x;
                                var dy = mouse.y - circle.y
                                var distance = Math.sqrt(dx * dx + dy * dy);
                                
                                if(distance <= circle.radius)
                                {
                                    clickedId = i + 1;
                                    break;
                                }
                            }
                            if(graphCanvas.selected === 0)
                            {
                                graphCanvas.id_from = clickedId;
                                graphCanvas.selected = 1;
                            }
                            else if(graphCanvas.selected === 1)
                            {
                                if(clickedId !== graphCanvas.id_from)
                                {
                                    graphCanvas.id_to = clickedId;
                                    userController.MakeConnection(graphCanvas.id_from, graphCanvas.id_to, 0);
                                    graphCanvas.addConnection(graphCanvas.id_from - 1, graphCanvas.id_to - 1, 0);
                                    graphCanvas.selected = 0;
                                    graphCanvas.id_from = -1;
                                    graphCanvas.id_to = -1;
                                }
                            }
                        }
                        else if(graphOptions.nodeEdit == true)
                        {

                        }
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
                Layout.preferredHeight: Layout.preferredWidthChanged * 1
                Layout.minimumWidth: 246
                Layout.minimumHeight: 246
                
                Rectangle{
                    anchors.left: parent.left
                    anchors.right: matrixTable.left
                    anchors.top: parent.top
                    anchors.bottom: matrixTable.top
                    border.width: 1
                    border.color: "#6FAD88"
                    color: "#D9D9D9"
                }
                

                HorizontalHeaderView{
                    id: horizontalHeader
                    height: verticalHeader.width
                    movableColumns: false
                    anchors.top: parent.top
                    anchors.left: matrixTable.left
                    clip: true

                    delegate: HeaderDelegate{
                    } 
                    syncView: matrixTable
                }

                VerticalHeaderView{
                    id: verticalHeader
                    movableRows: false
                    anchors.top: matrixTable.top
                    anchors.left: parent.left
                    clip: true

                    delegate: HeaderDelegate{
                    }
                    syncView: matrixTable
                }

                TableView{
                    id: matrixTable
                    anchors.top: horizontalHeader.bottom
                    anchors.left: verticalHeader.right
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    clip: true 
                    
                    model: userController.node

                    delegate: Rectangle{

                        implicitWidth: matrixTable.columns > 0 ? matrixTable.width / matrixTable.columns : 32
                        implicitHeight: matrixTable.rows > 0 ? matrixTable.height / matrixTable.rows : 32 
                        border.width: 1
                        border.color: "#6FAD88"
                        color: "#eeeeee"

                        Text{
                            anchors.centerIn: parent
                            text: display
                            color: "black"
                        }
                    }

                }
            }
            Rectangle{
                id: graphOptions
                color: root.baseColor
                Layout.fillWidth: true
                Layout.minimumHeight: 163
                property bool nodeCreate: true;
                property bool connectionCreate: false
                property bool nodeEdit: false
                ColumnLayout{
                    anchors.fill: parent
                    spacing: 5
                    CustomButton{
                        id: createNodeButton
                        buttonText:"Create Node"
                        Layout.fillWidth: true
                        Layout.rightMargin: 50
                        Layout.leftMargin: 50
                        onClicked: {
                            console.log("Create button pressed")
                            graphOptions.nodeCreate = true
                            graphOptions.connectionCreate = false 
                            graphOptions.nodeEdit = false 
                        }
                    }
                    CustomButton{
                        id: createConnectionButton
                        buttonText: "Create Connection"
                        Layout.fillWidth: true
                        Layout.rightMargin: 50
                        Layout.leftMargin: 50
                        onClicked: {
                            console.log("Connection create button pressed")
                            graphOptions.nodeCreate = false
                            graphOptions.connectionCreate = true 
                            graphOptions.nodeEdit = false 
                        }
                    }
                    CustomButton{
                        id: editNodeButton
                        buttonText: "Edit Node"
                        Layout.fillWidth: true
                        Layout.rightMargin: 50
                        Layout.leftMargin: 50
                        onClicked: {
                            graphOptions.nodeCreate = false
                            graphOptions.connectionCreate = false 
                            graphOptions.nodeEdit = true
                        }
                    }
                }
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
