
#property copyright "AlexanderS"
extern string Пapаметры=" Параметры советника";
extern int TP=10;
extern int SL=40;
extern double lot=0.01;
extern int Magic_Number=123;
extern double Otstup=2;
extern string Coments;


int k;
bool BuyStop;
bool SellStop;
double fu,fd;
bool buymarket;
bool sellmarket;
bool OpenBuy,OpenSell;
int init()
{
   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
   return(0);
}

int deinit()
{
   return(0);
}

int start()
{
 ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
ObjectSetText("label_object1","Нижняя граница фрактала= "+fd+" ;Верхняя граница фрактала="+fu,12,"Arial",Red);

BuyStop=false;SellStop=false;OpenBuy=true;OpenSell=true;
 for(int inn=0;inn<OrdersTotal();inn++)
     {      if(OrderSelect(inn,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number))
           {
         
           if((OrderType()==OP_BUYSTOP)&&(fu!=0)){BuyStop=true; if (OrderComment()!=fu){OpenNewBuystop();}}
            if((OrderType()==OP_SELLSTOP)&&(fd!=0)){SellStop=true;if (OrderComment()!=fd){Print(OrderOpenPrice(),(fd-Otstup*k*Point));OpenNewSellstop();}}
             if((OrderType()==OP_BUY)&&(OrderComment()==fu)){ OpenBuy=false;}
                 if((OrderType()==OP_SELL)&&(OrderComment()==fd)){ OpenSell=false;}
           }
        }
        }
//Установка TP и SL открытых ордеров
if ((buymarket==true)||(sellmarket==true)){
 for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
         
            if((OrderType()==OP_BUY)&&(buymarket==true)){OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL*k*Point,OrderOpenPrice()+TP*k*Point,0,Orange);buymarket=false; }
            if((OrderType()==OP_SELL)&&(sellmarket==true)){OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL*k*Point,OrderOpenPrice()-TP*k*Point,0,Orange);sellmarket=false;}
    
           }
        }
}
}
  
  if(!isNewBar())return(0);
 fu=0;fd=0;
   int f=0,shift=2;
   while(f<2)
   {
      if(iFractals(Symbol(),Period(),MODE_UPPER,shift)>0)
      {
         fu=iFractals(Symbol(),Period(),MODE_UPPER,shift);
         f=f+1;
      }
      if(iFractals(Symbol(),Period(),MODE_LOWER,shift)>0)
      {
         fd=iFractals(Symbol(),Period(),MODE_LOWER,shift);
         f=f+1;
      }
      shift=shift+1;
   }

   
   
  if ((BuyStop==false)&&(OpenBuy==true)){   if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,lot,fu+Otstup*k*Point,3*k,NULL,NULL,fu,Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError());
      
       }
       else {buymarket=true;}
       }  }
   
  if ((SellStop==false)&&(OpenSell==true)){    if(IsTradeAllowed()) 
        { if(OrderSend(Symbol(),OP_SELLSTOP,lot,fd-Otstup*k*Point,3*k,NULL,NULL,fd,Magic_Number,0,Red) < 0)
           {Alert("Ошибка открытия позиции № ",GetLastError());
           
            }
            else{sellmarket=true;}
            
        }}
  
   
   return(0);
  }
//+------------------------------------------------------------------+

double OpenNewBuystop()
{
  for(int iDel=OrdersTotal()-1; iDel>=0; iDel--)
        {
         if(!OrderSelect(iDel,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()>1)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
           }
        }
    
    
    if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,lot,fu+Otstup*k*Point,3*k,NULL,NULL,fu,Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()," Коммент ",Coments);Print("Открываемся с рынка");
      
       }
       else {buymarket=true;}
       }  
  
    return(0); }  


double OpenNewSellstop()
{
  for(int iDel=OrdersTotal()-1; iDel>=0; iDel--)
        {
         if(!OrderSelect(iDel,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()>1)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
           }
        }
    
    
   if(IsTradeAllowed()) 
        { if(OrderSend(Symbol(),OP_SELLSTOP,lot,fd-Otstup*k*Point,3*k,NULL,NULL,fd,Magic_Number,0,Red) < 0)
           {Alert("Ошибка открытия позиции № ",GetLastError()," Коммент",Coments);Print("Открываемся с рынка");
           
            }
            else{sellmarket=true;}
            
        }
    
    
       
    return(0); }  











bool isNewBar()
  {
  static datetime BarTime;  
   bool res=false;
    
   if (BarTime!=Time[0]) 
      {
         BarTime=Time[0];  
         res=true;
      } 
   return(res);
  }
  
//---- Возвращает количество ордеров указанного типа ордеров ----//

