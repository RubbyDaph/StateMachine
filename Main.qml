import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Window
import StateMachine 1.0

Window {
    id: root
    minimumWidth: 820
    minimumHeight: 650
    visible: true
    color: "#6FAD88"
    property color baseColor: "#D9D9D9"

    property var circles: []
    property var connections: []

    UserController{
        id: userController
    }

    FileDialog {
        id: saveGraphDialog
        title: "Save graph"
        fileMode: FileDialog.SaveFile
        defaultSuffix: "json"
        nameFilters: ["JSON files (*.json)", "All files (*)"]

        onAccepted: {
            if(!userController.SaveGraph(selectedFile))
            {
                console.log(userController.LastError())
            }
        }
    }

    FileDialog {
        id: loadGraphDialog
        title: "Load graph"
        fileMode: FileDialog.OpenFile
        nameFilters: ["JSON files (*.json)", "All files (*)"]

        onAccepted: {
            if(!userController.LoadGraph(selectedFile))
            {
                console.log(userController.LastError())
                return
            }
            root.syncCanvasFromController()
        }
    }

    function clearCanvasGraph()
    {
        root.circles = []
        root.connections = []
        graphCanvas.selected = 0
        graphCanvas.id_from = -1
        graphCanvas.id_to = -1
        graphCanvas.requestPaint()
    }

    function syncCanvasFromController()
    {
        root.clearCanvasGraph()

        var nodes = userController.GraphNodes()
        for(var i = 0; i < nodes.length; i++)
        {
            var node = nodes[i]
            root.circles.push({x: node.x, y: node.y, radius: 20})
        }

        var connections = userController.GraphConnections()
        for(var j = 0; j < connections.length; j++)
        {
            var connection = connections[j]
            root.connections.push({
                id_from: connection.id_from - 1,
                id_to: connection.id_to - 1,
                type: connection.direction
            })
        }

        graphCanvas.requestPaint()
    }

    // types for creation of nodes and connections and editing nodes
    // used in button graphOptions section
    // and in MouseArea inside canvasRect
    enum ModeType{
        None,
        NodeCreate,
        ConnectionCreate
    }

    property int modeType: Main.ModeType.None
    
    // types for connection
    // used in graphOptions
    // and in draw section for connections and also in function for adding connection
    enum ConnectionOptions{
        TwoWay,
        OneWay
    }

    property int connectionOption: Main.ConnectionOptions.TwoWay
    
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
                        
                        if(d === 0)
                        {
                            continue;
                        }
                        
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
                        
                        // arrow draw section
                        // if connectionType is one way we are gonna draw an arrow
                        if(connection.type == Main.ConnectionOptions.OneWay)
                        {
                            var arrowLength = 12
                            var arrowHalfWidth = 6
                            var perpendicularX = -ny;
                            var perpendicularY = nx;

                            var baseX = end_x - nx * arrowLength
                            var baseY = end_y - ny * arrowLength

                            var leftX = baseX + perpendicularX * arrowHalfWidth
                            var leftY = baseY + perpendicularY * arrowHalfWidth

                            var rightX = baseX - perpendicularX * arrowHalfWidth 
                            var rightY = baseY - perpendicularY * arrowHalfWidth

                            ctx.beginPath();
                            ctx.moveTo(end_x, end_y);
                            ctx.lineTo(leftX, leftY);
                            ctx.lineTo(rightX, rightY);
                            ctx.closePath();
                            ctx.fillStyle = "black"
                            ctx.fill();
                        }
                    }
                }
                function addCircle(x, y , radius){
                    root.circles.push({x: x, y: y, radius: radius});
                    requestPaint()
                }

                function addConnection(id_from, id_to, connectionType)
                {
                    for(var i = 0; i < root.connections.length; i++)
                    {
                        var reverseDirection = root.connections[i].id_from === id_to && root.connections[i].id_to === id_from
                        var sameDirection = root.connections[i].id_from === id_from && root.connections[i].id_to === id_to
                        if(connectionType === Main.ConnectionOptions.OneWay)
                        {
                            if(sameDirection)
                            {
                                requestPaint();
                                return
                            }
                            else if(reverseDirection)
                            {
                                root.connections.splice(i, 1)
                                connectionType = Main.ConnectionOptions.TwoWay
                                break
                            }
                        }
                        else
                        {
                            if(reverseDirection || sameDirection)
                            {
                                requestPaint();
                                return
                            }
                        }
                    }
                    root.connections.push({id_from: id_from, id_to: id_to, type: connectionType});
                    requestPaint();
                }

                property int id_from: -1;
                property int id_to: -1;
                property int selected: 0;
                MouseArea {
                    anchors.fill: parent
                    onClicked: (mouse) =>{
                        if(root.modeType === Main.ModeType.NodeCreate)
                        {
                            graphCanvas.addCircle(mouse.x, mouse.y, 20)
                            userController.AddNode(mouse.x, mouse.y)
                        }
                        else if(root.modeType === Main.ModeType.ConnectionCreate)
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
                            if(clickedId === -1)
                            {
                                graphCanvas.selected = 0;
                                graphCanvas.id_from = -1;
                                graphCanvas.id_to = -1;
                                return;
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
                                    if(userController.MakeConnection(graphCanvas.id_from, graphCanvas.id_to, root.connectionOption))
                                    {
                                        graphCanvas.addConnection(graphCanvas.id_from - 1, graphCanvas.id_to - 1, root.connectionOption);
                                    }
                                    graphCanvas.selected = 0;
                                    graphCanvas.id_from = -1;
                                    graphCanvas.id_to = -1;
                                }
                            }
                        }
                        else if(root.modeType === Main.ModeType.None)
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

                Loader{
                    id: graphOptionsLoader
                    anchors.fill: parent

                    sourceComponent:{
                        if(root.modeType === Main.ModeType.ConnectionCreate)
                        {
                            return connectionCreateModeComponent
                        }
                        return defaultModeComponent
                    }
                } 
            }
            Rectangle{
                id: fileOptions
                color: root.baseColor
                Layout.fillWidth: true
                Layout.minimumHeight: 181
                ColumnLayout{
                    anchors.fill: parent
                    spacing: 5
                    id: fileOptionsLayout
                    CustomButton{
                        id: saveGraphButton
                        buttonText:"Save graph"
                        Layout.fillWidth: true
                        Layout.rightMargin: 50
                        Layout.leftMargin: 50
                        onClicked:{
                            saveGraphDialog.open()
                        }
                        }
                    CustomButton{
                        id: loadGraphButton
                        buttonText:"Load graph"
                        Layout.fillWidth: true
                        Layout.rightMargin: 50
                        Layout.leftMargin: 50
                        onClicked:{
                            loadGraphDialog.open()
                        }
                    }
                    CustomButton{
                        id: clearGraphButton
                        buttonText:"Clear graph"
                        Layout.fillWidth: true
                        Layout.rightMargin: 50
                        Layout.leftMargin: 50
                        onClicked:{
                            userController.ClearGraph()
                            root.clearCanvasGraph()
                        }
                    }
                    
                }
            }
        }
    }
    Component{
        id: defaultModeComponent
        DefaultMode {
            onNodeCreateClicked: {
                root.modeType = Main.ModeType.NodeCreate
            }

            onConnectionCreateClicked: {
                root.modeType = Main.ModeType.ConnectionCreate
            }
            onFreeHandClicked: {
                root.modeType = Main.ModeType.None
            }
        }
    }
    Component {
      id: connectionCreateModeComponent

      ConnectionCreateMode {
          onExitConnectionCreate: {
              root.modeType = Main.ModeType.None
          }

          onOneWayClicked: {
              root.connectionOption = Main.ConnectionOptions.OneWay 
          }

          onTwoWayClicked: {
              root.connectionOption = Main.ConnectionOptions.TwoWay
          }
      }
  }
}
