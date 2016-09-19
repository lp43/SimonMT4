//+------------------------------------------------------------------+
//|                                                         USDX.mq4 |
//|                                  Copyright © 2012, Andriy Moraru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, Andriy Moraru"
#property link      "http://www.earnforex.com"

/* 
   USDX - indicator of the US Dollar Index.
   Displays a USDX chart in a separate window of the current chart.
   Based on EUR/USD, USD/JPY, GBP/USD, USD/CAD, USD/CHF and USD/SEK.
   All these pairs should be added to Market Watch for indicator to work.
   Two customizable moving averages can be applied to the index.
   Can be easily modified via input parameters to calculate any currency index.
*/

#property indicator_separate_window
#property indicator_buffers 3

#property indicator_color1 Red
#property indicator_width1 2

#property indicator_color2 White
#property indicator_width2 1

#property indicator_color3 Lime
#property indicator_width3 1

extern string comment1 = "// 0 - PRICE_CLOSE, 1 - PRICE_OPEN, 2 - PRICE_HIGH, 3 - PRICE_LOW, 4 - PRICE_MEDIAN, 5 - PRICE_TYPICAL, 6 - PRICE_WEIGHTED";
extern int USDX_PriceType = PRICE_CLOSE;
extern string IndexPairs = "EURUSD, USDJPY, GBPUSD, USDCAD, USDSEK, USDCHF"; // Update only currency pairs' names if they are different from your broker's
extern string IndexCoefficients = "-0.576, 0.136, -0.119, 0.091, 0.036, 0.042"; // Do not change for USDX
extern double IndexInitialValue = 50.14348112; // Do not change for USDX
extern int MA_Period1 = 13;
extern int MA_Period2 = 17;
extern string comment2 = "// 0 - MODE_SMA, 1 - MODE_EMA, 2 - MODE_SMMA, 3 - MODE_LWMA";
extern int MA_Mode1 = MODE_SMA;
extern int MA_Mode2 = MODE_SMA;

//---- Indicator buffers
double USDX[];
double MA1[];
double MA2[];

//---- Global variables
string Pairs[];
double Coefficients[];

// Gets pair names and coefficients out of the input parameters and creates the respective arrays.
int InitializePairs()
{
   int n = 0, count = 0, coef_n = 0, coef_count = 0;
   // Count elements.
   while (n != -1)
   {
      n = StringFind(IndexPairs, ",", n + 1);
      coef_n = StringFind(IndexCoefficients, ",", coef_n + 1);
      if (n > -1) count++;
      if (coef_n > -1) coef_count++;
   }
   count++;
   coef_count++;
   
   if (count != coef_count)
   {
      Alert("Each currency pair of the Index should have a corresponding coefficient.");
      return(-1);
   }
   
   ArrayResize(Pairs, count);
   ArrayResize(Coefficients, count);

   n = 0;
   coef_n = 0;
   int prev_n = 0, prev_coef_n = 0;
   for (int i = 0; i < count; i++)
   {
      n = StringFind(IndexPairs, ",", n + 1);
      coef_n = StringFind(IndexCoefficients, ",", coef_n + 1);
      // To remove the trailing comma
      if (prev_n > 0) prev_n++;
      if (prev_coef_n > 0) prev_coef_n++;
      Pairs[i] = StringTrimRight(StringTrimLeft(StringSubstr(IndexPairs, prev_n, n - prev_n)));
      Coefficients[i] = StrToDouble(StringSubstr(IndexCoefficients, prev_coef_n, coef_n - prev_coef_n));
      Print(Pairs[i], ": ", Coefficients[i]);
      if (!MarketInfo(Pairs[i], MODE_ASK)) Alert("Please add ", Pairs[i], " to your Market Watch.");
      prev_n = n;
      prev_coef_n = coef_n;
   }
   
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   if (StringLen(IndexPairs) == 0)
   {
      Alert("Please enter the USDX currency pairs (EUR/USD, USD/JPY, GBP/USD, USD/CAD, USD/CHF and USD/SEK) into IndexPairs input parameter. Use the currency pairs' names as they appear in your market watch.");
      return(-1);
   }

   if (StringLen(IndexCoefficients) == 0)
   {
      Alert("Please enter the the Index coefficients as coma-separated values in IndexCoefficients input parameter.");
      return(-1);
   }

   // Can initialize only if connected to account
   if (AccountCurrency() != "") InitializePairs();

//---- indicators
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, USDX);
   SetIndexLabel(0, "USDX");
   SetIndexEmptyValue(0, EMPTY_VALUE);

   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, MA1);
   SetIndexLabel(1, "MA(" + MA_Period1 + ")");
   SetIndexEmptyValue(1, 0);
   
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, MA2);
   SetIndexLabel(2, "MA(" + MA_Period1 + ")");
   SetIndexEmptyValue(2, 0);
   
   IndicatorShortName("USDX");
   
//----
   return(0);
}

int limit;

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   // Initialization hasn't been done yet.
   if (ArraySize(Pairs) == 0)
   {
      if (AccountCurrency() != "") InitializePairs();
      else return(0);
   }

   int counted_bars = IndicatorCounted();
//---- check for possible errors
   if (counted_bars < 0) return(-1);
//---- the last counted bar will be recounted
   if (counted_bars > 0) counted_bars--;
   limit = Bars - counted_bars;
//---- main loop
   for (int i = 0; i < limit; i++)
   {
      USDX[i] = IndexInitialValue;
      for (int j = 0; j < ArraySize(Pairs); j++)
      {
         switch (USDX_PriceType)
         {
            case PRICE_OPEN:
               USDX[i] *= MathPow(iOpen(Pairs[j], 0, i), Coefficients[j]);
               break;
            case PRICE_HIGH:
               USDX[i] *= MathPow(iHigh(Pairs[j], 0, i), Coefficients[j]);
               break;
            case PRICE_LOW:
               USDX[i] *= MathPow(iLow(Pairs[j], 0, i), Coefficients[j]);
               break;
            case PRICE_CLOSE:
               USDX[i] *= MathPow(iClose(Pairs[j], 0, i), Coefficients[j]);
               break;
            case PRICE_MEDIAN:
               USDX[i] *= MathPow((iHigh(Pairs[j], 0, i) + iLow(Pairs[j], 0, i)) / 2, Coefficients[j]);
               break;
            case PRICE_TYPICAL:
               USDX[i] *= MathPow((iHigh(Pairs[j], 0, i) + iLow(Pairs[j], 0, i) + iClose(Pairs[j], 0, i)) / 3, Coefficients[j]);
               break;
            case PRICE_WEIGHTED:
               USDX[i] *= MathPow((iHigh(Pairs[j], 0, i) + iLow(Pairs[j], 0, i) + iClose(Pairs[j], 0, i) * 2) / 4, Coefficients[j]);
               break;
            default:
               USDX[i] *= MathPow(iClose(Pairs[j], 0, i), Coefficients[j]);
               break;
         }
      }
   }

   CalculateMAs();
//---- done
   return(0);
}

void CalculateMAs()
{
   if (Bars < MA_Period1) return; // Not enough bars.
   if (MA_Period1 > 0) CalcMA(MA1, MA_Mode1, MA_Period1); // Calculate only if MA period is given
   if (Bars < MA_Period2) return;
   if (MA_Period2 > 0) CalcMA(MA2, MA_Mode2, MA_Period2);
}

// MA calculation methods encapsulator
void CalcMA(double &MA[], int ma_method, int ma_period)
{
   switch (ma_method)
   {
      case MODE_SMA:
         CalcSMA(MA, ma_period);
         break;
      case MODE_EMA:
         CalcEMA(MA, ma_period);
         break;
      case MODE_SMMA:
         CalcSMMA(MA, ma_period);
         break;
      case MODE_LWMA:
         CalcLWMA(MA, ma_period);
         break;
      default:
         CalcSMA(MA, ma_period);
         break;
   }
}

// Simple MA Calculation
void CalcSMA(double &MA[], int ma_period)
{
   // From new to old
   for (int j = 0; j < limit; j++)
   {
      double MA_Sum = 0;
      
      for (int k = j; k < j + ma_period; k++)
      {
         MA_Sum += USDX[k];
      }
      
      MA[j] = MA_Sum / ma_period;
   }
}

// Exponential MA Calculation
// ma_period is double here because int produces wrong divison results in coeff calculation below.
void CalcEMA(double &MA[], double ma_period)
{
   // From old to new
   for (int j = limit - 1; j >= 0; j--)
   {
      // Cannot calculate EMA for empty value.
      if (USDX[j] == EMPTY_VALUE) continue;
      
      // If no previous MA value, take the price value.
      if ((MA[j + 1] == 0) || (MA[j + 1] == EMPTY_VALUE)) MA[j] = USDX[j];
      else
      {
         double coeff = 2 / (ma_period + 1);
         MA[j] = USDX[j] * coeff + MA[j + 1] * (1 - coeff);
      }
   }
}

// Smoothed MA Calculation (Exponential with coeff = 1 / N)
// ma_period is double here because int produces wrong divison results in coeff calculation below.
void CalcSMMA(double &MA[], double ma_period)
{
   // From old to new
   for (int j = limit - 1; j >= 0; j--)
   {
      // Cannot calculate SMMA for empty value.
      if (USDX[j] == EMPTY_VALUE) continue;

      // If no previous MA value, take the price value.
      if ((MA[j + 1] == 0) || (MA[j + 1] == EMPTY_VALUE)) MA[j] = USDX[j];
      else
      {
         double coeff = 1 / ma_period;
         MA[j] = USDX[j] * coeff + MA[j + 1] * (1 - coeff);
      }
   }
}

// Linear Weighted MA Calculation
void CalcLWMA(double &MA[], int ma_period)
{
   // From new to old
   for (int j = 0; j < limit; j++)
   {
      double MA_Sum = 0;
      int weight = ma_period;
      int weight_sum = 0;
      for (int k = j; k < j + ma_period; k++)
      {
         weight_sum += weight;
         MA_Sum += USDX[k] * weight;
         weight--;
      }
      MA[j] = MA_Sum / weight_sum;
   }
}
//+------------------------------------------------------------------+