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

public:
                     Debug();
                    ~Debug();
                    void PrintArray(double &array[]);
                    void PrintPosition(Cursor &cursor, int positionIdx);
                    void PrintPosition(Cursor &cursor, int & position[]);
  };
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
void Debug::PrintArray(double &array[])
{
   for(int i =0; i<ArraySize(array);i++)
   {
      Alert("["+i+"] "+array[i]);
   }
}

void Debug::PrintPosition(Cursor &cursor, int positionIdx)
{
   int position[2];
   cursor.GetPositionByIdx(positionIdx, position);
   int cursorX = position[0];
   int cursorY = position[1];
   PrintPosition(cursor, position);
}

void Debug::PrintPosition(Cursor &cursor, int & position[])
{
   int cursorX = position[0];
   int cursorY = position[1];
   Alert("PrintPosition => "+"["+cursorX+","+cursorY+"]");
}