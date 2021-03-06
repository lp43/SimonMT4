//+------------------------------------------------------------------+
//|                                                      事件EA_01.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property description "EA01-事件EA"

#include "Transaction\MyTradeHelper.mqh"//如果要放在EA相同資源用這個
#include "Utils\MyTimer.mqh"
#include "enum\TradeType.mqh"

//--- input parameters
input bool 是否為台灣時區 = TRUE;
input datetime 啟動時間 =D'2016.08.05 17:16';
input datetime 結束時間 =D'2016.08.05 17:20';

input int 開始追蹤止損步數 = 20;
input int 追蹤止損步數 = 15;
input int 止損步數 = 30;

input ENUM_TRADETYPE 交易型式 = 現價;
input int 距離現價步數 = 0;

MyTradeHelper tradeHelper;

MyTimer timer;
MyTimer timer1;
MyTimer timer2;
bool IsEAShouldBeRun;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
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
  if(IsTradeAllowed()){

   if(timer.IsTimeGreaterThan(啟動時間, 是否為台灣時區) && timer.IsTimeSmallThan(結束時間, 是否為台灣時區)){
      IsEAShouldBeRun = true;   
   }else{
      IsEAShouldBeRun = false; 
   }

   if(IsEAShouldBeRun)
   {
   
      runEA();
 
      //Alert("EA On");
   }else{
      //Alert("EA Off");
   }
  }
   
  }
  
  void runEA(){
  
    if(timer1.IsTimeAfterSec(5))
     {
         tradeHelper.TrailingStop(開始追蹤止損步數, 追蹤止損步數);

     }
         
      //Time Frame   
      if(timer2.IsTimeAfterSec(Period()*60)) 
      {

         if(交易型式 == 現價)
         {  
            if(距離現價步數>0){
               Alert("現價交易中，[離現價步數]不能大於0，請修正。");
            }else{
               Buy();
               Sell();
            }
           
         }else{
            if(距離現價步數==0){
               Alert("預掛交易中，[離現價步數]不能等於0，請修正。");
            }
            else
            {
               if(交易型式 == STOP單)
               {
                  BuyStop();
                  SellStop();
               }
               else if(交易型式 == LIMIT單)
               {
                  BuyLimit();
                  SellLimit();
               }
            }
      
         }
         
         
        
      
        
        //Alert("new",IntegerToString(MyCalculator(1,2)));
         //tradeHelper.Hello("Period()");
      }
         
  }
//+------------------------------------------------------------------+

 void Buy()
   {
      int ticket = tradeHelper.SendOrderBuy(Symbol(), OP_BUY, 0.01, 0, 止損步數, 0, 11111);
      if(ticket<0)
      {
         //Alert("OrderSend failed with error #",GetLastError());
      }
      else
      {
         //Alert("OrderSend placed successfully");
      }
 }
 
   void BuyStop()
   {
      int ticket = tradeHelper.SendOrderBuy(Symbol(), OP_BUYSTOP, 0.01, 距離現價步數, 0, 0, 11111);
      if(ticket<0)
      {
         //Alert("OrderSend failed with error #",GetLastError());
      }
      else
      {
         //Alert("OrderSend placed successfully");
      }
 }
 
   void BuyLimit()
   {
      int ticket = tradeHelper.SendOrderBuy(Symbol(), OP_BUYLIMIT, 0.01, 距離現價步數, 0, 0, 11111);
      if(ticket<0)
      {
         //Alert("OrderSend failed with error #",GetLastError());
      }
      else
      {
         //Alert("OrderSend placed successfully");
      }
 }
  void Sell()
 {
 
      int ticket = tradeHelper.SendOrderSell(Symbol(), OP_SELL, 0.01, 0, 止損步數, 0, 11111);
      if(ticket<0)
      {
         //Alert("OrderSend failed with error #",GetLastError());
      }
      else
      {
         //Alert("OrderSend placed successfully");
      }

 }
 
    void SellStop()
   {
      int ticket = tradeHelper.SendOrderSell(Symbol(), OP_SELLSTOP, 0.01, 距離現價步數, 0, 0, 11111);
      if(ticket<0)
      {
         //Alert("OrderSend failed with error #",GetLastError());
      }
      else
      {
         //Alert("OrderSend placed successfully");
      }
 }
 
   void SellLimit()
   {
      int ticket = tradeHelper.SendOrderSell(Symbol(), OP_SELLLIMIT, 0.01, 距離現價步數, 0, 0, 11111);
      if(ticket<0)
      {
         //Alert("OrderSend failed with error #",GetLastError());
      }
      else
      {
         //Alert("OrderSend placed successfully");
      }
 }
