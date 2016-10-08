//+------------------------------------------------------------------+
//|                                                     examples.mq4 |
//|         Copyright ?2007, Antonio Banderass. All rights reserved |
//|                                               banderassa@ukr.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2007, Antonio Banderass. All rights reserved"
#property link      "banderassa@ukr.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   
   // example 1: finding the maximal and minimal price among all bars
   // and showing results

 
   //MessageBox("Bars size: "+Bars);
   MessageBox("High[0]: "+High[0]+", Low[0]: "+Low[0]+", Volume[0]: "+ Volume[0]);
   double max=0.0;
   double min=10.0;
   
   for(int a=0;a<Bars;a++)
   {
      if(High[a]>max)
         max=High[a];
         
      if(Low[a]<min)
         min=Low[a];         
   }
   
   //--- MessageBox("max="+max+" min="+min,"max and min prices");
   
   // example 2: finding the average maximal and minimal price 
   
   double maxAverage=0.0;
   double minAverage=0.0;
   
   for(a=0;a<Bars;a++)
   {
      maxAverage+=High[a];
      minAverage+=Low[a];         
   }
   
   maxAverage/=Bars+1;
   minAverage/=Bars+1;
   
     //--- MessageBox("maxAverage="+maxAverage+" minAverage="+minAverage,"max and min averages");  
   
   // example 3: counting the amount of "white", "black" and "gray" candlesticks
   
   int black=0;
   int white=0;
   int grey=0;
   
   for(a=0;a<Bars;a++)
   {
      if(Close[a]>Open[a])
         white++;
      else if(Close[a]<Open[a])
         black++;
      else
         grey++;
   }
   
     //--- MessageBox("black="+black+" white="+white+" grey="+grey,"candles");  
   
   // example 4: counting the maximal amount of candlesticks of one color that come successively
   
   int colorAmounts[3]={1,1,1};  // colorAmounts[0] - black candlesticks in a row
                                 // colorAmounts[1] - white candlesticks in a row
                                 // colorAmounts[2] - gray candlesticks in a row
   
   int currentColor=-1;          // current color: 0 - black, 1 - white, 2 - gray
   int lastColor=-1;             // last color
   int currentColorAmount=1;     // amount of the counted candlesticks of the current color 
   
   for(a=0;a<Bars;a++)
   {
      lastColor=currentColor;
   
      if(Close[a]>Open[a])
         currentColor=1;
      else if(Close[a]<Open[a])
         currentColor=0;
      else
         currentColor=2;
         
      if(currentColor==lastColor)
         currentColorAmount++;
      else
      {
         if(currentColorAmount>colorAmounts[currentColor])
            colorAmounts[currentColor]=currentColorAmount;
            
         currentColorAmount=1;
      }
   }
   
     //--- MessageBox("black="+colorAmounts[0]+" white="+colorAmounts[1]+" grey="+colorAmounts[2],"candles in a row");
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+