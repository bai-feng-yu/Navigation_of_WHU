import QtQuick
import QtQuick.Controls
Item {
    property int sx
    property int sy
    property int ex
    property int ey
    property color tc
    Rectangle{
        id:rect1
        x:sx
        y:sy-5
        height:10
        width:0
        color:tc
        transformOrigin: "Left"
        rotation: Math.atan((ey-sy)/(ex-sx))/(Math.PI/180)
        NumberAnimation {
            id: animatewidth1
            target: rect1
            properties: "width"
            to: Math.sqrt((ey-sy)*(ey-sy)+(ex-sx)*(ex-sx))
            duration: 1000
        }
        SequentialAnimation{
            id:banner
            loops: Animation.Infinite
            NumberAnimation {
                id: animateopacity1
                target: rect1
                properties: "opacity"
                to: 0.5
                duration: 1000
            }
            NumberAnimation {
                id: animateopacity2
                target: rect1
                properties: "opacity"
                to: 1
                duration: 1000
            }
        }
        Component.onCompleted: {
            if(ex<sx){
                rect1.rotation=180+Math.atan((ey-sy)/(ex-sx))/(Math.PI/180)
            }
            animatewidth1.start()
            banner.start()
        }
    }
}

