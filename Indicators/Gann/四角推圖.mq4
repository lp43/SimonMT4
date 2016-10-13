//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   //Alert("OnCalculate");
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {

//--- If this is an event of a mouse click on the chart
   if(id==CHARTEVENT_CLICK)
     {
      //--- Prepare variables
      int      x     =(int)lparam;
      int      y     =(int)dparam;
      datetime dt    =0;
      double   price =0;
      int      window=0;


      //--- Convert the X and Y coordinates in terms of date/time
      if(ChartXYToTimePrice(0,x,y,window,dt,price))
        {
         //PrintFormat("Window=%d X=%d  Y=%d  =>  Time=%s  Price=%G",window,x,y,TimeToString(dt),price);
         
         int shift = iBarShift(Symbol(), Period(), dt, false);
         double      price_high = High[shift];
         double      price_low  = Low[shift];
         
         //--- Show the event parameters on the chart
         Comment(__FUNCTION__,": dt=",dt," High=",price_high," Low=",price_low);
      
         //--- delete lines
         ObjectDelete(0,"V Line");
         ObjectDelete(0,"H Line");
         //--- create horizontal and vertical lines of the crosshair
         ObjectCreate(0,"H Line",OBJ_HLINE,window,dt,price_high);
         ObjectSetInteger(0,"H Line",OBJPROP_COLOR,clrGreen);
         ObjectCreate(0,"V Line",OBJ_VLINE,window,dt,price);
         ObjectSetInteger(0,"V Line",OBJPROP_COLOR,clrGreen);
         ChartRedraw(0);
              
        }
      else
         Print("ChartXYToTimePrice return error code: ",GetLastError());
      Print("+--------------------------------------------------------------+");
      
     }
    
  }
//+------------------------------------------------------------------+

  int deinit()
  {
//----
   ObjectDelete(0, "H Line");
   ObjectDelete(0, "V Line");
   //ObjectsDeleteAll();
//----
   return(0);
  }