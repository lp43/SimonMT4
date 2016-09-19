//+------------------------------------------------------------------+
//|                                               HelloIndicator.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#include "..\Experts\Utils\MyTimer.mqh"

input datetime 啟始時段 = D'2015.03.16 00:00';

MyTimer timer;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   DrawLable("bars", "Bar Size: "+IntegerToString(Bars),16, ANCHOR_RIGHT,10, 10, clrWhite);
   
   int firstBarIdx = FindBarIndex(啟始時段);
   if(firstBarIdx!=-1){
      DrawBarsName(firstBarIdx);
   }else{
      Alert("找不到時間為: "+TimeToString(啟始時段)+" 的K棒。");
   }
//---
   return(INIT_SUCCEEDED);
  }
  
  int deinit()
  {
//----
   ObjectsDeleteAll();
//----
   return(0);
  }
  
  int FindBarIndex(datetime finddatetime){
      int returnValue = -1;
      for(int i = 0; i<Bars; i++)
      {  
         if(timer.IsTimeMatch(finddatetime, Time[i]))
         {
            returnValue = i;
            //Alert(IntegerToString(i)+", 日期是: "+TimeToString(Time[i], TIME_DATE|TIME_MINUTES)+", High: "+DoubleToString(High[i]));
            
            break;
         }
      }
     return returnValue;
  }
    
  
  void DrawBarsName(int firstBarIdx)
  {
      //DrawText("text", "第1根", Time[firstBarIdx], High[firstBarIdx]);
      
      
      for (int i = firstBarIdx; i>0;i--)
      {
         int barIdx = firstBarIdx - i +1;
         DrawText("text"+IntegerToString(barIdx), IntegerToString((barIdx)),8, 80, Time[i], High[i]);
      }
  }
  
  void DrawArrowUp(string ArrowName,double LinePrice)
{
   ObjectCreate(ArrowName, OBJ_ARROW, 0, Time[0], LinePrice); //draw an up arrow
   ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, 233);
   ObjectSet(ArrowName, OBJPROP_COLOR,clrBlue);

}

void DrawArrowDown(string ArrowName,double LinePrice)
{
   ObjectCreate(ArrowName, OBJ_ARROW, 0, Time[0], LinePrice); //draw an up arrow
   ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, 234);
   ObjectSet(ArrowName, OBJPROP_COLOR,clrRed);
}

void DrawLable(string Name, string text, int size, int right_left, int x_distance, int y_distance, color clr)
{
   ObjectCreate(Name, OBJ_LABEL, 0, 0, 0);
   ObjectSet(Name, OBJPROP_CORNER, right_left);
   ObjectSet(Name, OBJPROP_XDISTANCE, x_distance);
   ObjectSet(Name, OBJPROP_YDISTANCE, y_distance);
   ObjectSet(Name, OBJPROP_ALIGN, ALIGN_RIGHT);

   ObjectSetText(Name,text,size,"Arial",clr);
}
void DrawText(string Name, string text, int size, int angle, datetime x_distance, double y_distance){
   //ObjectCreate(Name, OBJ_TEXT, 0, Time[0], Close[0]);
   ObjectCreate(Name, OBJ_TEXT, 0, x_distance, y_distance);
   ObjectSetText(Name,text,size,"Arial", clrWheat);
   ObjectSet(Name,OBJPROP_ANGLE,angle);
   ObjectSet(Name, OBJPROP_ALIGN, ALIGN_CENTER);
}
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
    return(rates_total);
  }
//+------------------------------------------------------------------+
