import QtQuick
import QtQuick.Controls
Rectangle {
        id: flashingblob
        x:0
        y:0
        z:-1
        width: 640
        height:400
        opacity:1;
        color:"white"
        property real clickNum
        property real startX
        property real startY
        property real stopX
        property real stopY
        Canvas{
            id : canvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")

                ctx.lineWidth = 5
                ctx.strokeStyle = 'rgba(255, 0, 0, 1)';//轮廓颜色
                ctx.beginPath()
                ctx.clearRect(0,0,canvas.width,canvas.height)
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo(startX,startY)
                ctx.lineTo(stopX,stopY)
                ctx.stroke()
            }
            MouseArea{
                id:area;
                anchors.fill: parent;
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                hoverEnabled: true
                onClicked:   {
                    if(mouse.button === Qt.LeftButton)
                    {
                        if(clickNum === 0)
                        {
                            startX = mouseX
                            startY = mouseY
                            clickNum++;
                        }
                        else{
                            stopX = mouseX
                            stopY = mouseY
                            clickNum = 0
                            canvas.requestPaint()
                        }
                    }
                }
            }
        }

    }
