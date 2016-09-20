//+------------------------------------------------------------------+
//|                                                       MyMath.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MyMath
  {
private:

public:
                     MyMath();
                    ~MyMath();
                    double FindClosest(double &array[], double value);
                    void ReverseArray(double &src_array[], double & des_array[]);
                    int FindIdxByValue(double &src_array[], double value);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyMath::MyMath()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyMath::~MyMath()
  {
  }
//+------------------------------------------------------------------+
double MyMath::FindClosest(double &array[],double value)
{
    double min = EMPTY_VALUE;
    double closest = value;

    for (double v : array) {
        double diff = MathAbs(v - value);

        if (diff < min) {
            min = diff;
            closest = v;
        }
    }

    return closest;
}

void MyMath::ReverseArray(double &src_array[], double &des_array[])
{
   int src_array_size = ArraySize(src_array);
   ArrayResize(des_array, src_array_size, 0);
   for( int i = src_array_size - 1; i >= 0; i-- ) {
      int desIdx = src_array_size - i - 1;
      des_array[desIdx] = src_array[i];
      //Alert("reverse::: src i = "+i+" => des i = "+desIdx);
   }
}

int MyMath::FindIdxByValue(double &src_array[], double value)
{
    int found_idx = -1;
    for(int i =0;i<ArraySize(src_array);i++){
      //Alert("i: "+i+" is "+src_array[i]);
      if(src_array[i]==value){
         found_idx = i;
         break;
      }
    }
    return found_idx;
}