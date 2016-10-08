#property indicator_separate_window

extern double  Risk_to_Reward_ratio =  3.0;
int nDigits;
//+------------------------------------------------------------------+
int init()
{
IndicatorShortName("TSR");
   if(Symbol()=="GBPJPY" || Symbol()=="EURJPY" || Symbol()=="USDJPY" || Symbol()=="GOLD" || Symbol()=="USDMXN") nDigits = 2;
   if(Symbol()=="GBPUSD" || Symbol()=="EURUSD" || Symbol()=="NZDUSD" || Symbol()=="USDCHF"  ||
   Symbol()=="USDCAD" || Symbol()=="AUDUSD" || Symbol()=="EURUSD" || Symbol()=="EURCHF"  || Symbol()=="EURGBP"
   || Symbol()=="EURCAD" || Symbol()=="EURAUD" || Symbol()=="AUDNZD")
   nDigits = 5;
   return(0);
}
int deinit(){return(0);}

int start()
  {
   int R1=0,R5=0,R10=0,R20=0,RAvg=0;
   int RoomUp=0,RoomDown=0,StopLoss_Long=0,StopLoss_Short=0;
   int      TodayRange=0;
   double   SL_Long=0,SL_Short=0;
   double   low0=0,high0=0;
   string   Text="";
   int i=0;

   R1 =  (iHigh(NULL,PERIOD_D1,1)-iLow(NULL,PERIOD_D1,1))/Point;
   for(i=1;i<=5;i++)      R5    =    R5  +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=10;i++)      R10   =    R10 +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=20;i++)      R20   =    R20 +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   TodayRange = (iHigh( NULL,PERIOD_D1,0)-iLow(NULL,PERIOD_D1,0))/Point;
   R5 = R5/5;
   R10 = R10/10;
   R20 = R20/20;
   RAvg  =  (R1+R5+R10+R20)/4;    

   low0  =  iLow(NULL,PERIOD_D1,0);
   high0 =  iHigh(NULL,PERIOD_D1,0);
   RoomUp   =  RAvg - (Bid - low0)/Point;
   RoomDown =  RAvg - (high0 - Bid)/Point;
   StopLoss_Long  =  RoomUp/Risk_to_Reward_ratio;
   SL_Long        =  Bid - StopLoss_Long*Point;
   StopLoss_Short =  RoomDown/Risk_to_Reward_ratio;
   SL_Short       =  Bid + StopLoss_Short*Point;

   Comment(Text);
  
   string P=Period();
    
        ObjectCreate("TSR", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR",StringSubstr(Symbol(),0),12, "Arial Bold", CadetBlue);
        ObjectSet("TSR", OBJPROP_CORNER, 0);
        ObjectSet("TSR", OBJPROP_XDISTANCE, 25);
        ObjectSet("TSR", OBJPROP_YDISTANCE, 2);
        ObjectCreate("TSR1", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR1",StringSubstr(P,0),12, "Arial Bold", CadetBlue);
        ObjectSet("TSR1", OBJPROP_CORNER, 0);
        ObjectSet("TSR1", OBJPROP_XDISTANCE, 100);
        ObjectSet("TSR1", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("TSR2", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR2","Av.Daily Range:", 10, "Arial Bold", CadetBlue);
        ObjectSet("TSR2", OBJPROP_CORNER, 0);
        ObjectSet("TSR2", OBJPROP_XDISTANCE, 140);
        ObjectSet("TSR2", OBJPROP_YDISTANCE, 2);
        ObjectCreate("TSR3", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR3",DoubleToStr(RAvg ,0),12, "Arial Bold", Orange);
        ObjectSet("TSR3", OBJPROP_CORNER, 0);
        ObjectSet("TSR3", OBJPROP_XDISTANCE, 250);
        ObjectSet("TSR3", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("TSR120", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR120","TODAY:", 10, "Arial Bold", CadetBlue);
        ObjectSet("TSR120", OBJPROP_CORNER, 0);
        ObjectSet("TSR120", OBJPROP_XDISTANCE, 280);
        ObjectSet("TSR120", OBJPROP_YDISTANCE, 2);
        ObjectCreate("TSR121", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR121",DoubleToStr(TodayRange ,0),12, "Arial Bold", Orange);
        ObjectSet("TSR121", OBJPROP_CORNER, 0);
        ObjectSet("TSR121", OBJPROP_XDISTANCE, 330);
        ObjectSet("TSR121", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("TSR4", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR4","Prev 01 Day Range:", 10, "Arial ", LightSteelBlue);
        ObjectSet("TSR4", OBJPROP_CORNER, 0);
        ObjectSet("TSR4", OBJPROP_XDISTANCE, 25);
        ObjectSet("TSR4", OBJPROP_YDISTANCE, 20);
        ObjectCreate("TSR5", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR5",DoubleToStr(R1,0),12, "Arial Bold", Orange);
        ObjectSet("TSR5", OBJPROP_CORNER, 0);
        ObjectSet("TSR5", OBJPROP_XDISTANCE, 160);
        ObjectSet("TSR5", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("TSR6", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR6","Prev 05 Days Range:", 10, "Arial ", LightSteelBlue);
        ObjectSet("TSR6", OBJPROP_CORNER, 0);
        ObjectSet("TSR6", OBJPROP_XDISTANCE, 25);
        ObjectSet("TSR6", OBJPROP_YDISTANCE, 35);
        ObjectCreate("TSR7", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR7",DoubleToStr(R5,0),12, "Arial Bold", Orange);
        ObjectSet("TSR7", OBJPROP_CORNER, 0);
        ObjectSet("TSR7", OBJPROP_XDISTANCE, 160);
        ObjectSet("TSR7", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("TSR8", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR8","Room UP:", 10, "Arial ", LightSteelBlue);
        ObjectSet("TSR8", OBJPROP_CORNER, 0);
        ObjectSet("TSR8", OBJPROP_XDISTANCE, 220);
        ObjectSet("TSR8", OBJPROP_YDISTANCE, 20);
        ObjectCreate("TSR9", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR9",DoubleToStr(RoomUp,0),12, "Arial Bold", Orange);
        ObjectSet("TSR9", OBJPROP_CORNER, 0);
        ObjectSet("TSR9", OBJPROP_XDISTANCE, 290);
        ObjectSet("TSR9", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("TSR10", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR10","Room DN:", 10, "Arial ", LightSteelBlue);
        ObjectSet("TSR10", OBJPROP_CORNER, 0);
        ObjectSet("TSR10", OBJPROP_XDISTANCE, 220);
        ObjectSet("TSR10", OBJPROP_YDISTANCE, 35);
        ObjectCreate("TSR11", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR11",DoubleToStr(RoomDown,0),12, "Arial Bold", Orange);
        ObjectSet("TSR11", OBJPROP_CORNER, 0);
        ObjectSet("TSR11", OBJPROP_XDISTANCE, 290);
        ObjectSet("TSR11", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("TSR16", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR16","Maximum StopLosses;",10, "Arial Bold", CadetBlue);
        ObjectSet("TSR16", OBJPROP_CORNER, 0);
        ObjectSet("TSR16", OBJPROP_XDISTANCE, 400);
        ObjectSet("TSR16", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("TSR17", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR17","Long:             Pips at", 10, "Arial ", LightSteelBlue);
        ObjectSet("TSR17", OBJPROP_CORNER, 0);
        ObjectSet("TSR17", OBJPROP_XDISTANCE, 400);
        ObjectSet("TSR17", OBJPROP_YDISTANCE, 20);
        ObjectCreate("TSR18", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR18",DoubleToStr(StopLoss_Long,0),12, "Arial Bold", Orange);
        ObjectSet("TSR18", OBJPROP_CORNER, 0);
        ObjectSet("TSR18", OBJPROP_XDISTANCE, 450);
        ObjectSet("TSR18", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("TSR19", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR19","Short:Pips at", 10, "Arial ", LightSteelBlue);
        ObjectSet("TSR19", OBJPROP_CORNER, 0);
        ObjectSet("TSR19", OBJPROP_XDISTANCE, 400);
        ObjectSet("TSR19", OBJPROP_YDISTANCE, 35);
        ObjectCreate("TSR20", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR20",DoubleToStr(StopLoss_Short,0),12, "Arial Bold", Orange);
        ObjectSet("TSR20", OBJPROP_CORNER, 0);
        ObjectSet("TSR20", OBJPROP_XDISTANCE, 450);
        ObjectSet("TSR20", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("TSR21", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR21",DoubleToStr(SL_Long,nDigits),12, "Arial Bold", SteelBlue);
        ObjectSet("TSR21", OBJPROP_CORNER, 0);
        ObjectSet("TSR21", OBJPROP_XDISTANCE, 530);
        ObjectSet("TSR21", OBJPROP_YDISTANCE, 20);
        ObjectCreate("TSR22", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR22",DoubleToStr(SL_Short,nDigits),12, "Arial Bold",SteelBlue);
        ObjectSet("TSR22", OBJPROP_CORNER, 0);
        ObjectSet("TSR22", OBJPROP_XDISTANCE, 530);
        ObjectSet("TSR22", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("TSR23", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR23","R/R:", 10, "Arial Bold", CadetBlue);
        ObjectSet("TSR23", OBJPROP_CORNER, 0);
        ObjectSet("TSR23", OBJPROP_XDISTANCE, 730);
        ObjectSet("TSR23", OBJPROP_YDISTANCE, 2);
        ObjectCreate("TSR24", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("TSR24",DoubleToStr( Risk_to_Reward_ratio ,0),12, "Arial Bold", Orange);
        ObjectSet("TSR24", OBJPROP_CORNER, 0);
        ObjectSet("TSR24", OBJPROP_XDISTANCE, 760);
        ObjectSet("TSR24", OBJPROP_YDISTANCE, 2);
               
        double HIDaily = iMA(Symbol(),PERIOD_D1,1,0,MODE_SMA,PRICE_HIGH,0);
        double LOWDaily = iMA(Symbol(),PERIOD_D1,1,0,MODE_SMA,PRICE_LOW,0); 
        double YEST_HIDaily = iMA(Symbol(),PERIOD_D1,1,0,MODE_SMA,PRICE_HIGH,1);
        double YEST_LOWDaily = iMA(Symbol(),PERIOD_D1,1,0,MODE_SMA,PRICE_LOW,1); 
             
        ObjectCreate("high", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("high",DoubleToStr(HIDaily,Digits), 12, "Arial Bold", Orange);
        ObjectSet("high", OBJPROP_CORNER, 0);
        ObjectSet("high", OBJPROP_XDISTANCE, 670);
        ObjectSet("high", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("high2", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("high2","DailyHigh", 9, "Arial Bold", CadetBlue);
        ObjectSet("high2", OBJPROP_CORNER, 0);
        ObjectSet("high2", OBJPROP_XDISTANCE, 670);
        ObjectSet("high2", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("low", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("low",DoubleToStr(LOWDaily,Digits), 12, "Arial Bold", Orange);
        ObjectSet("low", OBJPROP_CORNER, 0);
        ObjectSet("low", OBJPROP_XDISTANCE, 610);
        ObjectSet("low", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("low2", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("low2","DailyLow", 9, "Arial Bold", CadetBlue);
        ObjectSet("low2", OBJPROP_CORNER, 0);
        ObjectSet("low2", OBJPROP_XDISTANCE, 610);
        ObjectSet("low2", OBJPROP_YDISTANCE, 2);
                     
        double CURR =iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);
        double RANGE = (HIDaily-LOWDaily) ; 
       
        ObjectCreate("high3", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("high3",DoubleToStr(CURR,Digits), 12, "Arial Bold", Coral);
        ObjectSet("high3", OBJPROP_CORNER, 0);
        ObjectSet("high3", OBJPROP_XDISTANCE, 670);
        ObjectSet("high3", OBJPROP_YDISTANCE,35 );
            
        ObjectCreate("high4", OBJ_LABEL, WindowFind("TSR"), 0, 0);
        ObjectSetText("high4",DoubleToStr(CURR,Digits), 12, "Arial Bold", Coral);
        ObjectSet("high4", OBJPROP_CORNER, 0);
        ObjectSet("high4", OBJPROP_XDISTANCE, 610);
        ObjectSet("high4", OBJPROP_YDISTANCE,35 );
        
   return(0);
}

