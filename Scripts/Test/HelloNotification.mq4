//+------------------------------------------------------------------+
//|                                            HelloNotification.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input string message="Enter message text";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
  Print("OnStart");
      //--- Send the message
   bool res=SendNotification(message);
   if(!res)
     {
      Print("Message sending failed"+", error: "+GetLastError());
      
     }
   else
     {
      Print("Message sent");
     }
   
  }
//+------------------------------------------------------------------+
