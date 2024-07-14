
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtMultimedia

//import an.utility
/*----------------------------------------------------------------------------------------------------------------------------------*/
import "C:/Users/admin/Desktop/Navigation_of_WHU/Triggerable_Button.qml"
import "C:/Users/admin/Desktop/Navigation_of_WHU/SelectiveBox.qml"
/*----------------------------------------------------------------------------------------------------------------------------------*/
import com.database 1.0
import "D:/Documents/QTDocuments/downloadTest/ButtonWithComponent.qml"

Window {
    visible: true
    width:Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight - 25
    id : root
    title: qsTr("WuHan Univerity Guide")
    /* 通过交换控件的位置来避免 事件冲突 */
    /* 常用色的 定义*/
    property color chuntengPurple: Qt.rgba(51/255,5/255,141/255,0.5)
    property color donghuBlue: Qt.rgba(65/255,182/255,230/255,0.5)
    property color luoyingPink: Qt.rgba(248/255,163/255,188/255,0.5)
    property color qiuguiYellow: Qt.rgba(255/255,163/255,0/255,0.5)
    property color chengwuGrey: Qt.rgba(193/255,198/255,200/255,0.5)
    property color shuangyeRed: Qt.rgba(255/255,8/255,0/255,0.5)
    property int max_point_key : database.get_max_valid_point_key_from_points()
    property var tempobject1: []
    property var tempobject2: []
    property var tempobject3: [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    property var tempobject4: [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]//临时储存点
    property var temppointnum
    property var temppointallnum


    Graph{
        id:database
    }

    Component.onCompleted: {
        var locations = database.get_all_names_of_points(10)
        start_pos.selective_model.clear()
        for (var i = 0; i < locations.length; i++) {
            start_pos.selective_model.append({ "text": locations[i] })
            end_pos.selective_model.append({ "text": locations[i] })
        }
        unnamed1.play()
        unnamed2.play()
        console.log("play!")
        /*-------------- 评分listmodel初始化 ----------------------*/
        var rating_datas = database.get_score()
        for(var j = 0; j < rating_datas.length; j++){
            var point_name = rating_datas[j].point_name
            var score = Math.floor(rating_datas[j].score * 10) / 10
            var people_num = rating_datas[j].people_num
            rating_model.append({
                                    "point_name" :point_name,
                                    "score" : score,
                                    "people_num" : people_num

                                })
        }

    }

    Rectangle{
        id: second_window_form
        visible: false
        enabled: false
        width: parent.width
        height: parent.height
        property bool delete_button_pressed: false
        property bool delete_button_success: false
        property bool add_button_success: false
        // Image {
        //     id: unnamed1
        //     anchors.fill: parent
        //     /*-------------------------------------------------------------------------------------------------------*/
        //     source: "file:D:/Documents/QTDocuments/test_for_history_edit/TestImage.jpg"
        //     /*-------------------------------------------------------------------------------------------------------*/

        // }
        MediaPlayer {
            id: unnamed1
            loops: MediaPlayer.Infinite
            //anchors.fill: parent
            source: "file:///D:/Downloads/Lone_Cherry_Blossom.mp4"
            videoOutput: videoOutput2

            audioOutput: AudioOutput{}
        }
        VideoOutput{
            id:videoOutput2

            width: root.width;
            anchors.centerIn: parent
        }

        ListModel{
            id: pointsMod
        }
        ListModel {
            id: pathsMod
        }
        Component.onCompleted: {
            var max_point_key=database.get_max_valid_point_key_from_points();
            console.log("pointsMod max_point_key" + max_point_key)
            for(var i=1;i<=max_point_key;i++)
            {
                var point_map=database.get_address_of_point(i);
                var point_x=point_map["addr_x"];
                var point_y=point_map["addr_y"];
                // console.log(point_x+","+point_y)
                if(point_x!==-1)
                {
                    pointsMod.append({
                                         "point_addr_x":point_x,
                                         "point_addr_y":point_y,
                                         "point_key":i
                                     })
                }
                for(var j=1;j<=max_point_key;j++)
                {

                    if(database.get_road_key(i,j)!==-1)
                    {
                        var start_point_name=database.get_point_name(i);
                        var end_point_name=database.get_point_name(j);
                        var start_point_map=database.get_address_of_point(i);
                        var start_x=start_point_map["addr_x"];
                        var start_y=start_point_map["addr_y"];
                        var end_point_map=database.get_address_of_point(j);
                        var end_x=end_point_map["addr_x"];
                        var end_y=end_point_map["addr_y"];
                        var road_key=database.get_road_key(i,j);
                        pathsMod.append({
                                            "road_key":road_key,
                                            "road_name":database.get_road_name(road_key),
                                            "road_length":database.get_road_length(road_key),
                                            "start_point_name":database.get_point_name(i),
                                            "end_point_name":database.get_point_name(j),
                                            "start_point_add":Qt.point(start_x,start_y),
                                            "end_point_add":Qt.point(end_x,end_y)
                                        })
                    }
                }
            }
            console.log("pointMod count " + pointsMod.count)
        }
        property alias exportedListModel: pathsMod
        // Loader {
        //     id: loader
        //     source: "Triggerable_Button.qml"
        //     anchors.fill: parent
        // }


        Canvas {
            id: second_path_canvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.strokeStyle = shuangyeRed;//颜色调整
                ctx.lineWidth = 5;//路径宽度
                for (var i = 0; i <pathsMod.count; ++i) {
                    var startPoint = pathsMod.get(i).start_point_add;
                    var endPoint = pathsMod.get(i).end_point_add;
                    ctx.beginPath();
                    ctx.moveTo(startPoint.x, startPoint.y);
                    ctx.lineTo(endPoint.x, endPoint.y);
                    ctx.stroke();
                }
            }

        }


        Rectangle{
            id:welcome_rec
            width: 300
            height: 50
            visible: parent.visible
            enabled: parent.enabled
            radius: 20
            color: chengwuGrey
            border.width: 1
            border.color : shuangyeRed
            //border.color : "blue"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top : parent.top
            Text {
                id : welcome_text
                opacity: 1
                font.pixelSize: 30
                font.wordSpacing: 3
                font.family: "楷体"
                font.pointSize: 13
                //font.italic: true
                font.bold: true
                style: Text.Outline
                styleColor: "steelblue"
                color: "white"
                text: qsTr("管理员操作")
                anchors.centerIn: parent
            }

            // NumberAnimation {
            //     target: welcome_text
            //     loops: Animation.Infinite
            //     property: "name"
            //     duration: 200
            //     easing.type: Easing.InOutQuad
            // }

            SequentialAnimation{
                loops: Animation.Infinite
                running: true
                NumberAnimation {
                    target: welcome_text
                    property: "opacity"
                    duration: 2000
                    to: 0.2
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: welcome_text
                    property: "opacity"
                    duration: 2000
                    to: 1
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: welcome_text
                    property: "opacity"
                    duration: 200
                    to: 1
                    easing.type: Easing.InOutQuad
                }

            }

        }
        Repeater{
            id : pointsGenarating
            property int init_point_key: init_point_key = root.max_point_key

            model:pointsMod.count
            // x : index * 80
            // Triggerable_Button{
            //     anchors.fill: parent

            //     button_text: index

            // }

            delegate: Triggerable_Button{
                //console.log(pointsMod.get(index).point_key)
                //y : 20
                //id : index

                index_of_point :pointsMod.get(index).point_key
                button_text: pointsMod.get(index).point_key
                //anchors.left: parent.left
                //anchors.leftMargin: index * 40


                point_x: pointsMod.get(index).point_addr_x-15 // 使用当前元素的 point_x

                point_y: pointsMod.get(index).point_addr_y-15 // 使用当前元素的 point_y

            }

        }
        Rectangle{
            id:each_option_left
            width: 100
            height: 50
            visible: parent.visible
            enabled: parent.enabled
            color: chengwuGrey
            radius: 20
            border.color : "gray"
            anchors.left: parent.left
            anchors.bottom : parent.bottom
            Text {
                font.pixelSize: 20
                font.family: "楷体"
                color: "white"
                text: qsTr("添加景点")
                style: Text.Outline
                styleColor: "steelblue"
                anchors.centerIn: parent
            }
            Button{
                anchors.fill: parent

                opacity: 0
                enabled: parent.enabled
            }
            MouseArea{
                enabled: parent.enabled
                hoverEnabled: parent.enabled
                anchors.fill: parent
                onEntered: {
                    each_option_left.color = donghuBlue
                }
                onExited: {
                    each_option_left.color = chengwuGrey
                }
                onClicked:{
                    console.log("add view")
                    add_success_instruction.open()
                    each_option_left.createTriggerButton()
                }
            }
            function createTriggerButton() {
                var component = Qt.createComponent("Triggerable_Button.qml");
                var sprite = component.createObject(second_window_form, {x: 100, y: 0});

                if (sprite === null) {
                    // Error Handling
                    console.log("Error creating object");
                }
            }
        }
        Popup{
            id: add_success_instruction
            width: 120
            height: 80
            modal: true
            visible: parent.visible && second_window_form.add_button_success
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: add_success_rec
                width: add_success_instruction.width
                height: add_success_instruction.height
                MouseArea{
                    anchors.fill: add_success_instruction

                }

                Text{
                    id : add_success_text
                    font.family: "楷体"
                    font.pointSize : 20
                    color: "white"
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "添加成功!"
                    x : add_success_rec.x + (add_success_rec.width - add_success_text.width) / 2
                }

                Button{
                    width: 80
                    height: 40
                    id: add_success_instruction_button
                    anchors.top: add_success_text.bottom
                    anchors.topMargin: 5
                    Text{
                        font.family: "楷体"
                        font.pointSize : 20
                        color: "white"
                        style: Text.Outline
                        styleColor: "steelblue"
                        text: "OK"
                        anchors.centerIn: add_success_instruction_button
                    }

                    x : add_success_rec.x + (add_success_rec.width - add_success_instruction_button.width) / 2
                    //anchors.bottom: add_success_rec.bottom
                    //anchors.topMargin: 0
                    onClicked: {
                        add_success_instruction.close()
                    }
                }

            }

            Overlay.modal: Rectangle {
                color: chengwuGrey
            }
            closePolicy:Popup.CloseOnPressOutside
        }
        Popup{
            id: delete_finish_instruction
            width: 120
            height: 80
            modal: true
            visible: parent.visible && second_window_form.delete_button_success
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: delete_finish_instruction_rec
                width: delete_finish_instruction.width
                height: delete_finish_instruction.height
                Text{
                    id : delete_finish_text
                    font.family: "楷体"
                    color: "white"
                    font.pointSize: 20
                    x : delete_finish_instruction_rec.x + (delete_finish_instruction_rec.width - delete_finish_text.width) / 2
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "删除成功!"
                }
                MouseArea{
                    anchors.fill: delete_finish_instruction

                }
                Button{
                    width: 80
                    height: 40
                    id: delete_finish_instruction_button
                    anchors.top: delete_finish_text.bottom
                    anchors.topMargin: 5
                    Text{
                        font.family: "楷体"
                        font.pointSize : 20
                        color: "white"
                        style: Text.Outline
                        styleColor: "steelblue"
                        text: "OK"
                        anchors.centerIn: delete_finish_instruction_button
                    }
                    x : delete_finish_instruction_rec.x + (delete_finish_instruction_rec.width - delete_finish_instruction_button.width) / 2

                    onClicked: {
                        delete_finish_instruction.close()
                        //修改listmodel中的信息






                        //second_path_canvas.requestPaint()
                    }
                }
            }

            Overlay.modal: Rectangle {
                color: chengwuGrey
            }
        }

        Popup{
            id: delete_instruction
            width: 280
            height: 80
            modal: true
            visible: parent.visible && second_window_form.delete_button_pressed
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: delete_instruction_rec
                width: delete_instruction.width
                height: delete_instruction.height
                Text{
                    id : delete_text
                    color: "white"
                    font.family: "楷体"
                    font.pointSize : 20
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "请点击你要删除的景点:"
                    x : delete_instruction_rec.x + (delete_instruction_rec.width - delete_text.width) / 2
                }
                MouseArea{
                    anchors.fill: delete_instruction

                }
                Button{
                    id: delete_instruction_button
                    width: 80
                    height: 40
                    Text{
                        font.family: "楷体"
                        font.pointSize : 20
                        color: "white"
                        style: Text.Outline
                        styleColor: "steelblue"
                        text: "OK"
                        anchors.centerIn: delete_instruction_button
                    }

                    x : delete_instruction_rec.x + (delete_instruction_rec.width - delete_instruction_button.width) / 2
                    anchors.top: delete_text.bottom
                    anchors.topMargin: 10
                    onClicked: {
                        delete_instruction.close()
                    }
                }
            }

            Overlay.modal: Rectangle {
                color: chengwuGrey
            }
            //closePolicy:Popup.CloseOnPressOutside
        }

        Popup{            //输入景点信息弹窗
            id:confirm_add_point
            width:400
            height:200
            modal:true
            visible: false
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: confirm_add_rec
                width: confirm_add_point.width
                height: confirm_add_point.height
            }
            Text{
                id : add_point_text
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text: "请输入景点信息"
                font.pointSize: 24
                x : confirm_add_rec.x
                y:parent.y+5
            }
            Text{
                id:add_point_name
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text:"景点名称："
                font.pointSize: 20
                x : confirm_add_rec.x
                y: add_point_text.y + add_point_text.height+15

            }
            TextField{
                id:input_point_name
                visible: parent.visible
                enabled: parent.enabled
                width: 250
                height:add_point_name.hight
                x:add_point_name.width+confirm_add_rec.x+10
                y: add_point_text.y + add_point_text.height+20
                background: Rectangle {
                    radius: 4
                    border.color: "steelblue"
                }
            }
            Text{
                id:add_point_intro
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text:"景点简介："
                font.pointSize: 20
                x : confirm_add_rec.x
                y: add_point_text.y + add_point_text.height+10+input_point_name.height+25
            }
            TextField{
                id:input_point_intro
                visible: parent.visible
                enabled: parent.enabled
                width: 250
                height:add_point_name.hight
                x:add_point_name.width+confirm_add_rec.x+10
                y: add_point_text.y + add_point_text.height+15+input_point_name.height+25
                background: Rectangle {
                    radius: 4
                    border.color: "steelblue"
                }
            }
            Button{
                id:confirm_point
                text: "OK"
                width:80
                height:40
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var point_name=input_point_name.text
                    var point_intro=input_point_intro.text
                    database.update_point_intro(database.get_max_valid_point_key_from_points(),point_intro)
                    database.update_point_name(database.get_max_valid_point_key_from_points(),point_name)
                    confirm_add_point.close()

                }
            }
        }
        Rectangle{//删除景点
            id:each_option_center
            width: 100
            height: 50
            visible: parent.visible
            enabled: parent.enabled
            color: chengwuGrey
            radius: 20
            border.color : "gray"
            anchors.left: each_option_left.right
            anchors.bottom : parent.bottom
            Text {
                font.pixelSize: 20
                color: "white"
                font.family: "楷体"
                style: Text.Outline
                styleColor: "steelblue"
                text: qsTr("删除景点")
                anchors.centerIn: parent
            }
            Button{
                anchors.fill: parent``````````
                opacity: 0
                enabled: parent.enabled

            }
            MouseArea{
                enabled: parent.enabled
                hoverEnabled: parent.enabled
                anchors.fill: parent
                onEntered: {
                    each_option_center.color = luoyingPink
                }
                onExited: {
                    each_option_center.color = chengwuGrey
                }
                onClicked:{
                    second_window_form.delete_button_pressed = true

                    console.log("delete view")
                    //console.log("second_window_form.delete_button_pressed: " + second_window_form.delete_button_pressed)
                    console.log("instruction for delete")
                    delete_instruction.open()

                }
            }
        }
        Popup{//有误提示弹窗
            id:not_add_road_success
            width: 400
            height:200
            visible: false
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: not_add_road_success_rec
                width: not_add_road_success.width
                height: not_add_road_success.height

                Text {
                    id: not_add_road_success_text
                    text: "景点编号输入有误或不存在，请重新输入"
                    font.family: "楷体"
                    color: "white"
                    style: Text.Outline
                    styleColor: "steelblue"
                    font.pointSize: 15
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill:not_add_road_success

                }
                Button{
                    id: not_add_road_success_button
                    text: "OK"
                    width:80
                    height:40
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        not_add_road_success.close()
                    }
                }

            }
        }
        Popup{            //输入路径信息弹窗
            id:confirm_add_road
            width:400
            height:300
            modal:true
            visible: false
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: confirm_add_road_rec
                width: confirm_add_road.width
                height: confirm_add_road.height
            }
            Text{
                id : add_road_text
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text: "请输入路径信息"
                font.pointSize: 24
                x : confirm_add_road_rec.x
                y:parent.y+5
            }
            Text{
                id:add_road_name
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text:"路径名称："
                font.pointSize: 20
                x : confirm_add_road_rec.x
                y: add_road_text.y + add_road_text.height+15

            }
            TextField{
                id:input_road_name
                visible: parent.visible
                enabled: parent.enabled
                width: 250
                height:add_road_name.hight
                x:add_road_name.width+confirm_add_road_rec.x+10
                y: add_road_text.y + add_road_text.height+20
                background: Rectangle {
                    radius: 4
                    border.color: "steelblue"
                }
            }
            Text{
                id:add_road_length
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text:"路径长度(m)："
                font.pointSize: 20
                x : confirm_add_road_rec.x
                y: add_road_text.y + add_road_text.height+10+input_road_name.height+25
            }
            TextField{
                id:input_road_length
                visible: parent.visible
                enabled: parent.enabled
                width: 250
                height:add_road_name.hight
                x:add_road_name.width+confirm_add_road_rec.x+10
                y: add_road_text.y + add_road_text.height+15+input_road_name.height+25
                background: Rectangle {
                    radius: 4
                    border.color: "steelblue"
                }
            }
            Text {
                id: add_road_start
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text: "起点编号："
                font.pointSize: 20
                x : confirm_add_road_rec.x
                y:add_road_text.y + add_road_text.height+15+input_road_name.height+25+input_road_length.height+20
            }
            TextField{
                id:input_road_start
                visible: parent.visible
                enabled: parent.enabled
                width: 250
                height:add_road_name.hight
                x:add_road_name.width+confirm_add_road_rec.x+10
                y:add_road_text.y + add_road_text.height+15+input_road_name.height+25+input_road_length.height+20
                background: Rectangle {
                    radius: 4
                    border.color: "steelblue"
                }
            }
            Text {
                id: add_road_end
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text: "终点编号："
                font.pointSize: 20
                x : confirm_add_road_rec.x
                y:add_road_text.y + add_road_text.height+15+input_road_name.height+25+input_road_length.height+20+input_road_start.height+25
            }
            TextField{
                id:input_road_end
                visible: parent.visible
                enabled: parent.enabled
                width: 250
                height:add_road_name.hight
                x:add_road_name.width+confirm_add_road_rec.x+10
                y:add_road_text.y + add_road_text.height+15+input_road_name.height+25+input_road_length.height+20+input_road_start.height+25
                background: Rectangle {
                    radius: 4
                    border.color: "steelblue"
                }
            }

            Button{
                id:confirm_road
                text: "OK"
                width:80
                height:40
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var road_length=input_road_length.text
                    var road_name=input_road_name.text
                    var road_start_key=input_road_start.text
                    var road_end_key=input_road_end.text
                    var road_max_key=database.get_roads_max_id()
                    var start_point_map=database.get_address_of_point(road_start_key);
                    var new_start_x=start_point_map["addr_x"];
                    var new_start_y=start_point_map["addr_y"];
                    var end_point_map=database.get_address_of_point(road_end_key);
                    var new_end_x=end_point_map["addr_x"];
                    var new_end_y=end_point_map["addr_y"];
                    var new_start_name=database.get_point_name(road_start_key)
                    var new_end_name=database.get_point_name(road_end_key)
                    console.log(road_length+"   "+road_name+" "+road_start_key+"  "+road_end_key+" "+new_start_x+" "+new_end_x)

                    if(new_start_x!==-1&&new_end_x!==-1)
                    {

                        database.expand_road(road_max_key+1,road_name,new_start_name,new_end_name,road_length)
                        pathsMod.append({
                                            "road_key":road_max_key+1,
                                            "road_name":road_name,
                                            "road_length":road_length,
                                            "start_point_name":database.get_point_name(road_start_key),
                                            "end_point_name":database.get_point_name(road_end_key),
                                            "start_point_add":Qt.point(new_start_x,new_start_y),
                                            "end_point_add":Qt.point(new_end_x,new_end_y)

                                        })
                        second_path_canvas.requestPaint()
                        path_canvas.requestPaint()
                        confirm_add_road.close()
                    }
                    else
                    {
                        confirm_add_road.close()
                        not_add_road_success.visible=true

                    }


                }
            }
        }

        Rectangle{//添加路径
            id:each_option_right
            width: 100
            height: 50
            visible: parent.visible
            enabled: parent.enabled
            color: chengwuGrey
            radius: 20
            border.color : "gray"
            anchors.left: each_option_center.right
            anchors.bottom : parent.bottom
            Text {
                font.pixelSize: 20
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text: qsTr("添加路径")
                anchors.centerIn: parent
            }
            Button{
                anchors.fill: parent

                opacity: 0
                enabled: parent.enabled
                //onClicked:
            }
            MouseArea{
                enabled: parent.enabled
                hoverEnabled: parent.enabled
                anchors.fill: parent
                onEntered: {
                    each_option_right.color = qiuguiYellow
                }
                onExited: {
                    each_option_right.color = chengwuGrey
                }
                onClicked: {
                    confirm_add_road.visible=true

                }
            }
        }


        Rectangle{
            id:each_option_right_right
            width: 100
            height: 50
            visible: parent.visible
            enabled: parent.enabled
            color: chengwuGrey
            radius: 20
            border.color : "gray"
            anchors.left: each_option_right.right
            anchors.bottom : parent.bottom
            Text {
                font.pixelSize: 20
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text: qsTr("删除路径")
                anchors.centerIn: parent
            }
            Button{
                anchors.fill: parent

                opacity: 0
                enabled: parent.enabled
                //onClicked:
            }
            MouseArea{
                enabled: parent.enabled
                hoverEnabled: parent.enabled
                anchors.fill: parent
                onEntered: {
                    each_option_right_right.color = chuntengPurple
                }
                onExited: {
                    each_option_right_right.color = chengwuGrey
                }
                onClicked: {


                }
            }
        }
    }


    Rectangle{
        id: first_window_form
        visible: true
        enabled: true
        width: parent.width
        height: parent.height
        MediaPlayer {
            id: unnamed2
            loops: MediaPlayer.Infinite
            //anchors.fill: parent
            source: "file:///D:/Downloads/68363-528670466_small.mp4"
            videoOutput: videoOutput

            audioOutput: AudioOutput{}
        }
        VideoOutput{
            id:videoOutput

            width: root.width;
            anchors.centerIn: parent
        }

        // Image {
        //     id: unnamed2
        //     anchors.fill: parent
        //     source: "file:D:/Documents/QTDocuments/test_for_history_edit/TestImage.jpg"
        // }


        ButtonWithComponent{
            id:myButton_yinghuachengbao
            originalX:100
            originalY:100
            nameContext: "武汉大学"
            infoContext1: "介绍1"
            infoContext2: "介绍2"
            infoContext3: "介绍3"
            Component.onCompleted: {
                carousel_pics_model = [
                            {url:"file:///C:/Users/Administrator/Desktop/yinhua1.jpg"},
                            {url:"file:///C:/Users/Administrator/Desktop/yinhua2.jpg"},
                            {url:"file:///C:/Users/Administrator/Desktop/yinhua3.jpg"},
                            {url:"file:///C:/Users/Administrator/Desktop/yinhua4.jpg"}
                        ]
            }
        }


        Label {
            id: road_text_label
            visible: false
            Text{
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text: "点击路径以显示信息"
            }

            background: Rectangle {
                width: road_text_label.width + 10; height: road_text_label.height + 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 1.0; color: "lightblue" }
                }
            }
        }

        Canvas {
            id: path_canvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.strokeStyle = Qt.rgba(255/255,8/255,0/255,0.5);
                ctx.lineWidth = 5;//路径宽度
                for (var i = 0; i <pathsMod.count; ++i) {
                    var startPoint = pathsMod.get(i).start_point_add;
                    var endPoint = pathsMod.get(i).end_point_add;
                    ctx.beginPath();
                    ctx.moveTo(startPoint.x, startPoint.y);
                    ctx.lineTo(endPoint.x, endPoint.y);
                    ctx.stroke();
                }
            }


            MouseArea {
                id: road_mouseArea
                anchors.fill: parent
                onClicked: {
                    var mouseX = mouse.x - path_canvas.x;
                    var mouseY = mouse.y - path_canvas.y;
                    for(var i = 0; i < pathsMod.count; ++i) {
                        var startPoint = pathsMod.get(i).start_point_add;
                        var endPoint = pathsMod.get(i).end_point_add;

                        // 计算点击距图像的路径
                        var dx = endPoint.x - startPoint.x;
                        var dy = endPoint.y - startPoint.y;
                        var length = Math.sqrt(dx * dx + dy * dy);
                        for (var t = 0; t <= length; t++) {
                            var x = startPoint.x + dx * (t / length);
                            var y = startPoint.y + dy * (t / length);


                            var clickRadius = 4; // 按需要调整
                            if (Math.abs(x - mouseX) <= clickRadius && Math.abs(y - mouseY) <= clickRadius) {
                                // 调整label弹出的位置，目前在点击区域附件
                                road_text_label.x = mouseX + 10;
                                road_text_label.y = mouseY - road_text_label.height - 10;
                                road_text_label.visible = true;
                                road_text_label.text = "路名: " + pathsMod.get(i).road_name +
                                        "\n长度: " + pathsMod.get(i).road_length +"米"+
                                        "\n起点: " + pathsMod.get(i).start_point_name +
                                        "\n终点: " + pathsMod.get(i).end_point_name;
                                return;
                            }
                        }
                    }
                }
            }
        }
        TextField { // 文本输入框
            id: inputField
            visible: parent.visible
            enabled: parent.enabled
            width: 300
            height: 40
            selectByMouse: true
            font.pointSize: 15
            font.family: "楷体"
            //style: Text.Outline
            //styleColor: "lightblue"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0 // 顶部中心
            placeholderText : "请输入你想查找的景点："
            //placeholderTextColor : "black"
            background: Rectangle {
                radius: 4
                border.color: "steelblue"
            }

            property bool editing: false // qml 定义变量的方式

            onTextEdited: editing = true;
            onEditingFinished: editing = false; // 不在文本框上,不可编辑
            onTextChanged: { // 文本改变触发事件: 通过 INVOKE 宏实现直接调用
                historyModel.sortByKey(inputField.text);
            }
        }


        SelectiveBox{
            id:start_pos
            width: 150
            height: 30
            x:0
            y:30
            selective_model: ListModel{}
        }
        SelectiveBox{
            id:end_pos
            width: 150
            height: 30
            y:30
            x:160
            selective_model: ListModel{}
        }
        Button{
            property int clicknum1: 0
            id:shortest_search
            Text{
                font.family: "楷体"
                font.pixelSize: 20
                style: Text.Outline
                styleColor: "steelblue"
                color: "white"
                anchors.centerIn: parent
                text: qsTr("显示最短路径")
            }
            visible: start_pos.visible
            enabled: start_pos.enabled
            width: 140
            height: 30
            y : 30
            anchors.left: end_pos.right
            anchors.leftMargin: 20
            onClicked: {
                if(clicknum1===0){
                    if(start_pos.cur_chosen_point!==""&&end_pos.cur_chosen_point!==""){
                        var tempstartpoint=database.get_point_key(start_pos.cur_chosen_point)
                        var tempendpoint=database.get_point_key(end_pos.cur_chosen_point)
                        var shortest_point_key=database.inquire_shortest_road(tempstartpoint,tempendpoint)
                        console.log(tempstartpoint+" "+tempendpoint)
                        temppointnum=shortest_point_key.length-1
                        for(var i=0;i<shortest_point_key.length-1;i++){
                            var temppointxy11=database.get_address_of_point(shortest_point_key[i].point_key)
                            var temppointxy22=database.get_address_of_point(shortest_point_key[i+1].point_key)
                            console.log(shortest_point_key[i].point_key+":"+temppointxy11.addr_x+","+temppointxy11.addr_y)
                            console.log(shortest_point_key[i+1].point_key+":"+temppointxy22.addr_x+","+temppointxy22.addr_y)
                            var component2 = Qt.createComponent("shortestpath_animation.qml");
                            if (component2.status === Component.Ready) {
                                tempobject2[i]= component2.createObject(parent,{startx:temppointxy11.addr_x,
                                                                            starty:temppointxy11.addr_y,
                                                                            endx:temppointxy22.addr_x,
                                                                            endy:temppointxy22.addr_y});
                            }
                        }
                        for(var j=0;j<shortest_point_key.length-1;j++){
                            var temppointxy1=database.get_address_of_point(shortest_point_key[j].point_key)
                            var temppointxy2=database.get_address_of_point(shortest_point_key[j+1].point_key)
                            console.log(shortest_point_key[j].point_key+":"+temppointxy1.addr_x+","+temppointxy1.addr_y)
                            console.log(shortest_point_key[j+1].point_key+":"+temppointxy2.addr_x+","+temppointxy2.addr_y)
                            var component1 = Qt.createComponent("shortestpath_line.qml");
                            if (component1.status === Component.Ready){
                                tempobject1[j]= component1.createObject(parent,{sx:temppointxy1.addr_x,
                                                                            sy:temppointxy1.addr_y,
                                                                            ex:temppointxy2.addr_x,
                                                                            ey:temppointxy2.addr_y});
                                if((temppointxy1.addr_x-temppointxy2.addr_x)>0){
                                    tempobject1[j].transformOrigin="BottomRight"
                                }
                            }
                        }
                        clicknum1+=1
                    }
                }
                else{
                    for(var k=0;k<temppointnum;k++){
                        tempobject1[k].opacity=0
                        tempobject2[k].opacity=0
                    }
                    clicknum1=0
                }
            }
        }
        Button{
            property int clicknum2: 0
            id:allpath_search
            Text{
                font.family: "楷体"
                font.pixelSize: 20
                style: Text.Outline
                styleColor: "steelblue"
                color: "white"
                anchors.centerIn: parent
                text: qsTr("显示所有路径")
            }
            visible: start_pos.visible
            enabled: start_pos.enabled
            width: 140
            height: 30
            y : 0
            anchors.left: end_pos.right
            anchors.leftMargin: 20
            onClicked: {
                if(clicknum2===0){
                    if(start_pos.cur_chosen_point!==""&&end_pos.cur_chosen_point!==""){
                        var tempstartpoint=database.get_point_key(start_pos.cur_chosen_point)
                        var tempendpoint=database.get_point_key(end_pos.cur_chosen_point)
                        var all_point_key=database.inquire_all_roads(tempstartpoint,tempendpoint)
                        console.log(tempstartpoint+" "+tempendpoint)
                        temppointnum=all_point_key.length

                        for(var i=0;i<temppointnum;i++){
                            console.log("路径"+(i+1)+":")
                            temppointallnum=all_point_key[i].length-1
                            console.log(temppointallnum)
                            for(var k=0;k<temppointallnum;k++){
                                var temppointxy11=database.get_address_of_point(all_point_key[i][k])
                                var temppointxy22=database.get_address_of_point(all_point_key[i][k+1])
                                console.log(all_point_key[i][k]+":"+temppointxy11.addr_x+","+temppointxy11.addr_y)
                                console.log(all_point_key[i][k+1]+":"+temppointxy22.addr_x+","+temppointxy22.addr_y)
                                var component2 = Qt.createComponent("shortestpath_animation.qml");
                                if (component2.status === Component.Ready) {
                                    tempobject3[i][k]= component2.createObject(parent,{startx:temppointxy11.addr_x,
                                                                                   starty:temppointxy11.addr_y,
                                                                                   endx:temppointxy22.addr_x,
                                                                                   endy:temppointxy22.addr_y});
                                }
                            }
                            for(var j=0;j<temppointallnum;j++){
                                var temppointxy1=database.get_address_of_point(all_point_key[i][j])
                                var temppointxy2=database.get_address_of_point(all_point_key[i][j+1])
                                console.log(all_point_key[i][j]+":"+temppointxy1.addr_x+","+temppointxy1.addr_y)
                                console.log(all_point_key[i][j+1]+":"+temppointxy2.addr_x+","+temppointxy2.addr_y)
                                var component1 = Qt.createComponent("shortestpath_line.qml");
                                if (component1.status === Component.Ready){
                                    tempobject4[i][j]= component1.createObject(parent,{sx:temppointxy1.addr_x,
                                                                                   sy:temppointxy1.addr_y,
                                                                                   ex:temppointxy2.addr_x,
                                                                                   ey:temppointxy2.addr_y});
                                    if((temppointxy1.addr_x-temppointxy2.addr_x)>0){
                                        tempobject4[i][j].transformOrigin="BottomRight"
                                    }
                                }
                            }
                        }

                        clicknum2+=1
                    }
                }
                else{
                    for(var t=0;t<temppointnum;t++){
                        for(var p=0;p<temppointallnum;p++){
                            if(tempobject3[t][p]!==undefined){
                                tempobject3[t][p].opacity=0
                            }
                            if(tempobject4[t][p]!==undefined){
                                tempobject4[t][p].opacity=0
                            }

                        }
                    }
                    clicknum2=0
                }
            }
        }
        Label{
            id : start_pos_label
            visible: end_pos.visible
            enabled: end_pos.enabled
            width: start_pos.width
            height: start_pos.height
            Text{
                id : start_pos_label_text
                font.family: "楷体"
                color: "white"
                font.pixelSize: 15
                style: Text.Outline
                styleColor: "steelblue"
                text: "请输入起点:"
                anchors.centerIn: start_pos_label
            }

            background: Rectangle {
                width: start_pos.width
                height: start_pos.height
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    //GradientStop { position: 0.33; color: "yellow" }
                    GradientStop { position: 1.0; color: "lightblue" }
                }
            }
        }
        Label{
            id : end_pos_label
            visible: start_pos.visible
            enabled: start_pos.enabled
            anchors.left: start_pos_label.right
            anchors.leftMargin: 10
            width: start_pos.width
            height: start_pos.height
            Text{
                font.family: "楷体"
                font.pixelSize: 15
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"
                text: "请输入终点:"
                anchors.centerIn: end_pos_label
            }

            background: Rectangle {
                id : back
                anchors.centerIn: end_pos_label
                width: start_pos.width
                height: start_pos.height

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    //GradientStop { position: 0.33; color: "yellow" }
                    GradientStop { position: 1.0; color: "lightblue" }
                }
            }
        }
        Button {
            Text{
                font.family: "楷体"
                color: "white"
                font.pixelSize: 20
                text: qsTr("搜索")
                style: Text.Outline
                styleColor: "steelblue"
                anchors.centerIn: parent
            }

            visible: parent.visible
            enabled: parent.enabled
            onClicked: {
                if(inputField.text !== ""){
                    console.log(inputField.text)
                }
            }

            width: 70
            height: 40
            anchors.top: inputField.top // 与文本输入框绑定 同一高度
            anchors.left: inputField.right
            anchors.leftMargin: 12
        }

        Rectangle { // 历史记录的包装
            id: historyList
            radius: 4
            width: 300
            height: 120
            enabled: parent.enabled
            visible: parent.visible && (inputField.editing || inputField.activeFocus) // 什么时候可见
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: inputField.bottom
            anchors.topMargin: 2
            border.color: "red"
            color: Qt.rgba(255, 255, 255, 0.5)

            ListView { // 历史记录的列表
                id: listView
                anchors.fill: parent
                enabled: parent.enabled
                visible: parent.visible

                anchors.margins: 5
                clip: true
                spacing: 5
                delegate: Component {
                    Rectangle {
                        radius: 4
                        width: listView.width - 20
                        height: 22
                        color: hovered ? "#f4f4f4" : "#ddd"
                        border.color: chuntengPurple

                        property bool hovered: false

                        Text {
                            id: displayText
                            text: display // 文本名
                            font.family: "楷体"
                            color: "white"
                            style: Text.Outline
                            styleColor: "steelblue"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            font.pixelSize: 22
                            font.wordSpacing: 3

                            TextMetrics {
                                id: startWidth
                                font: displayText.font
                                text: {
                                    let index = display.indexOf(inputField.text);
                                    if (index !== -1)
                                        return displayText.text.substring(0, index);
                                    else
                                        return "";
                                }
                            }

                            TextMetrics {
                                id: keyWidth
                                font: displayText.font
                                text: inputField.text
                            }

                            Rectangle { // 确定标红区域
                                color: "red"
                                opacity: 0.4
                                x: startWidth.advanceWidth
                                width: keyWidth.advanceWidth
                                height: parent.height
                            }
                        }

                        MouseArea { // 可检测鼠标区域
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.hovered = true;
                            onExited: parent.hovered = false;
                            onClicked: {
                                let index = display.indexOf(inputField.text);
                                if (index !== -1)
                                    var curContent = displayText.text
                                //console.debug(curContent)
                                inputField.text = curContent

                            }
                        }
                    }
                }
                model: historyModel
                ScrollBar.vertical: ScrollBar {
                    width: 12
                    policy: ScrollBar.AlwaysOn
                }


            }

        }
        ParallelAnimation {
            id: searching_route_player
            running: false
            NumberAnimation { target: start_pos_label; property: "opacity"; from : 0;to: 1.0; duration: 400}
            NumberAnimation { target: end_pos_label; property: "opacity"; from :0;to: 1.0; duration: 400}
            NumberAnimation { target: shortest_search; property: "opacity"; from:0;to: 1.0; duration: 400}
            NumberAnimation { target: start_pos; property: "opacity"; from : 0;to: 1.0; duration: 400}
            NumberAnimation { target: end_pos; property: "opacity"; from : 0;to: 1.0; duration: 400}
            NumberAnimation { target: allpath_search; property: "opacity"; from : 0;to: 1.0; duration: 400}
        }
        Rectangle{
            id:search_route
            width: 100
            height: 50
            visible: parent.visible
            enabled: parent.enabled
            color: chengwuGrey
            radius: 20
            border.color : "gray"
            anchors.left: parent.left
            anchors.bottom : parent.bottom
            Text {
                font.pixelSize: 20
                color: "white"
                font.family: "楷体"
                text: qsTr("查找路线")
                style: Text.Outline
                styleColor: "steelblue"
                anchors.centerIn: parent
            }
            Button{
                anchors.fill: parent

                opacity: 0
                enabled: parent.enabled
            }
            MouseArea{
                enabled: parent.enabled
                hoverEnabled: parent.enabled
                anchors.fill: parent
                onEntered: {
                    search_route.color = shuangyeRed
                }
                onExited: {
                    search_route.color = chengwuGrey
                }
                onClicked: {
                    start_pos.visible = !start_pos.visible
                    end_pos.visible = !end_pos.visible
                    console.log("searching-")
                    searching_route_player.start()
                    for(var k=0;k<temppointnum;k++){
                        tempobject1[k].opacity=0
                        tempobject2[k].opacity=0
                    }
                }

            }
        }
        Rectangle{
            id:rating_scene
            width: 100
            height: 50
            visible: parent.visible
            enabled: parent.enabled
            color: chengwuGrey
            radius: 20
            border.color : "gray"
            anchors.left: search_route.right
            anchors.bottom : parent.bottom
            Text {
                font.pixelSize: 20
                color: "white"
                font.family: "楷体"
                text: qsTr("景点评分")
                style: Text.Outline
                styleColor: "steelblue"
                anchors.centerIn: parent
            }
            MouseArea{
                enabled: parent.enabled
                hoverEnabled: parent.enabled
                anchors.fill: parent
                onEntered: {
                    rating_scene.color = Qt.rgba(255/255,222/255,0/255,0.5)
                }
                onExited: {
                    rating_scene.color = chengwuGrey
                }
                onClicked: {
                    /* 调用 待评分 列表框*/
                    to_rate_pop_up.open()

                }

            }
        }
        ListModel{
            id : rating_model
        }



        Popup{
            id : to_rate_pop_up
            width: 200
            height: 200
            anchors.centerIn: first_window_form
            // enabled: parent.enabled
            // visible: parent.visible
            ListView {
                id:rating_list
                width: 200  // ListView 的宽度
                height: 200 // ListView 的高度
                snapMode: ListView.SnapOneItem // 确保一次只展示一个项目
                clip: true
                boundsBehavior: ListView.StopAtBounds
                orientation: ListView.Horizontal // 水平滚动
                interactive: true
                anchors.centerIn: parent
                model: rating_model
                delegate: Item {
                    width: 200 // 每个项目的宽度，确保与 ListView 的宽度一致
                    height: rating_list.height // 每个项目的高度

                    Rectangle {
                        id : show_rate_detail_rec
                        width: 200
                        height: rating_list.height
                        color: Qt.rgba(1,1,1,0.5)
                        border.color: "steelblue"
                        border.width: 2
                        Column {
                            width: parent.width
                            height: parent.height
                            spacing: 0
                            Text {
                                font.pixelSize: 20
                                color: "white"
                                font.family: "楷体"
                                text: point_name
                                style: Text.Outline
                                styleColor: "steelblue"
                                x: show_rate_detail_rec.x + (show_rate_detail_rec.width - width) / 2
                                y: show_rate_detail_rec.y
                            }

                            Text {
                                font.pixelSize: 20
                                color: "white"
                                font.family: "楷体"
                                text: "历史评分: " + score
                                style: Text.Outline
                                styleColor: "steelblue"
                                x: show_rate_detail_rec.x + (show_rate_detail_rec.width - width) / 2
                                y: show_rate_detail_rec.y
                            }

                            Text {
                                font.pixelSize: 20
                                color: "white"
                                font.family: "楷体"
                                text: "历史评分人数: " + people_num
                                style: Text.Outline
                                styleColor: "steelblue"
                                x: show_rate_detail_rec.x + (show_rate_detail_rec.width - width) / 2
                                y: show_rate_detail_rec.y
                            }

                            StarRating {
                                id: rated_star
                                starCount: score
                                editable: false
                                //anchors.horizontalCenter: parent.horizontalCenter
                                //anchors.top: Text.bottom
                                //anchors.topMargin: 10

                            }
                            Rectangle{
                                id : rate_button
                                width: 200
                                height: 90
                                color: "transparent"
                                border.color: "steelblue"
                                Button{
                                    Text {
                                        font.pixelSize: 30
                                        color: "white"
                                        font.family: "楷体"
                                        text: qsTr("点击此处评分:")
                                        style: Text.Outline
                                        styleColor: "steelblue"
                                        anchors.centerIn: parent
                                    }
                                    width: parent.width
                                    height: parent.height
                                    MouseArea{
                                        anchors.fill: parent
                                    }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("开始评分!")
                                        to_rate_pop_up.close()
                                        rating_pop_up.open()
                                    }
                                }

                            }
                        }
                    }
                }

                // Optional: Adjust the contentWidth to ensure smooth scrolling
                contentWidth: width * model.count

                onMovementEnded:{
                    currentIndex = rating_list.contentX/rating_list.width

                }
            }

        }

        Popup{
            id : rating_pop_up
            anchors.centerIn: first_window_form
            Column{
                spacing: 5
                Text {
                    font.pixelSize: 20
                    color: "white"
                    font.family: "楷体"
                    text: "为当前景点打个星吧："
                    style: Text.Outline
                    styleColor: "steelblue"
                    //x: rating_pop_up.x + (rating_pop_up.width - width) / 2

                }
                StarRating{
                    id : new_rate
                    backgroundColor: "white"
                }
                Rectangle{
                    width: 200
                    height: 20
                    color: "transparent"
                    border.color: "steelblue"
                    Text {
                        font.pixelSize: 20
                        color: "white"
                        font.family: "楷体"
                        text: qsTr("确定")
                        style: Text.Outline
                        styleColor: "steelblue"
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("评分成功!")
                            //to_rate_pop_up.open()

                            /*更新显示数据*/
                            var currItem = rating_model.get(rating_list.currentIndex)
                            currItem.people_num += 1
                            currItem.score = ((currItem.score * (currItem.people_num - 1) + new_rate.starCount) / currItem.people_num)
                            currItem.score = Math.floor(currItem.score * 10) / 10
                            var curItem_key = database.get_point_key(currItem.point_name)
                            database.add_score(curItem_key, currItem.score)

                            rate_success_instruction.open()
                            rating_pop_up.close()
                        }
                    }
                }
            }
        }
        // Timer {
        //         interval: 100
        //         running: true
        //         repeat: true
        //         onTriggered: {
        //             // Update the visibleIndex based on horizontal scroll
        //             var visibleIndex = Math.floor(rating_list.contentX / rating_list.delegate.width);
        //             if (visibleIndex >= 0 && visibleIndex < myModel.count) {
        //                 rating_list.currentIndex = visibleIndex;
        //             }
        //         }
        //     }
        Popup{
            id: rate_success_instruction
            width: 120
            height: 80
            modal: true
            visible: false
            enabled: parent.enabled
            anchors.centerIn: first_window_form
            padding: 0
            Rectangle{
                id: rate_success_rec
                width: rate_success_instruction.width
                height: rate_success_instruction.height
                MouseArea{
                    anchors.fill: rate_success_instruction

                }

                Text{
                    id : rate_success_text
                    font.family: "楷体"
                    font.pointSize : 20
                    color: "white"
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "评分成功!"
                    x : rate_success_rec.x + (rate_success_rec.width - rate_success_text.width) / 2
                }

                Button{
                    width: 80
                    height: 40
                    id: rate_success_instruction_button
                    anchors.top: rate_success_text.bottom
                    anchors.topMargin: 5
                    Text{
                        font.family: "楷体"
                        font.pointSize : 20
                        color: "white"
                        style: Text.Outline
                        styleColor: "steelblue"
                        text: "OK"
                        anchors.centerIn: rate_success_instruction_button
                    }

                    x : rate_success_rec.x + (rate_success_rec.width - rate_success_instruction_button.width) / 2
                    //anchors.bottom: add_success_rec.bottom
                    //anchors.topMargin: 0
                    onClicked: {
                        rate_success_instruction.close()
                        to_rate_pop_up.open()
                    }
                }

            }

            Overlay.modal: Rectangle {
                color: chengwuGrey
            }
            closePolicy:Popup.CloseOnPressOutside
        }

    }
    Button{
        id: disable_button
        width:100
        height: 50
        Text{
            id:disable_button_text
            font.pixelSize: 20
            font.family: "楷体"
            color: "white"
            style: Text.Outline
            styleColor: "steelblue"
            text: qsTr("游客访问")
            anchors.centerIn: parent
        }



        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom : parent.bottom
        onClicked: {
            disable_button_text.text = disable_button_text.text === "游客访问" ? "管理员访问" : "游客访问"
            first_window_form.visible = !first_window_form.visible;
            first_window_form.enabled = !first_window_form.enabled;
            second_window_form.visible = !second_window_form.visible;
            second_window_form.enabled = !second_window_form.enabled;
            /*max_point_key++;*/
            console.log("当前最大点为：" + root.max_point_key)
            console.log("init_max_key: " + pointsGenarating.init_point_key)
        }

    }


}
