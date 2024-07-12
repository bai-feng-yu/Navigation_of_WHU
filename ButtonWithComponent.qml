import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "D:/Documents/QTDocuments/downloadTest/Carousel.qml"
/*
创建组件语法：
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
*/

Rectangle {
    id: sceneButton

    //未点击时按钮的尺寸
    property int originalSize:16
    //点击后按钮的尺寸
    property int afterSize:20

    //用originalx和originaly确定按钮位置
    property int originalX:0
    property int originalY:0
    // 设置较高的z值
    property int zPriority: 1000

    x:originalX
    y:originalY
    z:zPriority

    //按钮尺寸外观定义
    width: originalSize
    height: originalSize
    radius: width / 2
    color: Qt.rgba(148/255,194/255,255/255,1.0)
    border.color: Qt.rgba(1/255,94/255,82/255,0.9)
    border.width: 1.5

    //判断大弹窗是否存在
    property bool isPopupVisible: false
    //在鼠标靠近按钮一定范围内时就可以显示小弹窗
    property int hoverMargin:5

    //三个接口
    property string nameContext:"未知"//景点名字
    property string imageSource:""//图片的路径
    property string infoContext1:"暂无信息"
    property string infoContext2:""
    property string infoContext3:""//景点信息
    property var carousel_pics_model


    //点击按钮后显示的详细信息大弹窗
    Component {
        id: popupComponent
        //固定弹窗大小
        Rectangle {
            width: 400
            height: 300
            color: Qt.rgba(244/255,255/255,243/255,1.0)
            radius: 10
            border.color: Qt.rgba(20/255,4/255,110/255,0.6)
            Item{
                anchors.centerIn: parent

                width: 400
                height: 300
                Carousel{
                    anchors.fill: parent
                    delegate: Component{
                        Image {
                            anchors.fill: parent
                            source: model.url
                            asynchronous: true
                            fillMode:Image.PreserveAspectCrop
                        }
                    }
                    Layout.topMargin: 20
                    Layout.leftMargin: 5
                    Component.onCompleted: {
                        model = carousel_pics_model
                    }
                }
            }
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
                // Image {
                //     id: sceneImage
                //     source:imageSource
                //     x:10
                //     y:lineBelowTitle2.y+4
                //     width:popupComponent.width-50
                //     property real aspectRatio: 1 // 默认宽高比，将在图片加载后更新
                //     onStatusChanged: {
                //         if (status === Image.Ready) {
                //             aspectRatio = sourceSize.width / sourceSize.height;
                //             height = width / aspectRatio;
                //         }
                //     }
                //     fillMode: Image.PreserveAspectFit // 保持比例的同时填充图片
                // }


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





    //鼠标交互
    MouseArea {
        //在按钮周围即可进行交互
        width: parent.width + hoverMargin * 2
        height: parent.height + hoverMargin * 2
        x: -hoverMargin
        y: -hoverMargin
        hoverEnabled: true

        //鼠标悬浮时，显示小弹窗
        onEntered: {
            if (!isPopupVisible) {
                if (!hoverPopup) {
                    hoverPopup = placeComponent.createObject(sceneButton)
                    hoverPopup.x = sceneButton.x-hoverPopup.width/2-90
                    hoverPopup.y = sceneButton.y-125

                    sceneButton.width=afterSize
                    sceneButton.height=afterSize
                    sceneButton.radius=sceneButton.width/2

                    sceneButton.color=Qt.rgba(148/255,194/255,255/255,1.0)

                    sceneButton.x=originalX-(afterSize-originalSize)/2
                    sceneButton.y=originalY-(afterSize-originalSize)/2
                }
            }


        }

        //鼠标离开范围时小弹窗消失
        onExited: {
            if (hoverPopup && !isPopupVisible) {
                hoverPopup.destroy()
                hoverPopup = null

                sceneButton.width=originalSize
                sceneButton.height=originalSize
                sceneButton.radius=sceneButton.width/2

                sceneButton.color=Qt.rgba(148/255,194/255,255/255,1.0)
                sceneButton.x=originalX
                sceneButton.y=originalY
            }
        }

        //点击按钮显示大弹窗，再点击则消失
        onClicked: {
            if (isPopupVisible) {
                // 如果大弹窗已经显示，则销毁它
                clickPopup.destroy()
                clickPopup = null
                isPopupVisible = false

                sceneButton.width=originalSize
                sceneButton.height=originalSize
                sceneButton.radius=sceneButton.width/2

                sceneButton.color=Qt.rgba(148/255,194/255,255/255,1.0)

                sceneButton.x=originalX
                sceneButton.y=originalY
            }
            else {
                // 否则，显示大弹窗
                if (hoverPopup) {
                    hoverPopup.destroy()
                    hoverPopup = null
                }
                clickPopup = popupComponent.createObject(sceneButton)
                clickPopup.x = sceneButton.x - 50
                clickPopup.y = sceneButton.y - 120
                isPopupVisible = true

                sceneButton.width=afterSize
                sceneButton.height=afterSize
                sceneButton.radius=sceneButton.width/2

                sceneButton.color=Qt.rgba(255/255,179/255,47/255,1.0)

                sceneButton.x=originalX-(afterSize-originalSize)/2
                sceneButton.y=originalY-(afterSize-originalSize)/2

            }
        }
    }

    // 添加一个变量来存储悬停时的小弹窗
    property var hoverPopup: null

    // 添加一个变量来存储点击时的大弹窗
    property var clickPopup: null
}
