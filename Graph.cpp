#include "Graph.h"
#include"Point.h"
#include"Road.h"
#include <queue>
#include <algorithm>
#include <QObject>
#include <Qstring>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
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

int Graph::get_points_num()
{
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    int points_num=0;
    if(query.exec("select * from point"))
    {
        while(query.next())
        {
            points_num++;
        }
        return points_num;
    }
    else
    {
        return -1;
    }

}

void Graph::createGraph()
{
    // 根据数据库的内容重新创建图
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery build_roads=QSqlQuery(database);
    QSqlQuery build_points=QSqlQuery(database);

    QString b_roads=QString("select * from road");
    QString b_points=QString("select * from point");

    vector<int> v;
    vector<vector<int>> ve;
    vector<vector<vector<int>> > vec(this->get_points_num()+1,ve);

    if(build_roads.exec(b_roads)&&build_points.exec(b_points))
    {
        while(build_points.next())
        {
            int point_key=build_points.value("point_key").toInt();
            string point_name=build_points.value("point_name").toString().toStdString();
            string point_intro=build_points.value("point_intro").toString().toStdString();
            Point* p=new Point(point_key,point_name,point_intro);
            this->points.push_back(p);

            QSqlQuery build_graph_l=QSqlQuery(database);
            QString b_graph_l=QString("select * from road where pl_key='%1'").arg(point_key);
            if(build_graph_l.exec(b_graph_l))
            {
                while(build_graph_l.next())
                {
                    int to=build_graph_l.value("pr_key").toInt();
                    int weight=build_graph_l.value("length").toInt();
                    v.push_back(to);
                    v.push_back(weight);
                    ve.push_back(v);
                    v.clear();
                }
            }

            QSqlQuery build_graph_r=QSqlQuery(database);
            QString b_graph_r=QString("select * from road where pr_key='%1'").arg(point_key);
            if(build_graph_r.exec(b_graph_r))
            {
                while(build_graph_r.next())
                {
                    int to=build_graph_r.value("pl_key").toInt();
                    int weight=build_graph_r.value("length").toInt();
                    v.push_back(to);
                    v.push_back(weight);
                    ve.push_back(v);
                    v.clear();
                }
            }
            vec[point_key]=ve;
            ve.clear();
        }

        while(build_roads.next())
        {
            int road_key =build_roads.value("road_key").toInt();
            string road_name=build_roads.value("road_name").toString().toStdString();
            float length =build_roads.value("length").toInt();
            int pl_key =build_roads.value("pl_key").toInt();
            int pr_key =build_roads.value("pr_key").toInt();

            QSqlQuery find_p1=QSqlQuery(database);
            QSqlQuery find_p2=QSqlQuery(database);
            QString f_p1=QString("select * from point where point_key='%1'").arg(pl_key);
            QString f_p2=QString("select * from point where point_key='%1'").arg(pr_key);

            if(find_p1.exec(f_p1)&&find_p2.exec(f_p2)&&find_p1.next()&&find_p2.next())
            {
                string point_name1=find_p1.value("point_name").toString().toStdString();
                string point_intro1=find_p1.value("point_intro").toString().toStdString();
                Point* p1=new Point(pl_key,point_name1,point_intro1);

                string point_name2=find_p2.value("point_name").toString().toStdString();
                string point_intro2=find_p2.value("point_intro").toString().toStdString();
                Point* p2=new Point(pr_key,point_name2,point_intro2);

                Road* r=new Road(road_key,p1,p2,road_name,length);
                this->roads.push_back(r);
            }
        }
    }
    this->graph=vec;
}

bool Graph::expand_point(string& new_point_name, string new_point_intro)
{
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery add_point=QSqlQuery(database);

    QString add_p= QString("INSERT INTO point(point_name, point_intro) "
                            "VALUES('%1', '%2')")
                        .arg(QString::fromStdString(new_point_name),
                             QString::fromStdString(new_point_intro));


    if(add_point.exec(add_p))
    {
        return true;
    }
    return false;
}

bool Graph::expand_point(string& new_point_name, string& former_point_name, float length,string& road_name,string new_point_intro)
{
    // 扩充景点，形成新的路
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery add_point=QSqlQuery(database);

    QString add_p= QString("INSERT INTO point(point_name, point_intro) "
                            "VALUES('%1', '%2')")
                        .arg(QString::fromStdString(new_point_name),
                             QString::fromStdString(new_point_intro));


    if(this->expand_road(road_name,former_point_name,new_point_name,length)&&add_point.exec(add_p))
    {
        return true;
    }
    return false;
}

bool Graph::expand_road(string& road_name,string& point1, string& point2, float length)
{
    // 扩充路径
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery add_road=QSqlQuery(database);

    int pl=this->find_point_key(point1);
    int pr=this->find_point_key(point2);

    QString add_r=QString("INSERT INTO road(road_name,length,pl_key,pr_key)"
                            "values('%1','%2','%3','%4')")
                        .arg(QString::fromStdString(road_name),
                             QString::number(length),
                             QString::number(pl),
                             QString::number(pr));

    if(add_road.exec(add_r))
    {
        return true;
    }
    return false;
}

int Graph::find_point_key(string& point_name)
{
    // 找point编号，-1表示没找到
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);
    QString str=QObject::tr("select * from point where point_name='%1' ")
                      .arg(QString::fromStdString(point_name));

    if(query.exec(str)&&query.next())
    {
        return query.value("point_key").toInt();
    }
    else
    {
        return -1;
    }
}

int Graph::find_road_key(Point *u, Point *v)
{
    for(int i=0;i<this->roads.size();i++){
        if(roads[i]->pl == u && roads[i]->pr == v || roads[i]->pr == u && roads[i]->pl == v) return i;
    }
    return -1;
}

int Graph::find_road_key(string& road_name)
{
    // 找road编号，-1表示没找到
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);
    QString str=QObject::tr("select * from road where road_name='%1' ").arg(QString::fromStdString(road_name));

    if(query.exec(str)&&query.next())
    {
        return query.value("road_key").toInt();
    }
    else
    {
        return -1;
    }
}

int Graph::find_road_key(int u_key, int v_key)
{
    // 根据两个点的编号查找对应的road_key
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query1=QSqlQuery(database);
    QSqlQuery query2=QSqlQuery(database);
    QString str1=QObject::tr("select * from road where pl_key='%1' and pr_key='%2' ").arg(u_key,v_key);
    QString str2=QObject::tr("select * from road where pl_key='%1' and pr_key='%2' ").arg(v_key,u_key);

    if(query1.exec(str1)&&query1.next())
    {
        return query1.value("road_key").toInt();
    }
    else if(query2.exec(str2)&&query2.next())
    {
        return query2.value("road_key").toInt();
    }
    else
    {
        return -1;
    }
}

vector<int> Graph::find_points_of_road(string& road_name)
{
    vector<int> vec;

    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);
    QString str=QObject::tr("select * from road where road_name='%1'").arg(QString::fromStdString(road_name));

    if(query.exec(str)&&query.next())
    {
        int pr_key=query.value("pr_key").toInt();
        int pl_key=query.value("pl_key").toInt();
        vec.push_back(pl_key);
        vec.push_back(pr_key);
    }
    return vec;
}

bool Graph::update_point(string& point_name,string& point_intro,int point_key)
{
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    QString str=QString("update point set point_name='%1',point_intro='%2' where point_key='%3'")
                      .arg(QString::fromStdString(point_name),QString::fromStdString(point_intro),QString::number(point_key));
    if(query.exec(str))
    {
        return true;
    }
    return false;
}

bool Graph::update_road(string& road_name,float length,int pl_key,int pr_key,int road_key)
{
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    QString str=QString("update point set road_name='%1',length='%2',pl_key='%3',pr_key='%4' where road_key='%5'")
                      .arg(QString::fromStdString(road_name),QString::number(length),QString::number(pl_key),QString::number(pr_key),QString::number(road_key));
    if(query.exec(str))
    {
        return true;
    }
    return false;
}
bool Graph::del_point(string& point_name)
{
    // 删除景点，删除对应的道路
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery del_p=QSqlQuery(database);
    QSqlQuery del_r=QSqlQuery(database);

    QString d_p=QString("DELETE FROM point where road_name='%1' ").arg(QString::fromStdString(point_name));
    int key=this->find_point_key(point_name);
    QString d_r=QString("DELETE FROM road where lp_key='%1 or rp_key='%1'").arg(key);

    if(del_p.exec(d_p)&&del_r.exec(d_r))
    {
        return true;
    }
    return false;
}

bool Graph::del_road(string& road_name) {
    // 删除道路
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery del_r=QSqlQuery(database);
    QString d_r=QString("DELETE FROM road where road_name='%1'").arg(QString::fromStdString(road_name));

    if(del_r.exec(d_r))
    {
        return true;
    }
    return false;
}
