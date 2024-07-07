import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
//import an.utility
/*----------------------------------------------------------------------------------------------------------------------------------*/
import "D:/Documents/QTDocuments/testForDataBase/Triggerable_Button.qml"
import "D:/Documents/QTDocuments/testForDataBase/SelectiveBox.qml"
/*----------------------------------------------------------------------------------------------------------------------------------*/
import com.database 1.0


Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("WuHan Univerity Guide")
    /* 通过交换控件的位置来避免 事件冲突 */
    property color chuntengPurple: Qt.rgba(51/255,5/255,141/255,0.5)
    property color donghuBlue: Qt.rgba(65/255,182/255,230/255,0.5)
    property color luoyingPink: Qt.rgba(248/255,163/255,188/255,0.5)
    property color qiuguiYellow: Qt.rgba(255/255,163/255,0/255,0.5)
    property color chengwuGrey: Qt.rgba(193/255,198/255,200/255,0.5)
    property color shuangyeRed: Qt.rgba(255/255,8/255,0/255,0.5)

    Rectangle{
        id: second_window_form
        visible: false
        enabled: false
        width: parent.width
        height: parent.height
        Image {
            id: unnamed1
            anchors.fill: parent
            /*-------------------------------------------------------------------------------------------------------*/
            source: "file:D:/Documents/QTDocuments/test_for_history_edit/TestImage.jpg"
            /*-------------------------------------------------------------------------------------------------------*/

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
            border.color : "blue"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top : parent.top
            Text {
                opacity: 100
                font.pixelSize: 30
                font.wordSpacing: 3
                font.family: "Georgia"
                font.pointSize: 13
                font.bold: true
                text: qsTr("Admin Operations")
                anchors.centerIn: parent
            }
        }
        Repeater{
            id : pointsGenarating
            model:5
            Triggerable_Button{
                anchors.fill: parent
                button_text: "2"

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
                text: qsTr("添加景点")
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
                }
            }
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
                text: qsTr("删除景点")
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
                    each_option_center.color = luoyingPink
                }
                onExited: {
                    each_option_center.color = chengwuGrey
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
            Image {
                id: unnamed2
                anchors.fill: parent
                source: "file:D:/Documents/QTDocuments/test_for_history_edit/TestImage.jpg"
            }
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
            TextField { // 文本输入框
                id: inputField
                visible: parent.visible
                enabled: parent.enabled
                width: 300
                height: 40
                selectByMouse: true
                font.pointSize: 12

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0 // 顶部中心
                background: Rectangle {
                   radius: 4
                   border.color: "green"
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
                x:0
                y:30

                selective_model: ListModel{

                    ListElement{ text : qsTr("武汉大学图书馆")}
                    ListElement{ text : qsTr("信息学部操场")}
                    ListElement{ text : qsTr("武汉大学桂园食堂")}
                }
            }
            SelectiveBox{
                id:end_pos
                y:30
                x:implicitWidth + 160
                selective_model: ListModel{

                    ListElement{ text : qsTr("武汉大学图书馆")}
                    ListElement{ text : qsTr("信息学部操场")}
                    ListElement{ text : qsTr("武汉大学桂园食堂")}
                }
            }
            Label{
                id : start_pos_label
                visible: end_pos.visible
                enabled: end_pos.enabled
                text: "         请输入起点：   "
                background: Rectangle {
                    width: 150; height: 30
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
                text: "                                                        请输入终点：   "
                background: Rectangle {
                    id : back
                    x : 160; y : 0
                    width: 150; height: 30
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "white" }
                        //GradientStop { position: 0.33; color: "yellow" }
                        GradientStop { position: 1.0; color: "lightblue" }
                    }
                }
            }
            Button {
                text: qsTr("搜索")
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
                height: 150
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
                            height: 20
                            color: hovered ? "#f4f4f4" : "#ddd"
                            border.color: "gray"

                            property bool hovered: false

                            Text {
                                id: displayText
                                text: display // 文本名
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                font.pixelSize: 18
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
                    text: qsTr("查找路线")
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
                    }

                }
            }
        }

    Button{
        id: disable_button
        width:100
        height: 50
        font.family: Ubuntu
        text: qsTr("游客访问")

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom : parent.bottom
        onClicked: {
            disable_button.text = disable_button.text === "游客访问" ? "管理员访问" : "游客访问"
            first_window_form.visible = !first_window_form.visible;
            first_window_form.enabled = !first_window_form.enabled;
            second_window_form.visible = !second_window_form.visible;
            second_window_form.enabled = !second_window_form.enabled;
        }

    }

}
