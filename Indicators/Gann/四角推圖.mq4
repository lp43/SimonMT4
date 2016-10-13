//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#include "..\..\Experts\Utils\Gann.mqh"
#include "..\..\Experts\Utils\GannScale.mqh"

enum ENUM_RUNMODE
{
   求接下來低點,
   求接下來高點
};

extern ENUM_RUNMODE RunMode;//跑圖方向
extern int parts = 6;//欲跑段數

Gann gann;
GannValue* GannValues[];
bool iscomputing = false;
string HORIZONTAL_LINE = "H Line";
string VERTICAL_LINE = "V Line";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   if(RunMode==求接下來低點){
      Alert("請在圖表視窗選擇一根 \"至高點\" K棒，以利四角推圖。");
   }else{
      Alert("請在圖表視窗選擇一根 \"至低點\" K棒，以利四角推圖。");
   }
   
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
   //Alert("OnCalculate");
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
   if(iscomputing==TRUE){
      Alert("背景仍在作業中，請稍候再試");
      return;
   }
   
   //--- If this is an event of a mouse click on the chart
   if( id==CHARTEVENT_CLICK)
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
         //PrintFormat("Window=%d X=%d  Y=%d  =>  Time=%s  Price=%G",window,x,y,TimeToString(dt),price);
         
         int shift = iBarShift(Symbol(), Period(), dt, false);
         double      price_high = High[shift];
         double      price_low  = Low[shift];
         double      price_to_compute = price_low;
         if(RunMode==求接下來低點){
            price_to_compute    = price_high;
         }
      
         //--- Show the event parameters on the chart
         Comment(__FUNCTION__,": dt=",dt," High=",DoubleToStr(price_high, Digits)," Low=",DoubleToStr(price_low, Digits));
         //--- 繪製十字線
         DrawCross(window, dt, clrGreen, price, price_to_compute);
         //--- 繪製跑圖結果
         GannValue* FourAngleValues[];
         RunFourAngles(shift, FourAngleValues);     
         //Alert("Value1: "+FourAngleValues[0].value);
         DrawTables(FourAngleValues,price_to_compute);
        }
      else
         Print("ChartXYToTimePrice return error code: ",GetLastError());
      Print("+--------------------------------------------------------------+");
      
     }
    
  }
//+------------------------------------------------------------------+

  int deinit()
  {
//----
   DeleteObjects();
//----
   return(0);
  }
  
  void DeleteObjects(){
     ObjectDelete(0, HORIZONTAL_LINE);
     ObjectDelete(0, VERTICAL_LINE);
     
     ObjectsDeleteAll(0, "LABEL_", -1, -1);
  }
  
  void DrawCross(int window, datetime dt, color clr, double price, double price_to_compute){
        //--- delete lines
      DeleteObjects();
      //--- create horizontal and vertical lines of the crosshair
      ObjectCreate(0,HORIZONTAL_LINE,OBJ_HLINE,window,dt,price_to_compute);
      ObjectSetInteger(0,HORIZONTAL_LINE,OBJPROP_COLOR,clr);
      ObjectCreate(0,VERTICAL_LINE,OBJ_VLINE,window,dt,price);
      ObjectSetInteger(0,VERTICAL_LINE,OBJPROP_COLOR,clr);
      ChartRedraw(0);

  }
  
  // Constellate 四角推圖
  void RunFourAngles(int  shift, GannValue* &array[]){
      //Alert("shift: "+shift);
      iscomputing = true;
      
      
      int run_type = RUN_HIGH;
      double price = High[shift];
      if(RunMode==求接下來低點){
         run_type = RUN_LOW;
         price    = Low[shift];
      }

      double gannValue = GannScale::ConvertToGannValue(Symbol(), price);
      //Alert("price: "+DoubleToStr(price, Digits)+" => gannValue: "+gannValue);
      
      //---繪製江恩矩陣
      double baseValue = 1;
      double beginValue = gannValue;
      double step = 1;
      // 詢問建議圈數
      int recommandSize = gann.GetRecommandSize(baseValue, beginValue, step, 2);
      //Alert("baseValue: "+baseValue+", beginValue: "+beginValue+", step: "+step+", recommandSize: "+recommandSize);
      gann.DrawSquare(baseValue, step, recommandSize, DRAW_CW);  // CW為順時針
      
      //---開始四角推圖
      gann.RunFourAngles(run_type, beginValue, step, parts, array);
      
      iscomputing = false;
  }
  
  void DrawTables(GannValue* &values[], double begin_value){
      int chart_ID = 0;
      
      //---繪製主標題
      string prename = "LABEL_";
      string text1 = "高";
      string text2 = "低";
      string titleLeft;
      string titleRight;
      if(RunMode==求接下來低點){
         titleLeft = text2;
         titleRight = text1;
      }else{
         titleLeft = text1;
         titleRight = text2;
      }
      string title_text = DoubleToStr(begin_value, Digits)+"求"+titleLeft+"點";
      DrawLabel(chart_ID, prename+"MAIN_TITLE", title_text, 20, 10, 10, clrWhite);//橫x高y
      
      //---繪製副標題
      DrawLabelLeft(chart_ID, prename+"SUB_TITLE_1", "預測"+titleLeft+"點", 16, 0, clrGray);
      DrawLabelRight(chart_ID, prename+"SUB_TITLE_2", "預測"+titleRight+"點", 16, 0, clrGray);
      
      int pre_row = NULL;
      for(int i = 0; i <ArraySize(values);i++){
         int row = values[i].part;  
         double PredictPrice = GannScale::ConvertToValue(Symbol(),values[i].value);
         //Alert("row is: "+row+", pre_row: "+pre_row);
         if(pre_row == NULL){
            pre_row = row;
            DrawLabelLeft(chart_ID, prename+"ROW_"+row+"_LEFT", PredictPrice, 16, row, clrYellow);
            //Alert("DrawLabelLeft values["+i+"].value: "+values[i].value);  
         }else{
            pre_row = NULL;
            DrawLabelRight(chart_ID, prename+"ROW_"+row+"_RIGHT", PredictPrice, 16, row, clrYellow);
            //Alert("DrawLabelRight values["+i+"].value: "+values[i].value);
         }
         
      }
      
  }
  void DrawLabel(int chart_id, string name, string text, int font_size, int x, int y, int clr){
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(chart_id,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(chart_id,name,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
      ObjectSetInteger(chart_id,name,OBJPROP_SELECTABLE,0);
      ObjectSetInteger(chart_id,name,OBJPROP_XDISTANCE,x); 
      ObjectSetInteger(chart_id,name,OBJPROP_YDISTANCE,y);
      ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
      ObjectSetInteger(chart_id,name,OBJPROP_FONTSIZE,font_size);
      //ObjectSetInteger(chart_id,name,OBJPROP_BACK,true);
      ObjectSetInteger(chart_id,name,OBJPROP_COLOR,clr);
  }
  
  void DrawLabelLeft(int chart_id, string name, string text, int font_size, int row_idx, int clr){
      int y = 40 + row_idx *25;
      DrawLabel(chart_id, name, text, font_size, 150, y, clr);
  }
  void DrawLabelRight(int chart_id, string name, string text, int font_size, int row_idx, int clr){
      int y = 40 + row_idx *25;
      DrawLabel(chart_id, name, text, font_size, 10, y, clr);
  }