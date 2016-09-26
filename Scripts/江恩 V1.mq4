//+------------------------------------------------------------------+
//|                                                        江恩 V1.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\Experts\Utils\Gann.mqh"
#include "..\Experts\Utils\MyGannScale.mqh"
Gann gann;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
   double baseValue = 150;
   double beginValue = 922;
   double step = 1;
   // 詢問建議圈數
   int recommandSize = gann.GetRecommandSize(baseValue, beginValue, step, 2);
   gann.DrawSquare(1, step, recommandSize, DRAW_CW);  // CW為順時針
   
   
   // 角線測試
   //double Angles[];
   //int angle = gann.RunAngle(RUN_LOW, beginValue, Angles);
   //Alert(beginValue+"'s HIGH Angle is: "+angle);
   
   // 十字線測試
   //double Crosses[];
   //int cross = gann.RunCross(RUN_LOW, beginValue, step, Crosses);
   //Alert(beginValue+"'s HIGH Cross is: "+cross);
   
   // 同位階測試
   //double sameLevel = gann.RunSameLevel(beginValue, IS_HIGH, step);
   //Alert(beginValue+"'s sameLevel is: "+sameLevel);  
  
   // 實單同位階測試  
//   for(int i = 0; i< 100; i++){
//      // 單位轉換測試
//      double beginValue = MyGannScale::ConvertToGannValue(Symbol(), iLow(Symbol(), Period(), i));
//      
//      // 同位階測試
//      double sameLevel = gann.RunSameLevel(beginValue, IS_LOW, step);
//      
//      //if(sameLevel!=EMPTY_VALUE)
//         //Alert("=========== "+beginValue+" 's sameLevel is: "+sameLevel+" ===========");   
//      
//   }

      // Constellate完整跑圖
      double Constellates[];
      gann.RunFullConstellate(RUN_LOW, beginValue, step, 5, true, Constellates);
      
   
  }
//+------------------------------------------------------------------+
