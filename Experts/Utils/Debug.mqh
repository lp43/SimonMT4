//+------------------------------------------------------------------+
//|                                                        Debug.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict

#include "Cursor.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Debug
  {
private:
                     static long LastTime;
public:
                     Debug();
                    ~Debug();
                    static void PrintArray(string msg,string &array[]);
                    static void PrintArray(string msg,Cursor &cursor);
                    static void PrintConstellateArray(string msg,Constellate* &array[]);
                    static void PrintPosition(Cursor &cursor, int positionIdx);
                    static void PrintPosition(Cursor &cursor, int & position[]);
                    
                    
                    static void StartTimeTracking(string name);
                    static void stopTimeTracking(string name);
                    
  };
 long Debug::LastTime;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Debug::Debug()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Debug::~Debug()
  {
  }
//+------------------------------------------------------------------+
static void Debug::PrintArray(string msg, string &array[])
{
   for(int i =0; i<ArraySize(array);i++)
   {
      Alert(msg+":::"+"["+i+"] "+array[i]);
   }
}

static void Debug::PrintArray(string msg, Cursor &cursor)
{  
   double SquareArray[];
   cursor.GetSquareArray(SquareArray);
   string temp[];
   for(int i =0;i<ArraySize(SquareArray);i++){
      int size = ArraySize(SquareArray);
      ArrayResize(temp, ++size);
      temp[size-1] = DoubleToStr(SquareArray[i],2);
   }
   PrintArray(msg, temp);
}

static void Debug::PrintConstellateArray(string msg,Constellate* &array[])
{
   string temp[];
   for(int i =0;i<ArraySize(array);i++){
      int size = ArraySize(temp);
      ArrayResize(temp, ++size);
      temp[size-1] = "第"+array[i].part+"段:::"+array[i].value;
   }
   PrintArray(msg, temp);
}

static void Debug::PrintPosition(Cursor &cursor, int positionIdx)
{
   int position[2];
   cursor.GetPositionByIdx(positionIdx, position);
   int cursorX = position[0];
   int cursorY = position[1];
   PrintPosition(cursor, position);
}

static void Debug::PrintPosition(Cursor &cursor, int & position[])
{
   int cursorX = position[0];
   int cursorY = position[1];
   Alert("PrintPosition => "+"["+cursorX+","+cursorY+"]");
}


static void Debug::StartTimeTracking(string name){
   datetime time = TimeCurrent();
   //Alert("time: "+TimeToStr(time, TIME_SECONDS));
   MqlDateTime time_current;
   TimeLocal(time_current);
   LastTime = time_current.hour*60*60 + time_current.min*60 + time_current.sec;
   //Alert("hour: "+time_current.hour+", min: "+time_current.min+", sec: "+time_current.sec);
   //Alert("lasttime: "+LastTime);
}

static void Debug::stopTimeTracking(string name){
   MqlDateTime time_current;
   TimeLocal(time_current);
   long diff = (time_current.hour*60*60 + time_current.min*60 + time_current.sec) - LastTime;
   //Alert("hour: "+time_current.hour+", min: "+time_current.min+", sec: "+time_current.sec);
   
   Alert(name+"耗時: "+diff +" 秒");
}
