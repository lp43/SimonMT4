//+------------------------------------------------------------------+
//|                                                 TrailingStop.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "3.00"
#property strict

#include "Transaction\MyTradeHelper.mqh"
#include "Utils\MyTimer.mqh"
//--- input parameters
input int      獲利幾步後啟動=50;
input int      追蹤止損步數=30;
input int      更新秒數=0;

MyTradeHelper tradeHelper;
MyTimer timer1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   //Print("Trailingstop OnInit");
   //EventSetTimer(1);
   
//---
   return(INIT_SUCCEEDED);
  }
  
//void OnStart()
  //{
    //  Alert("開始追蹤步數: "+IntegerToString(開始追蹤步數));
  //}
    
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //--- destroy timer
   //Print("Trailingstop OnDeinit");
   //EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  Print("Trailingstop OnTick");
//---
    if(IsTradeAllowed()){
        if(更新秒數>0){
         if(timer1.IsTimeAfterSec(更新秒數)){
            tradeHelper.TrailingStop(獲利幾步後啟動, 追蹤止損步數);
         }
        }else{
            tradeHelper.TrailingStop(獲利幾步後啟動, 追蹤止損步數);
        }
    }
  }
//+------------------------------------------------------------------+
void onTimer()
  {
   //Print("Trailingstop onTimer");
     // Alert("onTimer");
  }