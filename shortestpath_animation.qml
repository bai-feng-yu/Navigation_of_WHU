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
        x:startx-7.5
        y:starty-7.5
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
                to: endx-7.5
                duration: 1000
           }
            NumberAnimation {
                id: animateOpacity2
                target: tceee
                properties: "y"
                to: endy-7.5
                duration: 1000
           }
        }
        Component.onCompleted: {
            playbanner.start()
        }
    }
}
