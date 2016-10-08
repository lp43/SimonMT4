//+------------------------------------------------------------------+
//|                                           HelloOrderSend_Buy.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
      //---      Buy();
      Sell();
   
  }
 void Buy()
 {
    double StopLoss=NormalizeDouble(Ask-0.00050, Digits);
    double TakeProfit=NormalizeDouble(Ask+0.00100, Digits);
    
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
    double StopLoss=NormalizeDouble(Bid+0.00050, Digits);
    double TakeProfit=NormalizeDouble(Bid-0.00100, Digits);
    
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
