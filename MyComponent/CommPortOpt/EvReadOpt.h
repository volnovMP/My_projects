#ifndef EvReadOptH
#define EvReadOptH
#include <Classes.hpp>
#include "CommPortOpt.h"
//---------------------------------------------------------------------------
class TReadEventThreadOpt : public TThread
{
private:
protected:
		TCommPortOpt *FComPortOpt;
		int __fastcall byla_com(unsigned char REG_[12]);
		void __fastcall DoOnReceived(void);

public:
		AnsiString Name;
		Byte REG[18]; //---------------- ������� ������ ��� ������ ���������� �� ����
    bool Soob_Kvit; //------------ ��������� ���� �������� ������ 1-��������� /0-���������
		__fastcall TReadEventThreadOpt(TCommPortOpt *ComPortOpt);
    void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
