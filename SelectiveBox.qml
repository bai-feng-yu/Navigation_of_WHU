import QtQuick 2.12
import QtQuick.Controls
import QtQuick.Controls.Windows
Item {
    property alias selective_model: optional_points.model
    property alias cur_chosen_point: optional_points.currentText
    visible: false
    x : 0
    y : 0

    width: implicitWidth
    height:implicitHeight


    //anchors.horizontalCenter: parent
    ComboBox{
        enabled: parent.enabled
        visible: parent.visible
        id : optional_points
        width:150
        spacing: 5
        height:30
        editable:true
        currentIndex : -1
        model: ListModel{}
        indicator: Canvas {
            id: canvas // 定义 Canvas 控件作为指示器
            x: optional_points.width - width - optional_points.rightPadding + 12// 指示器的 x 坐标位置
            y: optional_points.topPadding + (optional_points.availableHeight - height) / 2 // 指示器的 y 坐标位置
            width: 12 // 指示器的宽度
            height: 8 // 指示器的高度
            contextType: "2d" // 指定上下文类型为 2D

            // 监听控件的按下状态变化，请求重新绘制指示器
            Connections {
                target: optional_points
                function onPressedChanged() { canvas.requestPaint(); }
            }

            // 绘制指示器的样式
            onPaint: {
                context.reset(); // 重置上下文
                context.moveTo(0, 0); // 移动到起始点
                context.lineTo(width, 0); // 绘制线条
                context.lineTo(width / 2, height); // 绘制线条
                context.closePath(); // 关闭路径
                context.fillStyle = optional_points.pressed ? "#17a81a" : "#21be2b"; // 根据按下状态设置颜色
                context.fill(); // 填充
            }
        }
        // 定义下拉框的弹出框
            popup: Popup {
                y: optional_points.height - 1 // 弹出框的位置
                width: optional_points.width // 弹出框的宽度与下拉框相同
                implicitHeight: contentItem.implicitHeight // 默认高度与内容项的默认高度相同
                padding: 1 // 内边距为 1
                // 弹出框的内容项为 ListView
                contentItem: ListView {
                    clip: true // 裁剪内容
                    implicitHeight: contentHeight // 默认高度为内容的高度
                    model: optional_points.popup.visible ? optional_points.delegateModel : null // 设置模型为下拉框的代理模型
                    currentIndex: optional_points.highlightedIndex // 当前选中项的索引

                    // 滚动条
                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                // 弹出框的背景样式
                background: Rectangle {
                    color: luoyingPink
                    border.color: chuntengPurple // 边框颜色
                    radius: 2 // 圆角半径
                }
        }

        onActivated: {
            console.log(qsTr("looking_up..." + optional_points.currentText));

        }
    }

}
