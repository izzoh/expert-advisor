//https://www.forexcrunch.com/coding-your-first-expert-advisor-writing-the-code/
//https://www.mql5.com/en/articles/1510
//https://book.mql4.com/samples/expert
//https://www.youtube.com/watch?v=uggLLgRaONI

//+------------------------------------------------------------------+
//|                                                        izzoh.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#define SIGNAL_NONE 0;
#define SIGNAL_BUY 1;
#define SIGNAL_SELL 2;
#define SIGNAL_CLOSEBUY 3;
#define SIGNAL_CLOSESELL 4;



extern int MagicNumber = 12345;
extern int TargetProfitPips = 150;
extern int CyclePips = 10;
extern int RecoveryZone = 50;
extern double size = 0.01;
extern int Spillage = 3;
double buySizeTotal, sellSizeTotal;
int entry = SIGNAL_NONE;
int position = SIGNAL_NONE;
double MacdCurrent, MacdPrevious, SignalCurrent;
double SignalPrevious, MaCurrent, MaPrevious, hHeiken_Ashi;
extern double TakeProfit = 50;
extern double Lots = 0.1;
extern double TrailingStop = 30;
extern double MACDOpenLevel=3;
extern double MACDCloseLevel=2;
extern double MATrendPeriod=26;
int cnt, ticket, total;

int OnInit()
  {
//---
   MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   MacdPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   SignalCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   SignalPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   MaCurrent=iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,0);
   MaPrevious=iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,1);
   total=OrdersTotal();
   hHeiken_Ashi = iCustom(NULL,PERIOD_CURRENT, "Examples\\Heiken Ashi", 13,1,0);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//+------------------------------------------------------------------+
//| Entry conditions                                                 |
//+------------------------------------------------------------------+
 /**************** Long Positions ***********************************/
      if(MacdCurrent<0 && MacdCurrent>SignalCurrent && MacdPrevious<SignalPrevious &&
            MathAbs(MacdCurrent)>(MACDOpenLevel*Point) && MaCurrent>MaPrevious)
           {
            ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,Ask+TakeProfit*Point,"macd sample",16384,0,Green);
            if(ticket>0)
              {
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
              }
            else Print("Error opening BUY order : ",GetLastError());
            }
 /**************** Short Positions ***********************************/
      if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious && 
               MacdCurrent>(MACDOpenLevel*Point) && MaCurrent<MaPrevious)
              {
               ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit*Point,"macd sample",16384,0,Red);
               if(ticket>0)
                 {
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
                 }
               else Print("Error opening SELL order : ",GetLastError());
               }
             
  }
//+------------------------------------------------------------------+
