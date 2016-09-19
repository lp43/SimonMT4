//+------------------------------------------------------------------+
//|                                              William VIX-FIX.mq4 |
//|                                    Copyright © 2013, Marketcalls |
//|                                        http://www.marketcalls.in |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2015, Marketcalls"
#property link      "http://www.marketcalls.in"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red 

extern int iPeriod =22;


double VIXFIX[];

int init()
{
 IndicatorShortName("William Vix-Fix");
 IndicatorDigits(Digits);

  SetIndexStyle(0,DRAW_LINE);
  SetIndexBuffer(0,VIXFIX);

 return(0);
}

int deinit()
{

 return(0);
}

int start()
{
 if(Bars<=iPeriod) return(0);
 int ExtCountedBars=IndicatorCounted();
 if (ExtCountedBars<0) return(-1);
 int limit=Bars-2;
 if(ExtCountedBars>2) limit=Bars-ExtCountedBars-1;
 int pos;
 double Max;
 pos=limit;
 while(pos>=0)
 {
  Max=Close[iHighest(NULL, 0, MODE_CLOSE, iPeriod, pos)];
  if (Max>0)
  {
   VIXFIX[pos]=100*(Max-Low[pos])/Max;
  }
  else
  {
   VIXFIX[pos]=0;
  } 
  pos--;
 } 
 return(0);
}

