//+------------------------------------------------------------------+
//|                                                     Windmill.mqh |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property description "風車位跑圖法"

#include "Gann.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Windmill : public Gann
  {
private:
                     
                     double mCompareNum, mBaseNum;
                     int mRunType;
                     void InsertBladeDegrees();
                     void InsertCrossBlades();
                     void InsertAngleBlades();
                     int GetBladeDegree(double compare_num);
                     void GetAngleNums(double begin_value, int blade_degree, double &array[]);
                     void GetCrossNums(double begin_value, int blade_degree, double &array[]);
                     void GetWindmillNums(int run_type, double base_value, double begin_value, GannValue* &array[]);
                   
public:
                     Windmill();
                    ~Windmill();
                    
                    void SetDatas(int run_type, double base_value, double begin_value);
                    virtual void Run(GannValue* &values[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Windmill::Windmill()
  {
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Windmill::~Windmill()
  {
  }

//+------------------------------------------------------------------+
int Windmill::GetBladeDegree(double compare_num){
   int returnBladeDegree = -1;
   CursorValue* crValue = cursor.GetCursorValueByValue(compare_num);
   if(crValue!=NULL){
      returnBladeDegree = crValue.blade_degree;
   }
      
   return returnBladeDegree;
}
void Windmill::GetAngleNums( double begin_value, int blade_degree,double &array[]){
    int BasePosition[2];
    cursor.GetPositionByValue(begin_value, BasePosition);
    
    double Temp[];
    double Angles[];
    GetAngleNums(RUN_BOTH, begin_value, Angles);
    for(int i = 0; i <ArraySize(Angles);i++){
      double angle = Angles[i];
      int ComparePosition[2];
      cursor.GetPositionByValue(angle, ComparePosition);
      int degree = MyAngle::GetDegree(ComparePosition,BasePosition);
      //Alert("angle "+angle+"'s degree is: "+degree);
      
      switch(blade_degree){
       case ANGLE_45:
       case ANGLE_225:{
         if(degree == ANGLE_45 | degree == ANGLE_225){
            int size_temp = ArraySize(Temp);
            ArrayResize(Temp, ++size_temp);
            Temp[size_temp-1]=angle;
         }
         break;
       }
       case ANGLE_135:
       case ANGLE_315:{
         if(degree == ANGLE_135 | degree == ANGLE_315){
            int size_temp = ArraySize(Temp);
            ArrayResize(Temp, ++size_temp);
            Temp[size_temp-1]=angle;
         }
         break;
       }
       }
     }
     ArrayCopy(array, Temp, 0,0,WHOLE_ARRAY);
     ArrayFree(Temp);

}

void Windmill::GetCrossNums(double begin_value, int blade_degree,double &array[]){
    int BasePosition[2];
    cursor.GetPositionByValue(begin_value, BasePosition);
    
    double Temp[];
    double Crosses[];
    GetCrossNums(RUN_BOTH, begin_value, Crosses);
    for(int i = 0; i <ArraySize(Crosses);i++){
      double cross = Crosses[i];
      int ComparePosition[2];
      cursor.GetPositionByValue(cross, ComparePosition);
      int degree = MyAngle::GetDegree(ComparePosition,BasePosition);
      //Alert("cross "+cross+"'s degree is: "+degree);
      
      switch(blade_degree){
       case ANGLE_0:
       case ANGLE_180:{
         if(degree == ANGLE_0 | degree == ANGLE_180){
            int size_temp = ArraySize(Temp);
            ArrayResize(Temp, ++size_temp);
            Temp[size_temp-1]=cross;
         }
         break;
       }
       case ANGLE_90:
       case ANGLE_270:{
         if(degree == ANGLE_90 | degree == ANGLE_270){
            int size_temp = ArraySize(Temp);
            ArrayResize(Temp, ++size_temp);
            Temp[size_temp-1]=cross;
         }
         break;
       }
       }
     }
     ArrayCopy(array, Temp, 0,0,WHOLE_ARRAY);
     ArrayFree(Temp);

}

void Windmill::GetWindmillNums(int run_type, double base_value, double begin_value, GannValue* &array[]){
   int BladeDegree = GetBladeDegree(begin_value);
   
   double Temp1[];
   //Alert(begin_value+"'s BladeDegree is: "+BladeDegree);
   if(BladeDegree%90==0){
      //Alert("into GetCrossNums");
      //如果在十字葉片上
      GetCrossNums(begin_value, BladeDegree, Temp1);
   }else{
      //Alert("into GetAngleNums");
      //如果在角線葉片上
      GetAngleNums(begin_value, BladeDegree, Temp1);
   }
   ArraySort(Temp1, WHOLE_ARRAY, 0, MODE_ASCEND);
   Debug::PrintArray("Temp1",Temp1,0);
   
   double Temp2[];
   if(run_type==RUN_BOTH){
        ArrayCopy(Temp2, Temp1, 0,0,WHOLE_ARRAY);
   }else{
      int idx = MyMath::FindClosestValue(Temp1,begin_value);
      Alert("found closest idx: "+idx);
      int correctIdx = (Temp1[idx]>begin_value)?idx:idx-1;
      Alert("Found closest "+Temp1[correctIdx]+"near begin_value: "+begin_value+", correctIdx: "+correctIdx);
      if(run_type==RUN_HIGH){
         ArrayCopy(Temp2, Temp1, 0, ++idx, WHOLE_ARRAY);
      }else{
         ArrayCopy(Temp2, Temp1, 0, 0, idx);
      }
   }
   Debug::PrintArray("Temp2",Temp2,0);
   ArrayFree(Temp1);
   
   for(int i = 0; i < ArraySize(Temp2);i++){
      int PartNow = i+1;
      GannValue* gannValue = new GannValue();
      gannValue.part = PartNow;
      gannValue.value = Temp2[i];
      
      int size_array = ArraySize(array);
      ArrayResize(array, ++size_array);
      array[size_array-1]=gannValue;
   }
   ArrayFree(Temp2);
   
}
void Windmill::SetDatas(int run_type, double base_value,double begin_value){
   mRunType = run_type;
   mBaseNum = base_value;
   mCompareNum = begin_value;
}

void Windmill::Run(GannValue* &values[]){
    InsertBladeDegrees();
    GetWindmillNums(mRunType, mBaseNum, mCompareNum, values);
}

 void Windmill::InsertBladeDegrees(){
   //Alert("InsertBladeDegrees");
   // ====處理角線====
   InsertAngleBlades();
   //Debug::PrintArray("Blade Info: ",cursor);
   
   // ====處理十字線====
   InsertCrossBlades();
   
   //將指針歸還回中間
   cursor.SetCursorTo(cursor.GetCenterIdx());
   //Debug::PrintArray("cursor blade",cursor);
 }
//---計算角線上葉片範圍---
 void Windmill::InsertAngleBlades(){
   double CenterValue = cursor.GetValueByIdx(cursor.GetCenterIdx());
   //Alert("CenterValue: "+CenterValue);
   double AngleNums[];
   GetAngleNums(RUN_BOTH, CenterValue,AngleNums);
   //Debug::PrintArray("CenterValue "+CenterValue+"'s anglenums",AngleNums, 0);
   for(int i = 0 ; i <ArraySize(AngleNums);i++){
      double value = AngleNums[i];
      int circlenum = cursor.GetCircleNumByValue(value);
      int bladeRange = circlenum%2==0?(circlenum/2)-1:((circlenum+1)/2)-1;
      int BasePosition[2];
      cursor.GetPositionByIdx(cursor.GetCenterIdx(), BasePosition);
      //Debug::PrintPosition(cursor,BasePosition);
      int ComparePosition[2];
      cursor.GetPositionByValue(value, ComparePosition);
      //Debug::PrintPosition(cursor,ComparePosition);
      int degree = MyAngle::GetDegree(ComparePosition,BasePosition);
      CursorValue* crValue = cursor.GetCursorValueByValue(value);
      //Alert("before cursorblade is: "+crValue.blade_degree);
      crValue.blade_degree = degree;
      //Alert(value+"'s circle num is: "+circlenum+", BladeRange is: "+bladeRange+", degree is: "+degree);
      switch(degree){
         case ANGLE_45:{
            //---往下處理X---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Down();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("down value is: "+crValue.value);
            }
            //---往右處理Y---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Right();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Right value is: "+crValue.value);
            }
            break;
         }
         case ANGLE_135:{
            //---往下處理X---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Down();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("down value is: "+crValue.value);
            }
            //---往左處理Y---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Left();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Left value is: "+crValue.value);
            }
         break;
         }
         case ANGLE_225:{
            //---往上處理X---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Up();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Up value is: "+crValue.value);
            }
            //---往左處理Y---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Left();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Left value is: "+crValue.value);
            }
            break;
         }
         case ANGLE_315:{
            //---往上處理X---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Up();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Up value is: "+crValue.value);
            }
            //---往右處理Y---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Right();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Right value is: "+crValue.value);
            }
            break;
         }
      }
    
    }
 }
//---計算十字線上的葉片範圍---
void Windmill::InsertCrossBlades(){
   double CenterValue = cursor.GetValueByIdx(cursor.GetCenterIdx());
   //Alert("CenterValue: "+CenterValue);
   double CrossNums[];
   GetCrossNums(RUN_BOTH, CenterValue, CrossNums);
   //Debug::PrintArray("CenterValue "+CenterValue+"'s crossnums",CrossNums, 0);
   for(int i = 0 ; i <ArraySize(CrossNums);i++){
      double value = CrossNums[i];
      int BasePosition[2];
      cursor.GetPositionByIdx(cursor.GetCenterIdx(), BasePosition);
      //Debug::PrintPosition(cursor,BasePosition);
      int ComparePosition[2];
      cursor.GetPositionByValue(value, ComparePosition);
      //Debug::PrintPosition(cursor,ComparePosition);
      int degree = MyAngle::GetDegree(ComparePosition,BasePosition);
      CursorValue* crValue = cursor.GetCursorValueByValue(value);
      //Alert("before: "+crValue.blade_degree);
      crValue.blade_degree = degree;
      //Alert(value+"'s circle num is: "+crValue.circle_number+", degree is: "+degree);
      switch(degree){
         case ANGLE_0:{
            cursor.SetCursorTo(ComparePosition);
            //---往上處理X---
            while(cursor.Up()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;    
            }
            //---往下處理X---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Down()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            break;
         }
         case ANGLE_90:{
            //---往左處理Y---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Left()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            //---往右處理Y---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Right()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
         break;
         }
         case ANGLE_180:{
            //---往上處理X---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Up()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            //---往下處理X---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Down()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            break;
         }
         case ANGLE_270:{
            //---往右處理Y---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Right()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            //---往左處理Y---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Left()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            break;
         }
      }
    
    }
}