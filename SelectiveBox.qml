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
        model: ListModel{}
        onActivated: {
            console.log(qsTr("looking_up..." + currentIndex)); 
        }
    }

}
