//+------------------------------------------------------------------+
//|                                                    lrAdvisor.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function        
//+------------------------------------------------------------------+

#include "OnNewBar.mqh"

// Global value

double         LRMABuffer[];
double         LRMAColors[];
input int      LRMAPeriod=14; 
int            lrmaHandle;
int            orderMagic = 117;
double         position = 0;

// current position
input double   inputPosition = 0;
input double   buySellLotSize = 1;

int OnInit()
  {
//--- create timer
   EventSetTimer(60);
      
      
     position = inputPosition;
     lrmaHandle = iCustom(NULL,0,"Downloads\\lrma_color_hl", LRMAPeriod);
     
     ArraySetAsSeries(LRMAColors,true);
     ArraySetAsSeries(LRMABuffer,true);     
     PrintFormat("lrma handle number: %d",  lrmaHandle);
    
     Print("working... working working...() ");
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   IndicatorRelease(lrmaHandle);
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
//void OnTick()
//  {
//---
   
//  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
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
  
void OnTesterDeinit()
{
        
}
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
  {
//---
   
  }
//+------------------------------------------------------------------+

void printTradeResult(MqlTradeResult& res) {

} 

uint buy(double amount) {
   /*
   printf("buying %f", amount);
   position = position + amount;
   return 1;
   */
    printf("buying %f", amount);
    MqlTradeRequest request={0};
    request.action = TRADE_ACTION_DEAL;
    request.type = ORDER_TYPE_BUY;
    request.magic = orderMagic;
    request.symbol = Symbol();
    request.volume = amount;
    request.sl = 0;
    request.tp = 0;
    //request.price = 0;
    
    MqlTradeResult result = {0};
    
    ResetLastError();
    
    if(!OrderSend(request,result)) {
      Print(__FUNCTION__,":",result.retcode);
      return 0; 
    }
    //--- write the server reply to log  
    Print(__FUNCTION__,":",result.comment);
    if(result.retcode==10016) Print(result.bid,result.ask,result.price);
    //--- return code of the trade server reply
    position = position + amount;
    return result.retcode; 
    
}

uint sell(double amount){
   /*
   printf("selling %f", amount);
   position = position - amount;
   return 1;
   */
    printf("selling %f", amount);
    MqlTradeRequest request={0};
    request.action = TRADE_ACTION_DEAL;
    request.type = ORDER_TYPE_SELL;
    request.magic = orderMagic;
    request.symbol = Symbol();
    request.volume = amount;
    request.sl = 0;
    request.tp = 0;
    //request.price = 0;
    
    MqlTradeResult result = {0};
    
    ResetLastError();
    
    if(!OrderSend(request,result)) {
      return 0; 
    }
     //--- write the server reply to log  
    Print(__FUNCTION__,":",result.comment);
    if(result.retcode==10016) Print(result.bid,result.ask,result.price);
    //--- return code of the trade server reply
    position = position - amount;
    return result.retcode; 
    
   
}

void OnEveryTick() {
   
   printf("OnEveryTick() - new tick arrived");
   
}

// call preventLoss after the price is moving away. 
void preventLoss() {

  // 1. calculate price moving direction by substracting last price in specific time frame, e.g. 15 minutes
  // 2. calculating profit/loss of current tick
  // 2.1 if profit/loss point < 5, and direction is against us, then close the position. 
}

// call this when position is closed by preventLoss(), and price is moving to the direction as signaled by indicator
void resumePosition () {

}

// If lose 30% of the profit, then close the position
void takeProfit () {

}



//+------------------------------------------------------------------+
//| New bar event handler function                                   |
//+------------------------------------------------------------------+
void OnNewBar() {
   
   PrintFormat("New bar: %s",TimeToString(TimeCurrent(),TIME_SECONDS));
   // if last finished bar color changed, then there is action
   
   if(CopyBuffer(lrmaHandle,1,0,15,LRMAColors ) && CopyBuffer(lrmaHandle,0,0,15,LRMABuffer )) {
      
      for(int i=0;i< ArraySize(LRMAColors);i++) {
         //PrintFormat("LRMAColor[ %d]: %f", i, LRMAColors[i]);
        
         // 1 is increase value
         // 2 is decrease value
      }
      for(int i=0;i< ArraySize(LRMABuffer);i++) {
         //PrintFormat("LRMABuffer[ %d]: %f", i, LRMABuffer[i]);
        
         // 1 is increase value
         // 2 is decrease value
      }   
      // 4, 3, 2, 1, 0   
      printf("position is: %f", position);
      //LRMABuffer[2]> LRMABuffer[1] && LRMABuffer[2] > LRMABuffer[3]
      if(LRMABuffer[2]> LRMABuffer[1] && LRMABuffer[2] > LRMABuffer[3]) {
      // 1 is 2, 2 is 1
      // decreased, sell  
         if(position > 0 ) {
            sell(position + buySellLotSize);  
         }
         if(position == 0) {
            sell(buySellLotSize);   
         }
         if(position < 0) {
            
            if( -position < buySellLotSize) {
                sell(position + buySellLotSize); 
            }
            // do nothing
         }
      }
      //LRMABuffer[2]< LRMABuffer[1] && LRMABuffer[2]< LRMABuffer[3]
      if(LRMABuffer[2]< LRMABuffer[1] && LRMABuffer[2]< LRMABuffer[3]) {

         // 1 is 1, 2 is 2
         // increased, buy
         if(position > 0) {
            
            if(position < buySellLotSize) {
               buy(buySellLotSize - position);
            }
            // do nothing
         }
         if(position == 0) {
            
            buy(buySellLotSize); 
         }
         if(position < 0) {
            
            buy( -position + buySellLotSize);
         }
      }
   }   
}