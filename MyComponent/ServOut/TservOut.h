//---------------------------------------------------------------------------

#ifndef TservOutH
#define TservOutH
//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
typedef void __fastcall(__closure *TTrubaPacketEvent)(char *Packet,int &Size,int &ErrC);

//��������������� ���������� ������ �����
__declspec(delphiclass) class TServOut;

  /*=============================================\
  |      ����� ������ ��� ������������ �����     |
  \=============================================*/
 class TTrubaServOut: public TThread
{
  friend class TServOut;
private:
  TServOut *FOwner;//������ ����� � ������
  unsigned char FInBuffer[28];  //������� �����
  unsigned char FOutBuffer[70]; //�������� �����
  unsigned long FCountOut; //������� ������
  unsigned long FCountIn; //������� ������
protected:
  bool fPending;
  void __fastcall Execute(void);//�������� ��������� ������
  void __fastcall DoReadPacket(void);//������������ �������-"���� �����"
  OVERLAPPED FRd; //����������� ��������� ������
  OVERLAPPED FWr; //����������� ��������� ������
public:
  __fastcall TTrubaServOut(TServOut *FOwner); //����������� ������
  __fastcall ~TTrubaServOut(void); //���������� ������
};
  /*==================================\
  |  ����� ����� ��� ���������� ����� |
  \==================================*/
class PACKAGE TServOut : public TComponent
{
  friend class TTrubaServOut;
private:
	void __fastcall SetSost(unsigned int sost);
protected:
  AnsiString FTrubaName;
  int FTrubaNumber;
  TTrubaPacketEvent FOnReadPacket; //������� "������ �����"
  HANDLE FHandle;   //���������� �����
  void __fastcall DoOpenTruba(void); //������� �������� �����
  void __fastcall DoCloseTruba(void); //������� �������� �����
private:
  AnsiString __fastcall GetTrubaName(void); //�������� ���
  void __fastcall SetTrubaNumber(const int Value);
  DWORD __fastcall ReadHandle(void);
public:
  __fastcall TServOut(TComponent *Owner); //����������� �����
  __fastcall ~TServOut(void);//���������� �����
  TTrubaServOut *FTrubaServOut; //�������� �����
  void __fastcall Open(void);
  void __fastcall Close(void);
  void __fastcall Tell(const char *BUFER);
  unsigned long Err_Srv;
	unsigned int FSost;     //��������� �����
	bool cikl_truba;
  __property unsigned int Sost = {read = FSost,write = SetSost};
  __property DWORD Hndler={read=ReadHandle};
__published:
  __property int TrubaNumber={read=FTrubaNumber,write=SetTrubaNumber};
  __property TTrubaPacketEvent OnReadPacket={read=FOnReadPacket,write=FOnReadPacket};
};
//---------------------------------------------------------------------------
#endif
