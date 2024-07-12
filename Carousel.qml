
import QtQuick
import QtQuick.Controls
Item {
    property bool autoPlay: true
    property int loopTime: 2000
    property var model
    property Component delegate
    property bool showIndicator: true
    property int indicatorGravity : Qt.AlignBottom | Qt.AlignHCenter
    property int indicatorMarginLeft: 0
    property int indicatorMarginRight: 0
    property int indicatorMarginTop: 0
    property int indicatorMarginBottom: 20
    property int indicatorSpacing: 10
    property alias indicatorAnchors: layout_indicator.anchors
    property Component indicatorDelegate : com_indicator
    id:control
    width: 400
    height: 300
    ListModel{
        id:content_model
    }
    // 利用一个 代理的 QtObject 类来实现模型的赋值/初始化
    QtObject{
        id:d
        property bool flagXChanged: true
        property bool isAnimEnable: control.autoPlay && list_view.count>3
        function setData(data){
            if(!data){
                return
            }
            // 循环连播
            content_model.clear()
            content_model.append(data[data.length-1])
            content_model.append(data)
            content_model.append(data[0])
            list_view.highlightMoveDuration = 0
            list_view.currentIndex = 1
            list_view.highlightMoveDuration = 250
            if(d.isAnimEnable){
                timer_run.restart()
            }
        }
    }
    ListView{
        id:list_view
        anchors.fill: parent
        snapMode: ListView.SnapOneItem // 1 次 展示 1 项
        clip: true
        boundsBehavior: ListView.StopAtBounds
        model:content_model
        maximumFlickVelocity: 4 * (list_view.orientation === Qt.Horizontal ? width : height)
        preferredHighlightBegin: 0
        preferredHighlightEnd: 0
        highlightMoveDuration: 0
        Component.onCompleted: { // 初始化
            d.setData(control.model) // model 初始化必需参数
        }
        interactive: list_view.count>3 // 便于看到较后的信息
        Connections{
            target: control
            function onModelChanged(){
                d.setData(control.model)
            }
        }
        orientation : ListView.Horizontal
        delegate: Item{
            id:item_control
            width: ListView.view.width
            height: ListView.view.height
            property int displayIndex: { // 根据 index 决定 展示的是 model 里第几个下标
                if(index === 0) // 如果是第一个项目（实际上是最后一个项目被滚动到前面）
                    return content_model.count-3 // 返回倒数第三个项目的索引
                if(index === content_model.count-1) // 如果是最后一个项目（实际上是第一个项目被滚动到后面）
                    return 0 // 返回第一个项目的索引
                return index-1 // 对于其他项目，返回其索引减1（因为索引是循环的）
            }
            Loader{
                property int displayIndex : item_control.displayIndex
                property var model: list_view.model.get(index)
                anchors.fill: parent
                sourceComponent: {
                    if(model){
                        return control.delegate // item_control
                    }
                    return undefined
                }
            }
        }
        // 拖动操作
        onMovementEnded:{
            currentIndex = list_view.contentX/list_view.width
            if(currentIndex === 0){
                currentIndex = list_view.count-2
            }else if(currentIndex === list_view.count-1){
                currentIndex = 1
            }
            d.flagXChanged = false
            timer_run.restart()
        }
        onMovementStarted: {
            d.flagXChanged = true
            timer_run.stop()
        }
        onContentXChanged: {
            if(d.flagXChanged){
                var maxX = Math.min(list_view.width*(currentIndex+1),list_view.count*list_view.width)
                var minY = Math.max(0,(list_view.width*(currentIndex-1)))
                if(contentX>=maxX){
                    contentX = maxX
                }
                if(contentX<=minY){
                    contentX = minY
                }
            }
        }
    }
    Component{
        id:com_indicator
        Rectangle{
            width:  8
            height: 8
            radius: 4
            // Shadow{
            //     radius: 4
            // }
            scale: checked ? 1.2 : 1
            color: checked ? "steelblue" : "red"
            border.width: mouse_item.containsMouse ? 1 : 0
            border.color: "black"
            MouseArea{
                id:mouse_item
                hoverEnabled: true
                anchors.fill: parent
                onClicked: {
                    changedIndex(realIndex)
                }
            }
        }
    }
    Row{
        id:layout_indicator
        spacing: control.indicatorSpacing
        anchors{
            horizontalCenter:(indicatorGravity & Qt.AlignHCenter) ? parent.horizontalCenter : undefined
            verticalCenter: (indicatorGravity & Qt.AlignVCenter) ? parent.verticalCenter : undefined
            bottom: (indicatorGravity & Qt.AlignBottom) ? parent.bottom : undefined
            top: (indicatorGravity & Qt.AlignTop) ? parent.top : undefined
            left: (indicatorGravity & Qt.AlignLeft) ? parent.left : undefined
            right: (indicatorGravity & Qt.AlignRight) ? parent.right : undefined
            bottomMargin: control.indicatorMarginBottom
            leftMargin: control.indicatorMarginBottom
            rightMargin: control.indicatorMarginBottom
            topMargin: control.indicatorMarginBottom
        }
        visible: showIndicator
        Repeater{
            id:repeater_indicator
            model: list_view.count
            Loader{
                property int displayIndex: {
                    if(index === 0)
                        return list_view.count-3
                    if(index === list_view.count-1)
                        return 0
                    return index-1
                }
                property int realIndex: index
                property bool checked: list_view.currentIndex === index
                sourceComponent: {
                    if(index===0 || index===list_view.count-1)
                        return undefined
                    return control.indicatorDelegate
                }
            }
        }
    }
    Timer{ // 从最后一张 到 第一张
        id:timer_anim
        interval: 250
        onTriggered: {
            list_view.highlightMoveDuration = 0
            if(list_view.currentIndex === list_view.count-1){
                list_view.currentIndex = 1
            }
        }
    }
    Timer{ // 自动翻页
        id:timer_run
        interval: control.loopTime
        repeat: d.isAnimEnable
        onTriggered: {
            list_view.highlightMoveDuration = 250
            list_view.currentIndex = list_view.currentIndex+1
            timer_anim.start()
        }
    }
    function changedIndex(index){ // 设置 currentIndex
        d.flagXChanged = true
        timer_run.stop()
        list_view.currentIndex = index
        d.flagXChanged = false
        if(d.isAnimEnable){
            timer_run.restart()
        }
    }
}
