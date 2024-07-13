#ifndef GRAPH_H
#define GRAPH_H

#include "Point.h"
#include "Road.h"
#include <vector>
#include<string>
#include<iostream>
#include<QString>
#include <QObject>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QDebug>
#include <connection.h>

using namespace std;

class Graph: public QObject
{
    Q_OBJECT
private:
    void __dfs(int from, int to, vector<vector<int>>& points_paths, vector<int>& visited,vector<int>& points_path);
    vector<int> __dijkstra(int from);
public:
    explicit Graph(QObject *parent = nullptr) : QObject(parent)
    {
        data::createConnection();       //建立数据库连接
        this->createGraph();            //更新间接数据
    }

    vector<Road*>roads;
    vector<Point*>points;
    vector<vector<vector<int>>>graph;                       // graph[i] -> {to, weight},{}

//用于算法的函数
    void createGraph();                                         /* 根据数据库的内容更新roads,points,graph*/


//用于大家查数据的函数
    //最短路径
    Q_INVOKABLE QVariantList inquire_shortest_road(int point_key1, int point_key2);       //查询点与点之间的最短路径key(包括两点的key)
    Q_INVOKABLE QList<QVariantList> inquire_all_roads(int point_key1, int point_key2);    //查询点与点之间的全部路径(每条路都各自包括两点的key)

    //查点
    Q_INVOKABLE int get_point_key(QString point_name);              //用景点名称查询景点的key,-1表示没找到
    Q_INVOKABLE QString get_point_name(int point_key);              //查询景点名称
    Q_INVOKABLE QString get_point_intro(int point_key);             //查询景点介绍
    Q_INVOKABLE QVariantMap get_address_of_point(int point_key);    //查询景点坐标,返回（-1，-1）为未查询到
    Q_INVOKABLE int get_points_num();                               //查询景点的总数
    Q_INVOKABLE int get_points_max_id();                            //查询景点的最大key
    Q_INVOKABLE int get_max_valid_point_key_from_points();          //获取目前景点中最大key
    Q_INVOKABLE QVariantList get_all_names_of_points(int max_num=5);//获取大量景点名

    //查路
    Q_INVOKABLE int get_road_key(QString road_name);         //找road编号，-1表示没找到
    Q_INVOKABLE int get_road_key(Point* u, Point* v);        //找两点间road编号，-1表示没找到
    Q_INVOKABLE int get_road_key(int u_key, int v_key);      //找两点间road编号，-1表示没找到
    Q_INVOKABLE QString get_road_name(int road_key);         //找road_name
    Q_INVOKABLE int get_road_length(int road_key);           //找length
    Q_INVOKABLE QVariantMap get_points_of_road(QString road_name);  //根据路名找两个端点
    Q_INVOKABLE QVariantMap get_points_of_road(int road_key);       //根据road_key找两个端点

    //增、删、改
    Q_INVOKABLE bool expand_point(int point_key,QString new_point_name, int addr_x,int addr_y,QString former_point_name, float length,int road_key, QString road_name,QString new_point_intro = "");  //扩充景点并形成新的路
    Q_INVOKABLE bool expand_point(int point_key,QString new_point_name, int addr_x,int addr_y,QString new_point_intro = "");   //扩充单个景点（用于初始化）
    Q_INVOKABLE bool expand_road(int road_key,QString road_name,QString point1, QString point2, float length);       //扩充路径
    Q_INVOKABLE bool expand_road(int road_key,QString road_name,int point1_key, int point2_key, float length);       //扩充路径


    Q_INVOKABLE bool update_point_name(int point_key,QString new_point_name);          //更改点的名称
    Q_INVOKABLE bool update_point_intro(int point_key,QString new_point_intro);        //更改点的介绍
    Q_INVOKABLE bool update_point_add(int point_key,int new_add_x,int new_add_y);      //更改点的坐标
    Q_INVOKABLE bool update_road_name(int road_key,QString road_name);                 //更改路的名称
    Q_INVOKABLE bool update_road_length(int road_key,float length);                    //更改路的长度

    Q_INVOKABLE bool del_point(QString point_name);             //删除景点 --> 删除对应的道路
    Q_INVOKABLE bool del_point(int point_key);                  //删除景点 --> 删除对应的道路
    Q_INVOKABLE bool del_road(QString road_name);               //删除道路
    Q_INVOKABLE bool del_road(int road_key);                    //删除道路

    Q_INVOKABLE bool add_score(int point_key,int score);        //输入评分
    Q_INVOKABLE float get_score(int point_key);                 //查询评分
    Q_INVOKABLE int get_people_num(int point_key);              //查询评价人数
};

#endif // GRAPH_H
