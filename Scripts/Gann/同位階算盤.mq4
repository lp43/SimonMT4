//+------------------------------------------------------------------+
//|                                                        同位階算盤.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs

#include "..\..\Experts\Utils\Gann.mqh"
#include "..\..\Experts\Utils\GannScale.mqh"

input double beginValue = 123.58; //請輸入欲計算價位
enum ENUM_TRADELEADER
{
   空方司令,
   多方司令
};
extern ENUM_TRADELEADER 盤勢目前主導人; 

Gann gann;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      double bGannValue = GannScale::ConvertToGannValue(Symbol(), beginValue);//美日現今空頭司令
      Alert("bGannValue is: "+bGannValue);
      double baseValue = 1;
      double step = 1;
      int recommandSize = gann.GetRecommandSize(baseValue, bGannValue, 1, 2);
      gann.DrawSquare(baseValue, step, recommandSize, DRAW_CW);  // CW為順時針
      
      //找出同位階
      int beginValueType = IS_LOW;
      if(盤勢目前主導人 == 多方司令){
         beginValueType = IS_HIGH;
      }
      double SameLevel = gann.RunSameLevel(bGannValue, beginValueType, step); 
      double price2 = GannScale::ConvertToValue(Symbol(), SameLevel);
      Alert(beginValue+"("+bGannValue+") 的同位階為 "+price2+"("+SameLevel+")");
  }
//+------------------------------------------------------------------+
