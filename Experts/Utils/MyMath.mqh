//+------------------------------------------------------------------+
//|                                                       MyMath.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MyMath
  {
private:

public:
                     MyMath();
                    ~MyMath();
                    double FindClosest(double &array[], double value);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyMath::MyMath()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyMath::~MyMath()
  {
  }
//+------------------------------------------------------------------+
double MyMath::FindClosest(double &array[],double value)
{
    double min = EMPTY_VALUE;
    double closest = value;

    for (double v : array) {
        double diff = MathAbs(v - value);

        if (diff < min) {
            min = diff;
            closest = v;
        }
    }

    return closest;
}