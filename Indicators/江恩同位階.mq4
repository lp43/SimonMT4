//+------------------------------------------------------------------+
//|                                                        江恩同位階.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

//#property indicator_color1 Blue // Long signal
//#property indicator_color2 Red // Short signal
//#property indicator_width1 3 // Long signal arrow
//#property indicator_width2 3 // Short signal arrow

#include "..\Experts\Utils\Gann.mqh"
#include "..\Experts\Utils\GannScale.mqh"

int margin = 50;
extern int 欲查詢天數 = 90;
extern double baseValue = 1;
extern double step = 1;

//double         UpArrowBuffer[]; 
//double         DownArrowBuffer[];

Gann gann;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
    //---- 2 allocated indicator buffers
    //SetIndexBuffer(0,UpArrowBuffer); //0 向上箭頭
    //SetIndexBuffer(1,DownArrowBuffer); //1 向下箭頭
    ////---- drawing parameters setting
    //SetIndexStyle(0,DRAW_ARROW);
    //SetIndexArrow(0,233); //0 向上箭頭
    //SetIndexStyle(1,DRAW_ARROW);
    //SetIndexArrow(1,234);//1 向下箭頭
    
   //---- 詢問建議圈數
   double beginValue = 1235;//美日現今空頭司令
   int recommandSize = gann.GetRecommandSize(baseValue, beginValue, step, 2);
   gann.DrawSquare(1, step, recommandSize, DRAW_CW);  // CW為順時針
   
  //---- 開始檢查同位階
  for(int i = 0; i< 20;i++){
   Alert("value i: "+i);
      //---- 先找出轉折點位
      double value = iCustom(Symbol(), Period(), "趨勢轉向", 0, i);
      
      //---- 從轉折點中找出同位階
      if(value!=EMPTY_VALUE){
          //Alert("value i: "+i+" Time: "+TimeToStr(Time[i], TIME_DATE|TIME_MINUTES)+" is: "+value);
          string time1 = TimeToStr(iTime(Symbol(), Period(), i), TIME_DATE);
          double value1 = Low[i];
          //UpArrowBuffer[i]=value;//向下趨勢
          
         //Alert("至低點為: "+TimeToStr(Time[i], TIME_DATE | TIME_MINUTES)+", 價位在: "+Low[i]);
          double bValue = GannScale::ConvertToGannValue(Symbol(), value1);

          //同位階測試
          double sameLevel = gann.RunSameLevel(bValue, IS_LOW, step);
         
         //檢查全部K棒Loading太重，因此只檢查前後15天
          for(int j = i-15; j <i+30; j++){
             //單位轉換測試
             string time2 = TimeToStr(iTime(Symbol(), Period(), j), TIME_DATE);
             double gannValue = GannScale::ConvertToGannValue(Symbol(), iLow(Symbol(), Period(), j));
             if(gannValue == sameLevel){
                double value2 = GannScale::ConvertToValue(Symbol(), sameLevel);
                Alert("====== ["+time1+"] "+DoubleToStr(value1, Digits)+" 出現同位階 ,對應點位 ["+time2+"] "+DoubleToStr(value2, Digits)+" ======");
                //UpArrowBuffer[j]=value2-(50*Point);   
                break;
             }
          }
      
      }
        
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
  
  int start()
   {
      
     //int limit;
     //int counted_bars=IndicatorCounted();
     // //---- check for possible errors
     //if(counted_bars<0) return(-1);
     // //---- the last counted bar will be recounted
     //if(counted_bars>0) {
     //    counted_bars--;
     //  //Alert("counted_bars: "+counted_bars);
     //}
     //limit=Bars-counted_bars;
   

      
      return(0);
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
