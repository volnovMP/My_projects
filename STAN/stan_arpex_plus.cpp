//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
USEFORM("Unit2.cpp", Tums1);
USEFORM("Unit3.cpp", Tums2);
USEFORM("Unit4.cpp", Flagi);
USEFORM("Unit6.cpp", Limit);
USEFORM("otladka.cpp", Otladka1);
USEFORM("ssk_srv_out.cpp", Stancia);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
	try
	{
		Application->Initialize();
//		SetApplicationMainFormOnTaskBar(Application, true);
		Application->CreateForm(__classid(TStancia), &Stancia);
		Application->CreateForm(__classid(TTums1), &Tums1);
		Application->CreateForm(__classid(TTums2), &Tums2);
		Application->CreateForm(__classid(TFlagi), &Flagi);
		Application->CreateForm(__classid(TLimit), &Limit);
		Application->CreateForm(__classid(TOtladka1), &Otladka1);

		Application->Run();
	}
	catch (Exception &exception)
	{
		Application->ShowException(&exception);
	}
	catch (...)
	{
		try
		{
			throw Exception("");
		}
		catch (Exception &exception)
		{
			Application->ShowException(&exception);
		}
	}
	return 0;
}
//---------------------------------------------------------------------------
