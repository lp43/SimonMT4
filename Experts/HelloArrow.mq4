//+------------------------------------------------------------------+
//|                                                   HelloArrow.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   //ChartApplyTemplate(0,"templates\\Simon_5_10.tpl");
      ObjectSetText("Label_Obj_MACD","HelloText",10,"Arial",clrRed);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
    DrawArrowUp("UP", 1.10855, clrAliceBlue);
  }
//+------------------------------------------------------------------+
  void DrawArrowUp(string ArrowName,double LinePrice,color LineColor)
{
   ObjectCreate(ArrowName, OBJ_ARROW, 0, Time[0], LinePrice); //draw an up arrow
   //ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   //ObjectSet(ArrowName, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
   //ObjectSet(ArrowName, OBJPROP_COLOR,LineColor);
   ObjectSet(ArrowName,OBJPROP_COLOR,LimeGreen);
}