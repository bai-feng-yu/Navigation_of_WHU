#include "historymodel.h" // 引入自定义的HistoryModel头文件
//#include "moving_pool.h"
#include <QGuiApplication> // 引入QGuiApplication类，用于GUI应用程序
#include <QQmlApplicationEngine> // 引入QQmlApplicationEngine类，用于加载QML文件
#include <QQmlContext> // 引入QQmlContext类，尽管在这段代码中未直接使用，但可能是为了说明或未来扩展

int main(int argc, char *argv[]) // 主函数入口
{
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling); // 启用高DPI缩放，以支持高分辨率屏幕

    QGuiApplication app(argc, argv); // 创建QGuiApplication实例，这是GUI应用程序的基础

    HistoryModel history_model; // 创建HistoryModel的实例，这个模型用于存储和管理历史数据
    //qmlRegisterType<MagicPool>("an.utility", 1, 0, "MagicPool"); // 注册qml 可见类型
    QQmlApplicationEngine engine; // 创建QQmlApplicationEngine实例，用于加载和显示QML界面
    engine.rootContext()->setContextProperty("historyModel", &history_model); // 将model实例添加到QML环境的根上下文中，使其可以通过"historyModel"标识符在QML中访问

    const QUrl url(QStringLiteral("qrc:/Campus-Guide/Main.qml")); // 创建QUrl对象，指向QML文件的资源路径
    /* 异常处理 + 安全处理 */
    // 使用QObject::connect连接QQmlApplicationEngine的objectCreated信号到一个lambda函数
    // 当QML对象创建完成后，此lambda函数将被调用
    // 如果obj为空且objUrl与url相等，则退出应用程序，表示QML文件未能正确加载
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection); // 使用Qt::QueuedConnection确保信号和槽在不同的线程中安全调用

    engine.load(url); // 加载QML文件

    return app.exec(); // 进入应用程序的主事件循环，等待用户交互
}
