import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
    id : trigger_root
    property alias button_text: circle_text.text
    property int index_of_point: circle_text.text // 表示无效id
    property int point_x: 0 // 每个按钮的 X 坐标
    property int point_y: 0 // 每个按钮的 Y 坐标

    Rectangle{
        id: circle_rect
        width: 30
        height: 30
        radius:15
        color: Qt.rgba(255, 255, 255, 0.5)
        border.color : "blue"
        property int count: 0
        //Drag.


        property bool draggable: true
        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0
        x:point_x
        y:point_y

        MouseArea {
            id: dragArea
            enabled: circle_rect.draggable
            anchors.fill: parent

            drag.target: parent
            onClicked: {
                //console.log(rec.x + " " + rec.y + " " + rec.Drag.hotSpot.x + " " + rec.Drag.hotSpot.y)

                console.log("a test for triggerable button" + index_of_point)
                /*c++端的删除操作 to be added*/
                if(second_window_form.delete_button_pressed){
                    trigger_root.visible = false
                    second_window_form.delete_button_pressed = ! second_window_form.delete_button_pressed
                    second_window_form.delete_button_success = true
                    delete_finish_instruction.open()
                }
            }
            onReleased: {

                console.log("确认" + index_of_point)
                // if(circle_rect.count % 2 == 0){
                //     circle_rect.x = 10, circle_rect.y = 10
                // }
                /*如何让按钮确认后不再移动*/
                circle_rect.draggable = false

            }
            // onDoubleClicked: {
            //     circle_rect.x = mouseX
            //     circle_rect.y = mouseY
            // }
        }
        Text{
            id:circle_text
            text: circle_text.text = ++root.max_point_key
            anchors.centerIn: parent
        }




    }

}
