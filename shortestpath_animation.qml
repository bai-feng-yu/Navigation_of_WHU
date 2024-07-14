import QtQuick
import QtQuick.Controls

Item {
    property int endx
    property int endy
    property int startx
    property int starty
    property color tc
    Rectangle{
        id:tceee
        x:startx
        y:starty
        width: 15; height: 15
        color: tc
        opacity: 1.0
        ParallelAnimation {
            id: playbanner
            running: false
            loops:Animation.Infinite
            NumberAnimation {
                id: animateOpacity
                target: tceee
                properties: "x"
                to: endx
                duration: 1000
           }
            NumberAnimation {
                id: animateOpacity2
                target: tceee
                properties: "y"
                to: endy
                duration: 1000
           }
        }
        Component.onCompleted: {
            playbanner.start()
        }
    }
}
