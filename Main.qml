
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
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
    property var tempobject2: []//临时储存点
    property var temppointnum
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

        ListModel{
            id: pointsMod
        }
        ListModel {
            id: pathsMod
        }
        Component.onCompleted: {
            var max_point_key=database.get_max_valid_point_key_from_points();

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
        }


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
                font.family: "华文彩云"
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


                point_x: pointsMod.get(index).point_addr_x // 使用当前元素的 point_x

                point_y: pointsMod.get(index).point_addr_y // 使用当前元素的 point_y


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
                font.family: "华文彩云"
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
            width: 130
            height: 40
            modal: true
            visible: parent.visible && second_window_form.add_button_success
            enabled: parent.enabled
            anchors.centerIn: second_window_form
            padding: 0
            Rectangle{
                id: add_success_rec
                width: add_success_instruction.width
                height: add_success_instruction.height
                Text{
                    id : add_success_text
                    font.family: "华文彩云"
                    color: "white"
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "添加成功!"
                    x : add_success_rec.x + (add_success_rec.width - add_success_text.width) / 2
                }
                MouseArea{
                    anchors.fill: add_success_instruction

                }
                Button{
                    id: add_success_instruction_button
                    text: "OK"
                    x : add_success_rec.x + (add_success_rec.width - add_success_instruction_button.width) / 2
                    anchors.top: add_success_text.bottom
                    anchors.topMargin: 0
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
            width: 50
            height: 40
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
                    font.family: "华文彩云"
                    color: "white"
                    x : delete_finish_instruction_rec.x + (delete_finish_instruction_rec.width - delete_finish_text.width) / 2
                    style: Text.Outline
                    styleColor: "steelblue"
                    text: "删除成功!"
                }
                MouseArea{
                    anchors.fill: delete_finish_instruction

                }
                Button{
                    id: delete_finish_instruction_button
                    text: "OK"
                    x : delete_finish_instruction_rec.x + (delete_finish_instruction_rec.width - delete_finish_instruction_button.width) / 2
                    anchors.top: delete_finish_text.bottom
                    anchors.topMargin: 0
                    onClicked: {
                        delete_finish_instruction.close()
                    }
                }
            }

            Overlay.modal: Rectangle {
                color: chengwuGrey
            }
        }

        Popup{
            id: delete_instruction
            width: 130
            height: 40
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
                    font.family: "华文彩云"
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
                    text: "OK"
                    x : delete_instruction_rec.x + (delete_instruction_rec.width - delete_instruction_button.width) / 2
                    anchors.top: delete_text.bottom
                    anchors.topMargin: 0
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
        Rectangle{
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
                font.family: "华文彩云"
                style: Text.Outline
                styleColor: "steelblue"
                text: qsTr("删除景点")
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



        Rectangle{
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
                font.family: "华文彩云"
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
                    each_option_right.color = qiuguiYellow
                }
                onExited: {
                    each_option_right.color = chengwuGrey
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
        // Image {
        //     id: unnamed2
        //     anchors.fill: parent
        //     source: "file:D:/Documents/QTDocuments/test_for_history_edit/TestImage.jpg"
        // }
        // MagicPool {
        //         id: magicPool
        //         visible: parent.visible
        //         enabled: parent.enabled
        //         anchors.fill: parent
        //         // Component.onCompleted: randomMove();

        //         // function randomMove() {
        //         //     var r_x = Math.random() * width;
        //         //     var r_y = Math.random() * height;
        //         //     magicPool.moveFish(r_x, r_y, false);
        //         // }

        //         Timer {
        //             interval: 1500
        //             repeat: true
        //             running: true
        //             onTriggered: {
        //                 //if (Math.random() > 0.6 && !magicPool.moving) magicPool.randomMove();
        //             }
        //         }

        //         MouseArea {
        //             enabled: parent.enabled && !inputField.activeFocus
        //             anchors.fill: parent
        //             onClicked: magicPool.moveFish(mouse.x, mouse.y, true);
        //         }
        // }

        ButtonWithComponent{
            id:myButton
            originalX:100
            originalY:100
            nameContext: "武汉大学"
            infoContext1: "介绍1"
            infoContext2: "介绍2"
            infoContext3: "介绍3"
            imageSource:"path/example.png"
        }


        Label {
            id: road_text_label
            visible: false
            Text{
                font.family: "华文彩云"
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
            font.family: "华文彩云"
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
                        font.family: "华文彩云"
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
                                if (component1.status === Component.Ready) {
                                    tempobject1[j]= component1.createObject(parent,{sx:temppointxy1.addr_x,
                                                                                sy:temppointxy1.addr_y,
                                                                                ex:temppointxy2.addr_x,
                                                                                ey:temppointxy2.addr_y});
                                }

                            }
                            clicknum1+=1
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
                    id:allpath_search
                    Text{
                        font.family: "华文彩云"
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
                        console.log(start_pos.cur_chosen_point + " " + end_pos.cur_chosen_point)
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
                font.family: "华文彩云"
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
                font.family: "华文彩云"
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
                font.family: "华文彩云"
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
                            font.family: "华文彩云"
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
                font.family: "华文彩云"
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
    }

    Button{
        id: disable_button
        width:100
        height: 50
        Text{
            id:disable_button_text
            font.pixelSize: 20
            font.family: "华文彩云"
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
            console.log("当前最大点数目为：" + max_point_key)
            console.log("init_max_key: " + pointsGenarating.init_point_key)
        }

    }

}
