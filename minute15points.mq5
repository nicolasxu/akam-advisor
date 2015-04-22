//+------------------------------------------------------------------+
//|                                               minute15points.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// use adaptivelaguerre_v2 indicator

#include "OnNewBar.mqh"
#include "Utilities.mqh"

double indicatorDataBuffer[];
double indicatorColorBuffer[];
int lagurreHandle;
double initialLotSize = 1.0;
double previousLotSize = initialLotSize;
double netPosition = 0;
double takeProfitDistance = 15 * Point();

int OnInit() {

   EventSetTimer(60);
   ArraySetAsSeries(indicatorColorBuffer, true);
   ArraySetAsSeries(indicatorDataBuffer, true);
   
   // create indicator handle
   lagurreHandle =              iCustom(NULL, // symbol name, NULL is current symbol
                                           0, // period, 0 is current period
    "Expert_Indicators\\adaptivelaguerre_v2", // folder/custom_indicator_name 
                                 //*** below is indicator input value ***
                                           0, // TimeFrame
                                 PRICE_CLOSE, // Apply to
                                          10, // Length
                                           4, // Laguerre Filter Order
                                           1, // Adaptive Mode: 0-off, 1-on
                                           5, // Adaptive Factor Smoothing Period
                                           4, // Adaptive Factor Smoothing Mode
                                           1  // Color Mode (0-off, 1-on)
                                           
    ); // end of iCustom()
   
   printf("lagurreHandle is: %d", lagurreHandle);
   
   if(lagurreHandle == INVALID_HANDLE) {
      
      return (INIT_FAILED);
   }
      
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

   EventKillTimer();
   IndicatorRelease(lagurreHandle);
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnEveryTick() {

   
}
  
void OnNewBar() {
   // designed to work on M1 bar only
   
   // 1. copy buffer
   int copied = 0;
   copied = CopyBuffer(lagurreHandle,1,0, 4, indicatorColorBuffer);
   
   
   if(copied < 0) {
      Print("not all prices copied. Will try on next tick Error =",GetLastError(),", copied =",copied);
      return;
   }
   
   // 1 (DeepSkyBlue) is up, 2 (OrangeRed) is down
   
   //printf("current color: %G", indicatorColorBuffer[0]);
   //printf("last color: %G", indicatorColorBuffer[1]);
   
   double currentColor = indicatorColorBuffer[1];
   double previousColor = indicatorColorBuffer[2];
   
   double lastPrice = getLastAskPrice();
   
   double thisLotSize = initialLotSize;
   
   
   MqlTick tick;
   SymbolInfoTick(Symbol(),tick);
   
   
   double spread = (tick.ask - tick.bid)/ Point();
  
   
   if(spread < 13) {
      printf("spread is: %G", spread );
   } else {
      return;
   }
   
   marketBuy(initialLotSize, 0000, 0);
   
   
   
   /************************
   if(currentColor == 2 && previousColor == 1) {
      printf("should sell...");
      // from 1 to 2, down
      if(netPosition != 0) {
         // 1. close previous postion
         if(netPosition > 0 ) {
            limitSell(netPosition,3000,lastPrice,0,0);
         } else {
            limitBuy(-netPosition,3000,lastPrice,0,0);
         }
         // if netPosition is not 0, there must be a loss
         // 2. double the lot size
         thisLotSize = previousLotSize * 2;
         // 3. open new position
      }
         
      limitSell(thisLotSize, 2000, lastPrice,lastPrice - takeProfitDistance,0);
      previousLotSize = thisLotSize;
   }
   
   if(currentColor == 1 && previousColor == 2) {
      printf("should buy...");
      // from 2 to 1, up
      if(netPosition !=0) {
         // handle the close previous position with loss
         if(netPosition > 0 ) {
            limitSell(netPosition,3000,lastPrice,0,0);
         } else {
             limitBuy(-netPosition,3000,lastPrice,0,0);
         }
         
         thisLotSize = previousLotSize * 2;
      }
      
      limitBuy(thisLotSize, 2000, lastPrice, lastPrice + takeProfitDistance,0);
      previousLotSize = thisLotSize;
   }
   *************************/
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {

   
}

//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade() {

   
}

//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result) {
   printf("transaction happened: " + EnumToString(trans.deal_type) );
   updatePosition(trans, netPosition);
   printf("position after updatePosition() in OnTradeTransaction(): %G", netPosition);
   
}

//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester() {

   double ret=0.0;

   return(ret);
}

//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit() {

   
}

//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass() {

   
}

//+------------------------------------------------------------------+
//| TesterDeinit function                                            |
//+------------------------------------------------------------------+
void OnTesterDeinit() {

   
}
//+------------------------------------------------------------------+
