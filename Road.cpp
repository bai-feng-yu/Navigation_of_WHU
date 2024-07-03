#include "Road.h"

Road::Road(int road_key,Point *pr, Point *pl, string &road_name, float length)
{
    this->pl = pl;
    this->pr = pr;
    this->road_name = road_name;
    this->length = length;
    this->road_key=road_key;
}
