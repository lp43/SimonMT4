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
                    static void PrintArray(string msg,double &array[]);
                    static void PrintArray(string msg,Cursor &cursor);
                    static void PrintPosition(Cursor &cursor, int positionIdx);
                    static void PrintPosition(Cursor &cursor, int & position[]);
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
static void Debug::PrintArray(string msg, double &array[])
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
   PrintArray(msg, SquareArray);
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