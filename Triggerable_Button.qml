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
    // 设置较高的z值
    property int zPriority: 1000
    property int buttonSize:30

    function confirm_new_point(index,point_name,centerX,centerY){
        //confirm_add_point.visible=true;
        second_window_form.point_is_onrelease=true
        database.expand_point(index,point_name,centerX,centerY,"")
        console.log(index)
    }




    Rectangle{
        id: circle_rect
        width: buttonSize
        height: buttonSize
        radius:buttonSize/2
        color: Qt.rgba(148/255,194/255,255/255,1.0)
        border.color: Qt.rgba(1/255,94/255,82/255,0.9)
        border.width: 1.3
        x:point_x
        y:point_y
        z:zPriority
        property int count: 0
        property bool draggable: first_window_form.enabled?false:true

        //在鼠标靠近按钮一定范围内时就可以显示小弹窗
        property int hoverMargin:5

        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0
        //property bool is_new:index_of_point>database.get_max_valid_point_key_from_points();

        //简介接口
        property string nameContext:"未知"//景点名字
        property string imageSource:""//图片的路径
        property string infoContext1:"暂无信息"
        property string infoContext2:""
        property string infoContext3:""//景点信息

        //鼠标悬浮未点击时显示的小弹窗 显示坐标名字
        Component {
            id: placeComponent
            //弹窗背景颜色外观

            Rectangle{
                    width: sceneSpotName.width
                    height: 20
                    color: Qt.rgba(1.0,240/255,206/255,0.5)
                    radius:4
                    border.color: Qt.rgba(20/255,4/255,110/255,0.4)
                    z:zPriority+2

                    //弹窗中文本
                    Text {
                        id: sceneSpotName
                        //width: parent.width
                        //height: parent.height
                        text: nameContext
                        font.family: "楷体"
                        font.weight: 600
                        anchors.centerIn: parent // 将文本居中显示
                    }
                }
            //}
        }

        //点击按钮后显示的详细信息大弹窗
        Component {
            id: popupComponent

            //固定弹窗大小
            Rectangle {
                width: 250
                height: 300
                color: Qt.rgba(244/255,255/255,243/255,1.0)
                radius: 10
                border.color: Qt.rgba(20/255,4/255,110/255,0.6)

                //支持鼠标滚轮以及滑动条浏览
                ScrollView {
                    anchors.fill: parent

                    contentWidth: contentText.width
                    contentHeight: contentText.height

                    //标题
                    Text{
                        y:10
                        x:5
                        id:sceneName
                        text:nameContext
                        font.family:"楷体"
                        font.weight:800
                        font.pointSize: 25
                        wrapMode: Text.WordWrap
                    }

                    Rectangle{
                        id:lineBelowTitle1
                        y:sceneName.y+34
                        x:3
                        width:200
                        height:1
                        color:"black"

                    }
                    Rectangle{
                        id:lineBelowTitle2
                        y:sceneName.y+42
                        x:3
                        width:200
                        height:1
                        color:"black"

                    }
                    //图片
                    Image {
                        id: sceneImage
                        source:imageSource
                        x:10
                        y:lineBelowTitle2.y+4
                        width:popupComponent.width-50
                        property real aspectRatio: 1 // 默认宽高比，将在图片加载后更新
                        onStatusChanged: {
                            if (status === Image.Ready) {
                                aspectRatio = sourceSize.width / sourceSize.height;
                                height = width / aspectRatio;
                            }
                        }
                        fillMode: Image.PreserveAspectFit // 保持比例的同时填充图片
                    }

                    //具体信息
                    Text {
                        id: contentText
                        width: 225
                        y:sceneImage.y+sceneImage.height+10
                        x:5
                        text:infoContext1+'\n'+infoContext2+'\n'+infoContext3+"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                        font.family:"楷体"
                        wrapMode: Text.WordWrap
                    }

                }
            }
        }


        MouseArea {
            id: dragArea
            anchors.fill: parent
            enabled: true
            //property bool isDraggable: true
            drag.target: circle_rect.draggable ? parent : null
            //判断大弹窗是否存在
            property bool isPopupVisible: false
            onClicked: {
                //console.log(rec.x + " " + rec.y + " " + rec.Drag.hotSpot.x + " " + rec.Drag.hotSpot.y)
                console.log("a test for triggerable button" + index_of_point)
                console.log("最大点为"+root.max_point_key)
                /*c++端的删除操作 to be added*/
                if(first_window_form.enabled){
                    if (isPopupVisible) {
                        // 如果大弹窗已经显示，则销毁它
                        clickPopup.destroy()
                        clickPopup = null
                        isPopupVisible = false

                        // circle_rect.width=originalSize
                        // circle_rect.height=originalSize
                        // circle_rect.radius=circle_rect.width/2

                        circle_rect.color=Qt.rgba(148/255,194/255,255/255,1.0)

                        // circle_rect.x+=/*point_x + */(afterSize - originalSize) / 2
                        // circle_rect.y+=/*point_y + */(afterSize - originalSize) / 2
                        //circle_rect.draggable=true
                    }
                    else {
                        // 否则，显示大弹窗
                        if (hoverPopup) {
                            hoverPopup.destroy()
                            hoverPopup = null
                        }
                        // 创建大弹窗，并确保其z值足够高
                        clickPopup = popupComponent.createObject(circle_rect.parent) // 使用parent作为父元素
                        clickPopup.x = circle_rect.x + 60
                        clickPopup.y = circle_rect.y - 30
                        clickPopup.z = circle_rect.z + 1 // 确保z值高于按钮

                        isPopupVisible = true

                        circle_rect.width = afterSize
                        circle_rect.height = afterSize
                        circle_rect.radius = circle_rect.width / 2

                        circle_rect.color = Qt.rgba(255/255, 179/255, 47/255, 1.0)

                        circle_rect.x -=/* point_x - */(afterSize - originalSize) / 2
                        circle_rect.y -=/* point_y - */(afterSize - originalSize) / 2
                        //circle_rect.draggable=false

                    }
                }
                else{
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




            }
            onReleased: {

                console.log("确认" + (++circle_rect.count))
                console.log("最大点为"+root.max_point_key)
                var centerX=circle_rect.x+15
                var centerY=circle_rect.y+15
                var point_name=""

                if(second_window_form.add_button_success)
                {
                    var centerX=circle_rect.x+15
                    var centerY=circle_rect.y+15
                    var point_name=""
                    // circle_rect.draggable=true
                    if(index_of_point>database.get_max_valid_point_key_from_points())
                    {
                        confirm_new_point(index_of_point,point_name, centerX, centerY)
                        console.log("添加的点坐标为"+centerX+","+centerY)
                        console.log(index_of_point)
                       // second_window_form.point_is_onrelease=true
                        circle_rect.draggable=false

                    index_of_point>database.get_max_valid_point_key_from_points()?
                        confirm_new_point(index_of_point,point_name,centerX,centerY):
                        database.update_point_add(index_of_point,centerX,centerY)
                        circle_rect.draggable=false
                    }
                }



                circle_rect.draggable = false




                // onDoubleClicked: {
                //     circle_rect.x = mouseX
                //     circle_rect.y = mouseY
                // }
            }

            onEntered: {
                if (!isPopupVisible) {
                    if (!hoverPopup) {
                        hoverPopup = placeComponent.createObject(circle_rect)
                        hoverPopup.x=circle_rect.width/2 - hoverPopup.width / 2
                        hoverPopup.y= -25
                        hoverPopup.z=circle_rect.z+1
                        // circle_rect.width=afterSize
                        // circle_rect.height=afterSize
                        // circle_rect.radius=circle_rect.width/2

                        circle_rect.color=Qt.rgba(148/255,194/255,255/255,1.0)

                        // circle_rect.x=point_x-(afterSize-originalSize)/2
                        // circle_rect.y=point_y-(afterSize-originalSize)/2
                    }
                }


            }

            //鼠标离开范围时小弹窗消失
            onExited: {
                if (hoverPopup && !isPopupVisible) {
                    hoverPopup.destroy()
                    hoverPopup = null

                    // circle_rect.width=originalSize
                    // circle_rect.height=originalSize
                    // circle_rect.radius=circle_rect.width/2

                    circle_rect.color=Qt.rgba(148/255,194/255,255/255,1.0)
                    // circle_rect.x=point_x
                    // circle_rect.y=point_y
                }
            }

            Text{
                id:circle_text
                text: circle_text.text = ++root.max_point_key
                anchors.centerIn: parent
            }

            // 添加一个变量来存储悬停时的小弹窗
            property var hoverPopup: null

            // 添加一个变量来存储点击时的大弹窗
            property var clickPopup: null
        }
    }
}
