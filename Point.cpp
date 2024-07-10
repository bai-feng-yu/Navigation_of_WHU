#include "Point.h"

Point::Point(int k, string &point_name, std::string &point_intro)
{
    this->point_key = k;
    this->point_name = point_name;
    this->point_intro = point_intro;
}
