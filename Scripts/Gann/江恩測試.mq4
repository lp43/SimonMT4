//+------------------------------------------------------------------+
//|                                                        江恩 V1.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\..\Experts\Utils\GannScale.mqh"
#include "..\..\Experts\Instance\GannSquare\Windmill.mqh"


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
   double baseValue = 1;
   //double beginValue = 1235;//美日現今空頭司令
   //double beginValue = GannScale::ConvertToGannValue(Symbol(),100.075);
   //Alert("beginValue: "+beginValue);
   double beginValue = 29;
   double step = 1;

   // 角線測試
   //double Angles[];
   //int angle = gann.RunAngle(RUN_LOW, beginValue, Angles);
   //Debug::PrintArray("Angles",Angles, 0);
   //Alert(beginValue+"'s HIGH Angle is: "+angle);
   
   // 十字線測試
   //double Crosses[];
   //int cross = gann.RunCross(RUN_LOW, beginValue, step, Crosses);
   //Alert(beginValue+"'s RUN_LOW Cross is: "+cross);
   
   // 同位階測試
   //double sameLevel = gann.RunSameLevel(beginValue, IS_LOW, step);
   //Alert(beginValue+"'s sameLevel is: "+sameLevel);  
   
   // 測試價位轉換
   //double gannValue = GannScale::ConvertToGannValue(Symbol(), iLow(Symbol(), Period(), 1));
   //double value = GannScale::ConvertToValue(Symbol(), gannValue);
 

   // Constellate完整跑圖
   //GannValue *Constellates[];
   //gann.RunFullConstellate(RUN_LOW, 922, step, 10, true, Constellates);
   //Debug::PrintArray("Constellates", Constellates);
    
   // Constellate 四角推圖
    //GannValue* FourAngles[];
    //int parts = 10;
    //gann.RunFourAngles(RUN_LOW, beginValue, step, parts, FourAngles);

   
   // 實算美日同位階
//   int days = 200; 
//   for(int i = 0; i< days; i++){
//       //單位轉換測試
//       string time1 = TimeToStr(iTime(Symbol(), Period(), i), TIME_DATE);
//       double value1 = iLow(Symbol(), Period(), i);
//       double beginValue = GannScale::ConvertToGannValue(Symbol(), value1);
//      
//       //同位階測試
//       double sameLevel = gann.RunSameLevel(beginValue, IS_LOW, step);
//      
//       for(int j = 0; j <days; j++){
//          //單位轉換測試
//          string time2 = TimeToStr(iTime(Symbol(), Period(), j), TIME_DATE);
//          double gannValue = GannScale::ConvertToGannValue(Symbol(), iLow(Symbol(), Period(), j));
//          if(gannValue == sameLevel){
//             double value2 = GannScale::ConvertToValue(Symbol(), sameLevel);
//             Alert("====== ["+time1+"] "+DoubleToStr(value1, Digits)+" 出現同位階 ,對應點位 ["+time2+"] "+DoubleToStr(value2, Digits)+" ======");   
//             break;
//          }
//       }
//      //if(sameLevel!=EMPTY_VALUE)
//         //Alert("=========== "+beginValue+" 's sameLevel is: "+sameLevel+" ===========");   
//   }

   //所屬圈數運算
   //double searchValue = 25;
   //double circlenum = gann.GetCircleNumByValue(searchValue);
   //Alert(searchValue+"'s circle num is : "+circlenum);   
   
   //風車位推圖
   Windmill* gann = new Windmill();
   // 詢問建議圈數
   int recommandSize = gann.GetRecommandSize(baseValue, beginValue, step, 2);
   //recommandSize = 7;
   Alert("recommandSize: "+recommandSize);
   gann.DrawSquare(baseValue, step, recommandSize, DRAW_CW);  // CW為順時針
   GannValue* gannValue[];
   gann.SetValues(141,65);
   gann.Run(gannValue);
   //gann.RunWindmill(141, 65);
  }
//+------------------------------------------------------------------+
