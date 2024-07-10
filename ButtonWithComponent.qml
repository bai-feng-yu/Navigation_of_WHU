import QtQuick
import QtQuick.Controls

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
    property int originalSize:12
    //点击后按钮的尺寸
    property int afterSize:14

    //用originalx和originaly确定按钮位置
    property int originalX:0
    property int originalY:0

    x:originalX
    y:originalY

    //按钮尺寸外观定义
    width: originalSize
    height: originalSize
    radius: width / 2
    color: "white"
    border.color: "grey"
    border.width: 1

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

    //鼠标悬浮未点击时显示的小弹窗 显示坐标名字
    Component {
        id: placeComponent
        //弹窗背景颜色外观
        Rectangle{
                width: scenespotname.width
                height: 20
                color: "lightgrey"
                radius:5

                //弹窗中文本
                Text {
                    id: scenespotname
                    //width: parent.width
                    //height: parent.height
                    text: nameContext
                    font.family: "Microsoft YaHei"
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
            color: "white"

            //支持鼠标滚轮以及滑动条浏览
            ScrollView {
                anchors.fill: parent

                contentWidth: contentText.width
                contentHeight: contentText.height

                Rectangle {
                    id: textContainer
                    width: 250
                    height: contentText.height
                    color: "white"

                    //标题
                    Text{
                        id:sceneName
                        text:nameContext
                        font.family:"Microsoft YaHei"
                        font.weight:800
                        font.pointSize: 25
                    }

                    //图片
                    Image {
                        id: sceneImage
                        source:imageSource
                        y:sceneName.y+30
                    }

                    //具体信息
                    Text {
                        id: contentText
                        width: 225
                        y:sceneImage.y+30
                        text:infoContext1+'\n'+infoContext2+'\n'+infoContext3+"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
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
                    hoverPopup.x = sceneButton.x-155
                    hoverPopup.y = sceneButton.y-125

                    sceneButton.width=afterSize
                    sceneButton.height=afterSize
                    sceneButton.radius=sceneButton.width/2

                    sceneButton.color="white"

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

                sceneButton.color="white"

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

                sceneButton.color="white"

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
                clickPopup.x = sceneButton.x - 80
                clickPopup.y = sceneButton.y - 120
                isPopupVisible = true

                sceneButton.width=afterSize
                sceneButton.height=afterSize
                sceneButton.radius=sceneButton.width/2

                sceneButton.color="red"

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
