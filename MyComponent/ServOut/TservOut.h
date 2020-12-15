//---------------------------------------------------------------------------

#ifndef TservOutH
#define TservOutH
//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
typedef void __fastcall(__closure *TTrubaPacketEvent)(char *Packet,int &Size,int &ErrC);

//предварительное объ€вление класса трубы
__declspec(delphiclass) class TServOut;

  /*=============================================\
  |      класс потока дл€ обслуживани€ трубы     |
  \=============================================*/
 class TTrubaServOut: public TThread
{
  friend class TServOut;
private:
  TServOut *FOwner;//объект трубы в потоке
  unsigned char FInBuffer[28];  //входной буфер
  unsigned char FOutBuffer[70]; //выходной буфер
  unsigned long FCountOut; //счетчик вывода
  unsigned long FCountIn; //счетчик приема
protected:
  bool fPending;
  void __fastcall Execute(void);//основна€ процедура потока
  void __fastcall DoReadPacket(void);//формирование событи€-"есть пакет"
  OVERLAPPED FRd; //асинхронна€ структура чтени€
  OVERLAPPED FWr; //асинхронна€ структура записи
public:
  __fastcall TTrubaServOut(TServOut *FOwner); //конструктор потока
  __fastcall ~TTrubaServOut(void); //деструктор потока
};
  /*==================================\
  |  класс трубы дл€ серверного конца |
  \==================================*/
class PACKAGE TServOut : public TComponent
{
  friend class TTrubaServOut;
private:
	void __fastcall SetSost(unsigned int sost);
protected:
  AnsiString FTrubaName;
  int FTrubaNumber;
  TTrubaPacketEvent FOnReadPacket; //событие "пришел пакет"
  HANDLE FHandle;   //дескриптор трубы
  void __fastcall DoOpenTruba(void); //функци€ открыти€ трубы
  void __fastcall DoCloseTruba(void); //функци€ закрыти€ трубы
private:
  AnsiString __fastcall GetTrubaName(void); //получить им€
  void __fastcall SetTrubaNumber(const int Value);
  DWORD __fastcall ReadHandle(void);
public:
  __fastcall TServOut(TComponent *Owner); //конструктор трубы
  __fastcall ~TServOut(void);//деструктор трубы
  TTrubaServOut *FTrubaServOut; //читающий поток
  void __fastcall Open(void);
  void __fastcall Close(void);
  void __fastcall Tell(const char *BUFER);
  unsigned long Err_Srv;
	unsigned int FSost;     //состо€ние трубы
	bool cikl_truba;
  __property unsigned int Sost = {read = FSost,write = SetSost};
  __property DWORD Hndler={read=ReadHandle};
__published:
  __property int TrubaNumber={read=FTrubaNumber,write=SetTrubaNumber};
  __property TTrubaPacketEvent OnReadPacket={read=FOnReadPacket,write=FOnReadPacket};
};
//---------------------------------------------------------------------------
#endif
