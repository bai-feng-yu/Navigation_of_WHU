#include "Graph.h"
#include"Point.h"
#include"Road.h"
#include <queue>
#include <algorithm>
#include <QObject>
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

QVariantList Graph::inquire_shortest_road(int point_key1, int point_key2)
{
    vector<int>res;
    vector<int> points_path = __dijkstra(point_key1);
    int cur = point_key2;
    while(cur != -1){
        res.push_back(cur);
        cur = points_path[cur];
    } 
    reverse(res.begin(), res.end());

    QVariantList list;
    for (const auto i : res) {
        QVariantMap map;
        map["point_key"] = i;
        list.append(map);
    }
    return list;
}

QList<QVariantList> Graph::inquire_all_roads(int point_key1, int point_key2)
{
    vector<vector<int>>points_paths;
    vector<int>visited;
    vector<int>points_path;
    visited.resize(get_max_valid_point_key_from_points() + 1);
    this->__dfs(point_key1, point_key2, points_paths, visited, points_path);

    QList<QVariantList> dataList;
    for(int i=0;i<int(points_paths.size());i++)
    {
        QVariantList list;
        for(int j=0;j<int(points_paths[i].size());j++)
        {
            list.append(points_paths[i][j]);
        }
        dataList.append(list);
    }
    return dataList;
}

QString Graph::get_point_name(int point_key)
{
    //查询景点名称
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");

    if (!database.isOpen()) {
        return QString("Database is not open.");
    }

    QSqlQuery query=QSqlQuery(database);
    QString find=QString("select * from point where point_key='%1'").arg(point_key);

    if(query.exec(find)&&query.next())
    {
        return QString(query.value("point_name").toString());
    }
    else
    {
        return QString("There is no such point.");
    }
}

QString Graph::get_point_intro(int point_key)
{
    //查询景点介绍
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");

    if (!database.isOpen()) {
        return QString("Database is not open.");
    }

    QSqlQuery query=QSqlQuery(database);
    QString find=QString("select * from point where point_key='%1'").arg(point_key);

    if(query.exec(find)&&query.next())
    {
        return QString(query.value("point_intro").toString());
    }
    else
    {
        return QString("There is no such point.");
    }
}

QVariantMap Graph::get_address_of_point(int point_key)  //查询景点坐标
{
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);
    QString find=QString("select * from point where point_key='%1'").arg(point_key);

    if(query.exec(find)&&query.next())
    {
        QVariantMap map;
        map["addr_x"]=query.value("addr_x").toInt();
        map["addr_y"]=query.value("addr_y").toInt();
        return map;
    }
    else
    {
        QVariantMap map;
        map["addr_x"]=-1;
        map["addr_y"]=-1;
        return map;
    }
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

int Graph::get_points_max_id()
{
    //查询景点的最大key
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    int max_key=0;
    if(query.exec("select * from point"))
    {
        while(query.next())
        {
            int n=query.value("point_key").toInt();
            if(max_key<n)
            {
                max_key=n;
            }
        }
        return max_key;
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
    vector<vector<vector<int>> > vec(this->get_points_max_id()+1,ve);

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

bool Graph::expand_point(QString new_point_name, int addr_x,int addr_y,QString new_point_intro)
{
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery add_point=QSqlQuery(database);

    QString add_p= QString("INSERT INTO point(point_name, point_intro,addr_x,addr_y) "
                            "VALUES('%1', '%2','%3','%4')")
                        .arg(new_point_name,
                             new_point_intro,
                             QString::number(addr_x),
                             QString::number(addr_y));


    if(add_point.exec(add_p))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::expand_point(QString new_point_name, int addr_x,int addr_y,QString former_point_name, float length, QString road_name,QString new_point_intro)
{
    // 扩充景点，形成新的路
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery add_point=QSqlQuery(database);

    QString add_p= QString("INSERT INTO point(point_name, point_intro,addr_x,addr_y) "
                            "VALUES('%1', '%2','%3','%4')")
                        .arg(new_point_name,
                             new_point_intro,
                             QString::number(addr_x),
                             QString::number(addr_y));


    if(this->expand_road(road_name,former_point_name,new_point_name,length)&&add_point.exec(add_p))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::expand_road(QString road_name,QString point1, QString point2, float length)
{
    // 扩充路径
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery add_road=QSqlQuery(database);

    int pl=this->get_point_key(point1);
    int pr=this->get_point_key(point2);

    QString add_r=QString("INSERT INTO road(road_name,length,pl_key,pr_key)"
                            "values('%1','%2','%3','%4')")
                        .arg(road_name,
                             QString::number(length),
                             QString::number(pl),
                             QString::number(pr));

    if(add_road.exec(add_r))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::expand_road(QString road_name,int point1_key, int point2_key, float length)
{
    //扩充路径
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery add_road=QSqlQuery(database);


    QString add_r=QString("INSERT INTO road(road_name,length,pl_key,pr_key)"
                            "values('%1','%2','%3','%4')")
                        .arg(road_name,
                             QString::number(length),
                             QString::number(point1_key),
                             QString::number(point2_key));

    if(add_road.exec(add_r))
    {
        this->createGraph();
        return true;
    }
    return false;
}

int Graph::get_point_key(QString point_name)
{
    // 找point编号，-1表示没找到
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);
    QString str=QObject::tr("select * from point where point_name='%1' ")
                      .arg(point_name);

    if(query.exec(str)&&query.next())
    {
        return query.value("point_key").toInt();
    }
    else
    {
        return -1;
    }
}

QVariantList Graph::get_all_names_of_points(int max_num)
{
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);
    QString str=QObject::tr("select * from point ");
    QVariantList list;


    if(query.exec(str))
    {
        int num=0;
        while(query.next()&&num<max_num)
        {
            num++;
            list.append(query.value("point_name"));
        }
        return list;
    }
    else
    {
        return list;
    }
}

int Graph::get_road_key(Point *u, Point *v)
{
    for(int i=0;i<this->roads.size();i++){
        if(roads[i]->pl == u && roads[i]->pr == v || roads[i]->pr == u && roads[i]->pl == v) return i;
    }
    return -1;
}

int Graph::get_road_key(QString road_name)
{
    // 找road编号，-1表示没找到
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);
    QString str=QObject::tr("select * from road where road_name='%1' ").arg(road_name);

    if(query.exec(str)&&query.next())
    {
        return query.value("road_key").toInt();
    }
    else
    {
        return -1;
    }
}

int Graph::get_road_key(int u_key, int v_key)
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

QVariantMap Graph::get_points_of_road(QString road_name)
{
    QVariantMap vec;

    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);
    QString str=QObject::tr("select * from road where road_name='%1'").arg(road_name);

    if(query.exec(str)&&query.next())
    {
        int pr_key=query.value("pr_key").toInt();
        int pl_key=query.value("pl_key").toInt();
        vec["pl_key"]=pl_key;
        vec["pr_key"]=pr_key;
    }
    return vec;
}

bool Graph::update_point_name(int point_key,QString new_point_name)
{
    //更改点的名称
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    QString str=QString("update point set point_name='%1' where point_key='%2'")
                      .arg(new_point_name,QString::number(point_key));

    if(query.exec(str))
    {
        this->createGraph();
        return true;
    }

    return false;
}

bool Graph::update_point_intro(int point_key,QString new_point_intro)
{
    //更改点的介绍
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    QString str=QString("update point set point_intro='%1' where point_key='%2'")
                      .arg(new_point_intro,QString::number(point_key));

    if(query.exec(str))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::update_point_add(int point_key,int new_add_x,int new_add_y)
{
    //更改点的坐标
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    QString str=QString("update point set add_x='%1',add_y='%2' where point_key='%3'")
                      .arg(QString::number(new_add_x),QString::number(new_add_y),QString::number(point_key));

    if(query.exec(str))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::update_road_name(int road_key,QString road_name)
{
    //更改路的名称
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    QString str=QString("update point set road_name='%1'where road_key='%2'")
                      .arg(road_name,QString::number(road_key));

    if(query.exec(str))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::update_road_length(int road_key,float length)
{
    //更改路的长度
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery query=QSqlQuery(database);

    QString str=QString("update point set length='%1' where road_key='%2'")
                      .arg(QString::number(length),QString::number(road_key));

    if(query.exec(str))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::del_point(QString point_name)
{
    // 删除景点，删除对应的道路
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery del_p=QSqlQuery(database);
    QSqlQuery del_r=QSqlQuery(database);

    QString d_p=QString("DELETE FROM point where point_name='%1' ").arg(point_name);
    int key=this->get_point_key(point_name);
    QString d_r=QString("DELETE FROM road where lp_key='%1 or rp_key='%2'").arg(key,key);

    if(del_p.exec(d_p)&&del_r.exec(d_r))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::del_point(int point_key)
{
    //删除景点 --> 删除对应的道路
    QString name=get_point_name(point_key);

    if(this->del_point(name))
    {
        return true;
    }
    return false;
}

bool Graph::del_road(QString road_name)
{
    // 删除道路
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery del_r=QSqlQuery(database);
    QString d_r=QString("DELETE FROM road where road_name='%1'").arg(road_name);

    if(del_r.exec(d_r))
    {
        this->createGraph();
        return true;
    }
    return false;
}

bool Graph::del_road(int road_key)
{
    //删除道路
    QSqlDatabase database = QSqlDatabase::database("qt_sql_default_connection");
    QSqlQuery del_r=QSqlQuery(database);
    QString d_r=QString("DELETE FROM road where road_key='%1'").arg(road_key);

    if(del_r.exec(d_r))
    {
        this->createGraph();
        return true;
    }
    return false;
}
