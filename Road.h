#ifndef ROAD_H
#define ROAD_H
#include "Point.h"
#include <vector>
#include<string>

using namespace std;
class Road {
public:
    Point* pr, *pl;//左右的点
    int road_key; // 对应显示 ui 界面的编号
    string road_name;//路的名称（如弘毅大道）
    float length;//路的长度
    Road(int road_key,Point *pr, Point *pl, string &road_name, float length);
    //bool road_name_match(string& str,Road &line);//检测字符串是否与某段道路名字相匹配
};
#endif // ROAD_H
