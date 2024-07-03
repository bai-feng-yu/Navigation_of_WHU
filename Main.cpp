#include "mainwindow.h"
#include"connection.h"
#include"Graph.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    data::createConnection();      //连接数据库
    w.show();
    return a.exec();
}
