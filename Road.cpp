#include "Road.h"

Road::Road(Point *pr, Point *pl, string &road_name, int length)
{
    this->pl = pl; 
    this->pr = pr; 
    this->road_name = road_name;
    this->length = length;
}