import QtQuick 2.12
import QtQuick.Controls
import QtQuick.Controls.Windows
Item {
    property alias selective_model: optional_points.model
    visible: false
    x : 0
    y : 0

    width: implicitWidth
    height:implicitHeight


    //anchors.horizontalCenter: parent
    ComboBox{
        enabled: parent.enabled
        visible: parent.visible
        id : optional_points
        width:150
        spacing: 5
        height:30
        editable:true
        currentIndex : -1
        model: ListModel{

            ListElement{ text : qsTr("武汉大学图书馆")}
            ListElement{ text : qsTr("信息学部操场")}
            ListElement{ text : qsTr("武汉大学桂园食堂")}
        }
        onActivated: {
            console.log(qsTr("looking_up..." + currentIndex)); 
        }
    }

}
