//+------------------------------------------------------------------+
//|                                                          風車位.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//#property indicator_chart_window

#include "../../Experts/Instance/GannSquare/Windmill.mqh"
#include "../../Experts/Utils/GannScale.mqh"

double mPrice1,mPrice2;
long unique_id;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME,"WINDMILL");
   unique_id = Debug::GetTimeLocal();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   //--- Show the event parameters on the chart
   //Comment(__FUNCTION__,": id=",id," lparam=",lparam," dparam=",dparam," sparam=",sparam);
      if(id==CHARTEVENT_CLICK)
     {
      //--- Prepare variables
      int      x     =(int)lparam;
      int      y     =(int)dparam;
      datetime dt    =0;
      double   price =0;
      int      window=0;
      //--- Convert the X and Y coordinates in terms of date/time
      if(ChartXYToTimePrice(0,x,y,window,dt,price))
        {
         PrintFormat("Window=%d X=%d  Y=%d  =>  Time=%s  Price=%G",window,x,y,TimeToString(dt),price);
         //--- Perform reverse conversion: (X,Y) => (Time,Price)
         if(ChartTimePriceToXY(0,window,dt,price,x,y))
            PrintFormat("Time=%s  Price=%G  =>  X=%d  Y=%d",TimeToString(dt),price,x,y);
         else
            Print("ChartTimePriceToXY return error code: ",GetLastError());
            
            int shift = iBarShift(Symbol(), Period(), dt, false);
            double      price_high = High[shift];
            double      price_low  = Low[shift];
            double      price_to_compute = price_low;
            
            
            if(mPrice1==0){
               mPrice1=price;
               Comment(__FUNCTION__,": dt=",dt," Price1=",DoubleToStr(mPrice1, Digits)," Price2=",DoubleToStr(mPrice2, Digits));
               DrawCross(window, dt, clrRed, mPrice1, price);
            }else if(mPrice2==0){
               mPrice2=price;
               Comment(__FUNCTION__,": dt=",dt," Price1=",DoubleToStr(mPrice1, Digits)," Price2=",DoubleToStr(mPrice2, Digits));
               DrawCross(window, dt, clrMagenta, mPrice2, price);
               
               RunWindmill(mPrice1, mPrice2);
            }
            
        }
      else
         Print("ChartXYToTimePrice return error code: ",GetLastError());
      Print("+--------------------------------------------------------------+");
     }
     if(sparam=="WINDMILL_BUTTON_DEL_INDICATOR"){
         //ObjectSetInteger(0,"WINDMILL_BUTTON_DEL_INDICATOR",OBJPROP_STATE,false);
         int window=ChartWindowFind();
         ChartIndicatorDelete(0, window, "WINDMILL");
     }
  }
  void RunWindmill(double price1, double price2){
     double gannValue1 = GannScale::ConvertToGannValue(Symbol(),price1);
     double gannValue2 = GannScale::ConvertToGannValue(Symbol(),price2);
     
     
     int step = (gannValue1<gannValue2)?1:-1;
     //Alert("GannValue1: "+gannValue1+", gannValue2: "+gannValue2+", step: "+step);
     Windmill gann;
     int recommand = gann.GetRecommandSize(gannValue1, gannValue2, step, 2);
     //Alert("recommand size is: "+recommand);
     gann.DrawSquare(gannValue1, step, recommand, DRAW_CW);
     //Debug::PrintArray("crValues",cursor);
     
     int run_type=RUN_BOTH;
     gann.SetDatas(run_type, gannValue2, gannValue1);
     GannValue* ganns[];
     gann.Run(ganns);
     //Debug::PrintArray("Windmill",ganns);
     
     DrawLines(ganns);
     DrawButton("WINDMILL_BUTTON_DEL_INDICATOR", "刪除當沖預測", 130, 50);
  }
//+------------------------------------------------------------------+
  void DeleteObjects(){     
     ObjectsDeleteAll(0, "WINDMILL_", -1, -1);
     Comment("");
  }
  
 void DrawCross(int window, datetime dt, color clr, double x, double y){
      
      //--- create horizontal and vertical lines of the crosshair
      string HORIZONTAL_LINE = "WINDMILL_LINE_H_"+TimeToStr(dt, TIME_DATE|TIME_MINUTES);
      ObjectCreate(0,HORIZONTAL_LINE,OBJ_HLINE,window,dt,y);
      ObjectSetInteger(0,HORIZONTAL_LINE,OBJPROP_COLOR,clr);
      string VERTICAL_LINE   = "WINDMILL_LINE_V_"+TimeToStr(dt, TIME_DATE|TIME_MINUTES);
      ObjectCreate(0,VERTICAL_LINE,OBJ_VLINE,window,dt,y);
      ObjectSetInteger(0,VERTICAL_LINE,OBJPROP_COLOR,clr);
      ChartRedraw(0);

  }

void DrawLines(GannValue* &ganns[]){
   for(int i = 0; i <ArraySize(ganns);i++){
      double value = GannScale::ConvertToValue(Symbol(),ganns[i].value);
      DrawLine("WINDMILL_LINE_"+unique_id+"_"+i,value);
   }
  
} 
void DrawLine(string obj_name, double positionY){
   ObjectCreate(obj_name, OBJ_HLINE , 0, Time[0], positionY);
   //ObjectSet(obj_name, OBJPROP_STYLE, STYLE_DASH);
   ObjectSet(obj_name, OBJPROP_COLOR, clrLavender);
   ObjectSet(obj_name, OBJPROP_WIDTH, 2);
   //ObjectSetText(obj_name, "What you want to call your line", 8, "Arial", Orange); 
}

void DrawButton(string obj_name, string text, int width, int height){
    ObjectCreate(0,obj_name,OBJ_BUTTON,0,0,0);
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,obj_name,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,25+width);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,25);
    ObjectSetInteger(0,obj_name,OBJPROP_XSIZE,width);
    ObjectSetInteger(0,obj_name,OBJPROP_YSIZE,height);
    ObjectSetString(0,obj_name,OBJPROP_TEXT,text);
}

void OnDeinit(const int reason)
  {
  //----
   //Alert("OnDeinit reason: "+reason);
   if(reason == REASON_REMOVE){
       DeleteObjects();
}
  

//----
   
  }