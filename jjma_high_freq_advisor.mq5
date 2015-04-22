//+------------------------------------------------------------------+
//|                                       jjma_high_freq_advisor.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"

// It is intended to use on H1 period

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
LossList*  lossList;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){

   EventSetTimer(60*timer);
   
   jjmaHandle = iCustom(NULL,0,"Expert_Indicators\\jjma", 10, 100, PRICE_WEIGHTED,0,0); 
   
   ArraySetAsSeries(jjmaBuffer, true);
   
   orderList = new OrderList(lossList);
   
   printf("jjmaHandle: %d", jjmaHandle);
     
   return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason) {


   EventKillTimer();
   
   // release handle
   IndicatorRelease(jjmaHandle);
   
   delete orderList;
      
}

void OnEveryTick() {



   CopyBuffer(jjmaHandle, 0, 0, 8, jjmaBuffer);
   double p0 = jjmaBuffer[0];
   double p1 = jjmaBuffer[1];
   double p2 = jjmaBuffer[2];
   double openPrice = getCurrentBarOpenPrice(0);
   if(p0 > p1 && p2 > p1) {
      // buy
      if(orderList.netPosition <0) {
         marketBuy(-orderList.netPosition,123,0);
      }
      //limitBuy(1,1234,openPrice +5*Point(),openPrice + expectProfit,0);
      marketBuy(1,1234,100*Point());
   }
   
   if(p0 <p1 && p2 < p1) {
      // sell
      printf("selling--------------------------");
      if(orderList.netPosition >0) {
         marketSell(orderList.netPosition,1234,0);
      }
      limitSell(1,12345, openPrice -5*Point(), openPrice - expectProfit, 0);
   }




}

void OnNewBar() {
   

}


void OnTimer(){
   
}
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade(){

}


void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result) {

   orderList.updatePosition(trans);
   printf("position is: %G", orderList.netPosition);
}



double OnTester() {

   double ret=0.0;

   return(ret);
}


void OnTesterInit() {

   
}
void OnTesterDeinit(){
        
}


void OnTesterPass() {
   
}


