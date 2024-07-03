#include "Graph.h"
#include "Point.h"
#include "Road.h"

using namespace std;
vector<vector<vector<int>>> get_data();
int main(){

    Graph g; g.graph = get_data();
    vector<vector<int>>paths = g.inquire_all_roads(2,4);
    vector<int> path = g.inquire_shortest_road(2,4);
    return 0;
}
vector<vector<vector<int>>> get_data(){
    int n, m; cin>>n>>m; // n 个点， m 条边
    /*
        测试数据：5 7
                2 3 4
                2 4 10
                3 4 3
                3 5 1
                5 4 1
                2 1 1
                1 5 2
    */
    vector<vector<vector<int>>> res;
    res.resize(n+1);
    for(int i=0;i<m;i++){
        int from, to, w;
        cin>>from>>to>>w;
        res[from].push_back({to, w});
        res[to].push_back({from, w});
    }
    return res;
}