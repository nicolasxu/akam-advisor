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

int jjmaHandle;
double jjmaBuffer[];




//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//--- create timer
   EventSetTimer(60);
   
   jjmaHandle = iCustom(NULL,0,"Expert_Indicators\\jjma", 7, 100, PRICE_CLOSE,0,0); 
   
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
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnEveryTick() {

}

void OnNewBar() {

}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
//---
   
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
void OnTesterInit()
  {
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
