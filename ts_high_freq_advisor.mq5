//+------------------------------------------------------------------+
//|                                         ts_high_freq_advisor.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"

#include "Utilities.mqh"
#include "onnewbar.mqh"

double basket[4] = {0};
TickList *tickList = new TickList();

int crossCounter = 0;
int billyMagic = 205;
OrderList *orderList;
LossList  *lossList;
int minuteCounter = 0;
double initialOrderSize = 1.0; // 1 lot

/*  

Summary:
   1) figure out the tick price density distributon around open price
   2) place the the bets



*/ 

void calculateCounter () {


   double openPrice = getCurrentBarOpenPrice(0);
   
   MqlTick theTick;
   SymbolInfoTick(Symbol(),theTick);
   
   double currentPrice = theTick.last;
   
   static bool isAbove = false;
   
   if(currentPrice > openPrice + 50 * Point()){
      
      if(isAbove == false) {
         crossCounter++;
         isAbove = true;
      }
         
   } else if (currentPrice < openPrice - 50 * Point() ){
      if(isAbove == true ) {
         crossCounter++;
         isAbove = false;
      }
   }
}
void calculateBasket(double & theBasket[]) {


   double openPrice = getCurrentBarOpenPrice(0);
   
   MqlTick theTick;
   SymbolInfoTick(Symbol(),theTick);
   
   double currentPrice = theTick.last;
   
   static bool isAbove = false;

   /*
   if((currentPrice > openPrice) && (currentPrice < openPrice + 30 * Point())){
      theBasket[1] = theBasket[1] + 1;
      TickObject *to = new TickObject(theTick);
      tickList.Add(to);
         
   }
   if((currentPrice < openPrice) && (currentPrice > openPrice - 30 * Point())) {
      theBasket[2] = theBasket[2] + 1;
      TickObject *to = new TickObject(theTick);   
      tickList.Add(to);
   }
   */
   
   if( currentPrice >= openPrice + 50 * Point()) {
      theBasket[0] =  theBasket[0] + 1;
      if(!isAbove){

         TickObject *to = new TickObject(theTick);
         tickList.Add(to);
         isAbove = true;
         
      }

   }
   if( currentPrice <= openPrice - 50 * Point()) {
      theBasket[3] =  theBasket[3] + 1;
      
      if(isAbove) {

         TickObject *to = new TickObject(theTick);
         tickList.Add(to);
         isAbove = false;
         // only record crossing the open price
      
      }

   }
   
   
   
}


// time series high frequency advisor
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
//--- create timer
   //EventSetMillisecondTimer(60*1000);
   
   EventSetTimer(1*60);
   
   orderList = new OrderList(lossList);
   if(orderList == NULL) {
      printf("Init CList error");
      return INIT_FAILED;   
   }   
      
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//--- destroy timer
   EventKillTimer();
   
   delete tickList;
   delete orderList;
   delete lossList;
      
}


void OnEveryTick(){
   double openPrice = getCurrentBarOpenPrice(0);
   
   calculateBasket(basket);
   calculateCounter();
   
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
  
   minuteCounter++;
   
   if(minuteCounter > 12*60) {
      double position = orderList.netPosition;
      
      if(position > 0) {
         marketSell(position, closePositionMagic,0);
      }
      if(position < 0) {
         marketBuy(-position, closePositionMagic, 0);
      }
   
   }
   



}

void OnNewBar() {
   // reset the minute counter
   minuteCounter = 0;
   tickList.saveTickToFile();
   tickList.Clear();
   printf("crossCounter: %d", crossCounter);
   
   // reset crossCounter
   crossCounter = 0;
   double openPrice = getCurrentBarOpenPrice(0);

   limitSell(initialOrderSize,billyMagic++,openPrice, openPrice - 100*Point(),openPrice + 800*Point());

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
                        const MqlTradeResult& result){


   orderList.updatePosition(trans);
   orderList.updateOrderCells(trans,request, result);
   
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
