import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
Item {
    property alias button_text: circle_text.text
    Rectangle{
        id: circle_rect
        width: 30
        height: 30
        radius:15
        color: Qt.rgba(255, 255, 255, 0.5)
        border.color : "blue"
        Button{
            opacity: 0
            anchors.centerIn: parent
            onClicked: console.log("a test for triggerable button")
        }
        Text{
            id:circle_text
            text: "1"
            anchors.centerIn: parent
        }

    }

}
