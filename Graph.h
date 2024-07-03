#ifndef GRAPH_H
#define GRAPH_H

#include "Point.h"
#include "Road.h"
#include <vector>
#include<string>
#include<iostream>
using namespace std;

class Graph
{
private:
    void __dfs(int from, int to, vector<vector<int>>& points_paths, vector<int>& visited,vector<int>& points_path);
    vector<int> __dijkstra(int from);
public:
    vector<Road*>roads;
    vector<Point*>points;
    vector<vector<vector<int>>>graph; // graph[i] -> {to, weight},{}
    Graph() {/* 实例 roads, points */}; // 填充 对应road对象的 road_key

    void createGraph(); /* 根据数据库的内容 重新*/
    int get_max_valid_point_key_from_points();
    void inquire_point(Point* v);//查询单个点的信息
    vector<int> inquire_shortest_road(Point* u, Point* v);//查询点与点之间的路径信息
    vector<int> inquire_shortest_road(int u, int v);
    vector<vector<int>> inquire_all_roads(Point* u, Point* v);//查询点与点之间的路径信息
    vector<vector<int>> inquire_all_roads(int u, int v);//查询点与点之间的路径信息

    int find_point_key(string& point_name);//找point编号，-1表示没找到
    int find_road_key(string& road_name);//找road编号，-1表示没找到
    int find_road_key(Point* u, Point* v);//找road编号，-1表示没找到
    int find_road_key(int u_key, int v_key);//找road编号，-1表示没找到
    vector<int> find_points_of_road(string& road_name);//根据路名找两个端点
    int get_points_num();//查询点的总数

    bool expand_point(string& new_point_name, string& former_point_name, float length, string& road_name,string new_point_intro = "");//扩充景点 --> 形成新的路
    bool expand_road(string& road_name,string& point1, string& point2, float length);//扩充路径
    bool expand_point(string& new_point_name, string new_point_intro = "");//扩充单个景点（用于初始化）
    bool update_point(string& point_name,string& point_intro,int point_key);//更改点信息
    bool update_road(string& road_name,float length,int pl_key,int pr_key,int road_key);//更改路信息
    bool del_point(string& point_name);//删除景点 --> 删除对应的道路
    bool del_road(string& road_name);//删除道路
};

#endif // GRAPH_H
