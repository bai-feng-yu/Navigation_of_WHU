#pragma once
#include "Point.h"
#include "Road.h"
#include <vector>
#include <iostream>

using namespace std;

class Graph
{
private:
    void __dfs(int from, int to, vector<vector<int>>& points_paths, vector<int>& visited,vector<int>& points_path);
    vector<int> __dijkstra(int from);
public:
    vector<Road*>roads; // i 从 1 - n 与数据库键值对应
    vector<Point*>points; // i 从 1 - n 与数据库键值对应
    //int points_num;
    vector<vector<vector<int>>>graph; // graph[i] -> {to, weight},{} // i 从 1 - n 与数据库键值对应
	Graph() {/* 实例 roads, points */}; // 填充 对应road对象的 road_key
    void createGraph(); /* 根据数据库的内容 重新*/
    int get_max_valid_point_key_from_points();
	// void dijkstra(Point* v);
	// void floyd();
    int find_road_key(Point* u, Point* v);
    int find_road_key(int u_key, int v_key);

	void inquire_point(Point* v);//查询单个点的信息
    // int 对应 Road 编号
	vector<int> inquire_shortest_road(Point* u, Point* v);//查询点与点之间的路径信息
    vector<int> inquire_shortest_road(int u, int v); 
    vector<vector<int>> inquire_all_roads(Point* u, Point* v);//查询点与点之间的路径信息
    vector<vector<int>> inquire_all_roads(int u, int v);//查询点与点之间的路径信息
    
	void expand_point(string& new_point_name, string& former_point_name, float length, string new_point_intro = "");//扩充景点 --> 形成新的路
	void expand_road(string& point1, string& point2, float length);//扩充路径
    int find_point(string& point_name);//找point编号，-1表示没找到 
    int find_road(string& road_name);//找road编号，-1表示没找到 
    bool del_point(string& point_name);//删除景点 --> 删除对应的道路
    bool del_road(string& road_name);//删除道路
};