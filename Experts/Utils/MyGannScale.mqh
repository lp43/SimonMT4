//+------------------------------------------------------------------+
//|                                                     MySymbol.mqh |
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
class MyGannScale
  {
private:

public:
                     MyGannScale();
                    ~MyGannScale();
                    static double ConvertToGannValue(string symbol, double value);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyGannScale::MyGannScale()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyGannScale::~MyGannScale()
  {
  }
//+------------------------------------------------------------------+
static double MyGannScale::ConvertToGannValue(string symbol,double value)
  {
     double GannValue = EMPTY_VALUE;
     if(symbol == "USDJPY"){
         
         GannValue = MathRound(value * 10);
         //Alert("iLow: "+value+" , Gann Value => "+GannValue);
     }
     return GannValue;
  }