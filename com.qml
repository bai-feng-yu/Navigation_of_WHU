import QtQuick
import QtQuick.Controls

Rectangle{
    property int aa:200
    property int bb:90
    property int cc:10
    property int dd:10
    id:tceee
    x:cc
    y:dd
    width: 15; height: 15
    color: "blue"
    opacity: 1.0
    PropertyAnimation on x{//立刻生效
        to: aa
        duration: 1000
    }
    PropertyAnimation on y{
        to: bb
        duration: 1000
    }
}
