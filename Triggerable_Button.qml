import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
Item {
    id : trigger_root
    property alias button_text: circle_text.text
    property int index_of_point: 0 // 表示无效id

    Rectangle{
        id: circle_rect
        width: 30
        height: 30
        radius:15
        color: Qt.rgba(255, 255, 255, 0.5)
        border.color : "blue"
        property int count: 0
        //Drag.
        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0

        MouseArea {
            id: dragArea
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

                console.log("确认" + (++circle_rect.count))
                // if(circle_rect.count % 2 == 0){
                //     circle_rect.x = 10, circle_rect.y = 10
                // }
                /*如何让按钮确认后不再移动*/


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
