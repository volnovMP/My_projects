//---------------------------------------------------------------------------
#ifndef ServOutH
#define ServOutH

#define CONNECTING_STATE 0
#define READING_STATE 1
#define WRITING_STATE 2
#define BUFSIZE 28

//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
#include <WinNT.h>
#include "Common.H"
__declspec(delphiclass) class TServOut;
class TTrubaServOut;

#include "TrubaServOut.h"

//============================================= ����� ����� ��� ���������� �����
class PACKAGE TServOut : public TComponent
{
private:

  HANDLE FHandle;	//---------------------------------------------- ����� �����
  HANDLE __fastcall ReadHandle(void);

  int FTrubaNumber; //---------------------------------------------- ����� �����
  void __fastcall SetTrubaNumber(int n);//----------------- �������� ����� �����

  unsigned int FSost;     //------------------------------------ ��������� �����
  unsigned int __fastcall GetSost(void);
  void __fastcall SetSost(unsigned int sost);

protected:
  char* FTrubaName;
  TTrubaPacketEvent FOnReadPacket;
  void __fastcall DoOpenTruba(void); //------------------ ������� �������� �����
	void __fastcall DoCloseTruba(void); //----------------- ������� �������� �����
public:
  DWORD cbToWrite;
  TTrubaServOut *FTrubaServOut; //------------------------------- �������� �����
  __fastcall TServOut(TComponent *Owner); //------------------ ����������� �����
	__fastcall ~TServOut(void); //------------------------------- ���������� �����
	_RTL_CRITICAL_SECTION WriteSection; //------- ����������� ������ ������ ������
	void __fastcall Open(void);
  void __fastcall Close(void);
  void __fastcall Tell(const char *BUFER, int size);
  unsigned long Err_Srv;
	bool cikl_truba;
	__property unsigned int Sost = {read = GetSost,write = SetSost};
  __property  HANDLE Hndler={read = ReadHandle};
  __property char* TrubaName = {read=FTrubaName};
__published:
  __property int TrubaNumber={read=FTrubaNumber,write=SetTrubaNumber};
  __property TTrubaPacketEvent OnReadPacket={read=FOnReadPacket,write=FOnReadPacket};
};
//---------------------------------------------------------------------------
#endif
