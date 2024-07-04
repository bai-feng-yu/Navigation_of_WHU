#ifndef POINT_H
#define POINT_H
#pragma once
#include<iostream>
#include <vector>
#include <string>
using namespace std;

class Point
{
public:
    int point_key;//代号，索引 // 显示在 ui 上
    string point_name;//点名
    string point_intro;//景点简介
    Point(int k, string& point_name, std::string& point_intro);//堆上构造
};
#endif // POINT_H
