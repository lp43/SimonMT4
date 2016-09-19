//+------------------------------------------------------------------+
//|                                                 HelloLibrary.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
 int MyCalculator(int value,int value2) export
   {
    return(value+value2);
   }
//+------------------------------------------------------------------+
