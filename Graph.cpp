#include "Graph.h"
#include <queue>
#include <algorithm>
struct  Cmp
{
    bool operator()(const vector<int>& a, const vector<int>& b){
        return a[1] > b[1];
    }
};

void Graph:: __dfs(int from, int to, vector<vector<int>>& points_paths, vector<int>& visited, vector<int>& points_path)
{
    visited[from] = true;
    points_path.push_back(from);

    if(from == to){
        points_paths.push_back(points_path);
    }else{
        for(auto& edge : graph[from]){ // edge为空时，不进入循环
            if(!visited[edge[0]]){
                __dfs(edge[0], to, points_paths, visited, points_path);
            }
        }
    }
    points_path.pop_back();
    visited[from] = false;
}

vector<int> Graph::__dijkstra(int from)
{
    int size = get_max_valid_point_key_from_points() + 1;
    vector<int>points_path(size, -1);
    vector<int>dist(size, INT_MAX); // 离 from 的距离
    vector<int>visited; // 点的记录是否查看过
    visited.resize(size);

    dist[from] = 0;

    priority_queue<vector<int>,vector<vector<int>>, Cmp>pq;
    pq.push({from,0});
    while(!pq.empty()){
            vector<int>top = pq.top();
            int v = top[0]; //w = top[1];
            pq.pop();
            if(!visited[v]){
                //尝试用该记录优化后面路径
                visited[v] = true;
                for(auto egde : graph[v]){
                    int nex = egde[0];
                    if(!visited[nex] && dist[v] + egde[1] < dist[nex]){
                        dist[nex] = dist[v] + egde[1];
                        pq.push({nex, dist[nex]});
                        points_path[nex] = v; // nex 的前一个节点是 v
                    }
                }
            }
    }
    return points_path; // 全信息的 path
}

int Graph::get_max_valid_point_key_from_points()
{
    int res = 0; // 表示没有元素
    for(Point* point : points){
        res = max(res, point->point_key);
    }
    return res;
    /*调试版
        int res = 0;
        for(int i=1;i<=graph.size();i++){
            if(!graph[i].empty()){
                res = i; // res 只会变大
            }
        }
        return res;
    */
}

int Graph::find_road_key(Point *u, Point *v) // 下标从 1 开始记录
{
    for(int i=1;i<=this->roads.size();i++){
        if(roads[i]->pl == u && roads[i]->pr == v || roads[i]->pr == u && roads[i]->pl == v) return i;
    }
    return -1;
}

void Graph::inquire_point(Point *v)
{
    cout<<v->point_name<<endl<<v->point_intro<<endl;
}

vector<int> Graph::inquire_shortest_road(Point *u, Point *v)
{
    int from = u->point_key, to = v->point_key;
    return this->inquire_shortest_road(from, to);
}

vector<int> Graph::inquire_shortest_road(int from, int to) 
{
    vector<int>res;
    vector<int> points_path = __dijkstra(from);  
    int cur = to;
    while(cur != -1){
        res.push_back(cur);
        cur = points_path[cur];
    } 
    reverse(res.begin(), res.end());
    return res;
}

vector<vector<int>> Graph::inquire_all_roads(Point *u, Point *v)
{
    int from = u->point_key, to = v->point_key;
    return this->inquire_all_roads(from, to);
}

vector<vector<int>> Graph::inquire_all_roads(int u, int v)
{
    vector<vector<int>>points_paths;
    vector<int>visited;
    vector<int>points_path;
    visited.resize(get_max_valid_point_key_from_points() + 1);
    this->__dfs(u, v, points_paths, visited, points_path);
    return points_paths; // 经过的所有点
}
