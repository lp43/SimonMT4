//+------------------------------------------------------------------+
//|                                                      HelloTS.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
//--- input parameters
input int MAGIC_NUM = 11111;
input int 追蹤步數 = 10;
void OnStart()
  {
      TrailingStop();
   
  }
  

void TrailingStop()
{
   Print("TrailingStop");
   //if(IsTradeAllowed()){
      Print("IsTradeAllowed");

      for(int i = 0; i < OrdersTotal(); i++)
      {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false)
         break;
    
         if(OrderMagicNumber() == MAGIC_NUM)
         {
            if(OrderType()==OP_BUY && Bid - OrderOpenPrice() > 追蹤步數 * Point && OrderStopLoss() < Bid - 追蹤步數*Point)
            {
               Print("into orderModify BUY::: "+IntegerToString(OrderTicket()));
               bool res = OrderModify(OrderTicket(), OrderOpenPrice(), Bid - 追蹤步數*Point, OrderTakeProfit(), 0, clrGreen);
           
               AlertResult(res);
            }
            if(OrderType()==OP_SELL && OrderOpenPrice() - Ask > 追蹤步數*Point && OrderStopLoss() > Ask + 追蹤步數*Point)
            {
               Print("into orderModify SELL::: "+IntegerToString(OrderTicket()));
               bool res = OrderModify(OrderTicket(), OrderOpenPrice(), Bid + 追蹤步數*Point, OrderTakeProfit(), 0, clrGreen);
               
               AlertResult(res);
            }
         }
      
      }
      
  
  // }

}
void AlertResult(bool res)
{
 if(!res)
      Alert("Error in OrderModify. Error code=",GetLastError());
    else
      Alert("Order modified successfully.");
}

void PrintResult(bool res)
{
 if(!res)
      Print("Error in OrderModify. Error code=",GetLastError());
    else
      Print("Order modified successfully.");
}
//+------------------------------------------------------------------+
