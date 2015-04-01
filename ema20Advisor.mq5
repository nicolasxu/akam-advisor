//+------------------------------------------------------------------+
//|                                                        ema20.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"

// 1. price move over ema20 line, buy and take profit 1000, and stoploss 2000
// 2. price move below ema 20 line, verseversa
// 3. jjma7 direction turns to the same direction as ema20, buy till jjma7 turns


#include "OnNewBar.mqh"
#include "Utilities.mqh"



int ema20Handle;
int jjma7Handle;
double jjmaBuffer[];
double emaBuffer[];

int timeInterval = 60*10; // 10 min

OrderList* orderList;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(timeInterval);
  
   ema20Handle = iMA(  NULL,          // symbol string
                            0,        // timeframe
                           20,        // ma period
                            0,        // ma shift
                     MODE_EMA,        // Smooth method
                  PRICE_CLOSE);       // Calculating on Close prices
                  
   jjma7Handle = iCustom(NULL,0,"Expert_Indicators\\jjma", 7, 100, PRICE_CLOSE,0,0); 
   
   ArraySetAsSeries(jjmaBuffer,true);
   ArraySetAsSeries(emaBuffer,true);
   
   orderList = new OrderList;
   if(orderList == NULL) {
        printf("Init CList error");
        return INIT_FAILED;   
   }
   
   printf("ema20Handle: %d", ema20Handle);
   printf("jjma7Handle: %d", jjma7Handle);   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//--- destroy timer
   EventKillTimer();
   delete orderList;
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
    CopyBuffer(jjma7Handle,
      0, // indicator buffer number
      0, // starting position
      2, // counts
      jjmaBuffer);
    CopyBuffer(ema20Handle,0, 0, 2 , emaBuffer);
    
    
    
    
    printf("jjmaBuffer[0]: %G",jjmaBuffer[0] );
    printf("emaBuffer[0]: %G",  emaBuffer[0]);
  }

void OnNewBar() {}
void OnEveryTick() {}
  
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade(){
//---
   
}
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result) {
   
   orderList.updateOrderCells(trans,request, result);
   orderList.updatePosition(trans);
   
}
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester(){
//---
   double ret=0.0;
//---

//---
   return(ret);
}
//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit(){
//---
   
}
void OnTesterDeinit() {
  
}  
  
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass(){
//---
   
}
//+------------------------------------------------------------------+
