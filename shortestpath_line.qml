import QtQuick
import QtQuick.Controls
Item {
    property int sx
    property int sy
    property int ex
    property int ey
    Rectangle{
        id:rect1
        x:sx
        y:sy
        height:10
        width:0
        color: "black"
        transformOrigin: "TopLeft"
        rotation: Math.atan((ey-sy)/(ex-sx))/(Math.PI/180)
        NumberAnimation {
            id: animatewidth1
            target: rect1
            properties: "width"
            to: Math.sqrt((ey-sy)*(ey-sy)+(ex-sx)*(ex-sx))
            duration: 1000
       }
        Component.onCompleted: {
            if(ex<sx){
                rect1.rotation=180+Math.atan((ey-sy)/(ex-sx))/(Math.PI/180)
            }
            animatewidth1.start()
        }
    }
}

