//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
USEFORM("ssk_srv_rbox.cpp", Stancia);
USEFORM("otladka.cpp", Otladka1);
USEFORM("Unit1.cpp", VVOD_DAY);
USEFORM("Unit2.cpp", Tums1);
USEFORM("Unit3.cpp", Tums2);
USEFORM("Unit4.cpp", Flagi);
USEFORM("Unit6.cpp", Limit);
//---------------------------------------------------------------------------
const char *NamedMutex = "OneOnly"; //-------------------------------- именованный мьютекс
//---------------------------------------------------------------------------
HANDLE CheckInstance(const char *Name)//------------ создание мьютекса с запросом владени€
{
	HANDLE Mutex = CreateMutex(NULL,true,Name);
	int er = GetLastError();
	if (er) return 0;
	return Mutex;
}

WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
	HANDLE Mutex = CheckInstance(NamedMutex);
	if(!Mutex)
	{
		ShowMessage("ƒругой экземпл€р этой программы в работе!");
		ReleaseMutex(Mutex);
		return 1;
	}

	try
	{
		Application->Initialize();
		Application->Title = "STAN";
		Application->CreateForm(__classid(TStancia), &Stancia);
		Application->CreateForm(__classid(TOtladka1), &Otladka1);
		Application->CreateForm(__classid(TTums1), &Tums1);
		Application->CreateForm(__classid(TTums2), &Tums2);
		Application->CreateForm(__classid(TFlagi), &Flagi);
		Application->CreateForm(__classid(TLimit), &Limit);
		Application->CreateForm(__classid(TVVOD_DAY), &VVOD_DAY);
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
	CloseHandle(Mutex);
}
//---------------------------------------------------------------------------
