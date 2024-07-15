import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
    width: 30
    height: 30
    id : trigger_root
    property alias button_text: circle_text.text
    property int index_of_point: circle_text.text

    property int point_x: 0 // 每个按钮的 X 坐标
    property int point_y: 0 // 每个按钮的 Y 坐标

    function confirm_new_point(index,point_name,centerX,centerY){
        //confirm_add_point.visible=true;
        second_window_form.point_is_onrelease=true
        database.expand_point(index,point_name,centerX,centerY,"")
        console.log(index)

    }




    Rectangle{
        id: circle_rect
        width: 30
        height: 30
        radius:15
        color: Qt.rgba(255, 255, 255, 0.5)
        border.color : "blue"
        x:point_x
        y:point_y
        property real centerX: circle_rect.width / 2
        property real centerY: circle_rect.height / 2

            // 将 centerX 和 centerY 转换为全局坐标
        property real globalCenterX: mapToGlobal(Qt.point(centerX, centerY)).x + 15
        property real globalCenterY: mapToGlobal(Qt.point(centerX, centerY)).y + 15
        property int count: 0
        property bool draggable: true

        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0
        //property bool is_new:index_of_point>database.get_max_valid_point_key_from_points();


        MouseArea {
            id: dragArea
            anchors.fill: parent
            enabled: circle_rect.draggable | second_window_form.delete_button_pressed
            drag.target: parent
            onClicked: {
                //console.log(rec.x + " " + rec.y + " " + rec.Drag.hotSpot.x + " " + rec.Drag.hotSpot.y)
                console.log("a test for triggerable button" + index_of_point)
                console.log("最大点为"+root.max_point_key)
                /*c++端的删除操作 to be added*/
                if(second_window_form.delete_button_pressed){
                    trigger_root.visible = false
                    second_window_form.delete_button_pressed = ! second_window_form.delete_button_pressed
                    second_window_form.delete_button_success = true
                    delete_finish_instruction.open()
                    database.del_point(index_of_point)
                    database.del_road(index_of_point)


                }

                chosen_to_be_deleted_index = index_of_point
                if(chosen_to_be_deleted_index >= 0){

                    console.log("chosen_to_be_deleted_index = " + chosen_to_be_deleted_index)
                }else{
                    console.log("not set successfully")
                }


            }
            onReleased: {

                console.log("确认" + (++circle_rect.count))
                console.log("最大点为"+root.max_point_key)

                if(second_window_form.add_button_success)
                {
                    var centerX=circle_rect.x+15
                    var centerY=circle_rect.y+15
                    var point_name=""
                    if(index_of_point>database.get_max_valid_point_key_from_points())
                    {
                        //confirm_new_point(index_of_point,point_name,circle_rect.globalCenterX,circle_rect.globalCenterY)
                        confirm_new_point(index_of_point,point_name, centerX, centerY)
                        console.log("添加的点坐标为"+centerX+","+centerY)
                        console.log(index_of_point)
                       // second_window_form.point_is_onrelease=true

                    }
                    else
                    {        console.log("更新原有的点，新点坐标为"+centerX+","+centerY)
                        database.update_point_add(index_of_point,centerX,centerY)
                    }
                }



                circle_rect.draggable = false




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
}
