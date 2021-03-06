//+------------------------------------------------------------------+
//|                                                      HelloEA.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//#include <Transaction\HelloLibrary.mqh> //如果要放在Include資料夾用這個
#include "Transaction\MyTradeHelper.mqh"//如果要放在EA相同資源用這個
#include "Utils\MyTimer.mqh"

input int 開始追蹤步數 = 20;
input int 追蹤步數 = 15;
input int 止損步數 = 30;
MyTradeHelper tradeHelper;

MyTimer timer1;
MyTimer timer2;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   //EventSetTimer(1000);
      
   return(INIT_SUCCEEDED);
  }
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   //EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
  {

      
      if(IsTradeAllowed()){
      //---
      
         if(timer1.IsAfterSec(5))
         {
            tradeHelper.TrailingStop(開始追蹤步數, 追蹤步數);
            //tradeHelper.Hello("Hello 5秒");
         }
        

         //Time Frame   
         if(timer2.IsAfterSec(Period()*60)) 
         {
         
           Buy();
           Sell();
           
           //Alert("new",IntegerToString(MyCalculator(1,2)));
            //tradeHelper.Hello("Period()");
         }
        
           
            
      }
     
         
  }
  
  void Buy()
 {
    double StopLoss=NormalizeDouble(Ask-止損步數*Point, Digits);
    //double TakeProfit=NormalizeDouble(Ask+0.00100, Digits);
    //double StopLoss=0;
    double TakeProfit=0;
    Print("StopLoss: "+ DoubleToString(StopLoss)+", TakeProfit: "+DoubleToString(TakeProfit));
    
      int ticket = OrderSend(Symbol(), OP_BUY, 0.01, Ask, 3, StopLoss, TakeProfit, "MyFirstOrder", 11111, 0, clrBlue);
      
      if(ticket<0)
      {
         Print("OrderSend failed with error #",GetLastError());
      }
      else
      {
         Print("OrderSend placed successfully");
      }

 }
 
  void Sell()
 {
    double StopLoss=NormalizeDouble(Bid+止損步數*Point, Digits);
    //double TakeProfit=NormalizeDouble(Bid-0.00100, Digits);
    //double StopLoss=0;
    double TakeProfit=0;
    Print("StopLoss: "+ DoubleToString(StopLoss)+", TakeProfit: "+DoubleToString(TakeProfit));
    
      int ticket = OrderSend(Symbol(), OP_SELL, 0.01, Bid, 3, StopLoss, TakeProfit, "MyFirstOrder", 11111, 0, clrBlue);
      
      if(ticket<0)
      {
         Print("OrderSend failed with error #",GetLastError());
      }
      else
      {
         Print("OrderSend placed successfully");
      }

 }
 
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
