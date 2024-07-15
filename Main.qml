
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtMultimedia
import QtQuick.Effects
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
    property var tempcolor: ["#E3170D","#9C661F","#FF8000","#A020F0","#DA70D6","#00C78C","#C76114","#228B22","#03A89E"]
    property int max_point_key : database.get_max_valid_point_key_from_points()
    property var tempobject1: []
    property var tempobject2: []
    property var tempobject3: [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    property var tempobject4: [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]//临时储存点
    property var tempobject5: [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    property var tempobject6: [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    property var temppointnum
    property var temppointnum2
    property var temppointallnum
    property int choosen_del_point_index: -1


    property int i1: 0
    property int j1: 0
    property int k1: 0
    property var kk: [0,0]


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
    onTemppointnum2Changed: {
        path_cho.selective_model.clear()
        for (var i = 0; i < temppointnum2; i++) {
            path_cho.selective_model.append({ "text": "路径"+i })
        }
        path_cho.selective_model.append({ "text": "全部路径" })
    }
    Rectangle{
        id: second_window_form
        visible: false
        enabled: false
        width: parent.width
        height: parent.height
        Image {
            id: myImage
            anchors.centerIn: parent
            source: "file:///D:/QTproject/new/Navigation_of_WHU/ditu.jpg"
        }
        property bool delete_button_pressed: false
        property bool delete_button_success: false
        property bool delete_road_success: false
        property bool add_button_success: false
        property bool point_is_onrelease:false
        property bool start_to_add_point: false

        property int path_num

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
        Image {
            width: 1000
            height: 700
            //opacity: 0.2
            fillMode: Image.PreserveAspectFit
            id: graph_image_sec
            anchors.centerIn: parent
            //source: "file:///C:/Users/Administrator/Desktop/graphImage.jpg" // 0%
            //source: "file:///D:/Downloads/20240714220422.png" // 50%
            //source: "file:///D:/Downloads/20240714220353.png" // 66%
            source: "file:///D:/Downloads/20240714221015.png"
            //source: "file:///D:/Downloads/20240714220726.png" // 80%
        }
        MultiEffect {
             source: graph_image_sec
             anchors.fill: graph_image_sec
             brightness: -0.4
             saturation: 0

             //contrast: 0.5

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
                                            "start_point_key":i,
                                            "end_point_key":j,
                                            "end_point_name":database.get_point_name(j),
                                            "start_point_add":Qt.point(start_x,start_y),
                                            "end_point_add":Qt.point(end_x,end_y)
                                        })
                    }
                }
            }
            console.log("pointMod count " + pointsMod.count)
            console.log("path.count"+pathsMod.count)

        }



        Canvas {
            id: second_path_canvas
            anchors.fill: parent
            property int clicked_count: 0

            onPaint: {
                var ctx = getContext("2d");
                ctx.strokeStyle = shuangyeRed;//颜色调整
                ctx.lineWidth = 5;//路径宽度
                second_window_form.path_num = pathsMod.count
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

            model:pointsMod
            // x : index * 80
            // Triggerable_Button{
            //     anchors.fill: parent

            //     button_text: index

            // }

            delegate: Triggerable_Button{


                index_of_point :pointsMod.get(index).point_key
                button_text: pointsMod.get(index).point_key
                //anchors.left: parent.left
                //anchors.leftMargin: index * 40


                point_x: pointsMod.get(index).point_addr_x-15// 使用当前元素的 point_x

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
                var sprite = component.createObject(root, {x: 0, y: 0});

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
                        second_window_form.start_to_add_point=true
                        second_window_form.add_button_success=true
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
            property int max_point_num: delete_finish_instruction.max_point_num=pointsMod.count

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
                        console.log("初始路数：：：："+second_window_form.path_num)
                        // console.log("初始路数"+delete_finish_instruction.max_path_num)
                        var del_point_name=database.get_point_name(choosen_del_point_index)

                        delete_finish_instruction.close()
                        for(var i=0;i<delete_finish_instruction.max_point_num;i++)
                        {
                            if(pointsMod.get(i).point_key===choosen_del_point_index)
                            {
                                pointsMod.remove(i)
                            }
                        }
                        database.del_point(del_point_name)
                        console.log(choosen_del_point_index)

                        for(var z=second_window_form.path_num-1;z>-1;z--)
                        {
                            console.log("当前下标"+z)
                            console.log("各个起点"+pathsMod.get(z).start_point_name)
                            console.log("各个终点"+pathsMod.get(z).end_point_name)
                        }
                        for(var j=second_window_form.path_num-1;j>-1;j--)
                        {
                            if(pathsMod.get(j) !== undefined && pathsMod.get(j).start_point_name===del_point_name)
                            {
                                console.log("被删除的起点："+pathsMod.get(j).start_point_name+","+del_point_name)
                                var del_road_name=pathsMod.get(j).road_name
                                console.log("删除的路线名"+del_road_name)


                                pathsMod.remove(j)
                                console.log("起点下标"+j)
                                database.del_road(del_road_name)
                                // console.log(delete_finish_instruction.max_path_num)
                            }
                            if(pathsMod.get(j) !== undefined&&pathsMod.get(j).end_point_name===del_point_name)
                                //if(pathsMod.get(j).end_point_key==choosen_del_point_index)
                            {
                                console.log("被删除的重点："+pathsMod.get(j).start_point_name+","+del_point_name)
                                //var del_road_name_two=pathsMod.get(j).road_name
                                console.log("终点下标"+j)

                                pathsMod.remove(j)
                            }
                        }
                        console.log("删除完成后路的数量"+pathsMod.count)
                        console.log("原本路数"+second_window_form.path_num)
                        var ctx_1=second_path_canvas.getContext("2d")
                        ctx_1.clearRect(0,0,second_path_canvas.width,second_path_canvas.height)
                        second_path_canvas.requestPaint()
                        var ctx_2=path_canvas.getContext("2d")
                        ctx_2.clearRect(0,0,path_canvas.width,path_canvas.height)
                        path_canvas.requestPaint()
                        console.log("被删除的点"+choosen_del_point_index)


                        //修改listmodel中的信息

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
            visible: second_window_form.point_is_onrelease&&second_window_form.start_to_add_point
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
                    second_window_form.add_button_success=false
                    second_window_form.point_is_onrelease=false
                    second_window_form.start_to_add_point=false

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
                    second_window_form.delete_button_pressed=false
                    second_window_form.delete_button_success=false
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
                    console.log(new_start_name+"   "+new_end_name)

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
                        pathsMod.append({
                                            "road_key":road_max_key+1,
                                            "road_name":road_name,
                                            "road_length":road_length,
                                            "start_point_name":database.get_point_name(road_end_key),
                                            "end_point_name":database.get_point_name(road_start_key),
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
        Popup{//有误提示弹窗
            id:not_del_road_success
            width: 400
            height:200
            visible: false
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: not_del_road_success_rec
                width: not_del_road_success.width
                height: not_del_road_success.height

                Text {
                    id: not_del_road_success_text
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
                    id: not_del_road_success_button
                    text: "OK"
                    width:80
                    height:40
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        not_del_road_success.close()
                    }
                }

            }
        }

        Popup{//删除路径
            id:delete_road_start
            width: 400
            height: 200
            modal: true
            visible: parent.visible && second_window_form.delete_road_success
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: delete_road_rec
                width: delete_road_start.width
                height: delete_road_start.height
                Text{
                    id : delete_road_text
                    color: "white"
                    font.family: "楷体"
                    font.pointSize : 20
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "请输入你要删除的路径信息:"
                    x : delete_road_rec.x + (delete_road_rec.width - delete_road_text.width) / 2
                }
                MouseArea{
                    anchors.fill: delete_road_start

                }
                Text {
                    id: del_road_start
                    font.family: "楷体"
                    color: "white"
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "起点编号："
                    font.pointSize: 20
                    x : delete_road_rec.x
                    y:delete_road_text.y + delete_road_text.height+15
                }
                TextField{
                    id:input_del_road_start
                    visible: parent.visible
                    enabled: parent.enabled
                    width: 250
                    height:add_road_name.hight
                    x:del_road_start.width+delete_road_rec.x+10
                    y:delete_road_text.y + delete_road_text.height+20
                    background: Rectangle {
                        radius: 4
                        border.color: "steelblue"
                    }
                }
                Text {
                    id: del_road_end
                    font.family: "楷体"
                    color: "white"
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "终点编号："
                    font.pointSize: 20
                    x : delete_road_rec.x
                    y:input_del_road_start.y+input_del_road_start.height+25
                }
                TextField{
                    id:input_del_road_end
                    visible: parent.visible
                    enabled: parent.enabled
                    width: 250
                    height:add_road_name.hight
                    x:del_road_start.width+delete_road_rec.x+10
                    y:input_del_road_start.y+input_del_road_start.height+30
                    background: Rectangle {
                        radius: 4
                        border.color: "steelblue"
                    }
                }
                Button{
                    id: delete_road_button
                    width: 80
                    height: 40
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        font.family: "楷体"
                        font.pointSize : 20
                        color: "white"
                        style: Text.Outline
                        styleColor: "steelblue"
                        text: "OK"
                        anchors.centerIn: delete_road_button
                    }

                    onClicked: {
                        var del_road_start_key=input_del_road_start.text
                        var del_road_end_key=input_del_road_end.text
                        var del_road_key=database.get_road_key(del_road_start_key,del_road_end_key)
                        // var del_road_key_two=database.get_road_key(del_road_end_key,del_road_start_key)
                        //console.log(del_road_start_key+","+del_road_end_key)
                        //console.log("删除路key"+del_road_key)
                        var start_point_map=database.get_address_of_point(del_road_start_key);
                        var del_start_x=start_point_map["addr_x"];
                        var del_start_y=start_point_map["addr_y"];
                        var end_point_map=database.get_address_of_point(del_road_end_key);
                        var del_end_x=end_point_map["addr_x"];
                        var del_end_y=end_point_map["addr_y"];
                        if(del_road_key!==-1)
                        {
                            for(var i=pathsMod.count-1;i>-1;i--)
                            {
                                console.log("当前路key"+pathsMod.get(i).road_key)
                                if(pathsMod.get(i).road_key===del_road_key)
                                {
                                    pathsMod.remove(i)
                                    return;
                                }
                            }
                            database.del_road(database.get_road_name(del_road_key))
                            var ctx_1=second_path_canvas.getContext("2d")
                            ctx_1.clearRect(0,0,second_path_canvas.width,second_path_canvas.height)
                            second_path_canvas.requestPaint()
                            var ctx_2=path_canvas.getContext("2d")
                            ctx_2.clearRect(0,0,path_canvas.width,path_canvas.height)
                            path_canvas.requestPaint()
                        }
                        else{
                            not_del_road_success.visible=true

                        }

                        delete_road_start.close()

                        second_window_form.delete_road_success=false
                    }
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
                    second_window_form.delete_road_success=true



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
        /* Image {
               id: first_myImage
               anchors.centerIn: parent
               source: "file:///D:/QTproject/new/Navigation_of_WHU/ditu.jpg"
           }*/
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

        Image {
            width: 1000
            height: 700
            //opacity: 0.2
            fillMode: Image.PreserveAspectFit
            id: graph_image_fir
            anchors.centerIn: parent
            //source: "file:///C:/Users/Administrator/Desktop/graphImage.jpg" // 0%
            //source: "file:///D:/Downloads/20240714220422.png" // 50%
            //source: "file:///D:/Downloads/20240714220353.png" // 66%
            source: "file:///" + appDir + "/20240714221015.png"
            //source: "file:///D:/Downloads/20240714220726.png" // 80%
        }
        MultiEffect {
             source: graph_image_fir
             anchors.fill: graph_image_fir
             brightness: -0.4
             saturation: 0

             //contrast: 0.5

         }
        Repeater{
            id : pointsGenarating_fir
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
        Repeater{
            id : first_pointsGenarating
            //property int init_point_key: init_point_key = root.max_point_key

            model:pointsMod
            // x : index * 80
            // Triggerable_Button{
            //     anchors.fill: parent

            //     button_text: index

            // }

            delegate: Triggerable_Button{


                index_of_point :pointsMod.get(index).point_key
                button_text: pointsMod.get(index).point_key
                //anchors.left: parent.left
                //anchors.leftMargin: index * 40


                point_x: pointsMod.get(index).point_addr_x-15// 使用当前元素的 point_x

                point_y: pointsMod.get(index).point_addr_y-15 // 使用当前元素的 point_y
            }
        }


        /*Label {
            id: road_text_label
            visible: false
            Text{
                font.family: "楷体"
                color: "white"
                style: Text.Outline
                styleColor: "steelblue"

            }

            background: Rectangle {
                width: road_text_label.width + 10; height: road_text_label.height + 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 1.0; color: "lightblue" }
                }
            }
        }*/
        Popup{
            id:road_text
            width: 200
            height: 110
            visible: false
            Rectangle {
                id : show_road_text_rec
                anchors.centerIn: parent
                width: 200
                height: 110
                color: Qt.rgba(1,1,1,0.5)
                border.color: "steelblue"
                border.width: 2
                Column {
                    //spacing: 10
                    width: parent.width
                    height: parent.height
                    spacing: 6
                    Text {
                        id: show_road_name
                        font.pixelSize: 20
                        color: "white"
                        font.family: "楷体"
                        style: Text.Outline
                        styleColor: "steelblue"
                        x: show_road_text_rec.x + (show_road_text_rec.width - width) / 2
                        y: show_road_text_rec.y+5
                    }
                    Text {
                        id:show_road_length
                        font.pixelSize: 20
                        color: "white"
                        font.family: "楷体"

                        style: Text.Outline
                        styleColor: "steelblue"
                        x: show_road_text_rec.x + (show_road_text_rec.width - width) / 2
                        y: show_road_text_rec.y
                    }
                    Text{
                        id:show_road_start
                        font.pixelSize: 20
                        color: "white"
                        font.family: "楷体"
                        style: Text.Outline
                        styleColor: "steelblue"
                        x: show_road_text_rec.x + (show_road_text_rec.width - width) / 2
                        y: show_road_text_rec.y

                    }
                    Text{
                        id:show_road_end
                        font.pixelSize: 20
                        color: "white"
                        font.family: "楷体"
                        style: Text.Outline
                        styleColor: "steelblue"
                        x: show_road_text_rec.x + (show_road_text_rec.width - width) / 2
                        y: show_road_text_rec.y

                    }

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
                                road_text.x = mouseX + 10;
                                road_text.y = mouseY - road_text.height - 10;
                                road_text.visible = true;

                                /*road_text_label.text = "路名: " + pathsMod.get(i).road_name +
                                        "\n长度: " + pathsMod.get(i).road_length +"米"+
                                        "\n起点: " + pathsMod.get(i).start_point_name +
                                        "\n终点: " + pathsMod.get(i).end_point_name;*/
                                show_road_name.text="路名:"+pathsMod.get(i).road_name
                                show_road_length.text="长度:"+pathsMod.get(i).road_length +"米"
                                show_road_start.text="起点:"+pathsMod.get(i).start_point_name
                                show_road_end.text="终点:"+pathsMod.get(i).end_point_name
                                return;
                            }
                            else{
                                road_text.visible=false
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
        SelectiveBox{
            id:path_cho
            width: 150
            height: 30
            y:0
            x:500
            selective_model: ListModel{}
        }
        Timer{
            id:timer1
            interval: 1000
            repeat: true
            running:false
            triggeredOnStart: true
            onTriggered: {
                var tempstartpoint=database.get_point_key(start_pos.cur_chosen_point)
                var tempendpoint=database.get_point_key(end_pos.cur_chosen_point)
                var shortest_point_key=database.inquire_shortest_road(tempstartpoint,tempendpoint)
                console.log(tempstartpoint+" "+tempendpoint)
                temppointnum=shortest_point_key.length-1
                if(i1<temppointnum){
                    var temppointxy11=database.get_address_of_point(shortest_point_key[i1].point_key)
                    var temppointxy22=database.get_address_of_point(shortest_point_key[i1+1].point_key)
                    console.log(shortest_point_key[i1].point_key+":"+temppointxy11.addr_x+","+temppointxy11.addr_y)
                    console.log(shortest_point_key[i1+1].point_key+":"+temppointxy22.addr_x+","+temppointxy22.addr_y)
                    var component2 = Qt.createComponent("shortestpath_animation.qml");
                    if (component2.status === Component.Ready) {
                        tempobject2[i1]= component2.createObject(parent,{startx:temppointxy11.addr_x,
                                                                    starty:temppointxy11.addr_y,
                                                                    endx:temppointxy22.addr_x,
                                                                    endy:temppointxy22.addr_y,
                                                                    tc:tempcolor[8]});
                    }
                    i1+=1
                }
                if(j1<temppointnum){
                    var temppointxy1=database.get_address_of_point(shortest_point_key[j1].point_key)
                    var temppointxy2=database.get_address_of_point(shortest_point_key[j1+1].point_key)
                    console.log(shortest_point_key[j1].point_key+":"+temppointxy1.addr_x+","+temppointxy1.addr_y)
                    console.log(shortest_point_key[j1+1].point_key+":"+temppointxy2.addr_x+","+temppointxy2.addr_y)
                    var component1 = Qt.createComponent("shortestpath_line.qml");
                    if (component1.status === Component.Ready){
                        tempobject1[j1]= component1.createObject(parent,{sx:temppointxy1.addr_x,
                                                                    sy:temppointxy1.addr_y,
                                                                    ex:temppointxy2.addr_x,
                                                                    ey:temppointxy2.addr_y,
                                                                    tc:tempcolor[3]});
                        if((temppointxy1.addr_x-temppointxy2.addr_x)>0){
                            tempobject1[j1].transformOrigin="BottomRight"
                        }
                    }
                    j1+=1
                }
            }
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
                        timer1.restart()
                        clicknum1+=1
                    }
                }
                else{
                    for(var k=0;k<temppointnum;k++){
                        tempobject1[k].opacity=0
                        tempobject2[k].opacity=0
                    }
                    clicknum1=0
                    timer1.stop()
                    i1=0
                    j1=0
                }

            }
        }
        Timer{
            id:timer2
            interval: 1000
            repeat: true
            running:false
            triggeredOnStart: true
            onTriggered: {
                var tempstartpoint=database.get_point_key(start_pos.cur_chosen_point)
                var tempendpoint=database.get_point_key(end_pos.cur_chosen_point)
                var all_point_key=database.inquire_all_roads(tempstartpoint,tempendpoint)
                if(k1<temppointnum2){
                    temppointallnum=all_point_key[k1].length-1
                    if(kk[0]===temppointallnum){
                        timer3.restart()
                        k1+=1
                        kk[0]=0
                    }
                    else if(k1===0){
                        timer3.restart()
                    }
                }
                else if(k1===temppointnum2){
                    timer3.stop()
                }
            }
        }
        Timer{
            id:timer3
            interval: 1000
            repeat: true
            running:false
            triggeredOnStart: true
            onTriggered: {
                var tempstartpoint=database.get_point_key(start_pos.cur_chosen_point)
                var tempendpoint=database.get_point_key(end_pos.cur_chosen_point)
                var all_point_key=database.inquire_all_roads(tempstartpoint,tempendpoint)
                if(kk[0]<temppointallnum){
                    var temppointxy11=database.get_address_of_point(all_point_key[k1][kk[0]])
                    var temppointxy22=database.get_address_of_point(all_point_key[k1][kk[0]+1])
                    var component2 = Qt.createComponent("shortestpath_animation.qml");
                    if (component2.status === Component.Ready) {
                        tempobject3[k1][kk[0]]= component2.createObject(parent,{startx:temppointxy11.addr_x,
                                                                       starty:temppointxy11.addr_y,
                                                                       endx:temppointxy22.addr_x,
                                                                       endy:temppointxy22.addr_y,
                                                                       tc:tempcolor[k1+2]});
                    }
                    var temppointxy1=database.get_address_of_point(all_point_key[k1][kk[0]])
                    var temppointxy2=database.get_address_of_point(all_point_key[k1][kk[0]+1])
                    var component1 = Qt.createComponent("shortestpath_line.qml");
                    if (component1.status === Component.Ready){
                        tempobject4[k1][kk[0]]= component1.createObject(parent,{sx:temppointxy1.addr_x,
                                                                       sy:temppointxy1.addr_y,
                                                                       ex:temppointxy2.addr_x,
                                                                       ey:temppointxy2.addr_y,
                                                                       tc:tempcolor[k1]});
                        if((temppointxy1.addr_x-temppointxy2.addr_x)>0){
                            tempobject4[k1][kk[0]].transformOrigin="BottomRight"
                        }
                    }
                    kk[0]+=1
                }
            }
        }
        Timer{
            id:timer4
            interval: 1000
            repeat: true
            running:false
            triggeredOnStart: true
            onTriggered: {
                var tempstartpoint=database.get_point_key(start_pos.cur_chosen_point)
                var tempendpoint=database.get_point_key(end_pos.cur_chosen_point)
                var all_point_key=database.inquire_all_roads(tempstartpoint,tempendpoint)
                temppointallnum=all_point_key[path_cho.cur_chosen_key].length-1
                if(kk[0]<temppointallnum){
                    var temppointxy11=database.get_address_of_point(all_point_key[path_cho.cur_chosen_key][kk[0]])
                    var temppointxy22=database.get_address_of_point(all_point_key[path_cho.cur_chosen_key][kk[0]+1])
                    var component2 = Qt.createComponent("shortestpath_animation.qml");
                    if (component2.status === Component.Ready) {
                        tempobject5[path_cho.cur_chosen_key][kk[0]]= component2.createObject(parent,{startx:temppointxy11.addr_x,
                                                                       starty:temppointxy11.addr_y,
                                                                       endx:temppointxy22.addr_x,
                                                                       endy:temppointxy22.addr_y,
                                                                       tc:tempcolor[k1+2]});
                    }
                    var temppointxy1=database.get_address_of_point(all_point_key[path_cho.cur_chosen_key][kk[0]])
                    var temppointxy2=database.get_address_of_point(all_point_key[path_cho.cur_chosen_key][kk[0]+1])
                    var component1 = Qt.createComponent("shortestpath_line.qml");
                    if (component1.status === Component.Ready){
                        tempobject6[path_cho.cur_chosen_key][kk[0]]= component1.createObject(parent,{sx:temppointxy1.addr_x,
                                                                       sy:temppointxy1.addr_y,
                                                                       ex:temppointxy2.addr_x,
                                                                       ey:temppointxy2.addr_y,
                                                                       tc:tempcolor[path_cho.cur_chosen_key]});
                        if((temppointxy1.addr_x-temppointxy2.addr_x)>0){
                            tempobject6[path_cho.cur_chosen_key][kk[0]].transformOrigin="BottomRight"
                        }
                    }
                    kk[0]+=1
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
                        path_cho.visible = !path_cho.visible
                        var tempstartpoint=database.get_point_key(start_pos.cur_chosen_point)
                        var tempendpoint=database.get_point_key(end_pos.cur_chosen_point)
                        var all_point_key=database.inquire_all_roads(tempstartpoint,tempendpoint)
                        temppointnum2=all_point_key.length
                        clicknum2+=1
                    }
                }
                else{
                    if(start_pos.cur_chosen_point!==""&&end_pos.cur_chosen_point!==""){
                        path_cho.visible = !path_cho.visible
                        for(var t=0;t<temppointallnum;t++){
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
                        timer2.stop()
                        timer3.stop()
                        k1=0
                    }
                }
            }
        }
        Button{
            property int clicknum3: 0
            id:allpath_search_for
            Text{
                font.family: "楷体"
                font.pixelSize: 20
                style: Text.Outline
                styleColor: "steelblue"
                color: "white"
                anchors.centerIn: parent
                text: qsTr("显示")
            }
            visible: start_pos.visible
            enabled: start_pos.enabled
            width: 140
            height: 30
            y : 60
            anchors.left: end_pos.right
            anchors.leftMargin: 20
            onClicked: {
                if(clicknum3===0){
                    if(start_pos.cur_chosen_point!==""&&end_pos.cur_chosen_point!==""){
                        if(path_cho.cur_chosen_point==="全部路径"){
                            kk[0]=0
                            timer2.start()
                            clicknum3+=1
                        }
                        else if(path_cho.cur_chosen_point===""){kk[0]=0}
                        else {
                            kk[0]=0
                            timer4.restart()
                            clicknum3+=1
                        }
                    }
                }
                else{
                    if(start_pos.cur_chosen_point!==""&&end_pos.cur_chosen_point!==""){
                        for(var o=0;o<temppointnum2;o++){
                            for(var l=0;l<20;l++){
                                if(tempobject3[o][l]!==undefined){
                                    tempobject3[o][l].opacity=0
                                }
                                if(tempobject4[o][l]!==undefined){
                                    tempobject4[o][l].opacity=0
                                }
                            }
                        }
                        for(var t=0;t<temppointnum2;t++){
                            for(var p=0;p<20;p++){
                                if(tempobject6[t][p]!==undefined){
                                    tempobject6[t][p].opacity=0
                                }
                                if(tempobject5[t][p]!==undefined){
                                    tempobject5[t][p].opacity=0
                                }
                            }
                        }
                        clicknum3=0
                        timer2.stop()
                        timer3.stop()
                        timer4.stop()
                        k1=0
                    }
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
            second_window_form.delete_button_success=false
            second_window_form.delete_button_pressed=false
            second_window_form.delete_road_success=false
            //second_window_form.add_button_success=false
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
