import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: starRating
    width: 200
    height: 50

    // 当前评分的星星数量
    property real starCount: 3
    // 最大星星数量
    property int maxStarCount: 5
    // 是否可编辑
    property bool editable: true

    // 星星的外半径
    property int outerRadius: 15
    // 星星之间的间距
    property int spacing: 5

    property color backgroundColor: Qt.rgba(1,1,1,0.6)
    Rectangle {
        id: container

        width: parent.width
        height: parent.height
        color:backgroundColor
        border.color: "steelblue"

        Canvas {
            id: canvas
            width: container.width // 画布宽度与 Rectangle 宽度相同
            height: container.height // 画布高度与 Rectangle 高度相同

            onPaint: {
                var ctx = canvas.getContext('2d'); // 获取 2D 绘图上下文
                var innerRadius = outerRadius * Math.sin(Math.PI / 5) / Math.sin(2 * Math.PI / 5); // 内半径
                var offsetY = (height - outerRadius * 2) / 2; // 计算 y 方向上的偏移量，使星星垂直居中

                // 计算星星的总宽度（包含间距）
                var totalStarsWidth = maxStarCount * (outerRadius * 2 + spacing) - spacing;
                // 计算星星的起始 x 坐标，使星星水平居中
                var startX = (width - totalStarsWidth) / 2;

                ctx.clearRect(0, 0, width, height); // 清除画布

                for (var i = 0; i < maxStarCount; i++) {
                    // 计算每颗星星的 x 坐标
                    var x = startX + i * (outerRadius * 2 + spacing) + outerRadius;
                    var color;
                    if (i < starCount) {
                        color = "gold"; // 已评分的星星颜色
                    } else {
                        color = "lightgray"; // 未评分的星星颜色（在可编辑模式下）
                    }

                    ctx.fillStyle = color; // 设置填充颜色
                    drawStar(ctx, x, offsetY + outerRadius, outerRadius, innerRadius); // 绘制星星
                    ctx.fill(); // 填充星星
                }
            }

            // Request a repaint when the starCount property changes
            //onStarCountChanged: canvas.requestPaint()
        }

        // 控制星星的可编辑状态
        MouseArea {
            anchors.fill: parent // 鼠标区域填满整个 Rectangle
            onClicked: function(mouse) {
                if (editable) {
                    // 计算每颗星星的实际宽度（包含间距）
                    var starWidth = outerRadius * 2 + spacing; // 每颗星星的宽度

                    // 计算每颗星星的实际起始 x 坐标
                    var totalStarsWidth = maxStarCount * (outerRadius * 2 + spacing) - spacing;
                    var startX = (canvas.width - totalStarsWidth) / 2;

                    // 计算点击位置对应的星星索引
                    var index = Math.floor((mouse.x - startX) / starWidth);
                    // 更新评分的星星数量，确保不超过最大星星数量
                    starRating.starCount = Math.min(index + 1, maxStarCount);
                    canvas.requestPaint(); // 请求重新绘制画布
                }
            }
        }
    }

    // 绘制五角星的函数
    function drawStar(ctx, x, y, outerRadius, innerRadius) {
        ctx.beginPath(); // 开始新的路径
        for (var i = 0; i < 5; i++) {
            // 计算外顶点的角度
            var angle = Math.PI / 2 + i * Math.PI * 2 / 5;
            // 计算外顶点的坐标
            var xPos = x + outerRadius * Math.cos(angle);
            var yPos = y - outerRadius * Math.sin(angle);
            ctx.lineTo(xPos, yPos); // 连接到外顶点

            // 计算内顶点的角度
            angle += Math.PI / 5;
            // 计算内顶点的坐标
            xPos = x + innerRadius * Math.cos(angle);
            yPos = y - innerRadius * Math.sin(angle);
            ctx.lineTo(xPos, yPos); // 连接到内顶点
        }
        ctx.closePath(); // 关闭路径
    }
}
