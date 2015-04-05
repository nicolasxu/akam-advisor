//+------------------------------------------------------------------+
//|                                       jjma_high_freq_advisor.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"

#include "OnNewBar.mqh"
#include "Utilities.mqh"



double expectProfit = 100*Point();
int timer = 5; // 5 minutes

double initialOrderSize = 20;
double nextOrderSize = initialOrderSize;

int jjmaHandle;
double jjmaBuffer[];

bool newBarUsed = false; // flag to control only one order is sent in every new bar, e.g.: hourly bar

OrderList* orderList;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//--- create timer
   EventSetTimer(60*timer);
   
   jjmaHandle = iCustom(NULL,0,"Expert_Indicators\\jjma", 7, 100, PRICE_CLOSE,0,0); 
   
   ArraySetAsSeries(jjmaBuffer, true);
   
   orderList = new OrderList;
   
   printf("jjmaHandle: %d", jjmaHandle);
      
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//--- destroy timer
   EventKillTimer();
   
   // release handle
   IndicatorRelease(jjmaHandle);
   
   
    delete orderList;
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnEveryTick() {

}

void OnNewBar() {
   // set this flag to false
   // This flag will be set to true when an order is sent
   // So only one order is sent in every new bar
   newBarUsed = false;
   
   CopyBuffer(jjmaHandle, 0, 0, 8, jjmaBuffer);
   // jjmaBuffer[0], current time t unfinished value
   // jjmaBuffer[1], t - 1 value
   // jjmaBuffer[2], t - 2 value
   double diff1 =  jjmaBuffer[1] - jjmaBuffer[2]; // t - 1 diff
   double diff2 = jjmaBuffer[2] - jjmaBuffer[3];
   double diff3 = jjmaBuffer[3] - jjmaBuffer[4];
   double diff4 = jjmaBuffer[4] - jjmaBuffer[5];
   
   
   if(diff1 > 0 && diff2 > 0){
      if(diff1 > diff2){
         if(MathAbs(diff1 - diff2) > 200*0.000001) {
            
            printf("diff1 - diff2 > 200: %G", (diff1 - diff2)*1000000); 
            marketBuy(initialOrderSize,5, expectProfit);
         } 
       
      }
   }
   
   if(diff1< 0 && diff2 < 0){
      if(diff1 < diff2){
         
         if(MathAbs(diff1 - diff2) > 200*0.000001) {
            
            printf("diff1 - diff2 > 200: %G", (diff1 - diff2)*1000000); 
            marketSell(initialOrderSize, 6, expectProfit);
         }            
      }
   }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
//---
   CopyBuffer(jjmaHandle, 0, 0, 4, jjmaBuffer);
  
   
   
   // situation 1
   
   // situation 2
   
   // situation 3
   
   // situation 4
   
   // before order sent, close all position that is in other direction first
   
   
   
}
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit() {
//---
   
}
void OnTesterDeinit(){
        
}
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
  {
//---
   
  }
//+------------------------------------------------------------------+
