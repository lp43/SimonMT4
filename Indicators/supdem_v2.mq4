//+------------------------------------------------------------------+
//|                                                    II_SupDem_mq4 |
//|                            Copyright © 2010, Insanity Industries |
//|                                http://www_insanityindustries_net |
//|                                                                  |
//| v_2_3_1 21/7/2010                                                |
//| code by bredin, except where noted                               |
//| donations can be made via PayPal to bredin@lpemail_com           |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Insanity Industries"
#property link      "https://www_paypal_com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=JEHPJ5XSPPN62"

#property indicator_chart_window
#property indicator_buffers 2
extern int forced_tf = 0;
extern bool draw_zones = true;
extern bool solid_zones = true;
extern bool solid_retouch = false;
extern bool recolor_retouch = true;
extern bool recolor_weak_retouch = false;
extern bool zone_strength = true;
extern bool no_weak_zones = false;
extern bool draw_edge_price = false;
extern int zone_width = 2;
extern bool zone_fibs = false;
extern int fib_style = 0;
extern bool HUD_on = false;
extern bool timer_on = false;
extern int layer_zone = 0;
extern int layer_HUD = 20;
extern int corner_HUD = 1;
extern int pos_x = 10;
extern int pos_y = 170;
extern bool alert_on = true;
extern bool alert_popup = true;
extern string alert_sound = "alert.wav";
extern color color_sup_strong =  C'148,104,174';
extern color color_sup_weak =    LightPink;
extern color color_sup_retouch = DarkOrchid;

extern color color_dem_strong =  Green;
extern color color_dem_weak =    LimeGreen;
extern color color_dem_retouch = Green;

extern color color_fib = DodgerBlue;
extern color color_HUD_tf = Navy;
extern color color_arrow_up = SeaGreen;
extern color color_arrow_dn = Crimson;
extern color color_timer_back = DimGray;
extern color color_timer_bar = Red;
extern color color_shadow = DarkSlateGray;

extern bool limit_zone_vis = false;
extern bool same_tf_vis = true;
extern bool show_on_m1 = false;
extern bool show_on_m5 = true;
extern bool show_on_m15 = false;
extern bool show_on_m30 = false;
extern bool show_on_h1 = false;
extern bool show_on_h4 = false;
extern bool show_on_d1 = false;
extern bool show_on_w1 = false;
extern bool show_on_mn = false;


extern int Price_Width = 1;

extern int time_offset = 0;

extern bool globals = false;

double BuferUp1[];
double BuferDn1[];

double sup_RR[4];
double dem_RR[4];
double sup_width,dem_width;

string l_hud,l_zone;
int HUD_x;
string font_HUD = "Comic Sans MS";
int font_HUD_size = 20;
string font_HUD_price = "Arial Bold";
int font_HUD_price_size = 12;
int arrow_UP = 0x70;
int arrow_DN = 0x71;
string font_arrow = "WingDings 3";
int font_arrow_size = 40;
int font_pair_size = 8;


string arrow_glance;
color color_arrow;
int visible;
int rotation=270;
int lenbase;
string s_base="|||||||||||||||||||||||";
string timer_font="Arial Bold";
int size_timer_font=8;

double min,max;
double iPeriod[4] = {3,8,13,34}; 
int Dev[4] = {2,5,8,13};
int Step[4] = {2,3,5,8};
datetime t1,t2;
double p1,p2;
string pair;
double point;
int digits;
int tf;
string TAG;

double fib_sup,fib_dem;
int SupCount,DemCount;
int SupAlert,DemAlert;
double up_cur,dn_cur;
double fib_level_array[13]={0,0.236,0.386,0.5,0.618,0.786,1,1.276,1.618,2.058,2.618,3.33,4.236};
string fib_level_desc[13]={"0","23.6%","38.6%","50%","61.8%","78.6%","100%","127.6%","161.8%","205.8%","261.80%","333%","423.6%"};

int hud_timer_x,hud_timer_y,hud_arrow_x,hud_arrow_y,hud_tf_x,hud_tf_y;
int hud_sup_x,hud_sup_y,hud_dem_x,hud_dem_y;
int hud_timers_x,hud_timers_y,hud_arrows_x,hud_arrows_y,hud_tfs_x,hud_tfs_y;
int hud_sups_x,hud_sups_y,hud_dems_x,hud_dems_y;

int init()
{
   SetIndexBuffer(1,BuferUp1); 
   SetIndexEmptyValue(1,0.0);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexBuffer(0,BuferDn1); 
   SetIndexEmptyValue(0,0.0); 
   SetIndexStyle(0,DRAW_NONE);

   if(layer_HUD > 25) layer_HUD = 25;
   l_hud = CharToStr(0x61+layer_HUD);
   if(layer_zone > 25) layer_zone = 25;
   l_zone = CharToStr(0x61+layer_zone);

   pair=Symbol();   
   if(forced_tf != 0) tf = forced_tf;
      else tf = Period();
   point = Point;
   digits = Digits;
   if(digits == 3 || digits == 5) point*=10;
   if(HUD_on && !draw_zones) TAG = "II_HUD"+tf;
   else TAG = "II_SupDem"+tf;
   lenbase=StringLen(s_base);
   
   if(HUD_on) setHUD();
   if(limit_zone_vis) setVisibility();
   ObDeleteObjectsByPrefix(l_hud+TAG);
   ObDeleteObjectsByPrefix(l_zone+TAG);
   //DoLogo();
   return(0);
}

int deinit()
{
   ObDeleteObjectsByPrefix(l_hud+TAG);
   ObDeleteObjectsByPrefix(l_zone+TAG);
   Comment(""); 
   return(0);
}

int start()
{
   if(NewBar()==true)
   {
      SupAlert = 1;
      DemAlert = 1;
      ObDeleteObjectsByPrefix(l_zone+TAG);
      CountZZ(BuferUp1,BuferDn1,iPeriod[0],Dev[0],Step[0]);
      GetValid(BuferUp1,BuferDn1);
      Draw();
      if(HUD_on) HUD();
   }
   if(HUD_on && timer_on) BarTimer();
   if(alert_on) CheckAlert();
   return(0);
}

void CheckAlert(){
//   SupCount DemCount
//   SupAlert DemAlert
   double price = ObjectGet(l_zone+TAG+"UPAR"+SupAlert,OBJPROP_PRICE1);
   if(Close[0] > price && price > point){
      if(alert_popup) Alert(pair+" "+TimeFrameToString(tf)+" Supply Zone Entered at "+DoubleToStr(price,Digits));
      //PlaySound(alert_sound);
      SupAlert++;
   }
   price = ObjectGet(l_zone+TAG+"DNAR"+DemAlert,OBJPROP_PRICE1);
   if(Close[0] < price){
      Alert(pair+" "+TimeFrameToString(tf)+" Demand Zone Entered at "+DoubleToStr(price,Digits));
      //PlaySound(alert_sound);
      DemAlert++;
   }
}

void Draw()
{
   int fib_sup_hit=0;
   int fib_dem_hit=0;

   int sc=0,dc=0; 
   int i,j,countstrong,countweak;
   color c;
   string s;
   bool exit,draw,fle,fhe,retouch;
   bool valid;
   double val;
   fhe=false;
   fle=false;
   SupCount=0;
   DemCount=0;
   fib_sup=0;
   fib_dem=0;
   for(i=0;i<iBars(pair,tf);i++){
      if(BuferDn1[i] > point){
         retouch = false;
         valid = false;
         t1 = iTime(pair,tf,i);
         t2 = Time[0];
         p2 = MathMin(iClose(pair,tf,i),iOpen(pair,tf,i));
         if(i>0) p2 = MathMax(p2,MathMax(iLow(pair,tf,i-1),iLow(pair,tf,i+1)));
         if(i>0) p2 = MathMax(p2,MathMin(iOpen(pair,tf,i-1),iClose(pair,tf,i-1)));
         p2 = MathMax(p2,MathMin(iOpen(pair,tf,i+1),iClose(pair,tf,i+1)));
         
         draw=true;
         if(recolor_retouch || !solid_retouch){
            exit = false;
            for(j=i;j>=0;j--){
               if(j==0 && !exit) {draw=false;break;}
               if(!exit && iHigh(pair,tf,j)<p2) {exit=true;continue;}
               if(exit && iHigh(pair,tf,j)>p2) {
                  retouch = true;
                  if(zone_fibs && fib_sup_hit==0){ fib_sup = p2; fib_sup_hit = j;}
                  break;
               }
            }
         }
         if(SupCount != 0) val = ObjectGet(TAG+"UPZONE"+SupCount,OBJPROP_PRICE2); //final sema cull
            else val=0;
         if(draw_zones && draw && BuferDn1[i]!=val) {
            valid=true;
            c = color_sup_strong;
            if(zone_strength && (retouch || !recolor_retouch)){
               countstrong=0;
               countweak=0;
               for(j=i;j<1000000;j++){
                  if(iHigh(pair,tf,j+1)<p2) countstrong++;
                  if(iHigh(pair,tf,j+1)>BuferDn1[i]) countweak++;
                  if(countstrong > 1) break;
                     else if(countweak > 1){
                        c=color_sup_weak;
                        if(no_weak_zones) draw = false;
                        break;
                     }                 
               }
            }
//         if(c == color_sup_weak && !no_weak_zones) draw = false;
         if(draw){
            if(recolor_retouch && retouch && countweak<2) c = color_sup_retouch;
               else if(recolor_weak_retouch && retouch && countweak>1) c = color_sup_retouch;
            SupCount++;
            if(draw_edge_price){
               s = l_zone+TAG+"UPAR"+SupCount;
               ObjectCreate(s,OBJ_ARROW,0,0,0);
               ObjectSet(s,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
               ObjectSet(s, OBJPROP_TIME1, t2);
               ObjectSet(s, OBJPROP_PRICE1, p2);
               ObjectSet(s,OBJPROP_COLOR,c);
               ObjectSet(s,OBJPROP_WIDTH,Price_Width);
               if(limit_zone_vis) ObjectSet(s,OBJPROP_TIMEFRAMES,visible);
            }
            s = l_zone+TAG+"UPZONE"+SupCount;
            ObjectCreate(s,OBJ_RECTANGLE,0,0,0,0,0);
            ObjectSet(s,OBJPROP_TIME1,t1);
            ObjectSet(s,OBJPROP_PRICE1,BuferDn1[i]);
            ObjectSet(s,OBJPROP_TIME2,t2);
            ObjectSet(s,OBJPROP_PRICE2,p2);
            ObjectSet(s,OBJPROP_COLOR,c);
            ObjectSet(s,OBJPROP_BACK,true);
            if(limit_zone_vis) ObjectSet(s,OBJPROP_TIMEFRAMES,visible);
            if(!solid_zones) {ObjectSet(s,OBJPROP_BACK,false);ObjectSet(s,OBJPROP_WIDTH,zone_width);}
            if(!solid_retouch && retouch) {ObjectSet(s,OBJPROP_BACK,false);ObjectSet(s,OBJPROP_WIDTH,zone_width);}
            
            if(globals){
               GlobalVariableSet(TAG+"S_PH"+SupCount,BuferDn1[i]);
               GlobalVariableSet(TAG+"S_PL"+SupCount,p2);
               GlobalVariableSet(TAG+"S_T"+SupCount,iTime(pair,tf,i));
            }
            if(!fhe && c!=color_dem_retouch){fhe=true;GlobalVariableSet(TAG+"GOSHORT",p2);}
            }
         }
         if(draw && sc<4 && HUD_on && valid){
            if(sc==0) sup_width = BuferDn1[i] - p2;
            sup_RR[sc] = p2;
            sc++;
         }

      }
      
      if(BuferUp1[i] > point){
         retouch = false;
         valid=false;
         t1 = iTime(pair,tf,i);
         t2 = Time[0];
         p2 = MathMax(iClose(pair,tf,i),iOpen(pair,tf,i));
         if(i>0) p2 = MathMin(p2,MathMin(iHigh(pair,tf,i+1),iHigh(pair,tf,i-1)));
         if(i>0) p2 = MathMin(p2,MathMax(iOpen(pair,tf,i-1),iClose(pair,tf,i-1)));
         p2 = MathMin(p2,MathMax(iOpen(pair,tf,i+1),iClose(pair,tf,i+1)));
         
         c = color_dem_strong;
         draw=true;
         if(recolor_retouch || !solid_retouch){
            exit = false;
            for(j=i;j>=0;j--) {
               if(j==0 && !exit) {draw=false;break;}
               if(!exit && iLow(pair,tf,j)>p2) {exit=true;continue;}
               if(exit && iLow(pair,tf,j)<p2) {
                  retouch = true;
                  if(zone_fibs && fib_dem_hit==0){fib_dem = p2; fib_dem_hit = j; }
                  break;
               }
            }
         }
         if(DemCount != 0) val = ObjectGet(TAG+"DNZONE"+DemCount,OBJPROP_PRICE2); //final sema cull
            else val=0;
         if(draw_zones && draw && BuferUp1[i]!=val){
            valid = true;
            if(zone_strength && (retouch || !recolor_retouch)){
               countstrong=0;
               countweak=0;
               for(j=i;j<1000000;j++){
                  if(iLow(pair,tf,j+1)>p2) countstrong++;
                  if(iLow(pair,tf,j+1)<BuferUp1[i]) countweak++;
                  if(countstrong > 1) break;
                     else if(countweak > 1){
                        if(no_weak_zones) draw = false;
                        c=color_dem_weak;
                        break;
                     }                 
               }
            }
            
            if(draw){
            if(recolor_retouch && retouch && countweak<2) c = color_dem_retouch;
               else if(recolor_weak_retouch && retouch && countweak>1) c = color_dem_retouch;

            DemCount++;
            if(draw_edge_price){
               s = l_zone+TAG+"DNAR"+DemCount;
               ObjectCreate(s,OBJ_ARROW,0,0,0);
               ObjectSet(s,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
               ObjectSet(s, OBJPROP_TIME1, t2);
               ObjectSet(s, OBJPROP_PRICE1, p2);
               ObjectSet(s,OBJPROP_COLOR,c);
               ObjectSet(s,OBJPROP_WIDTH,Price_Width);  
               if(limit_zone_vis) ObjectSet(s,OBJPROP_TIMEFRAMES,visible);
            }
            s = l_zone+TAG+"DNZONE"+DemCount;
            ObjectCreate(s,OBJ_RECTANGLE,0,0,0,0,0);
            ObjectSet(s,OBJPROP_TIME1,t1);
            ObjectSet(s,OBJPROP_PRICE1,p2);
            ObjectSet(s,OBJPROP_TIME2,t2);
            ObjectSet(s,OBJPROP_PRICE2,BuferUp1[i]);
            ObjectSet(s,OBJPROP_COLOR,c);
            ObjectSet(s,OBJPROP_BACK,true);
            if(limit_zone_vis) ObjectSet(s,OBJPROP_TIMEFRAMES,visible);
            if(!solid_zones) {ObjectSet(s,OBJPROP_BACK,false);ObjectSet(s,OBJPROP_WIDTH,zone_width);}
            if(!solid_retouch && retouch) {ObjectSet(s,OBJPROP_BACK,false);ObjectSet(s,OBJPROP_WIDTH,zone_width);}
            if(globals){
               GlobalVariableSet(TAG+"D_PL"+DemCount,BuferUp1[i]);
               GlobalVariableSet(TAG+"D_PH"+DemCount,p2);
               GlobalVariableSet(TAG+"D_T"+DemCount,iTime(pair,tf,i));
            }
            if(!fle && c!=color_dem_retouch){fle=true;GlobalVariableSet(TAG+"GOLONG",p2);}
            }
         }
         if(draw && dc<4 && HUD_on && valid){
            if(dc==0) dem_width = p2-BuferUp1[i];
            dem_RR[dc] = p2;
            dc++;
         }
      }
   }
   if(zone_fibs || HUD_on){
      double a,b;
      int dr=0;
      int sr=0;
      int d1=0;
      int s1=0;
      //int t;
      for(i=0;i<100000;i++){
         if(iHigh(pair,tf,i)>fib_sup && sr==0) sr = i;
         if(iHigh(pair,tf,i)>sup_RR[0] && s1==0) s1 = i;
         if(iLow(pair,tf,i)<fib_dem && dr==0) dr = i;
         if(iLow(pair,tf,i)<dem_RR[0] && d1==0) d1 = i;
         if(sr!=0&&s1!=0&&dr!=0&&d1!=0) break;
      }
   }
      
      if(zone_fibs){
      
         if(dr<sr) {b = fib_dem;a = sup_RR[0];}
            else {b = fib_sup;a = dem_RR[0];}

      
         s = l_zone+TAG+"FIBO";
         ObjectCreate(s, OBJ_FIBO, 0,Time[0],a,Time[0],b);
	      ObjectSet(s, OBJPROP_COLOR, CLR_NONE);
	      ObjectSet(s, OBJPROP_STYLE, fib_style);
	      ObjectSet(s, OBJPROP_RAY, true);
	      ObjectSet(s, OBJPROP_BACK, true);
         if(limit_zone_vis) ObjectSet(s,OBJPROP_TIMEFRAMES,visible);
         int level_count=ArraySize(fib_level_array);
   
         ObjectSet(s, OBJPROP_FIBOLEVELS, level_count);
         ObjectSet(s, OBJPROP_LEVELCOLOR, color_fib);
   
         for(j=0; j<level_count; j++){
            ObjectSet(s, OBJPROP_FIRSTLEVEL+j, fib_level_array[j]);
            ObjectSetFiboDescription(s,j,fib_level_desc[j]);
         }
      }
      if(HUD_on) {
         if(d1<s1) {b = dem_RR[0];a = sup_RR[0]; arrow_glance = CharToStr(arrow_UP); color_arrow = color_arrow_up;}
            else {b = sup_RR[0];a = dem_RR[0]; arrow_glance = CharToStr(arrow_DN); color_arrow = color_arrow_dn;}      
         min = MathMin(a,b);
         max = MathMax(a,b);
      }
   
   
}

bool NewBar() {
	static datetime LastTime = 0;
	if (iTime(pair,tf,0)+time_offset != LastTime) {
		LastTime = iTime(pair,tf,0)+time_offset;		
		return (true);
	} else
		return (false);
}

void ObDeleteObjectsByPrefix(string Prefix){
   int L = StringLen(Prefix);
   int i = 0; 
   while(i < ObjectsTotal()) {
      string ObjName = ObjectName(i);
      if(StringSubstr(ObjName, 0, L) != Prefix) {
         i++;
         continue;
      }
      ObjectDelete(ObjName);
   }
}

int CountZZ( double& ExtMapBuffer[], double& ExtMapBuffer2[], int ExtDepth, int ExtDeviation, int ExtBackstep ){ // based on code (C) metaquote{
   int    shift, back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;
   int count = iBars(pair,tf)-ExtDepth;

   for(shift=count; shift>=0; shift--){
      val = iLow(pair,tf,iLowest(pair,tf,MODE_LOW,ExtDepth,shift));
      if(val==lastlow) val=0.0;
      else { 
         lastlow=val; 
         if((iLow(pair,tf,shift)-val)>(ExtDeviation*Point)) val=0.0;
         else{
            for(back=1; back<=ExtBackstep; back++){
               res=ExtMapBuffer[shift+back];
               if((res!=0)&&(res>val)) ExtMapBuffer[shift+back]=0.0; 
              }
           }
        } 
        
          ExtMapBuffer[shift]=val;
      //--- high
      val=iHigh(pair,tf,iHighest(pair,tf,MODE_HIGH,ExtDepth,shift));
      
      if(val==lasthigh) val=0.0;
      else {
         lasthigh=val;
         if((val-iHigh(pair,tf,shift))>(ExtDeviation*Point)) val=0.0;
         else{
            for(back=1; back<=ExtBackstep; back++){
               res=ExtMapBuffer2[shift+back];
               if((res!=0)&&(res<val)) ExtMapBuffer2[shift+back]=0.0; 
              } 
           }
        }
      ExtMapBuffer2[shift]=val;
     }
   // final cutting 
   lasthigh=-1; lasthighpos=-1;
   lastlow=-1;  lastlowpos=-1;

   for(shift=count; shift>=0; shift--){
      curlow=ExtMapBuffer[shift];
      curhigh=ExtMapBuffer2[shift];
      if((curlow==0)&&(curhigh==0)) continue;
      //---
      if(curhigh!=0){
         if(lasthigh>0) {
            if(lasthigh<curhigh) ExtMapBuffer2[lasthighpos]=0;
            else ExtMapBuffer2[shift]=0;
           }
         //---
         if(lasthigh<curhigh || lasthigh<0){
            lasthigh=curhigh;
            lasthighpos=shift;
           }
         lastlow=-1;
        }
      //----
      if(curlow!=0){
         if(lastlow>0){
            if(lastlow>curlow) ExtMapBuffer[lastlowpos]=0;
            else ExtMapBuffer[shift]=0;
           }
         //---
         if((curlow<lastlow)||(lastlow<0)){
            lastlow=curlow;
            lastlowpos=shift;
           } 
         lasthigh=-1;
        }
     }
  
   for(shift=iBars(pair,tf)-1; shift>=0; shift--){
      if(shift>=count) ExtMapBuffer[shift]=0.0;
         else {
            res=ExtMapBuffer2[shift];
            if(res!=0.0) ExtMapBuffer2[shift]=res;
         }
   }

  return(0);
}
 
void GetValid(double& ExtMapBuffer[], double& ExtMapBuffer2[]){
   up_cur = 0;
   int upbar = 0;
   dn_cur = 0;
   int dnbar = 0;
   double cur_hi = 0;
   double cur_lo = 0;
   double last_up = 0;
   double last_dn = 0;
   double low_dn = 0;
   double hi_up = 0;
   int i;
   for(i=0;i<iBars(pair,tf);i++) if(ExtMapBuffer[i] > 0){
      up_cur = ExtMapBuffer[i];
      cur_lo = ExtMapBuffer[i];
      last_up = cur_lo;
      break;
   }
   for(i=0;i<iBars(pair,tf);i++) if(ExtMapBuffer2[i] > 0){
      dn_cur = ExtMapBuffer2[i];
      cur_hi = ExtMapBuffer2[i];
      last_dn = cur_hi;
      break;
   }

   for(i=0;i<iBars(pair,tf);i++) // remove higher lows and lower highs
   {
      if(ExtMapBuffer2[i] >= last_dn) {
         last_dn = ExtMapBuffer2[i];
         dnbar = i;
      }
         else ExtMapBuffer2[i] = 0.0;
      if(ExtMapBuffer2[i] <= dn_cur && ExtMapBuffer[i] > 0.0) ExtMapBuffer2[i] = 0.0;
      if(ExtMapBuffer[i] <= last_up && ExtMapBuffer[i] > 0) {
         last_up = ExtMapBuffer[i];
         upbar = i;
      }
         else ExtMapBuffer[i] = 0.0;
      if(ExtMapBuffer[i] > up_cur) ExtMapBuffer[i] = 0.0;
   }
   low_dn = MathMin(iOpen(pair,tf,dnbar),iClose(pair,tf,dnbar));
   hi_up = MathMax(iOpen(pair,tf,upbar),iClose(pair,tf,upbar));         
   for(i=MathMax(upbar,dnbar);i>=0;i--) {// work back to zero and remove reentries into s/d
      if(ExtMapBuffer2[i] > low_dn && ExtMapBuffer2[i] != last_dn) ExtMapBuffer2[i] = 0.0;
         else if(ExtMapBuffer2[i] > 0) {
            last_dn = ExtMapBuffer2[i];
         low_dn = MathMin(iClose(pair,tf,i),iOpen(pair,tf,i));
         if(i>0) low_dn = MathMax(low_dn,MathMax(iLow(pair,tf,i-1),iLow(pair,tf,i+1)));
         if(i>0) low_dn = MathMax(low_dn,MathMin(iOpen(pair,tf,i-1),iClose(pair,tf,i-1)));
         low_dn = MathMax(low_dn,MathMin(iOpen(pair,tf,i+1),iClose(pair,tf,i+1)));
         }
      if(ExtMapBuffer[i] <= hi_up && ExtMapBuffer[i] > 0 && ExtMapBuffer[i] != last_up) ExtMapBuffer[i] = 0.0;
         else if(ExtMapBuffer[i] > 0){
            last_up = ExtMapBuffer[i];
            hi_up = MathMax(iClose(pair,tf,i),iOpen(pair,tf,i));
            if(i>0) hi_up = MathMin(hi_up,MathMin(iHigh(pair,tf,i+1),iHigh(pair,tf,i-1)));
            if(i>0) hi_up = MathMin(hi_up,MathMax(iOpen(pair,tf,i-1),iClose(pair,tf,i-1)));
            hi_up = MathMin(hi_up,MathMax(iOpen(pair,tf,i+1),iClose(pair,tf,i+1)));
         }
   }
}

void HUD()
{
   string s = TimeFrameToString(tf);
   string l = "b";
   if (draw_edge_price)
   {
     string u = DoubleToStr(ObjectGet(l_zone+TAG+"UPAR"+1,OBJPROP_PRICE1),Digits);
     string d = DoubleToStr(ObjectGet(l_zone+TAG+"DNAR"+1,OBJPROP_PRICE1),Digits);
   }
   DrawText(l,s,hud_tf_x,hud_tf_y,color_HUD_tf,font_HUD,font_HUD_size,corner_HUD);
   DrawText(l,arrow_glance,hud_arrow_x,hud_arrow_y,color_arrow,font_arrow,font_arrow_size,corner_HUD,0,true);
   if (draw_edge_price)
   {
      DrawText(l,u,hud_sup_x,hud_sup_y,color_sup_strong,font_HUD_price,font_HUD_price_size,corner_HUD);
      DrawText(l,d,hud_dem_x,hud_dem_y,color_dem_strong,font_HUD_price,font_HUD_price_size,corner_HUD);
   }

   l = "a";
   DrawText(l,s,hud_tfs_x,hud_tfs_y,color_shadow,font_HUD,font_HUD_size,corner_HUD);
   DrawText(l,arrow_glance,hud_arrows_x,hud_arrows_y,color_shadow,font_arrow,font_arrow_size,corner_HUD,0,true);
   if (draw_edge_price)
   {
     DrawText(l,u,hud_sups_x,hud_sups_y,color_shadow,font_HUD_price,font_HUD_price_size,corner_HUD);
     DrawText(l,d,hud_dems_x,hud_dems_y,color_shadow,font_HUD_price,font_HUD_price_size,corner_HUD);
   }
   
}

void BarTimer() // Original Code by Vasyl Gumenyak, I just fucked it up
{
   int i=0,sec=0;
   double pc=0.0;
   string time="",s_end="",s;
   s = l_hud+TAG+"btimerback";
   if (ObjectFind(s) == -1) {
      ObjectCreate(s , OBJ_LABEL,0,0,0);
      ObjectSet(s, OBJPROP_XDISTANCE, hud_timer_x);
      ObjectSet(s, OBJPROP_YDISTANCE, hud_timer_y);
      ObjectSet(s, OBJPROP_CORNER, corner_HUD);
      ObjectSet(s, OBJPROP_ANGLE, rotation);
      ObjectSetText(s, s_base, size_timer_font, timer_font, color_timer_back);
   }

   sec=TimeCurrent()-iTime(pair,tf,0);
   i=(lenbase-1)*sec/(tf*60);
   pc=100-(100.0*sec/(tf*60));
   if(i>lenbase-1) i=lenbase-1;
   if(i<lenbase-1) s_end=StringSubstr(s_base,i+1,lenbase-i-1);
   time=StringConcatenate("|",s_end);

   s = l_hud+TAG+"timerfront";
   if (ObjectFind(s) == -1) {
     ObjectCreate(s , OBJ_LABEL,0,0,0);
     ObjectSet(s, OBJPROP_XDISTANCE, hud_timer_x);
     ObjectSet(s, OBJPROP_YDISTANCE, hud_timer_y);
     ObjectSet(s, OBJPROP_CORNER, corner_HUD);
     ObjectSet(s, OBJPROP_ANGLE, rotation);
   }
   ObjectSetText(s, time, size_timer_font, timer_font, color_timer_bar);   
}

void DrawText(string l, string t, int x, int y, color c, string f, int s, int k=0, int a=0, bool b=false)
{
   string tag = l_hud+TAG+l+x+y;
   ObjectDelete(tag);
   ObjectCreate(tag,OBJ_LABEL,0,0,0);
   ObjectSetText(tag,t,s,f,c);
   ObjectSet(tag,OBJPROP_XDISTANCE,x);
   ObjectSet(tag,OBJPROP_YDISTANCE,y);
   ObjectSet(tag,OBJPROP_CORNER,k);
   ObjectSet(tag,OBJPROP_ANGLE,a);
   if(b) ObjectSet(tag,OBJPROP_BACK,true);
}

string TimeFrameToString(int _tf) //code by TRO
{
   string tfs;
   switch(_tf) {
      case PERIOD_M1:  tfs="M1"  ; break;
      case PERIOD_M5:  tfs="M5"  ; break;
      case PERIOD_M15: tfs="M15" ; break;
      case PERIOD_M30: tfs="M30" ; break;
      case PERIOD_H1:  tfs="H1"  ; break;
      case PERIOD_H4:  tfs="H4"  ; break;
      case PERIOD_D1:  tfs="D1"  ; break;
      case PERIOD_W1:  tfs="W1"  ; break;
      case PERIOD_MN1: tfs="MN";
   }
   return(tfs);
}

void setHUD()
{
   switch(tf) {
      case PERIOD_M1:  HUD_x=7 ; break;
      case PERIOD_M5:  HUD_x=7 ; break;
      case PERIOD_M15: HUD_x=3 ; break;
      case PERIOD_M30: HUD_x=2 ; break;
      case PERIOD_H1:  HUD_x=12 ; break;
      case PERIOD_H4:  HUD_x=8 ; break;
      case PERIOD_D1 : HUD_x=12 ; break;
      case PERIOD_W1:  HUD_x=8 ; break;
      case PERIOD_MN1: HUD_x=7 ; break;
   }
   if(corner_HUD > 3) corner_HUD=0;
   if(corner_HUD == 0 || corner_HUD == 2) rotation = 90;
   switch(corner_HUD){
      case 0 : hud_tf_x = pos_x-HUD_x+10;
               hud_tf_y = pos_y+18;
               hud_arrow_x = pos_x-2;
               hud_arrow_y = pos_y+7;
               hud_sup_x = pos_x;
               hud_sup_y = pos_y;
               hud_dem_x = pos_x;
               hud_dem_y = pos_y+56;
               hud_timer_x = pos_x+50;
               hud_timer_y = pos_y+72;
               hud_tfs_x = hud_tf_x+1;
               hud_tfs_y = hud_tf_y+1;
               hud_arrows_x = hud_arrow_x+1;
               hud_arrows_y = hud_arrow_y+1;
               hud_sups_x = hud_sup_x+1;
               hud_sups_y = hud_sup_y+1;
               hud_dems_x = hud_dem_x+1;
               hud_dems_y = hud_dem_y+1;
               break;
      case 1 : hud_tf_x = pos_x+HUD_x;
               hud_tf_y = pos_y+18;
               hud_arrow_x = pos_x+2;
               hud_arrow_y = pos_y+7;
               hud_sup_x = pos_x;
               hud_sup_y = pos_y;
               hud_dem_x = pos_x;
               hud_dem_y = pos_y+56;
               hud_timer_x = pos_x-15;
               hud_timer_y = pos_y+71;
               hud_tfs_x = hud_tf_x-1;
               hud_tfs_y = hud_tf_y+1;
               hud_arrows_x = hud_arrow_x-1;
               hud_arrows_y = hud_arrow_y+1;
               hud_sups_x = hud_sup_x-1;
               hud_sups_y = hud_sup_y+1;
               hud_dems_x = hud_dem_x-1;
               hud_dems_y = hud_dem_y+1;
               break;
      case 2 : hud_tf_x = pos_x-HUD_x;
               hud_tf_y = pos_y+20;
               hud_arrow_x = pos_x-2;
               hud_arrow_y = pos_y+7;
               hud_sup_x = pos_x;
               hud_sup_y = pos_y+56;
               hud_dem_x = pos_x;
               hud_dem_y = pos_y;
               hud_timer_x = pos_x+62;
               hud_timer_y = pos_y+3;
               hud_tfs_x = hud_tf_x+1;
               hud_tfs_y = hud_tf_y-1;
               hud_arrows_x = hud_arrow_x+1;
               hud_arrows_y = hud_arrow_y-1;
               hud_sups_x = hud_sup_x+1;
               hud_sups_y = hud_sup_y-1;
               hud_dems_x = hud_dem_x+1;
               hud_dems_y = hud_dem_y-1;
               break;
      case 3 : hud_tf_x = pos_x+HUD_x;
               hud_tf_y = pos_y+20;
               hud_arrow_x = pos_x+2;
               hud_arrow_y = pos_y+7;
               hud_sup_x = pos_x;
               hud_sup_y = pos_y+56;
               hud_dem_x = pos_x;
               hud_dem_y = pos_y;
               hud_timer_x = pos_x-2;
               hud_timer_y = pos_y+3;
               hud_tfs_x = hud_tf_x-1;
               hud_tfs_y = hud_tf_y-1;
               hud_arrows_x = hud_arrow_x-1;
               hud_arrows_y = hud_arrow_y-1;
               hud_sups_x = hud_sup_x-1;
               hud_sups_y = hud_sup_y-1;
               hud_dems_x = hud_dem_x-1;
               hud_dems_y = hud_dem_y-1;
               break;
   }
}

void DoLogo(){
   string _TAG = CharToStr(0x61+27)+"II_Logo";
   if( ObjectFind(_TAG+"ZZ"+0) >= 0 && ObjectFind(_TAG+"ZZ"+1) >= 0 && ObjectFind(_TAG+"ZZ"+2) >= 0  && 
       ObjectFind(_TAG+"AZ"+0) >= 0 && ObjectFind(_TAG+"AZ"+1) >= 0 && ObjectFind(_TAG+"AZ"+2) >= 0 ) return;
   string str[3] = {"$","Insanity","Industries"};
   int size[3] = {25,10,10};
   int _pos_x[3] = {47,19,17};
   int _pos_y[3] = {10,25,15};
   int pos_xs[3] = {46,18,16};
   int pos_ys[3] = {9,24,14};
   for(int i=0;i<3;i++){
      string n = _TAG+"ZZ"+i;
      ObjectDelete(n);
      ObjectCreate(n,OBJ_LABEL,0,0,0);
      ObjectSetText(n,str[i],size[i],"Pieces Of Eight",AliceBlue);
      ObjectSet(n,OBJPROP_XDISTANCE,_pos_x[i]);
      ObjectSet(n,OBJPROP_YDISTANCE,_pos_y[i]);
      ObjectSet(n,OBJPROP_CORNER,3);
      n = _TAG+"AZ"+i;
      ObjectDelete(n);
      ObjectCreate(n,OBJ_LABEL,0,0,0);
      ObjectSetText(n,str[i],size[i],"Pieces Of Eight",Black);
      ObjectSet(n,OBJPROP_XDISTANCE,pos_xs[i]);
      ObjectSet(n,OBJPROP_YDISTANCE,pos_ys[i]);
      ObjectSet(n,OBJPROP_CORNER,3);
   }
}

void setVisibility()
{
   int per = Period();
   visible=0;
   if(same_tf_vis){
  	   if(forced_tf == per || forced_tf == 0){
  	      switch(per){
            case PERIOD_M1:  visible= 0x0001 ; break;
            case PERIOD_M5:  visible= 0x0002 ; break;
            case PERIOD_M15: visible= 0x0004 ; break;
            case PERIOD_M30: visible= 0x0008 ; break;
            case PERIOD_H1:  visible= 0x0010 ; break;
            case PERIOD_H4:  visible= 0x0020 ; break;
            case PERIOD_D1:  visible= 0x0040 ; break;
            case PERIOD_W1:  visible= 0x0080 ; break;
            case PERIOD_MN1: visible= 0x0100 ;  	   
  	      }
  	   }
  	} else {
  	  if(show_on_m1) visible += 0x0001;
	  if(show_on_m5) visible += 0x0002;
	  if(show_on_m15) visible += 0x0004;
	  if(show_on_m30) visible += 0x0008;
	  if(show_on_h1) visible += 0x0010;
	  if(show_on_h4) visible += 0x0020;
	  if(show_on_d1) visible += 0x0040;
	  if(show_on_w1) visible += 0x0080;
	  if(show_on_mn) visible += 0x0100;
   }

}