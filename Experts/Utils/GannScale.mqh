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
class GannScale
  {
private:

public:
                     GannScale();
                    ~GannScale();
                    static double ConvertToGannValue(string symbol, double value);
                    static double ConvertToValue(string symbol, double gann_value);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GannScale::GannScale()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GannScale::~GannScale()
  {
  }
//+------------------------------------------------------------------+
static double GannScale::ConvertToGannValue(string symbol,double value)
  {
     double gannValue = EMPTY_VALUE;
     if(symbol == "USDJPY"){
         
         gannValue = NormalizeDouble(value * 10, 0);
         //Alert("iLow: "+value+" , Gann Value => "+gannValue);
     }
     return gannValue;
  }
  
static double GannScale::ConvertToValue(string symbol,double gann_value)
  {
     double value = EMPTY_VALUE;
     if(symbol == "USDJPY"){
         
         value = NormalizeDouble(gann_value / 10, Digits);
         //Alert("gann_value: "+gann_value+" , Value => "+DoubleToStr(value, Digits));
     }
     return value;
  }