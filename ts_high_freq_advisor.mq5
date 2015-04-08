//+------------------------------------------------------------------+
//|                                         ts_high_freq_advisor.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"

#include "Utilities.mqh"

double basket[] = {0};
/*  

Summary:
   1) figure out the tick price density distributon around open price
   2) place the the bets



*/ 

void calculateBasket(double & theBasket[]) {
   double openPrice = getCurrentBarOpenPrice(0);
   double currentPrice = getLastPrice();
   //printf("openPrice: %G", openPrice);
   //printf("currentPrice: %G", currentPrice);
   if((currentPrice > openPrice) && (currentPrice < openPrice + 30 * Point())){
      theBasket[1] = theBasket[1] + 1;   
   }
   if((currentPrice < openPrice) && (currentPrice > openPrice - 30 * Point())) {
      theBasket[2] = theBasket[2] + 1;
   }
   if( (currentPrice >= openPrice + 30 * Point()) && (currentPrice <= openPrice + 55 * Point())) {
      theBasket[0] =  theBasket[0] + 1;
   }
   if( (currentPrice <= openPrice - 30 * Point()) && (currentPrice >= openPrice - 55 * Point())) {
      theBasket[3] =  theBasket[3] + 1;
   }
   
   
}


// time series high frequency advisor
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
//--- create timer
   //EventSetMillisecondTimer(60*1000);
   
   EventSetTimer(1);
      
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


void OnTick(){
   double openPrice = getCurrentBarOpenPrice(0);
   
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
   static int timerCounter = 0;
   if(timerCounter < 50){
      double openPrice = getCurrentBarOpenPrice(0);
      if(timerCounter %2 == 0) {
         limitBuy(1,1234,openPrice,openPrice + 50*Point(),0);
      } else {
         limitSell(1,12345,openPrice,openPrice - 50*Point(),0);
      }
      
   }
   
   timerCounter++;

      
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
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TesterDeinit function                                            |
//+------------------------------------------------------------------+
void OnTesterDeinit()
  {
//---
   
  }
//+------------------------------------------------------------------+
