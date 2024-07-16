#include"connection.h"

void data::createConnection()   //初始化创建数据库连接
{
    QSqlDatabase database;        //创建操作对象
    database = QSqlDatabase::addDatabase("QMYSQL");    //添加数据库驱动
    database.setHostName("110.42.189.57");                    //远程连接的数据库IP地址
    database.setPort(3306);                                 //数据库提供的端口
    database.setUserName("far");                             //远程连接的用户
    database.setPassword("123456");                            // 密码
    database.setDatabaseName("mydatabase");          //设置数据库名称
    database.open();                 //打开数据库

    QSqlQuery sqlQuery;              //创建操作对象

    //创建点数据表
    QString point = QString("create table  IF NOT EXISTS point ("
                                "point_key int not null, "
                                "point_name text not null,"
                                "point_intro text,"
                                "addr_x int not null,"
                                "addr_y int not null,"
                                "score float,"
                                "people_num int)");
    sqlQuery.exec(point);

    QString make_first_id_zero=QString("UPDATE sqlite_sequence SET seq = -1 WHERE name='%1'").arg("point");

    //创建路数据表
    QString road = QString("create table  IF NOT EXISTS road ("
                                "road_key int not null, "
                                "road_name text not null,"
                                "length float not null,"
                                "pl_key int not null,"
                                "pr_key int not null)");
    sqlQuery.exec(road);

    //为每一列标题添加绑定值
    sqlQuery.prepare("INSERT INTO point (point_name,point_intro) "
                     "VALUES (:point_name, :point_intro)");

    sqlQuery.prepare("INSERT INTO road (road_name,length,pl_key,pr_key) "
                     "VALUES (:road_name,:length,:pl_key,:pr_key)");

}

void data::Connection()             //连接数据库
{
    QSqlDatabase database= QSqlDatabase::database("qt_sql_default_connection");
    if (!database.open())
    {
        QMessageBox::information(nullptr, "信息", database.lastError().text(), QMessageBox::Ok);
    }
}

void data::closeConnection()        //关闭数据库
{
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    database.close();               //关闭数据库
}
