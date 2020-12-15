unit Marshrut;
{$INCLUDE d:\Sapr2012\CfgProject}
//------------------------------------------------------------------------------
//             ��������� � ��������� ��������� ��������� ��-���
//------------------------------------------------------------------------------

interface

uses
  Windows,
  SysUtils,
  TypeAll;
var

  MarhRdy      : Boolean; //----------------- ������� ���������� �������� � ������ � �����
  LastMsgToDSP : string;
  LastJmp : TOZNeighbour;

function ResetTrace : Boolean;
function ResetMarhrutSrv(fr : word) : Boolean;
function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
function EndTracertMarshrut : Boolean;
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorOtkrytSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorMarsh(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function GetSoglOtmeny(Uslovie : SmallInt) : string;

{$IFDEF RMDSP}
function OtmenaMarshruta(Svetofor : SmallInt; Marh : Byte) : Boolean;
{$ENDIF}

function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
function SetProgramZamykanie(Group : Byte; Auto : Boolean) : Boolean;
function SendMarshrutCommand(Group : Byte) : Boolean;
function SendTraceCommand(Group : Byte) : Boolean;
function RestorePrevTrace : Boolean;
{$IFNDEF RMARC}
function AddToTracertMarshrut(index : SmallInt) : Boolean;
function NextToTracertMarshrut(index : SmallInt) : Boolean;
{$ENDIF}
function StepTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte) : TTracertResult;

//------------------------------------------------------ ������� ����������� ����� �������
function StepTraceStrelka(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

function StepStrelFindTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelContTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelZavTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelCheckTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelZamykTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelPovtorRazdel(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelFindIzvStrel(var Con :TOZNeighbour; const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

//---------------------------------------------------- ������� ����������� ����� �� ��� ��
function StepTraceSP(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

function StepSPforFindTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPforContTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPforZavTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPforCheckTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPforZamykTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPPovtorRazdel(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPFindIzvStrel(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;


//--------------------------------------------------------- ������� ����������� ����� ����
function StepTracePut(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

function StepPutFindTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutContTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutZavTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutCheckTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutZamykTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutFindIzvStrel(var Con :TOZNeighbour; const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;


//---------------------------------------------------- ������� ����������� ����� ���������
function StepTraceSvetofor(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

function StepSvetoforFindTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod:Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSvetoforContTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSvetoforZavTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSvetoforCheckTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSvetoforZamykTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigAutoPovtorRazdel(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigFindIzvStrel(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;


function StepTraceAB(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTracePriglas(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceUKSPS(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceVSN(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceUvazManRn(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceZaprosPoezdOtpr(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTracePAB(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceDZOhr(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceIzvPer(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceDZSP(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTracePoezdSogl(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceUvazGor(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceMarNadvig(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceMarshOtpr(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTracePerezamStrInPut(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceOPI(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceZonaOpov(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceProchee(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function SoglasieOG(Index : SmallInt) : Boolean;
function CheckOgrad(ptr : SmallInt; Group : Byte) : Boolean;
function CheckOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
function NegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
function SignCircOgrad(ptr : SmallInt; Group : Byte) : Boolean;
function SignCircOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
function SigCircNegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
function VytajkaRM(ptr : SmallInt) : Boolean;
function VytajkaZM(ptr : SmallInt) : Boolean;
function VytajkaOZM(ptr : SmallInt) : Boolean;
function VytajkaCOT(ptr : SmallInt) : string;
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
procedure SetNadvigParam(Ptr : SmallInt);
function AutoMarsh(Ptr : SmallInt; mode : Boolean) : Boolean;
function CheckAutoMarsh(Ptr : SmallInt; Group : Byte) : Boolean;
function AutoMarshReset(Ptr : SmallInt) : Boolean;
function AutoMarshON(Ptr : SmallInt; Napr : Boolean) : Boolean;
function AutoMarshOFF(Ptr : SmallInt; Napr : Boolean  ) : Boolean;

const
  MarshM = 3;   //----------------------------------------------------- ���������� �������
  MarshP = 12;  //------------------------------------------------------- �������� �������
  MarshL = 19;  //--------------------------------------------------- ���������� ���������


  TryMarhLimit = 6962;//----------------------- ������� �������� ��� ����������� ��������.
                      //----------------  ���-�� ��������� �������� �������� ��� ��������,
                      //-------- �� ��������� 231 ("�������� ������� ������� �����������")

implementation

uses
  Commands,
  CMenu,
  MainLoop,

{$IFDEF RMDSP}
  TabloForm,
{$ENDIF}

{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}

{$IFDEF RMSHN}
  TabloSHN,
{$ENDIF}

{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}
  Commons;

var
  tm : string;

//========================================================================================
function ResetTrace : Boolean;
//----------------------------------------------------- �������� ��������� ������ ��������
var
  i,k,o : integer;
begin
try
  WorkMode.GoTracert        :=false; //-------------- �������� ������� "���� �����������"
  MarhTracert[1].SvetBrdr   :=0;//����� ������� ���������,���������. ������������ �������
  MarhTracert[1].AutoMarh   :=false;//����� �������� �������.�������� ������������ �������
  MarhTracert[1].Povtor     :=false;//����� �������� ��������� �������� ������ ��������
                                    //  (��� ������ �������� ���������. ��������� �� ����)
  MarhTracert[1].GonkaStrel :=false;//--- ����� �������� ������������ ������ ������� �����
                                    //  ������� (��� ������ �������� ��� ��������� ������)
  MarhTracert[1].GonkaList  :=0; //------------����� ���������� ������� ��� ������ �������
                                 // ����� ������� ��� ������ �������� ��� ��������� ������
  Marhtracert[1].LockPovtor :=false;//����� �������� ���������� ������ ��������� ���������
                                    //            �������� ����� ����������� �������������
  MarhTracert[1].Finish     :=false; //---- �������� ���������� ������ ������ ����� ������
  MarhTracert[1].TailMsg    := '';  //--------------- �������� ��������� � ������ ��������
  MarhTracert[1].FindTail   := false;//---------- �������� ������� ������ ������ ���������
                                     //                            � ����� ������ ��������
  MarhTracert[1].WarCount   := 0; //�������� ������� �������������� ��� ��������� ��������
  MarhTracert[1].MsgCount   := 0; //--------------- �������� ������� ��������� �����������
  k := 0;
  MarhTracert[1].VP         := 0; //--- �������� ������ �� ��� ����������� �������� ������
  MarhTracert[1].TraceRazdel := false;//����� �������� ����������� � ���������� ����������
  if MarhTracert[1].ObjStart > 0 then //----------------- ���� ���� ������ ������ ��������
  begin //------------------------------------------------ ����� �������� ��� �� ���������
    k := MarhTracert[1].ObjStart;
    if not ObjZav[k].bParam[14] then
    begin
      ObjZav[k].bParam[7] := false; //----------------------- ����� ���������� �����������
      ObjZav[k].bParam[9] := false; //------------------------- ����� �������� �����������
    end;
  end;
  MarhTracert[1].ObjStart := 0;
  for i := 1 to WorkMode.LimitObjZav do
  begin // ������ ��������� ����������� �� ���� �������� �������
    case ObjZav[i].TypeObj of

      1 : begin // ����� �������
        ObjZav[i].bParam[27] := false;
        ObjZav[i].iParam[3] := 0;
      end;

      2 : begin // �������
        ObjZav[i].bParam[10] := false;
        ObjZav[i].bParam[11] := false;
        ObjZav[i].bParam[12] := false;
        ObjZav[i].bParam[13] := false;
      end;

      3 : begin // ������
        if not ObjZav[i].bParam[14] then
        begin
          ObjZav[i].bParam[8] := true;
        end;
      end;

      4 : begin // ����
        if not ObjZav[i].bParam[14] then
        begin
          ObjZav[i].bParam[8] := true;
        end;
      end;

      5 : begin // ��������
        if not ObjZav[i].bParam[14] and // ��� ���������������� ���������
           ObjZav[i].bParam[11] then    // ��� ��������������� ���������
        begin
          ObjZav[i].bParam[7] := false;
          ObjZav[i].bParam[9] := false;
        end;
      end;

      8 : begin // ���
        ObjZav[i].bParam[27] := false;
      end;

      15 : begin // ��
        if not ObjZav[i].bParam[14] and // ��� ���������������� ���������
           ObjZav[ObjZav[i].BaseObject].bParam[2] then // ��� ��������������� ���������
        begin
          ObjZav[i].bParam[15] := false;
        end;
      end;

      25 : begin // �������
        if not ObjZav[i].bParam[14] then // ��� ���������������� ���������
        begin
          ObjZav[i].bParam[8] := false;
        end;
      end;

      41 : begin // �������� �������� �����������
        o := ObjZav[i].UpdateObject;
        if not ObjZav[o].bParam[14] and ObjZav[o].bParam[2] and // ��� ���������������� ��� ��������������� ���������
           not ObjZav[ObjZav[i].BaseObject].bParam[3] and not ObjZav[ObjZav[i].BaseObject].bParam[4] then // �������� ������ �� ������ ��������
        begin
          ObjZav[i].bParam[20] := false;
          ObjZav[i].bParam[21] := false;
        end;
      end;

      42 :
      begin //-------------------------------------- ������������� ��������� �� ����������
        o := ObjZav[i].UpdateObject;      //------------------------ �������������� ������
        if not ObjZav[o].bParam[14] and //------- ���� ��� ������������ ��������� ������ �
        ObjZav[o].bParam[2] then //------------------------------- ��� ��������� ���������
        begin
          ObjZav[i].bParam[1] := false;  //------  ������� ��������� �������� ������ �����
          ObjZav[i].bParam[2] := false; //--------- ������� ���������� ������������� �����
        end;
      end;
    end;
  end;

  //--------------------------------------------------------------- �������� ��� ���������
  for i := 1 to High(MarhTracert[1].Msg) do
  begin
    MarhTracert[1].Msg[i] := '';
    MarhTracert[1].MsgIndex[i] := 0;
    MarhTracert[1].MsgObject[i] := 0;
  end;
  MarhTracert[1].MsgCount := 0;
  //---------------------------------------------------------- �������� ��� ��������������
  for i := 1 to High(MarhTracert[1].Warning) do
  begin
    MarhTracert[1].Warning[i]  := '';
    MarhTracert[1].WarIndex[i] := 0;
    MarhTracert[1].WarObject[i] := 0;
  end;
  MarhTracert[1].WarCount := 0;

  //------------------------------------------------------------ �������� ��� ����� ������
  for i := 1 to High(MarhTracert[1].ObjTrace) do MarhTracert[1].ObjTrace[i] := 0;
  MarhTracert[1].Counter := 0;

  //---------------------------------------------------------- �������� ��� ������� ������
  for i := 1 to High(MarhTracert[1].StrTrace) do
  begin
    MarhTracert[1].StrTrace[i] := 0;
    MarhTracert[1].PolTrace[i,1] := false;
    MarhTracert[1].PolTrace[i,2] := false;
  end;
  MarhTracert[1].StrCount := 0;

  MarhTracert[1].ObjEnd := 0;
  MarhTracert[1].ObjLast := 0;
  MarhTracert[1].ObjStart := 0;

  MarhTracert[1].PinLast := 0;
  MarhTracert[1].Rod := 0;

  WorkMode.GoTracert := false;

  if (k > 0) and not ObjZav[k].bParam[14] then
  begin
    InsArcNewMsg(k,2,1);
    ShowShortMsg(2,LastX,LastY,'�� '+ ObjZav[k].Liter);
  end;
  ResetTrace := true;
  ZeroMemory(@MarhTracert[1],sizeof(MarhTracert[1]));
except
  reportf('������ [Marshrut.ResetTrace]'); ResetTrace := false;
end;
end;
//========================================================================================
function ResetMarhrutSrv(fr : word) : Boolean;
//---------------------------------------------------- ������� �� ����� �������� � �������
var
  i,im : integer;
begin
try
  im := 0;
  // ����� ������� �������� �� ������ FR3
  for i := 1 to WorkMode.LimitObjZav do
    if ObjZav[i].TypeObj = 5 then
    begin
      if ObjZav[i].ObjConstI[3] > 0 then
        if fr = (ObjZav[i].ObjConstI[3] div 8) then begin im := i; break; end;
      if ObjZav[i].ObjConstI[5] > 0 then
        if fr = (ObjZav[i].ObjConstI[5] div 8) then begin im := i; break; end;
    end;
  if im > 0 then
  begin // ���������� ������� ������ �������� �� ������� ��� ���� ���������� ������� ��������
    for i := 1 to WorkMode.LimitObjZav do
      if ObjZav[i].TypeObj = 5 then
        if ObjZav[i].iParam[1] = im then ObjZav[i].bParam[34] := true; // ���������� �� ��������� � ��������� ��������
    if ObjZav[im].RU = config.ru then
    begin // ������� ��������� � ������������ ��������
      MsgStateRM := GetShortMsg(2,7,ObjZav[im].Liter,1);
      MsgStateClr := 1;
    end;
    InsArcNewMsg(im,7+$400,1);
    ResetMarhrutSrv := true;
  end else
  begin // ������ �������� �� ���������
    ResetMarhrutSrv := false;
  end;
except
  reportf('������ [Marshrut.ResetMarhrutSrv]'); ResetMarhrutSrv := false;
end;
end;
//========================================================================================
procedure InsWar(Group,Obj,Index : SmallInt);
//---------------------------------------------------------- �������� ����� ��������������
begin
  MarhTracert[Group].WarObject[MarhTracert[Group].WarCount] := Obj;
  MarhTracert[Group].WarIndex[MarhTracert[Group].WarCount] := Index;
end;
//========================================================================================
procedure InsMsg(Group,Obj,Index : SmallInt);
//----------------------------------------------------- �������� ������������ ������������
begin
  MarhTracert[Group].MsgObject[MarhTracert[Group].MsgCount] := Obj;
  MarhTracert[Group].MsgIndex[MarhTracert[Group].MsgCount] := Index;
end;
//========================================================================================
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
//------------------------------------------ ������� ������ � ���������� ������ ����������
var
  i : Integer;
  jmp : TOZNeighbour;
begin
try
  ResetTrace;
  if Marh = MarshM then
  begin
    ObjZav[Svetofor].bParam[7] := true;
    ObjZav[Svetofor].bParam[9] := false;
  end else
  begin
    ObjZav[Svetofor].bParam[7] := false;
    ObjZav[Svetofor].bParam[9] := true;
  end;

  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Rod := Marh;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].WarCount := 0;
  MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].ObjStart := Svetofor;

  // ��������� ������������ �� ���� ������
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[2];

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  MarhTracert[Group].Level := tlRazdelSign; //---------- ����� ������� ������ � ����������
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  MarhTracert[Group].FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of

      trStop, trEnd : break;

      trEndTrace : break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // ������ �������� ���������
    result := false;
    InsArcNewMsg(Svetofor,228,1);
    ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter);
    Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  //--------------------------------------------------------- ����� �� ������������
    MarhTracert[1].TraceRazdel := true;//---- ��������� ����������� ���� ���� ������������
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]);
    result := false;
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  // ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
  if FindIzvStrelki (Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount);
    MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
    GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter,1); //
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTracert[Group].WarCount > 0 then
  begin //---------------------------------------------------------------- ����� ���������

    CreateDspMenu(CmdMarsh_Razdel,LastX,LastY);
    result := false;
    exit;
  end;
{$ENDIF}
  result := true;
except
  reportf('������ [Marshrut.OtkrytRazdel]'); result := false;
end;
end;

//========================================================================================
function CheckAutoMarsh(Ptr : SmallInt; Group : Byte) : Boolean;
//-------------------- �������� ����������� ������ ������� ��������� �������� ������������
//-------------------------------- Ptr - ������ ������������ ��� ��������� � �������������
//--------------------------------------------------------------------- Group - ������ ���
var
  i : Integer;
  jmp : TOZNeighbour;
  tr : boolean;
begin
  try
    result := false;
    //------------------------- ��������� ������� ������������������ �������� ������������
    if ObjZav[Ptr].bParam[2] then   //---------------------- ���� ��������������� ��������
    begin
      //----------------------------------------- ������� ���������� �������� ������������
      MarhTracert[Group].Rod := MarshP;
      MarhTracert[Group].Finish := false;
      MarhTracert[Group].WarCount := 0;
      MarhTracert[Group].MsgCount := 0;
      MarhTracert[Group].ObjStart := ObjZav[Ptr].BaseObject; //-- �������� � �������������
      MarhTracert[Group].Counter := 0;

      //- ������ ������� �������� ������� ������������ � ���� ����������� �������� �������
      i := 1000;
      jmp := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2]; //- ����� ��������� �� ������� 2
      MarhTracert[Group].FindTail := true;
      //--------------------------------- ��������� ��������� ����������� ������ ���������
      if ObjZav[ObjZav[ObjZav[Ptr].BaseObject].BaseObject].bParam[2] then //���� ����� "�"
      begin
        //------- ����� ������� ������� ����������� ������ ��� ���������� ��������� ������
        ObjZav[Ptr].bParam[3] := false; //- ����� �������� ����.������� �� �������� �����.
        ObjZav[Ptr].bParam[4] := false;// ����� �������� ����.������� ��� �������� �������
        ObjZav[Ptr].bParam[5] := false;  //- ����� �������� ����.������ �����.� ����������
        tr := true;
      end else
      begin
        //----- ��������� ������� ����������� ������ ����� ��������� �������� ������������
        tr := false;
        if ObjZav[Ptr].bParam[3] then
        begin //------------ ������������� ������� ����������� ������ � ��������� ��������
          if not ObjZav[Ptr].bParam[4] then
          begin
            if not ObjZav[Ptr].bParam[5] then
            begin
              InsArcNewMsg(ObjZav[Ptr].BaseObject,475,1);//������  �� ������ �������� ����
              AddFixMessage(GetShortMsg(1,475,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),4,5);
              ObjZav[Ptr].bParam[5] := true;
            end;
          end;
          MarhTracert[Group].ObjStart := 0;
          exit;
        end else
        if ObjZav[ObjZav[ObjZav[Ptr].BaseObject].BaseObject].bParam[1] then
        begin //---------------------------------------------------------- ������ ��������

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTracert[Group].Level := tlSignalCirc;  //----------- ����� ���������� ������
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        end else
        begin
          ObjZav[Ptr].bParam[3] := true; //--------- ����������� ������� ������ � ��������
          if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
          //-------- �������� ��������� ��������� ������� �� ������ ������� ����������� ��
          ObjZav[Ptr].bParam[4] := true;
          MarhTracert[Group].ObjStart := 0;
          exit;
        end;
      end;

      if tr then
      begin // ������� ������� �������� ��� ������������ �� ���� "�" �������� ������������

        if ObjZav[ObjZav[Ptr].BaseObject].bParam[9] or  //������� �������� ����������� ���
        ObjZav[ObjZav[Ptr].BaseObject].bParam[14] then //-- ������� ������������ ���������

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[Group].Level := tlPovtorRazdel //- ����� ������ �������� �� ����������
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        else

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[Group].Level := tlRazdelSign;//----- ����� ������� ������ � ����������
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      end;

      MarhTracert[Group].AutoMarh := true;
      MarhTracert[Group].SvetBrdr := ObjZav[Ptr].BaseObject;
      ObjZav[ObjZav[Ptr].BaseObject].bParam[9] := true;
      while i > 0 do
      begin
        case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
          trStop, trEnd, trEndTrace :  break;
        end;
        dec(i);
      end;

      if i < 1 then exit; //------------------------------------ ������ �������� ���������

      if MarhTracert[Group].MsgCount > 0 then
      begin
        MarhTracert[Group].ObjStart := 0;
        exit; //---------------------------------------------------- ����� �� ������������
      end;
      result := true;
    end else
    begin //------------------ ��������� ������������ �� ���� ������ �������� ������������
      ObjZav[ObjZav[Ptr].BaseObject].bParam[7] := false; //-- ����� ���������� �����������
      ObjZav[ObjZav[Ptr].BaseObject].bParam[9] := false; //---- ����� �������� �����������
      MarhTracert[Group].Rod := MarshP;
      MarhTracert[Group].Finish := false;
      MarhTracert[Group].WarCount := 0;
      MarhTracert[Group].MsgCount := 0;
      MarhTracert[Group].ObjStart := ObjZav[Ptr].BaseObject;
      MarhTracert[Group].Counter := 0;
      i := 1000;
      jmp := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2];

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      MarhTracert[Group].Level := tlAutoTrace; //--- �����  ������� ������ � �����. �����.
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      MarhTracert[Group].FindTail := true;
      while i > 0 do
      begin
        case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
          trStop, trEnd, trEndTrace : break;
        end;
        dec(i);
      end;

      if i < 1 then exit; //------------------------------------ ������ �������� ���������
      if MarhTracert[Group].MsgCount > 0 then
      begin
{
        if not ObjZav[Ptr].bParam[4] then
        begin
          AddFixMessage(GetShortMsg(1,475,ObjZav[ObjZav[Ptr].BaseObject].Liter),4,5);
        end;
}
        MarhTracert[Group].ObjStart := 0;
        MarhTracert[Group].MsgCount := 0;
        exit; //---------------------------------------------------- ����� �� ������������
      end;
      //--------------------------------------------------------- �������� ������� ����� ?
      case ObjZav[ObjZav[Ptr].UpdateObject].TypeObj of
        4 :
        begin //--------------------------------------------------------------------- ����
          if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] or
          not ObjZav[ObjZav[Ptr].UpdateObject].bParam[16] then
          begin
            MarhTracert[Group].ObjStart := 0;
            exit;
          end;
        end;

        15 :
        begin //----------------------------------------------------------------------- ��
          if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[2] then
          begin
            MarhTracert[Group].ObjStart := 0;
            exit;
          end;
        end;

        else //--------------------------------------------------------------------- ��,��
          if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] then
          begin
            MarhTracert[Group].ObjStart := 0;
            exit;
          end;
      end;

      ObjZav[Ptr].bParam[2] := true;
    end;
  except
    reportf('������ [Marshrut.CheckAutoMarsh]'); result := false;
  end;
end;
//========================================================================================
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
//----------------------------------------- ������� �������� ���������� �������� ���������
var
  i : Integer;
  jmp : TOZNeighbour;
begin
  try
    ResetTrace;
    MarhTracert[Group].SvetBrdr := Svetofor;
    MarhTracert[Group].Finish := false;
    MarhTracert[Group].Rod := Marh;
    MarhTracert[Group].TailMsg := '';
    MarhTracert[Group].WarCount := 0;
    MarhTracert[Group].MsgCount := 0;
    MarhTracert[Group].ObjStart := Svetofor;
    //---------------------------------------------- ��������� ������������ �� ���� ������
    i := 1000;
    jmp := ObjZav[Svetofor].Neighbour[2];
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[Group].Level := tlSignalCirc;  //----------------- ����� ���������� ������
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTracert[Group].FindTail := true;
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
        trStop, trEnd :  break;
        trEndTrace :  break;
      end;
      dec(i);
    end;

    if i < 1 then
    begin //---------------------------------------------------- ������ �������� ���������
      InsArcNewMsg(Svetofor,228,1); //---------------------- ������ �������� �� $ ��������
      result := false;
      ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter);
      Marhtracert[Group].LockPovtor := true;
      MarhTracert[Group].ObjStart := 0;
      exit;
    end;

    if MarhTracert[Group].MsgCount > 0 then
    begin  //------------------------------------------------------- ����� �� ������������
    // ��������� ����������� � �������� ������ ���� ���� ������������
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]);
    result := false;
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;
  //-------- ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount);
    MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
    GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTracert[Group].WarCount > 0 then
  begin //---------------------------------------------------------------- ����� ���������
    CreateDspMenu(CmdMarsh_Povtor,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;
{$ENDIF}  
  result := true;
except
  reportf('������ [Marshrut.PovtorSvetofora]'); result := false;
end;
end;
//========================================================================================
function PovtorOtkrytSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
//�������� ���������� �������� ������� (� ����������) �� ���������������� ��������� ������
var
  i : Integer;
  jmp : TOZNeighbour;
begin
try
  ResetTrace;
  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].Rod := Marh;
  MarhTracert[Group].TailMsg := '';
  MarhTracert[Group].WarCount := 0;
  MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].ObjStart := Svetofor;
  //------------------------------------------------ ��������� ������������ �� ���� ������
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[2];

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  MarhTracert[Group].Level := tlPovtorRazdel;  //----- ����� ������ �������� �� ����������
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  MarhTracert[Group].FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of

      trStop, trEnd :
        break;

      trEndTrace :
        break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // ������ �������� ���������
    InsArcNewMsg(Svetofor,228,1);
    result := false;
    ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter);
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  //--------------------------------------------------------- ����� �� ������������
    //--------------------- ��������� ����������� � �������� ������ ���� ���� ������������
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]);
    result := false;
    Marhtracert[Group].LockPovtor := true;
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  //-------- ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount);
    MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
    GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
  
{$IFNDEF RMARC}
  if MarhTracert[Group].WarCount > 0 then
  begin //---------------------------------------------------------------- ����� ���������
    CreateDspMenu(CmdMarsh_PovtorOtkryt,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;
{$ENDIF}
  result := true;
except
  reportf('������ [Marshrut.PovtorOtkrytSvetofora]');
  result := false;
end;
end;
//========================================================================================
function PovtorMarsh(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
//-------------------------------------------------- ��������� ��������� �������� ��������
var
  i,j : Integer;
  jmp : TOZNeighbour;
begin
  try
    ResetTrace;
    MarhTracert[Group].SvetBrdr := Svetofor;
    MarhTracert[Group].Finish := false;
    MarhTracert[Group].Rod := Marh;
    MarhTracert[Group].TailMsg := '';
    MarhTracert[Group].WarCount := 0; MarhTracert[Group].MsgCount := 0;
    MarhTracert[Group].ObjStart := Svetofor;
    //---------------------------------------------- ��������� ������������ �� ���� ������
    i := 1000;
    jmp := ObjZav[Svetofor].Neighbour[2];

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[Group].Level := tlPovtorMarh; //------- ����� ��������� ��������� ��������
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTracert[Group].FindTail := true;

    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
        trStop, trEnd : break;
        trEndTrace : break;
      end;
      dec(i);
    end;

    if i < 1 then
    begin //---------------------------------------------------- ������ �������� ���������
      InsArcNewMsg(Svetofor,228,1); //-------------------- "������ �������� �� $ ��������"
      result := false;
      ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter);
      Marhtracert[Group].LockPovtor := true;
      MarhTracert[Group].ObjStart := 0;
      exit;
    end;

    if MarhTracert[Group].MsgCount > 0 then
    begin  //------------------------------------------------------- ����� �� ������������
      //------------------- ��������� ����������� � �������� ������ ���� ���� ������������
      InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
      PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]);
      result := false;
      Marhtracert[Group].LockPovtor := true;
      MarhTracert[Group].ObjStart := 0;
      exit;
    end;

    //---------------------------------------------- ��������� ������������ �� ���� ������
    i := 1000;
    MarhTracert[Group].SvetBrdr := Svetofor;
    MarhTracert[Group].Povtor := true;
    MarhTracert[Group].MsgCount := 0;
    //----------- "�������" ������������ ������, ������������� ������ �� �������� ��������
    MarhTracert[Group].HTail := MarhTracert[Group].ObjTrace[1];
    jmp := ObjZav[MarhTracert[Group].ObjStart].Neighbour[2];

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[Group].Level := tlCheckTrace;//---- ����� �������� ������������� �� ������ 
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    if MarhTracert[Group].ObjEnd < 1 then
    begin
        j := MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter];
        MarhTracert[Group].ObjEnd := j;
    end
    else  j := MarhTracert[Group].ObjEnd;

    while MarhTracert[Group].ObjEnd < 1 do
    begin
      j := MarhTracert[Group].ObjTrace[j];
      MarhTracert[Group].ObjEnd := j;
      dec(j);
    end;


    MarhTracert[Group].CIndex := 1;
    while i > 0 do
    begin
      if jmp.Obj = j then
      begin // ��������� ������ ����� ������
        // ������������ � ������
      StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);
      break;
    end;

    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
      trStop : begin
        break;
      end;
    end;
    dec(i);
    inc(MarhTracert[Group].CIndex);
  end;

  if i < 1 then
  begin // ����� �� ���������� ��������
    InsArcNewMsg(Svetofor,231,1);
    RestorePrevTrace; result := false;
    ShowShortMsg(231, LastX, LastY, '');
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  //--------------------------------------------------------- ����� �� ������������
    //--------------------- ��������� ����������� � �������� ������ ���� ���� ������������
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[Group]);
    result := false;
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  //-------- ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount);
    MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
    GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTracert[Group].WarCount > 0 then
  begin //---------------------------------------------------------------- ����� ���������
    CreateDspMenu(CmdMarsh_PovtorMarh,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    exit;
  end;
{$ENDIF}
  result := true;
except
  reportf('������ [Marshrut.PovtorMarsh]'); result := false;
end;
end;
//========================================================================================
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
// ��������� �������������� ������� �� ���������� ������ �� ����������� �������� (��� ���)
//--------------------------------- Svetofor - ������ ������������ ������� ������ ��������
//------------------------------------------ Marh - ��� �������� (�������� ��� ����������)
//---------------------- ����������  ������� ����������� ������� &  ������� ������� ������
var
  i : integer;
  jmp : TOZNeighbour;
begin
  try
    result := false;
    if Svetofor < 1 then exit;
    i := 1000; //--------------------------------------- ���������� ���������� ����� �����
    MarhTracert[1].IzvStrNZ := false;//- ����� ������� ����������� ������� ����� ���������
    MarhTracert[1].IzvStrFUZ := false; // ����� �������� ��������� ������� ������ ��������
    MarhTracert[1].IzvStrUZ := false;//����� �������� ������� ������� ������ �� ���������.

    MarhTracert[1].ObjStart := Svetofor; //----- �������� �������� �� ������������ �������

    jmp := ObjZav[Svetofor].Neighbour[1]; //------------------------- ����� ����� ��������

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[1].Level := tlFindIzvStrel;//-- ����� "�������� ������. ��������. �������"
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    while i > 0 do //--------------------------------------------- ��������� ���� ��������
    begin
      //------------------------------------------------ ������������� �� ����������� ����
      case StepTrace(jmp, MarhTracert[1].Level, MarhTracert[1].Rod, 1) of
        trStop, //----- ��������� ���� = ����� ����������� ��-�� ����������� �������������
        trEnd,  //-------------------------------------- ��� - ����� ����������� ���������
        trBreak : //-------------------------- ��� - ������������� ����������� �� ��������
        begin
          //------------ ��������� = ������� ����������� ������� �  ������� ������� ������
          result := MarhTracert[1].IzvStrNZ and MarhTracert[1].IzvStrUZ;
          if result then //----------------------------------------- ���� ���� �� � ������
          begin //-------------------------------------------------- ������ ��������������
            SingleBeep := true;
{$IFNDEF TABLO}
            TimeLockCmdDsp := LastTime;
{$ENDIF}
            LockCommandDsp := true;
            ShowWarning := true;
          end;
          break;
        end;
      end;
      dec(i);
    end;
  except
    reportf('������ [Marshrut.FindIzvStrelki]'); result := false;
  end;
end;
//========================================================================================
function GetSoglOtmeny(Uslovie : SmallInt) : string;
//------------------------------------------ ��������� �������� ���������� ������ ��������
begin
  try
    result := '';
    if Uslovie > 0 then
    begin //-------------------------------------- ��������� ���������� �� ������ ��������
      case ObjZav[Uslovie].TypeObj of //---------------------------- ���� ������� ���� ...
        30 :
        begin //------------------------------------------- ���� �������� ��������� ������
          if ObjZav[Uslovie].bParam[2] then  //--- ���� "�"
          //------------------------------------- ������� ������� �� (��������� ������)...
          result := GetShortMsg(1,254,ObjZav[ObjZav[Uslovie].BaseObject].Liter,1);
        end;

      33 :
      begin //---------------------------------------------------------- ���������� ������
        if ObjZav[Uslovie].ObjConstB[1] then  //-------------------- ���� ������ ���������
        begin
          if ObjZav[Uslovie].bParam[1] then   //------------------- ���� ������ ����������
          result := MsgList[ObjZav[Uslovie].ObjConstI[3]]; //------ �������� �� ����������
        end else
        begin
          if ObjZav[Uslovie].bParam[1] then
          result := MsgList[ObjZav[Uslovie].ObjConstI[2]]; //-------- �������� � ���������
        end;
      end;

      38 :
      begin //------------------------------------------------------------ ������� �������
        if ObjZav[Uslovie].bParam[1] then    //-------------------------------- ���� � ???
        //----------------------------------------------- ���������� ������� ������� � ...
        result := GetShortMsg(1,346,ObjZav[ObjZav[Uslovie].BaseObject].Liter,1);
      end;
    end;
  end;
  except
    reportf('������ [Marshrut.GetSoglOtmeny]'); result := '';
  end;
end;
//========================================================================================
function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
//------------------------ �������� ��������� ����������� ��� ������ �������� (������ ���)
//-------------------------------------  Svetofor - ������ ���������t; Marh - ��� ��������

var
  i : integer;
  jmp : TOZNeighbour;
begin
  try
    result := 0;
    if Svetofor < 1 then exit; //------------------------------ �� ������ �������� - �����
    MarhTracert[1].Rod := Marh;
    case Marh of
      MarshP :  //------------------------------------------------------- �������� �������
      begin
        //------------------------------------------ ��������� ����� ��������� �����������
        if ObjZav[Svetofor].ObjConstI[27] > 0 then //------ ���� ���� �������� �����������
        begin
          if ObjZav[ObjZav[Svetofor].ObjConstI[27]].bParam[1] then//���� ����������� �����
          begin result := 1; exit; end;//--------- ����� �� �������������� ������� - �����
        end;
        //---------------------------------------------- ������ �� ��������������� �������
        if ObjZav[Svetofor].ObjConstB[19] //---- ���� �������������� �������� ��� ��������
        then MarhTracert[1].IzvCount := 0   //----------------------- �� ����-�������� ���
        else MarhTracert[1].IzvCount := 1; //------ ���� �� ��������, �� ����-������� ����
      end;

      MarshM : //------------------------------------------------------ ���������� �������
      begin
        if ObjZav[Svetofor].ObjConstB[20]  //- ���� �������������� �������� ��� ����������
        then MarhTracert[1].IzvCount := 0 //------------------------- �� ����-�������� ���
        else MarhTracert[1].IzvCount := 1; //------ ���� �� ��������, �� ����-������� ����
      end;

      else MarhTracert[1].IzvCount := 1; //---- ��� ������ ��������� ����-������� ���� ???
    end;

    if not ObjZav[Svetofor].bParam[2] and  //------------ ���� ��� ��2 � ��� �2 , �� �����
    not ObjZav[Svetofor].bParam[4]
    then exit; //----------------------------------------------------------- ������ ������

    i := 1000;
    jmp := ObjZav[Svetofor].Neighbour[1]; //--------------------- ��������� ����� ��������

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[1].Level := tlFindIzvest;//- ����� ���� ����������� ����� ������� ��������
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
      trStop, trEnd : break;

      trBreak :
      begin
        //------------------------------------- ��������� ��������������� �������� �������
        if MarhTracert[1].IzvCount < 2 then
        begin //--------------------------------------------------- �������������� �������
          if ObjZav[jmp.Obj].TypeObj = 26 then result := 3
          else

          if ObjZav[jmp.Obj].TypeObj = 15 then result := 3
          else result := 1;
        end
        else  result := 2; //------------------------------------------- ����� �� ��������
        SingleBeep := true;
{$IFNDEF TABLO}
        TimeLockCmdDsp := LastTime;
{$ENDIF}
        LockCommandDsp := true;
        ShowWarning := true;
        break;
      end;
    end;
    dec(i);
  end;
  except
    reportf('������ [Marshrut.GetIzvestitel]'); result := 0;
  end;
end;
{$IFDEF RMDSP}
//========================================================================================
function OtmenaMarshruta(Svetofor : SmallInt; Marh : Byte) : Boolean;
var
  index,i : integer;
  jmp : TOZNeighbour;
//----------------------------------- ������ ������� ������ �������� � ������ (������ ���)
begin
  result := false;
  try
    //--------------------------- ������� ������� ��������������� ������������ ��� ��������}
    index := Svetofor;
    MarhTracert[1].TailMsg := '';
    MarhTracert[1].ObjStart := Svetofor;
    MarhTracert[1].Rod := Marh;
    MarhTracert[1].Finish := false;
    if ObjZav[ObjZav[MarhTracert[1].ObjStart].BaseObject].bParam[2] then
    begin
      //--------------------------------------------- ����� ���������� ��������� ���������
      ObjZav[MarhTracert[1].ObjStart].bParam[14] := false;
      ObjZav[MarhTracert[1].ObjStart].bParam[7] := false;
      ObjZav[MarhTracert[1].ObjStart].bParam[9] := false;
    end;
    i := 1000;
    jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2]; // ��������� �����

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[1].Level := tlOtmenaMarh;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    //------------------------------------------------ ����� ���������� ��������� ��������
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
        trStop, trEnd : break;
      end;
      dec(i);
    end;

    //----------------------------------------------------- ������ ������� ������ ��������
    case Marh of
      MarshM :
      begin
        if SendCommandToSrv(ObjZav[index].ObjConstI[3] div 8, cmdfr3_svzakrmanevr, index)
        then
        begin
          InsArcNewMsg(Index,24,7);
          ShowShortMsg(24, LastX, LastY, ObjZav[index].Liter);
          result := true;
        end;
      end;

      MarshP :
      begin
        if SendCommandToSrv(ObjZav[index].ObjConstI[5] div 8, cmdfr3_svzakrpoezd, index)
        then
        begin
          InsArcNewMsg(Index,25,7);
          ShowShortMsg(25, LastX, LastY, ObjZav[index].Liter);
          result := true;
        end;
      end;
    end;
    MarhTracert[1].ObjStart := 0;
  except
   reportf('������ [Marshrut.OtmenaMarshruta]');
   result := false;
  end;   
end;
{$ENDIF}
//========================================================================================
function SetProgramZamykanie(Group : Byte; Auto : Boolean) : Boolean;
//--------------------------------------------------------------- �������� ������ ��������
var
  jmp : TOZNeighbour;
  i,j,k,obj_tras,Sig_End : integer;
begin
  try
    k := 0;
    //-------------------------------- ���������� ����������� ��������� ��������� ��������
    MarhTracert[Group].SvetBrdr := MarhTracert[Group].ObjStart;//��������� �������� ������
    MarhTracert[Group].Finish := false;    //------------- ����� ������ ���� ������ ������
    MarhTracert[Group].TailMsg := '';      //------ ��������� � "������" �������� ���� ���
    ObjZav[MarhTracert[Group].ObjStart].bParam[14] := true; //- ���������� �������� ������

    ObjZav[MarhTracert[Group].ObjStart].iParam[1] :=
    MarhTracert[Group].ObjStart; //----------------------------- ��������� ������ ��������

    i := MarhTracert[Group].Counter; //---------------- ��������� ����� ��������� ��������

    jmp := ObjZav[MarhTracert[Group].ObjStart].Neighbour[2]; //----------- ����� � ����� 2

    //############## � � � � � � � � � � � �  � � � � � � � � � ##########################
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[Group].Level := tlZamykTrace; // ���� ����������� = ������������ ���������
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTracert[Group].FindTail := true; //--------------- ������� ������ ��� ����� ������
    j := MarhTracert[Group].ObjEnd;

    if ObjZav[j].TypeObj <> 5 then
    begin
      k := 1;
      obj_tras := MarhTracert[Group].ObjTrace[i];
      while ((ObjZav[obj_tras].TypeObj <> 5) and (k <> i)) do
      begin
        obj_tras := MarhTracert[Group].ObjTrace[i-k];
        inc(k);
      end;
    end
    else obj_tras := j;

    if (k > 0) and (i <> k) then MarhTracert[Group].ObjEnd := obj_tras;
    Sig_End := obj_tras;
    if ObjZav[Sig_End].TypeObj = 5 then
    begin
      if ((MarhTracert[Group].Rod = MarshP) and not ObjZav[Sig_End].ObjConstB[5])
      or((MarhTracert[Group].Rod = MarshM) and
      not(ObjZav[Sig_End].ObjConstB[7] or ObjZav[Sig_End].ObjConstB[8])) then
      begin
        obj_tras := MarhTracert[Group].ObjStart;
        ObjZav[obj_tras].bParam[9] := false;
        ObjZav[obj_tras].bParam[7] := false;
        ObjZav[obj_tras].bParam[14] := false;
        ResetTrace;
        InsArcNewMsg(obj_tras,77,1);
        ShowShortMsg(77, LastX, LastY, ObjZav[obj_tras].Liter);
        result := false;
        exit;
      end;
    end;
    

    MarhTracert[Group].CIndex := 1; //----------------- ����������� ������ ������ � ������
    if j < 1 then j := MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter];
    while i > 0 do
    begin
      if jmp.Obj = j then //-------------------------------- ��������� ������ ����� ������
      begin
        case ObjZav[jmp.Obj].TypeObj of
          //-------------------------- ������� � ����� ������ �������� ���������� ��������
          2 : StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);

          5 : //-------------------------------------------------- �������� � ����� ������
          begin
            //������ � ��� 2,������ ��������� � ����� ������ ��������, ���������� ��������
            if jmp.Pin = 2 then
            StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group)
            else //------------------------ ���� �� ����� 2, �� �������� �������� � ������
            if MarhTracert[Group].FindTail //-------------- ���� ����� �������� ��� ������
            then MarhTracert[Group].TailMsg:=' �� '+ObjZav[jmp.Obj].Liter;//����� ��������
          end;

          //------------------------------- �� � ����� ������ �������� ���������� ��������
          15 : StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);

          30 : //------------------------------------------ ������ ���� ��������� ��������
          begin
            if MarhTracert[Group].FindTail// ���� ����� ������ �����, �� ��� ������ ������
            then MarhTracert[Group].TailMsg:=' �� '+ObjZav[ObjZav[jmp.Obj].BaseObject].Liter;
          end;

          //------------------------------------------------------- ������ ������ � ������
          32 : MarhTracert[Group].TailMsg:=' �� '+ ObjZav[jmp.Obj].Liter;//������ �� �����
        end;
        break; //---------------------------- ����� �� ����� ��� ���������� ����� ��������
      end;
      //----- ���� ����� ������ ��� �� ��������� �� ������ ��������� ��� � ����������� ���
      case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
        trStop, trEnd : //���� ����� �� ������������ ��� ����� ���������, �� �������� ����
        begin i := -1; break; end;
      end;
      dec(i); //---------------------------- ��������� ����� ���������� ��������� ��������
      inc(MarhTracert[Group].CIndex); //------------------- ��������� �� ��������� �������
    end;

    if (i < 1) and not Auto then
    begin // ����� �� ���������� ������
      ResetTrace;
      result := false;
      InsArcNewMsg(MarhTracert[Group].ObjStart,228,1);
      ShowShortMsg(228, LastX, LastY, ObjZav[MarhTracert[Group].ObjStart].Liter);
      exit;
    end;
    result := true;
  except
    reportf('������ [Marshrut.SetProgramZamykanie]');
    result := false;
  end;
end;
//========================================================================================
function SendMarshrutCommand(Group : Byte) : Boolean;
var
  i,j : integer;
  os,oe : SmallInt;
begin
  try
     MarhTracert[Group].Finish := false;
     //--------------------------------------------------- ������������ ���������� �������
     for i := 1 to 10 do MarhTracert[Group].MarhCmd[i] := 0;

     if ObjZav[MarhTracert[Group].ObjStart].TypeObj = 30 then
     os := ObjZav[ObjZav[MarhTracert[Group].ObjStart].BaseObject].ObjConstI[5] div 8
     else
     if ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] > 0 then
     os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] div 8
     else os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[5] div 8;

     if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 30 then
     oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[5] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 24 then
     oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[13] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 26 then
     oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[4] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 32 then
     oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[2] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] > 0 then
     oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] > 0 then
     oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] div 8
     else
     oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[7] div 8;

     MarhTracert[Group].MarhCmd[1] := os;
     MarhTracert[Group].MarhCmd[2] := os div 256;
     MarhTracert[Group].MarhCmd[3] := oe;
     MarhTracert[Group].MarhCmd[4] := oe div 256;
     MarhTracert[Group].MarhCmd[5] := MarhTracert[Group].StrCount;

     case MarhTracert[Group].Rod of // ���������� ��������� ��������
      MarshM :
      begin
        if MarhTracert[Group].Povtor then
        MarhTracert[Group].MarhCmd[10] := cmdfr3_povtormarhmanevr
        else MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutmanevr;
        tm := '�����������';
      end;

      MarshP :
      begin
        if MarhTracert[Group].Povtor then
        MarhTracert[Group].MarhCmd[10] := cmdfr3_povtormarhpoezd
        else MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutpoezd;
        tm := '���������';
      end;

      MarshL :
      begin
        MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutlogic;
        tm := '�����������';
      end;
    end;

    if MarhTracert[Group].StrCount > 0 then
    begin
      for i := 1 to MarhTracert[Group].StrCount do
      begin
        if MarhTracert[Group].PolTrace[i,2] then
        begin
          case i of
            1 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 1;
            2 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 2;
            3 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 4;
            4 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 8;
            5 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 16;
            6 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 32;
            7 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 64;
            8 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 128;
            9 :  MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 1;
            10 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 2;
            11 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 4;
            12 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 8;
            13 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 16;
            14 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 32;
            15 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 64;
            16 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 128;
            17 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 1;
            18 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 2;
            19 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 4;
            20 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 8;
            21 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 16;
            22 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 32;
            23 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 64;
            24 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 128;
          end;
        end;
      end;
    end;

    CmdSendT := LastTime;
    WorkMode.MarhRdy := true;
    InsArcNewMsg(MarhTracert[Group].ObjStart,5,7);

    ShowShortMsg(5, LastX, LastY, tm + ' �������� �� '+
    ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg);

    LastMsgToDSP := ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg;

    CmdBuff.LastObj := MarhTracert[Group].ObjStart;

    //-------------------------------------------------------- ����� ��������� �����������

    MarhTracert[Group].ObjStart := 0;
    MarhTracert[Group].PutPriem := 0;
    for i := MarhTracert[Group].Counter downto 1 do
    begin
      j := MarhTracert[Group].ObjTrace[i];
      if (ObjZav[j].TypeObj = 4)then
      begin
        MarhTracert[Group].PutPriem := j;
        break;
      end;
    end;

    for i := 1 to High(MarhTracert[Group].ObjTrace) do MarhTracert[Group].ObjTrace[i] := 0;
    MarhTracert[Group].Counter := 0;
    for i := 1 to High(MarhTracert[Group].StrTrace) do
    begin
      MarhTracert[Group].StrTrace[i] := 0;
      MarhTracert[Group].PolTrace[i,1] := false;
      MarhTracert[Group].PolTrace[i,2] := false;
    end;
    MarhTracert[Group].StrCount := 0;
    MarhTracert[Group].ObjEnd := 0;
    MarhTracert[Group].ObjLast := 0;
    MarhTracert[Group].PinLast := 0;
    MarhTracert[Group].ObjPrev := 0;
    MarhTracert[Group].PinPrev := 0;
    MarhTracert[Group].Rod := 0;
    MarhTracert[Group].Povtor := false;
    WorkMode.GoTracert := false;
    WorkMode.CmdReady  := true; //-------- ������ ���������� ������ �� ��������� ���������
    result := true;
  except
    reportf('������ [Marshrut.SendMarshrutCommand]'); result := false;
  end;
end;
//========================================================================================
function SendTraceCommand(Group : Byte) : Boolean;
//--------------------------------------------- ������ ������� ��������� �������� � ������
var
  i,baza : integer;
  os,oe : SmallInt;
begin
  try
    if (MarhTracert[Group].GonkaList = 0) or //���� ��� ������� ������ ����������� ��� ...
    not MarhTracert[Group].GonkaStrel then //------ ��� ������� ������� ������ �� ��������
    begin
      ResetTrace;
      result := false;
      exit;
    end;
    MarhTracert[Group].Finish     := false;  //���������� ������ ������ ����� ������ �����
    MarhTracert[Group].GonkaStrel := false;
    MarhTracert[Group].GonkaList  := 0;

    //--------------------------------------------------------------- ������������ �������
    for i := 1 to 10 do MarhTracert[Group].MarhCmd[i] := 0; //---- �������� ������ �������

    baza := ObjZav[MarhTracert[Group].ObjStart].BaseObject; //--- ����� ������� ��� ������

    if ObjZav[MarhTracert[Group].ObjStart].TypeObj = 30 then //���� ������ "���� ��������"
    os := ObjZav[baza].ObjConstI[5] div 8 //----- ������ ������� �2 ��������� ������ � FR3
    else

    if ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] > 0 then  //-------- ���� ���� ��2
    os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] div 8 //------ ������ ��2 � FR3

    else
    os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[5] div 8; //------ ������ �2 � FR3

    baza := ObjZav[MarhTracert[Group].ObjEnd].BaseObject;  //--------- ����� ������� �����

    if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 30 then // ���� ����� - "���� ��������"
    oe := ObjZav[baza].ObjConstI[5] div 8 //------- ������ ������� C2 ������� ������ � FR3
    else

    if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 24 then//���� ����� - ������ � ��������
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[13] div 8//- �� ������� ����� ������
    else

    if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 26 then//---- ���� ����� - ������ � ���
    oe := ObjZav[baza].ObjConstI[4] div 8 //--- ������ ������� C1 �������� ��������� � FR3
    else

    if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 32 then // ���� ����� - ������ � ������
    oe := ObjZav[baza].ObjConstI[2] div 8 // ������ ��� �C1 ������.��������� � ����� � FR3
    else

    if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] > 0 then  //-- ���� � ����� ���� ��2
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] div 8 //-------- ������ ��2 � FR3
    else

    if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] > 0 then //---- ���� � ����� ���� �2
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] div 8  //-------- ������ �2 � FR3
    else

    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[7] div 8; //--- ����� ��� ��� ??????

    MarhTracert[Group].MarhCmd[1] := os;
    MarhTracert[Group].MarhCmd[2] := os div 256;
    MarhTracert[Group].MarhCmd[3] := oe;
    MarhTracert[Group].MarhCmd[4] := oe div 256;
    MarhTracert[Group].MarhCmd[5] := MarhTracert[Group].StrCount;
    MarhTracert[Group].MarhCmd[10] := cmdfr3_ustanovkastrelok;

    if MarhTracert[Group].StrCount > 0 then //���� ���� �������, �� ��������� �� ���������
    begin
      for i := 1 to MarhTracert[Group].StrCount do
      begin
        if MarhTracert[Group].PolTrace[i,2] then
        begin
          case i of
            1 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 1;
            2 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 2;
            3 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 4;
            4 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 8;
            5 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 16;
            6 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 32;
            7 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 64;
            8 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 128;
            9 :  MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 1;
            10 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 2;
            11 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 4;
            12 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 8;
            13 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 16;
            14 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 32;
            15 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 64;
            16 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 128;
            17 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 1;
            18 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 2;
            19 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 4;
            20 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 8;
            21 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 16;
            22 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 32;
            23 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 64;
            24 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 128;
          end;
        end;
      end;
    end;

    CmdSendT := LastTime;

    WorkMode.MarhRdy := true;

    InsArcNewMsg(MarhTracert[Group].ObjStart,5,7);
    tm := GetShortMsg(1,5, ' ������� �� ������ �������� �� '+ //- ������ ������� ���������
    ObjZav[MarhTracert[Group].ObjStart].Liter + MarhTracert[Group].TailMsg,7);

    LastMsgToDSP := ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg;

    CmdBuff.LastObj := MarhTracert[Group].ObjStart;

    //-------------------------------------------------------- ����� ��������� �����������
    ResetTrace;
    PutShortMsg(2,LastX,LastY,tm); //----------------------------------- ������ $ ��������
    WorkMode.CmdReady  := true; //-------- ������ ���������� ������ �� ��������� ���������
    result := true;
  except
    reportf('������ [Marshrut.SendTraceCommand]');
    result := false;
  end;
end;
//========================================================================================
function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
var
  cvet : integer;
//----------------------------------------------- ������������ ������ ����������� ��������
begin
  try
    ResetTrace; //------------------------------------- ����� ����� ����� ��������� ������
    case command of
      CmdMenu_BeginMarshManevr :  //---------------------------- ������ ���������� �������
      begin
        MarhTracert[1].Rod := MarshM;
        ObjZav[index].bParam[7] := true; //------------------------- ���������� ������� ��
        cvet := 7;
      end;

      CmdMenu_BeginMarshPoezd :  //------------------------------- ������ �������� �������
      begin
        MarhTracert[1].Rod := MarshP;
        ObjZav[index].bParam[9] := true; //-------------------------- ���������� ������� �
        cvet := 2;
      end;

      else
        InsArcNewMsg(MarhTracert[1].ObjStart,32,1); //"��������� ����������� ��� ��������"
        result := false;
        ShowShortMsg(32,LastX,LastY,ObjZav[MarhTracert[1].ObjStart].Liter);
        exit;
    end;
    WorkMode.GoTracert := true; //-------------------------- �������� ����������� ��������
    MarhTracert[1].AutoMarh := false; //---------------- �������� ����������� ������������
    MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
    MarhTracert[1].ObjStart := index; //---------- �������� ����������� � ������� ��������
    MarhTracert[1].ObjLast := index; //--------------- �������, ��� ���� ������ � ��������
    MarhTracert[1].PinLast := 2; //--------------------------- ������ ������ �� ����������
    MarhTracert[1].ObjPrev := MarhTracert[1].ObjLast;
    MarhTracert[1].PinPrev := MarhTracert[1].PinLast;
    InsArcNewMsg(MarhTracert[1].ObjStart,78,cvet); //---------- ������� ������ �������� ��
    ShowShortMsg(78,LastX,LastY,ObjZav[MarhTracert[1].ObjStart].Liter);
    result := true;
  except
    reportf('������ [Marshrut.BeginTracertMarshrut]');
    result := false;
  end;
end;
//========================================================================================
function RestorePrevTrace : Boolean;
//----------------------------- ������������ ������ �� ��������� ������������ ������������
var
  i : integer;
begin
  try
    i := MarhTracert[1].Counter; //------------------------------- ����� �������� � ������

    while i > 0 do
    begin
      if MarhTracert[1].ObjTrace[i] = MarhTracert[1].ObjPrev then break //- ���� ���������
      else //------------------------------ ���� �� ������� ��������� ������� ����� ������
      begin
        if ObjZav[MarhTracert[1].ObjTrace[i]].TypeObj = 2 then //--- ���� ����� �� �������
        begin //----------------------------------- �������� ��������� ����������� �������
          ObjZav[MarhTracert[1].ObjTrace[i]].bParam[10] := false;
          ObjZav[MarhTracert[1].ObjTrace[i]].bParam[11] := false;
          ObjZav[MarhTracert[1].ObjTrace[i]].bParam[12] := false;
          ObjZav[MarhTracert[1].ObjTrace[i]].bParam[13] := false;
        end;
        MarhTracert[1].ObjTrace[i] := 0; //----------------------- ������ ������ �� ������
      end;
      dec(i);
    end;

    MarhTracert[1].Counter := i; //---------------- ������ � ������ ������� ����� ��������
    MarhTracert[1].ObjLast := MarhTracert[1].ObjPrev; //---- ����������� ������ ����������
    MarhTracert[1].PinLast := MarhTracert[1].PinPrev; //----- ����������� ����� ����������
    MarhTracert[1].MsgCount := 0;
    RestorePrevTrace := true;
  except
    reportf('������ [Marshrut.RestorePrevTrace]'); result := false;
  end;
end;
//========================================================================================
function EndTracertMarshrut : Boolean;
//------------------------------------------------------- ������� ���������� ������ ������
begin
  try
    if Marhtracert[1].Counter < 1 then //------------------- ���� � �������� ��� ���������
    begin result := false; exit; end
    else
    if MarhTracert[1].ObjEnd < 1 then //------------------ ���� ��� ������� ����� ��������
    begin //-------------------- ������������� �� ���� ���������� �������� ������ ��������
      case ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].TypeObj of

        5,15,26,30 :// ���� ��� ������,��,��� ��� "��������", �� ��� � ���� ����� ��������
        MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

        else  result := false; exit; //---------------------------- ����� ����� � ��������
      end;
    end;

    //-------------------------------------------------------- ���� ������ �������� � ....
    if (ObjZav[MarhTracert[1].ObjLast].TypeObj = 5) and (MarhTracert[1].PinLast = 2) and
    //--- �� ������� �� ���������� 1-�� ��� 2-�� ������� �� �������� 1-�� ��� 2-�� �������
    not (ObjZav[MarhTracert[1].ObjLast].bParam[1] or ObjZav[MarhTracert[1].ObjLast].bParam[2] or
    ObjZav[MarhTracert[1].ObjLast].bParam[3] or ObjZav[MarhTracert[1].ObjLast].bParam[4]) then
    begin
      if ObjZav[MarhTracert[1].ObjLast].bParam[5] then //---------- ���� �� ����� ��������
      begin //----------------------------- ������� �� ������� ����������� ����� ���������
        inc(MarhTracert[1].WarCount);
        MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
        //---------------------------- "������� �� ��������.���������� ����������� �����."
        GetShortMsg(1,115, ObjZav[MarhTracert[1].ObjLast].Liter,1);
        InsWar(1,MarhTracert[1].ObjLast,115);
      end;

      //----------- ��������� �������� ������� �������� ������� ���� �������� ����-�������
      case MarhTracert[1].Rod of
        MarshP :    //----------------------------------------------------- ������� ��������
        begin
          //-------------------------- ���� �������� �������������� ������� �������� � ...
          if ObjZav[MarhTracert[1].ObjLast].ObjConstB[19] and
          not ObjZav[MarhTracert[1].ObjLast].bParam[4] then //--- ��� 2-�� ������� ���������
          begin
            InsArcNewMsg(MarhTracert[1].ObjLast,391,1);//----------------- "������ ������"
            ShowShortMsg(391,LastX,LastY, ObjZav[MarhTracert[1].ObjLast].Liter);
            result := false;
            exit;
          end;
        end;

        MarshM :  //---------------------------------------------------- ������� ����������
        begin
          //------------------------ ���� �������� �������������� ������� ���������� � ...
          if ObjZav[MarhTracert[1].ObjLast].ObjConstB[20] and
          not ObjZav[MarhTracert[1].ObjLast].bParam[2] then //- ��� 2-�� ������� �����������
          begin
            InsArcNewMsg(MarhTracert[1].ObjLast,391,1);//----------------- "������ ������"
            ShowShortMsg(391,LastX,LastY, ObjZav[MarhTracert[1].ObjLast].Liter);
            result := false;
            exit;
          end;
        end;

        else  result := false; exit; //---------------------- ������ ��������� ���� �� �����
      end;
    end;

    //------ ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
    if FindIzvStrelki(MarhTracert[1].ObjStart, MarhTracert[1].Rod) then //-------- ���� ����
    begin
      inc(MarhTracert[1].WarCount);
      MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
      //- �������������� "�������� ���� ����������� ������� ��������������� ������� �������"
      GetShortMsg(1,333, ObjZav[MarhTracert[1].ObjStart].Liter,1);
      InsWar(1,MarhTracert[1].ObjStart,333);
    end;
    MarhTracert[1].Finish := true;
    result := true;
  except
    reportf('������ [Marshrut.EndTracertMarshrut]'); result := false;
  end;
end;
{$IFNDEF RMARC}
//========================================================================================
function AddToTracertMarshrut(index : SmallInt) : Boolean;
//--------------------------- ������� ����������� �� ��������� �����, ��������� ����������
var i,j,nextptr : integer;
begin
  try
    if (index = MarhTracert[1].ObjStart) or (index = MarhTracert[1].ObjEnd) then
    begin
      InsArcNewMsg(MarhTracert[1].ObjStart,1,7); //------- "����������� ����� �������� ��"
      ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
      result := false;
      exit;
    end;
    for i := 1 to MarhTracert[1].Counter do
    if Marhtracert[1].ObjTrace[i] = index then
    begin //------------------------- ���� ������ ��� � ������ - ��������� ��������� �����
      InsArcNewMsg(MarhTracert[1].ObjStart,1,7);
      ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
      result := false;
      exit;
    end;

    //--------------------------------------------------------- ����� ������ � ������ ����
    for i := 1 to High(AKNR) do
    begin
      if (AKNR[i].ObjStart = 0) or (AKNR[i].ObjEnd = 0) then break
      else
      begin
        if (AKNR[i].ObjStart = MarhTracert[1].ObjLast) and (AKNR[i].ObjEnd = index) then
        for j := 1 to High(AKNR[i].ObjAuto) do
        begin
          if AKNR[i].ObjAuto[j] = 0 then break
          else
          begin
            nextptr := AKNR[i].ObjAuto[j];
            result := NextToTracertMarshrut(nextptr);
            if not result then exit;
          end;
        end;
      end;
    end;
    result := NextToTracertMarshrut(index);
  except
    reportf('������ [Marshrut.AddToTracertMarshrut]'); result := false;
  end;
end;
//========================================================================================
function NextToTracertMarshrut(index : SmallInt) : Boolean;
//----------------------------------------------------- �������� ������ �� ��������� �����
//------------------- index - ������ �������, ��������� �������� ���������� ������� ������

var
  i,j,c,k,wc,oe,strelka,signal : Integer;
  jmp : TOZNeighbour;
  TST_TRAS : TTracertResult;
  b,res : boolean;
begin
  try
    signal := 0;
    MarhTracert[1].FindNext := false;//�������-���������� �������� ����������� �����������
    MarhTracert[1].LvlFNext := false;//������� �������� ������ ������ ��� ���������� ����.
    MarhTracert[1].Dobor    := false;//---- ������� �������� ����������� "������" ��������
    MarhTracert[1].HTail    := index; //------------- "�����" ������, ��������� ����������
    Marhtracert[1].FullTail := false; //----------  ������� ������� ������ ������ ��������
    Marhtracert[1].VP := 0; //------------------------- ������ �������� ��� ������� � ����
    MarhTracert[1].TailMsg  := ''; //--- ��������� � ����� �������� ("��" ������ ��� "��")
    MarhTracert[1].FindTail := true; //----------- ������� �������� �����������, ���� "��"
    LastJmp.TypeJmp := 0; LastJmp.Obj := 0; LastJmp.Pin := 0;

    if WorkMode.GoTracert and not WorkMode.MarhRdy then //���� �����������,�����. �� �����
    begin
      result := true;
      if index = MarhTracert[1].ObjLast then //------- ���� ����� �� �������� ����� ������
      begin
        InsArcNewMsg(MarhTracert[1].ObjStart,1,7);//------ "����������� ����� �������� ��"
        ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
        result := true;
        exit;
      end;
      //------------------------------------------ ��������� ��������� ������� �����������
      MarhTracert[1].ObjPrev := MarhTracert[1].ObjLast; //-- ������ � ����� ������� ������
      MarhTracert[1].PinPrev := MarhTracert[1].PinLast; // ����������� ����� ����� �������

      if MarhTracert[1].Counter < High(MarhTracert[1].ObjTrace) then //���� �������� �����
      begin //---------------- ����������� - ��������� ����, ����� ����� ��������� �������
        i := TryMarhLimit; //------------------------- ���������� ������������ �����������
        jmp :=ObjZav[MarhTracert[1].ObjLast].Neighbour[MarhTracert[1].PinLast];//���������

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[1].Level := tlFindTrace; //- ��������� ������� �������� ������� ������
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        //-------------------------------------------- ����� ���������� ���� ������ ������
        while i > 0 do //-------- ���� �� ���������� ������, ���� ���������� ����� �������
        begin //------------------------------------------ ������������ �� ��������� �����

          if jmp.Obj = index then break; //-------- ��������� ������, ��������� ����������

          case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of //- ������� ���
            trRepeat : //---------- ����� �� ������, ���������� ����� �� ��������� �������
            begin
              if MarhTracert[1].Counter > 0 then
              begin //------------------------- ������� � ��������� �������������� �������
                j := MarhTracert[1].Counter; //------- �������� �� �������� ������� ������

                while j > 0 do
                begin
                  case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of //--- ������� �� ����
                    2 :
                    begin //------------------------------------------------------ �������
                      strelka := MarhTracert[1].ObjTrace[j];// ����� ������ ���. �� ������

                      if ObjZav[strelka].ObjConstB[3] then //- �������� �������� �� ������
                      begin
                        if (ObjZav[strelka].bParam[10] and //----- ��� ������ ������ � ...
                        not ObjZav[strelka].bParam[11]) or //--- �� ���� ���� 2-�� ��� ...
                        ObjZav[strelka].bParam[12] or  // ���������� ����� � ����� ��� ...
                        ObjZav[strelka].bParam[13] then //------ ���������� ����� � ������
                        begin
                          ObjZav[strelka].bParam[10] :=false;//����� �������� 1-�� �������
                          ObjZav[strelka].bParam[11] :=false;//����� �������� 2-�� �������
                          ObjZav[strelka].bParam[12] :=false; //-- ����� ����������� �����
                          ObjZav[strelka].bParam[13] :=false; //- ����� ����������� ������
                          MarhTracert[1].ObjTrace[j] :=0; //----- ������ �� ������ �������
                          dec(MarhTracert[1].Counter);  //------ ��������� ����� ���������
                        end else
                        begin
                          ObjZav[strelka].bParam[11] := false; // ����� �������� 2-�� ����
                          jmp := ObjZav[strelka].Neighbour[2]; //--- ������� �� ����-�����
                          break;
                        end;
                      end else //------------------------------ �������� �������� �� �����
                      begin
                        if ObjZav[strelka].bParam[11] or //- ������ ��� �� ������� ��� ...
                        ObjZav[strelka].bParam[12] or //------- ���������� � ����� ��� ...
                        ObjZav[strelka].bParam[13] then //------------ ���������� � ������
                        begin
                          ObjZav[strelka].bParam[10] :=false;//����� �������� 1-�� �������
                          ObjZav[strelka].bParam[11] :=false;//����� �������� 2-�� �������
                          ObjZav[strelka].bParam[12] :=false; //-- ����� ����������� �����
                          ObjZav[strelka].bParam[13] :=false; //- ����� ����������� ������
                          MarhTracert[1].ObjTrace[j] := 0;
                          dec(MarhTracert[1].Counter);
                        end else
                        begin
                          ObjZav[strelka].bParam[11] := true;
                          jmp := ObjZav[strelka].Neighbour[3]; //-- ������� �� �����-�����
                          break;
                        end;
                      end;
                    end;

                    else //------------------------------ ����� ������ �������� �� �������
                      if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                      begin j := 0; break; end //------ ��������� � ����� ������, ��������
                      else
                      begin //--------------------------- �������� �� ���� ������ � ������
                        MarhTracert[1].ObjTrace[j] := 0;
                        dec(MarhTracert[1].Counter);
                      end;
                  end; //------------------------------------------------------ ����� case
                  dec(j);
                end; //------------------------------------------ ������� while ��� ������

                if j < 1 then //----------------------- ��������� �����, ������ �� �������
                begin //------------------------ ����� ����������� - ����� ������� �������
                  InsArcNewMsg(MarhTracert[1].ObjStart,86,1);
                  RestorePrevTrace;
                  result := false;
                  ShowShortMsg(86, LastX, LastY, '');
//                  SingleBeep := true;
                  exit;
                end;
              end else //-------------------------- � ������ ��� ��������� (������ ������)
              begin //-------------------------- ����� ����������� - ����� ������� �������
                InsArcNewMsg(MarhTracert[1].ObjStart,86,1);
                RestorePrevTrace; //------- ������������ ������ �� ��������� ������� �����
                result := false;
                ShowShortMsg(86, LastX, LastY, ''); //--- "����� ������ $ ������� �������"
                exit;
              end;
            end;

            trStop : //------------ ��� ������� ������ ����� ������ - ��������� �� �������
            begin
              InsArcNewMsg(MarhTracert[1].ObjStart,77,1);
              RestorePrevTrace; //-------------- �������������� �� ��������� ������� �����
              result := false;
              ShowShortMsg(77, LastX, LastY, '');  //--------------- ������� �� ����������
              exit;
            end;

            trEnd :
            begin //---------------------------- ����� ����������� - ������� �� ����������
              InsArcNewMsg(MarhTracert[1].ObjStart,77,1);
              RestorePrevTrace;
              result := false;
              ShowShortMsg(77, LastX, LastY, ''); exit;
            end;
          end; //------------------------------------------------- ����� ���� ����� ������
          dec(i); //------ ������� � ���������� ����, �������� ����� ���������� ����������
        end; //------------------------------ ����� ����� ������� ������� �� �������� ����

        if i < 1 then //--------------------------- ����� �� ������� �������������� ������
        begin //------------------------------------------------- �������� ������� �������
          InsArcNewMsg(MarhTracert[1].ObjStart,231,1);// �������� ���� ������� �����������
          RestorePrevTrace;
          result := false;
          ShowShortMsg(231, LastX, LastY, '');
          exit;
        end;

        MarhTracert[1].ObjLast := index; //------------------------ ��������� ����� ������

        if ObjZav[index].TypeObj = 5 then MarhTracert[1].ObjEnd := index;

        case jmp.Pin of
          1 : MarhTracert[1].PinLast := 2; // ���������� ����� ������ �� ��������� �������
          else MarhTracert[1].PinLast := 1;
        end;

        //------------------- ��������� ������������� ������ �������������� �������� �����
        b := true;
        MarhTracert[1].PutPO := false; //--------------- ����� �������� ����������� � ����

        if ObjZav[MarhTracert[1].ObjLast].TypeObj = 5 then
        begin //------------------ ��� ��������� ��������� ������� ����������� �����������
          signal := MarhTracert[1].ObjLast;
          if ObjZav[signal].ObjConstB[1] then  //-- ���� ����� ����������� � ����� �������
          begin//����� ������� ��������� �/� (����� ����������� �������� �� �������, �����)
            b := false;
            MarhTracert[1].ObjEnd := signal;
          end
          else
          case MarhTracert[1].PinLast of
            1 :  //----------------------- ����� �� ������� � ����� 1 (����� �� ���������)
            begin
              case MarhTracert[1].Rod of
                MarshP :
                begin
                  if ObjZav[signal].ObjConstB[6] then //---- ���� ����� �������� � ����� 2
                  begin //------------------ ��������� ����������� ���� �������� �� ������
                    b := false;
                    MarhTracert[1].ObjEnd := signal;
                  end else //-------------- ��� ����� � � ����� 2 ( �� ��������� ��������)
                  if ((ObjZav[signal].Neighbour[1].TypeJmp = 0) or
                  (ObjZav[signal].Neighbour[1].TypeJmp = LnkNecentr))
                  then begin b := false; i := 0; end; //����� ���� ��� ��������� �� ������
                end;

                MarshM :
                begin
                  if ObjZav[signal].ObjConstB[8] then //-- ���� ����� ���������� � ����� 2
                  begin //----- ��������� ����������� �� ���������, �� ��������� ���� ����
                    b := true;
                    MarhTracert[1].ObjEnd := signal;
                  end;
                end;

                else b := true; //---------------------------- �������������� ��� ��������
              end;
            end;

            else //--- ����� �� ������� ����� � ����� 2 (�� ��������, ������ ������� "��")

            //-------------- ���� ���������� � ���� ����� ���������� � ����� 1 ("��")  ���
            if(((MarhTracert[1].Rod=MarshM) and ObjZav[signal].ObjConstB[7]) or
            //--------------------------- ���� �������� � ���� ����� �������� � ����� 1 �
            ((MarhTracert[1].Rod = MarshP) and ObjZav[signal].ObjConstB[5])) and
            //---------------- ���� ���������� FR4 ��� ���������� � �� ��� ��� ��/�� ���
            (ObjZav[signal].bParam[12] or
            ObjZav[signal].bParam[13] or
            ObjZav[jmp.Obj].bParam[18] or
            //-----------------------------------------------���� ������ �������� � �1 ���
            (ObjZav[signal].ObjConstB[2] and
            (ObjZav[signal].bParam[3] or
            //----------------------------------------------- �2 ��� ������ �� ������� ���
            ObjZav[signal].bParam[4] or
            ObjZav[signal].bParam[8] or
            //--------------------------------- ��� ����������� ��� ���� ������ ����������
            ObjZav[signal].bParam[9])) or
            (ObjZav[signal].ObjConstB[3]
            //-------------------------------------------------------------- � ��1 ��� ��2
            and (ObjZav[signal].bParam[1]
            or ObjZav[signal].bParam[2]
            //--------------------------------- ��� ���� �� �� ������� ��� ��� �����������
            or ObjZav[signal].bParam[6]
            or ObjZav[signal].bParam[7]
            //��� ���
            or ObjZav[signal].bParam[21]))) then
            begin //--------------- ��������� ����������� ���� �������� ������� ��� ������
              b := false;
              MarhTracert[1].ObjEnd := signal;
            end else //----------------------------------------------------- ������ ������
            begin
              case MarhTracert[1].Rod of
                MarshP :      //-------------------------------------------- ���� ��������
                begin //------------------------------- ���� ���� ����� �������� � ����� 1
                  if ObjZav[signal].ObjConstB[5] then
                  begin //---------------------- ���� ����� ��������� �������� � ���������
                    MarhTracert[1].FullTail := true;
                    MarhTracert[1].FindNext := true;
                  end;
                  //------------------- ���� ��� ��������� �������� � ���� ������ ��������
                  if ObjZav[signal].ObjConstB[16] and
                  ObjZav[signal].ObjConstB[2] then //-------------- ��� ��������� ��������
                  begin //-------------- ��������� ����������� ���� ��� ��������� ��������
                    b := false;
                    MarhTracert[1].ObjEnd := signal;
                    MarhTracert[1].FullTail := true //------------- ��������� ����� ������
                  end else
                  begin
                    if ObjZav[signal].ObjConstB[5] then b := false // ���� ����� "�" � �.1
                    else b := true;

                    if ObjZav[signal].ObjConstB[5] and //------ ���� ����� "�" � �.1 � ...
                    not ObjZav[signal].ObjConstB[2] then //---------- ��� ��������� ������
                    begin
                      MarhTracert[1].ObjEnd := signal; //-- �����, ��� �������� �� �������
                    end;
                  end;
                end;

                MarshM :
                begin
                  if ObjZav[signal].ObjConstB[7] then //-- ���� ����� ���������� � ����� 1
                  begin
                    MarhTracert[1].FullTail := true;
                    MarhTracert[1].FindNext := true;
                  end;

                  if ObjZav[signal].ObjConstB[7]
                  then b := false
                  else b := true;

                  if ObjZav[signal].ObjConstB[7] and //------ ���� ����� � � ����� 1 � ...
                  not ObjZav[signal].ObjConstB[3] then //- � ������� ��� ������ ����������
                  begin
                    MarhTracert[1].ObjEnd := signal;//- ���������, ��� �������� �� �������
                  end;
                end;

                else  b := true; //--------------- �������������� ������� ������� ��������
              end;
            end;
          end;
        end else //--------------------------------- ������� ���� "����" ��� "�� � ������"
        if ((ObjZav[MarhTracert[1].ObjLast].TypeObj = 4) or //---------- ���� ���� ��� ...

        ((ObjZav[MarhTracert[1].ObjLast].TypeObj = 3) and //--------------------- �� � ...
        (MarhTracert[1].Rod = MarshP) and //----------------------- �������� ������� � ...
        (MarhTracert[1].PinLast = 1) and  //-------------- ����� �� �� ����� ����� 1 � ...
        (ObjZav[MarhTracert[1].ObjLast].ObjConstB[10] = true)) or //���� ����� � ��� 1 ���

        ((ObjZav[MarhTracert[1].ObjLast].TypeObj = 3) and //--------------------- �� � ...
        (MarhTracert[1].Rod = MarshP) and //----------------------- �������� ������� � ...
        (MarhTracert[1].PinLast = 2) and  //-------------- ����� �� �� ����� ����� 2 � ...
        (ObjZav[MarhTracert[1].ObjLast].ObjConstB[11] = true)))  //---- ���� ����� � ��� 2
        then  MarhTracert[1].PutPO := true
        //---------------- ��� ���� ��� �� � ������ ���������� ������� ����� ������ ������
        else
        if ObjZav[MarhTracert[1].ObjLast].TypeObj = 24 then
        begin //-------------------------- ��� ����������� ������ ��������� ����� ��������
          b := false;
          MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
        end else
        if ObjZav[MarhTracert[1].ObjLast].TypeObj = 32 then
        begin //------------------------------------- ��� ������� ��������� ����� ��������
          b := false;
          MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
        end;

        //++++++++++++++++++++++++++++++++++++++++++++ ��������� ������ �������� �� ������
        if b then  //-------------------------------- ��� ���������� ��������, ����� �����
        begin //--- ������ �� �������� ����� ��� ����������� �������, ����������� ��������
          MarhTracert[1].FullTail := false;

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTracert[1].Level := tlContTrace; //------------------ ����� ��������� ������
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          //---------------------- � � � � �   � � � � � �  ------------------------------
          i := 1000;

          while i > 0 do
          begin
            TST_TRAS := StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1);//�������
            case TST_TRAS of
              trStop :
              begin //-------------------------- ����� ����������� - ������� �� ����������
                InsArcNewMsg(MarhTracert[1].ObjStart,77,1);
                RestorePrevTrace;
                result := false;
                ShowShortMsg(77, LastX, LastY, '');
                exit;
              end;

              trBreak :
              begin //------------------------- ������� ����� �� ���������� ����� ��������
                b := false;
                break;
              end;

              trEnd :
                      break; //------------------------- ���������� ������� ����� ��������

              trEndTrace :
              begin  //-------------------------------- ���������� �������� ����� ��������
                MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
                MarhTracert[1].ObjLast := ObjZav[signal].Neighbour[1].Obj;//������ �� ���.
                break;
              end;
            end;
            dec(i);
          end;

          if i < 1 then
          begin //----------------------------------------------- �������� ������� �������
            InsArcNewMsg(MarhTracert[1].ObjStart,231,1);
            RestorePrevTrace;
            result := false;
            ShowShortMsg(231, LastX, LastY, ''); exit;
          end;

          if b then
          begin //------------------------------------------------------------- ��� ������
            jmp.Obj := MarhTracert[1].ObjLast;
            case jmp.Pin of
              1 : MarhTracert[1].PinLast := 2;
              else  MarhTracert[1].PinLast := 1;
            end;
          end else
          begin //-------------------------------------------------- ��� ����� �� ���� ���
            //------------------------------------------------------ ���������� �� �������

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            MarhTracert[1].Level := tlStepBack; //----- ����� ��� ����� �� ������ ��������
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            i := MarhTracert[1].Counter;
            while i > 0 do
            begin
              case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
                trStop : break;
              end;
              dec(i);
            end;
            MarhTracert[1].ObjLast := jmp.Obj;
            MarhTracert[1].PinLast := jmp.Pin;
          end;
        end else
        begin //------------------------------------------ ���� ��� ������ ������ ��������
          if MarhTracert[1].Counter < High(MarhTracert[1].ObjTrace) then
          begin //---------------------------------------- ��������� ����� � ������ ������
            inc(MarhTracert[1].Counter);
            MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj;
          end;
        end;

        LastJmp := jmp; //-------------------- ��������� ��������� ������� ����� ���������

        if i < 1 then
        begin //----------------------------------- ����� �� �������������� �������� �����
          InsArcNewMsg(index,86,1);   //------------------- ����� ������ $ ������� �������
          RestorePrevTrace; result := false;
          ShowShortMsg(86, LastX, LastY, ObjZav[index].Liter);
          exit;
        end;

        //-------------------------------------------- ��������� ���������� �� ���� ������
        i := 1000;
        Marhtracert[1].VP := 0;
        jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2];

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[1].Level := tlVZavTrace; //----- ����� �������� ������������ �� ������
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        j := MarhTracert[1].ObjEnd; //------------------ ��������� ����� ���������� ������

        MarhTracert[1].CIndex := 1;
        if j < 1 then j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

        res := false;
        while i > 0 do
        begin
          case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
            trStop :  begin i := 0; break; end;
            trBreak : break;
            trEnd :   break;
          end;
          dec(i);
          if res then break;         
          if jmp.Obj = j then res := true; //--------------- ��������� ������ ����� ������
          inc(MarhTracert[1].CIndex);
        end;

        if MarhTracert[1].MsgCount > 0 then //-- ���� ����������� ��������� (������������)
        begin
          InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1],1);
          RestorePrevTrace;
          result := false;
          PutShortMsg(1, LastX, LastY, MarhTracert[1].Msg[1]);
          exit;
        end;

        if i < 0 then //--------------------- ����� �� ����������� - ������� �� ����������
        begin
          InsArcNewMsg(MarhTracert[1].ObjStart,77,1);
          RestorePrevTrace;
          result := false;
          ShowShortMsg(77, LastX, LastY, '');
          exit;
        end;

        //------------------------------ ��������� �������� ����������� �� �������� ������
        for i := 1 to MarhTracert[1].Counter do
        begin
          case ObjZav[MarhTracert[1].ObjTrace[i]].TypeObj of
            3 :   //--------------------------------------------------------------- ������
            begin
              if  not ObjZav[MarhTracert[1].ObjTrace[i]].bParam[14] then
              ObjZav[MarhTracert[1].ObjTrace[i]].bParam[8] := false;
            end;

            4 :  //------------------------------------------------------------------ ����
            begin
              if  not ObjZav[MarhTracert[1].ObjTrace[i]].bParam[14] then
              ObjZav[MarhTracert[1].ObjTrace[i]].bParam[8] := false;
            end;
          end;
        end;

        //------------------------------------------ ��������� ������������ �� ���� ������
        i := 1000;
        MarhTracert[1].MsgCount := 0;
        MarhTracert[1].WarCount := 0;
        MarhTracert[1].GonkaStrel := false; //----- ������ ������� ����� ������� �� ������
        MarhTracert[1].GonkaList  := 0;    // �������� ������� �������, ��������� ��������
        jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2];

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[1].Level := tlCheckTrace;//---- ����� �������� ������������� �� ������
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        Marhtracert[1].VP := 0;
        j := MarhTracert[1].ObjEnd;
        if j < 1 then j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
        MarhTracert[1].CIndex := 1;

        while i > 0 do
        begin
          if jmp.Obj = j then
          begin //------------------------------------------ ��������� ������ ����� ������
            //----------------------------------------------- ����� ������������� � ������
            StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1);
            break;
          end;

          case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
            trStop : break;
          end;
          dec(i);
          inc(MarhTracert[1].CIndex);
        end;

        if i < 1 then
        begin //--------------------------------------------- ����� �� ���������� ��������
          InsArcNewMsg(MarhTracert[1].ObjStart,231,1);
          RestorePrevTrace;
          result := false;
          ShowShortMsg(231, LastX, LastY, '');
          exit;
        end;
        tm := MarhTracert[1].TailMsg; //------------ ��������� ��������� � ������ ��������

        if MarhTracert[1].MsgCount > 0 then
        begin  //--------------------------------------------------- ����� �� ������������
          MarhTracert[1].MsgCount := 1; //------------------------ �������� ���� ���������
          //--------------- ��������� ����������� � �������� ������ ���� ���� ������������
          CreateDspMenu(KeyMenu_ReadyResetTrace,LastX,LastY);
          result := false;
          exit;
        end else
        begin
          if MarhTracert[1].PutPO then //---------------- ��������� ����� ���� ������ ����
           MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

          if (MarhTracert[1].WarCount > 0) and
          MarhTracert[1].FullTail then //--------  ��� ������� ��������� � ������ ��������
          MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

          //------------------------------ �������� ����������� ������ ���������� ��������
          c := MarhTracert[1].Counter; //-------- ��������� ������� ����� ��������� ������
          wc := MarhTracert[1].WarCount;  //--------------- ��������� ����� ��������������
          oe := MarhTracert[1].ObjEnd; //--------------------------------- �������� ������

          MarhTracert[1].VP := 0;
          MarhTracert[1].LvlFNext := true;

          if (MarhTracert[1].ObjEnd = 0) and (MarhTracert[1].FindNext) then
          begin //------------------------ �������� ����������� ������ ���������� ��������
            i := TryMarhLimit * 2;
            jmp := ObjZav[MarhTracert[1].ObjLast].Neighbour[MarhTracert[1].PinLast];

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            MarhTracert[1].Level := tlFindTrace;
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            while i > 0 do
            begin //------------------------------------------------ ������������ �� �����

              case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of

                trRepeat :  //--------------------- ���� ����� ������� � ��������� �������
                begin

                  if MarhTracert[1].Counter > c then //-- ���� ��� ���� �� ���� ��� ������
                  begin   //------------------- ������� � ��������� �������������� �������
                    j := MarhTracert[1].Counter; // �������� � ����� (������� ����� j > c)
                    while j > 0 do
                    begin

                      case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of

                        2 :
                        begin //-------------------------------------------------- �������
                          strelka := MarhTracert[1].ObjTrace[j];

                          if ObjZav[strelka].ObjConstB[3] then//������� �������� �� ������
                          begin
                            if (ObjZav[strelka].bParam[10] and  //-- ��� 1-�� ������ � ...
                            not ObjZav[strelka].bParam[11]) or //- ��� 2-�� ������ ��� ...
                            ObjZav[strelka].bParam[12] or //  ���������� ����� � ����� ���
                            ObjZav[strelka].bParam[13] then //-- ���������� ����� � ������
                            begin
                              ObjZav[strelka].bParam[10] := false;//�������� ������ ������
                              ObjZav[strelka].bParam[11] := false;//�������� ������ ������
                              ObjZav[strelka].bParam[12] := false; // ����� ���������� � +
                              ObjZav[strelka].bParam[13] := false; // ����� ���������� � -
                              MarhTracert[1].ObjTrace[j] := 0; // ������ ������� �� ������
                              dec(MarhTracert[1].Counter); //------------ ��������� ������
                            end else
                            begin
                              ObjZav[strelka].bParam[11] := false;//���������� 2-�� ������
                              jmp := ObjZav[strelka].Neighbour[2]; //������� �� ����-�����
                              break;
                            end;
                          end else
                          begin //----------------------------- �������� �������� �� �����
                            if ObjZav[strelka].bParam[11] or//���� ��� 2-�� ������ ��� ...
                            ObjZav[strelka].bParam[12] or //--- ���������� � ����� ��� ...
                            ObjZav[strelka].bParam[13] then //-------- ���������� � ������
                            begin
                              ObjZav[strelka].bParam[10] := false;
                              ObjZav[strelka].bParam[11] := false;
                              ObjZav[strelka].bParam[12] := false;
                              ObjZav[strelka].bParam[13] := false;
                              MarhTracert[1].ObjTrace[j] := 0;
                              dec(MarhTracert[1].Counter);
                            end else
                            begin
                              ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := true;//2-��
                              jmp:= ObjZav[MarhTracert[1].ObjTrace[j]].Neighbour[3];//�� -
                              break;
                            end;
                          end;
                        end;

                        else //---------------- ����� ������ ������ (�� �������� ��������)
                          if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                          begin  //- �����, �������� ����������� �� ������ ��� �����������
                            j := 0; break;
                          end else
                          begin //---------------- �������� �� ���� ������ � ������ ������
                            MarhTracert[1].ObjTrace[j] := 0;
                            dec(MarhTracert[1].Counter);
                          end;

                      end; //-------------------------------- ����� case �� ����� ��������
                      dec(j);
                    end; //--------- ����� while j > 0 �� ����� �������� �������� � ������

                    if j <= c then //------------------------- ���� �������� ������� �����
                    begin //-------------------------------------------- ����� �����������
                      oe := MarhTracert[1].ObjLast;
                      break;
                    end;
                  end else //------------ ���� �� ��������� ������� ��� ����������� ������
                  begin //---------------------------------------------- ����� �����������
                    MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
                    break;
                  end;
                end; //-------------------------- ����� case �� ���������� ���� = trRepeat

                trStop, trEnd : break; //------------------------------- ����� �����������
              end; //------------------------------------------------------ case steptrace

              //-------------------------------------- ��������� ���������� �������� �����
              b := false;

              if ObjZav[jmp.Obj].TypeObj = 5 then //-------------------------- ���� ������
              begin //------------ ��� ��������� ��������� ������� ����������� �����������
                if ObjZav[jmp.Obj].ObjConstB[1] then b := true //- ����� ������� ���������
                else
                case jmp.Pin of
                  2 :
                  begin //--------------------------- ������� � ����� 2 (������ ���������)
                    case MarhTracert[1].Rod of
                      MarshP : if ObjZav[jmp.Obj].ObjConstB[6] then b := true;//� ����� �2

                      MarshM : if ObjZav[jmp.Obj].ObjConstB[8] then b := true;//� ����� �2

                      else  b := false;
                    end;
                  end;
                  else //---------------------------- ������� � ����� 1, (������ ��������)
                    if ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2]//��1 ��� ��2
                    or //------------------------------------------------------------- ���
                    ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4] //--- �1 ��� �2
                    or //------------------------------------------------------------- ���
                    ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7]//��_FR3 ��� ���
                    or //------------------------------------------------------------- ���
                    ObjZav[jmp.Obj].bParam[8] or ObjZav[jmp.Obj].bParam[9] //�_FR3 ��� ���
                    or //------------------------------------------------------------- ���
                    ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13]//����STAN_DSP
                    or //------------------------------------------------------------- ���
                    ObjZav[jmp.Obj].bParam[18] or ObjZav[jmp.Obj].bParam[21] //- ��_��_���
                    then b := true //�������� ��� ������, �� ��������, � ������,����������
                    else
                    begin
                      case MarhTracert[1].Rod of
                        MarshP :
                        begin
                          if ObjZav[jmp.Obj].ObjConstB[16] and // ��� ��������� �������� �
                          ObjZav[jmp.Obj].ObjConstB[2] then b := true // ���� ������ ��� �
                          else
                          begin
                            b := ObjZav[jmp.Obj].ObjConstB[5]; //������� � ����� � ����� 1
                          end;
                        end;

                        MarshM : b := ObjZav[jmp.Obj].ObjConstB[7];   // � ����� � ����� 1

                        else  b := true;  //------------------- ������� ������� ����������
                      end;
                    end;
                end;
              end else
              if ObjZav[jmp.Obj].TypeObj = 15 then
              begin //-------------------- ��� ������ � ��������� ��������� ����� ��������
                inc(MarhTracert[1].Counter);
                MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj;
                b := true;
              end else
              if ObjZav[jmp.Obj].TypeObj = 24 then
              begin //-------------------- ��� ����������� ������ ��������� ����� ��������
                b := true;
              end else
              if ObjZav[jmp.Obj].TypeObj = 26 then
              begin //-------------------------- ��� ������ � ��� ��������� ����� ��������
                inc(MarhTracert[1].Counter);
                MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj;
                b := true;
              end else
              if ObjZav[jmp.Obj].TypeObj = 32 then
              begin //------------------------------- ��� ������� ��������� ����� ��������
                b := true;
              end;

              if b then //- ������� �������� �� ����� �����������, �� ��������� ����������
              begin
                k := 15000;
                jmp.Obj := MarhTracert[1].ObjLast;
                if MarhTracert[1].PinLast = 1 then jmp.Pin := 2 else
                jmp.Pin := 1;

                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                MarhTracert[1].Level := tlVZavTrace;//����� �������� ������������ � ������
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
                MarhTracert[1].CIndex := c;
                b := true;

                while k > 0 do
                begin
                  if jmp.Obj = j then break; //------------- ��������� ������ ����� ������
                  case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
                    trStop :         begin  b := false; break; end;
                    trBreak, trEnd : begin   break;            end;
                  end;
                  dec(k);
                  inc(MarhTracert[1].CIndex);
                end;

                if (k > 1000) and b then
                begin
                  //----------------------------------------------- ��������� ������������
                  jmp.Obj := MarhTracert[1].ObjLast;
                  if MarhTracert[1].PinLast = 1 then jmp.Pin := 2
                  else jmp.Pin := 1;

                  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  MarhTracert[1].Level := tlCheckTrace;//- ����� �������� �����. �� ������
                  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                  MarhTracert[1].Dobor := true;
                  MarhTracert[1].MsgCount := 0;
                  j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
                  MarhTracert[1].CIndex := c;
                  while k > 0 do
                  begin
                    if jmp.Obj = j then
                    begin //-------------------------------- ��������� ������ ����� ������
                      // ������������ � ������
                      StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1); break;
                    end;

                    case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
                      trStop,trBreak :  break;
                    end;

                    dec(i);
                    inc(MarhTracert[1].CIndex);
                  end;
                end;

                if MarhTracert[1].MsgCount > 0 then b := false;

                if (k < 1) or not b then
                begin //--------------------------- ����� �� ����������� ��� �������������
                  if MarhTracert[1].Counter > c then
                  begin
                    //------------------------- ������� � ��������� �������������� �������
                    j := MarhTracert[1].Counter;
                    while j > 0 do
                    begin
                      case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of
                        2 :
                        begin //-------------------------------------------------- �������
                          strelka := MarhTracert[1].ObjTrace[j];
                          if ObjZav[strelka].ObjConstB[3] then
                          begin //---------------------------- �������� �������� �� ������
                            if (ObjZav[strelka].bParam[10] and
                            not ObjZav[strelka].bParam[11]) or
                            ObjZav[strelka].bParam[12] or
                            ObjZav[strelka].bParam[13] then
                            begin
                              ObjZav[strelka].bParam[10] := false;
                              ObjZav[strelka].bParam[11] := false;
                              ObjZav[strelka].bParam[12] := false;
                              ObjZav[strelka].bParam[13] := false;
                              MarhTracert[1].ObjTrace[j] := 0;
                              dec(MarhTracert[1].Counter);
                            end else
                            begin
                              ObjZav[strelka].bParam[11] := false;
                              jmp := ObjZav[strelka].Neighbour[2]; //������� �� ����-�����
                              break;
                            end;
                          end else
                          begin //----------------------------- �������� �������� �� �����
                            if ObjZav[strelka].bParam[11] or
                            ObjZav[strelka].bParam[12] or
                            ObjZav[strelka].bParam[13] then
                            begin
                              ObjZav[strelka].bParam[10] := false;
                              ObjZav[strelka].bParam[11] := false;
                              ObjZav[strelka].bParam[12] := false;
                              ObjZav[strelka].bParam[13] := false;
                              MarhTracert[1].ObjTrace[j] := 0;
                              dec(MarhTracert[1].Counter);
                            end else
                            begin
                              ObjZav[strelka].bParam[11] := true;
                              jmp := ObjZav[strelka].Neighbour[3];//������� �� �����-�����
                              break;
                            end;
                          end;
                        end;
                        else
                          if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                          begin
                            oe := MarhTracert[1].ObjLast;
                            break;
                          end else
                          begin //----------------------- �������� �� ���� ������ � ������
                            MarhTracert[1].ObjTrace[j] := 0;
                            dec(MarhTracert[1].Counter);
                          end;
                      end;
                      dec(j);
                    end;
                    if j <= c then
                    begin //-------------------------------------------- ����� �����������
                      oe := MarhTracert[1].ObjLast;
                      break;
                    end;
                  end else
                  begin //---------------------------------------------- ����� �����������
                    oe := MarhTracert[1].ObjLast;
                    break;
                  end;
                end
                else break;
              end;

              //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              MarhTracert[1].Level := tlFindTrace; //
              //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

              dec(i);
            end;

            if i < 1 then oe := MarhTracert[1].ObjLast; //------- �������� ������� �������

          end;

          while MarhTracert[1].Counter > c do
          begin //------------------ ������ �������� ����������� ����� ������������ ������
            if ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].TypeObj = 2 then // �������
            begin
              ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[10] := false;
              ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[11] := false;
              ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[12] := false;
              ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[13] := false;
            end;
            MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := 0;
            dec(MarhTracert[1].Counter);
          end;
          MarhTracert[1].MsgCount := 0;
          MarhTracert[1].WarCount := wc;
          MarhTracert[1].ObjEnd   := oe;

          if MarhTracert[1].ObjEnd > 0 then
          begin //-------------------------- ��������� ����� ���� ������ ���������� ������
            if (ObjZav[MarhTracert[1].ObjLast].TypeObj = 5) and  //- ���� ��� ������ � ...
            (MarhTracert[1].PinLast = 2) and  //------------ ������������ �� ����� 2 � ...
            not (ObjZav[MarhTracert[1].ObjLast].bParam[1] or // ��� �� ����������� ��, ...
            ObjZav[MarhTracert[1].ObjLast].bParam[2] or //�� ��������� ����������� �������
            ObjZav[MarhTracert[1].ObjLast].bParam[3] or //------------ �� ��������� �� ...
            ObjZav[MarhTracert[1].ObjLast].bParam[4]) then  //---- ��� ��������� ���������
            begin
              if ObjZav[MarhTracert[1].ObjLast].bParam[5] then //----------------------- �
              begin //--------------------- ������� �� ������� ����������� ����� ���������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,115, ObjZav[MarhTracert[1].ObjLast].Liter,1);
                InsWar(1,MarhTracert[1].ObjLast,115);
              end;

              case MarhTracert[1].Rod of // �������� �������� ������� �������� ������� ���� �������� ����-�������
                MarshP :
                begin
                  if ObjZav[MarhTracert[1].ObjLast].ObjConstB[19] and
                  not ObjZav[MarhTracert[1].ObjLast].bParam[4] then
                  begin
                    InsArcNewMsg(MarhTracert[1].ObjLast,391,1);
                    ShowShortMsg(391,LastX,LastY,ObjZav[MarhTracert[1].ObjLast].Liter);
                    exit;
                  end;
                end;

                MarshM :
                begin
                  if ObjZav[MarhTracert[1].ObjLast].ObjConstB[20] and
                  not ObjZav[MarhTracert[1].ObjLast].bParam[2] then
                  begin
                    InsArcNewMsg(MarhTracert[1].ObjLast,391,1);
                    ShowShortMsg(391,LastX,LastY,ObjZav[MarhTracert[1].ObjLast].Liter);
                    exit;
                  end;
                end;
                else result := false; exit;
              end;
            end;

            // ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
            if FindIzvStrelki(MarhTracert[1].ObjStart, MarhTracert[1].Rod) then
            begin
              inc(MarhTracert[1].WarCount);
              MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
              GetShortMsg(1,333, ObjZav[MarhTracert[1].ObjStart].Liter,7);
              InsWar(1,MarhTracert[1].ObjStart,333);
            end;

            MarhTracert[1].TailMsg := tm; //----- ������������ ��������� � ������ ��������

            if MarhTracert[1].WarCount > 0 then
            begin //------------------------------------------------- ����� ��������������
             SingleBeep := true;
{$IFNDEF TABLO}
              TimeLockCmdDsp := LastTime;
{$ENDIF}
              LockCommandDsp := true;
              CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
            end
            else CreateDspMenu(CmdMarsh_Ready,LastX,LastY);

            MarhTracert[1].Finish := true;
          end else
          begin
            MarhTracert[1].TailMsg := tm; // ������������ ��������� � ������ ��������
            InsArcNewMsg(MarhTracert[1].ObjStart,1,7); //- "����������� ����� �������� ��"
            ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
          end;
        end;
      end else
      begin
        InsArcNewMsg(MarhTracert[1].ObjStart,180,7);
        RestorePrevTrace;
        result := false;
        ShowShortMsg(180, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
      end;
    end
    else result := false;
  except
    reportf('������ [Marshrut.NextToTracertMarshrut]'); result := false;
  end;
end;
{$ENDIF}
//========================================================================================
function StepTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte) : TTracertResult;
//----------------------------------------------------------------- ��������� ���� �� ����
//-------------------------------- Con:TOZNeighbour -  ����� � �������, �� �������� ������
//--------------------------------------- Lvl:TTracertLevel ---- ���� ����������� ��������
//------------------------------------------------------------ Rod:Byte ----- ��� ��������
//------------------------------------------ Group:Byte ����� �������� � ������ ����������

var
  //o,j,k,m : integer;
  //tr,p : boolean;
  jmp : TOZNeighbour;
begin
try
  result := trStop;
  case Lvl of
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlVZavTrace, //----------- �������� ������������������ �� ������ (���������� � ������)
    tlCheckTrace,//----------------------------- �������� ������������� �� ������ ��������
    tlZamykTrace : // ��������� ������ ��������, ���� ��������� ����������� ������� ������
    begin //-------------------------------------------------- �������� ����������� ������
      if MarhTracert[Group].CIndex <= MarhTracert[Group].Counter then  //--- ���� �� �����
      begin
         //-------------------- ������ �� ��������� � ������
        if Con.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].CIndex]
        then exit; //---------------------------------------------- ���������� �����������
      end else
      if MarhTracert[Group].CIndex = MarhTracert[Group].Counter+1 then //--- ���� �� �����
      if Con.Obj <> MarhTracert[Group].ObjEnd //------------------- ������ �� ����� ������
      then exit; //------------------------------------------------ ���������� �����������
    end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    tlStepBack : //------------------------------------------------- ����� ����� �� ������
    begin
      jmp := Con; //------------------------------------ ��� ������ ����������� ������� ��
      case ObjZav[jmp.Obj].TypeObj of
        27,29 :
        begin
          if jmp.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop; //---------------------------------- ����� ������
              LnkEnd : result := trStop; //---------------------------------- ����� ������
              else  result := trNextStep;  //------------------------- ����� ������ ������
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
              else  result := trNextStep;
            end;
          end;
        end;
        else result := trStop; exit; //---------- ��� ������ �������� ������������ � �����
      end;

      if MarhTracert[Group].Counter > 0 then
      begin
        MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]:=0;//�������� �����-������
        dec(MarhTracert[Group].Counter); //-------------- ��������� ����� ��������� ������
      end
      else result := trStop;
      exit;
    end;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  jmp := Con; //------------------------- � ����������� ������� ���������� ��������� �����

  case ObjZav[jmp.Obj].TypeObj of
  //////////////////////////////////////////////////////////////////////////////////////
    2 : result := StepTraceStrelka(Con,Lvl,Rod,Group,jmp);
    3 : result := StepTraceSP(Con,Lvl,Rod,Group,jmp);
    4 : result := StepTracePut(Con,Lvl,Rod,Group,jmp);
    5 : result := StepTraceSvetofor(Con,Lvl,Rod,Group,jmp);
    7 : result := StepTracePriglas(Con,Lvl,Rod,Group,jmp);
   14 : result := StepTraceUKSPS(Con,Lvl,Rod,Group,jmp);
   15 : result := StepTraceAB(Con,Lvl,Rod,Group,jmp);
   16 : result := StepTraceVSN(Con,Lvl,Rod,Group,jmp);
   23 : result := StepTraceUvazManRn(Con,Lvl,Rod,Group,jmp);
   24 : result := StepTraceZaprosPoezdOtpr(Con,Lvl,Rod,Group,jmp);
   26 : result := StepTracePAB(Con,Lvl,Rod,Group,jmp);
   27 : result := StepTraceDZOhr(Con,Lvl,Rod,Group,jmp);
   28 : result := StepTraceIzvPer(Con,Lvl,Rod,Group,jmp);
   29 : result := StepTraceDZSP(Con,Lvl,Rod,Group,jmp);
   30 : result := StepTracePoezdSogl(Con,Lvl,Rod,Group,jmp);
   32 : result := StepTraceUvazGor(Con,Lvl,Rod,Group,jmp);
   38 : result := StepTraceMarNadvig(Con,Lvl,Rod,Group,jmp);
   41 : result := StepTraceMarshOtpr(Con,Lvl,Rod,Group,jmp);
   42 : result := StepTracePerezamStrInPut(Con,Lvl,Rod,Group,jmp);
   43 : result := StepTraceOPI(Con,Lvl,Rod,Group,jmp);
   45 : result := StepTraceZonaOpov(Con,Lvl,Rod,Group,jmp);
   else result := StepTraceProchee(Con,Lvl,Rod,Group,jmp);
  end;

  if (result = trBreak) or (lvl = tlVZavTrace) or (lvl = tlCheckTrace) or
  (lvl = tlFindIzvest) or (lvl = tlFindIzvStrel) or (lvl = tlZamykTrace)
  or (lvl = tlOtmenaMarh) then exit;

  //-- ���������� ������� ������ ��� ������ ������, � ���������, ������,������� ��������,
  //-------------------------------------------- ���������� ��������,  ������� �����������
  if MarhTracert[Group].Counter < High(MarhTracert[Group].ObjTrace) then
  begin
    inc(MarhTracert[Group].Counter);
    MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] := jmp.Obj;
  end
  else result := trStop;
except
  reportf('������ [Marshrut.TraceStep]');
  result := trStop;
end;
end;
//========================================================================================
function SoglasieOG(Index : SmallInt) : Boolean;
//------------------------------- ��������� ����������� ������ �������� �� ���������� ����
var
  i,o,p,j : integer;
begin
try
  j := ObjZav[Index].UpdateObject; // ������ ������� ���������� ����
  if j > 0 then
  begin
    result := ObjZav[j].bParam[1]; // ���� ������ �� ����������
    // ��������� ���������� �� 1-�� �����
    o := ObjZav[Index].Neighbour[1].Obj; p := ObjZav[Index].Neighbour[1].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // �������
          case p of
            2 : begin // ���� �� �����
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
            end;
            3 : begin // ���� �� ������
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break; // ������� � ������ �� �����
            end;
          else
            result := false; break; // ������ � �������� ������������ - ����������� �� � ����� �����
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;

        3 : begin // �������
          result := ObjZav[o].bParam[2]; // ��������� �������
          break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;
    if not result then exit;
    // ��������� ���������� �� 2-�� �����
    o := ObjZav[Index].Neighbour[2].Obj; p := ObjZav[Index].Neighbour[2].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // �������
          case p of
            2 : begin // ���� �� �����
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
            end;
            3 : begin // ���� �� ������
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break; // ������� � ������ �� �����
            end;
          else
            result := false; break; // ������ � �������� ������������ - ����������� �� � ����� �����
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;

        3 : begin // �������
          result := ObjZav[o].bParam[2]; // ��������� �������
          break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;

    // ��������� ������ ���������� ��� ������� ����������
    o := ObjZav[j].ObjConstI[18];
    if result and (o > 0) then
    begin
      if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
      begin
        result := false;
      end;
    end;
    o := ObjZav[j].ObjConstI[19];
    if result and (o > 0) then
    begin
      if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
      begin
        result := false;
      end;
    end;
  end else
  begin
    result := false;
  end;
except
  reportf('������ [Marshrut.SoglasieOG]');
  result := false;
end;
end;
//========================================================================================
function CheckOgrad(ptr : SmallInt; Group : Byte) : Boolean;
//------ ��������� ���������� ���� ����� �� ������� ��� �������� ������������� �����������
var
  i,o,p : integer;
begin
try
  result := true;
  for i := 1 to 10 do
    if ObjZav[Ptr].ObjConstI[i] > 0 then
    begin
      case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
        6 : begin // ���������� ����
          for p := 14 to 17 do
          begin
            if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[p] = Ptr then
            begin
              o := ObjZav[Ptr].ObjConstI[i];
              if ObjZav[o].bParam[2] then
              begin // ����������� ���������� ����
                if (not MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[10] and not ObjZav[Ptr].bParam[11]) or ObjZav[Ptr].bParam[12]) or
                   (MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].bParam[7])) then
                begin // ������� ����� � �����
                  if not ObjZav[o].ObjConstB[p*2-27] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end else
                if (not MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[10] and ObjZav[Ptr].bParam[11]) or ObjZav[Ptr].bParam[13]) or
                   (MarhTracert[Group].Povtor and (not ObjZav[Ptr].bParam[6] and ObjZav[Ptr].bParam[7])) then
                begin // ������� ����� � ������
                  if not ObjZav[o].ObjConstB[p*2-26] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //6
      end; //case
  end;
except
  reportf('������ [Marshrut.CheckOgrad]');
  result := false;
end;
end;
//========================================================================================
function CheckOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
//----------------- ��������� ��������� �������� ����������� � ���� � ����������� ��������
//-------------------- ����� ����� ������� ��� �������� ������������� ����������� ��������
var
  i,j,o,p : integer;
begin
try
  result := true;
  for i := 14 to 19 do
  begin
    p := ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[i];
    if p > 0 then
    begin
      case ObjZav[p].TypeObj of
        41 : begin //---------------------- �������� ��������� �������� ����������� � ����
          if ObjZav[p].bParam[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZav[p].ObjConstI[j];
              if o = ptr then
              begin //---------- ��������� ��������� ��������� ������� ��� ����� ���������
                if (not MarhTracert[Group].Povtor and
                (ObjZav[Ptr].bParam[10] and not ObjZav[Ptr].bParam[11])
                or ObjZav[Ptr].bParam[12]) or
                (MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[6]
                and not ObjZav[Ptr].bParam[7])) then
                begin //-------------------------------------------- ������� ����� � �����
                  if not ObjZav[p].ObjConstB[(j-1)*3+3] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end else
                if (not MarhTracert[Group].Povtor and
                (ObjZav[Ptr].bParam[10] and ObjZav[Ptr].bParam[11])
                or ObjZav[Ptr].bParam[13]) or
                (MarhTracert[Group].Povtor and (not ObjZav[Ptr].bParam[6]
                and ObjZav[Ptr].bParam[7])) then
                begin //------------------------------------------- ������� ����� � ������
                  if not ObjZav[p].ObjConstB[(j-1)*3+4] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //41
      end; //case
    end; // for
  end;
except
  reportf('������ [Marshrut.CheckOtpravlVP]');
  result := false;
end;
end;
//========================================================================================
function SignCircOgrad(ptr : SmallInt; Group : Byte) : Boolean;
// ��������� ���������� ���� ����� �� ������� ��� �������� ������������� ���������� ������
var
  i,o,p : integer;
begin
try
  result := true;
  for i := 1 to 10 do
    if ObjZav[Ptr].ObjConstI[i] > 0 then
    begin
      case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
        6 : begin //------------------------------------------------------ ���������� ����
          for p := 14 to 17 do
          begin
            if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[p] = Ptr then
            begin
              o := ObjZav[Ptr].ObjConstI[i];
              if ObjZav[o].bParam[2] then
              begin //---------------------------------------- ����������� ���������� ����
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
                begin //-------------------------------------------- ������� ����� � �����
                  if not ObjZav[o].ObjConstB[p*2-27] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end else
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                begin // ������� ����� � ������
                  if not ObjZav[o].ObjConstB[p*2-26] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //6
      end; //case
  end;
except
  reportf('������ [Marshrut.SignCircOgrad]');
  result := false;
end;
end;
//========================================================================================
function SignCircOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
//----------------- ��������� ��������� �������� ����������� � ���� � ����������� ��������
//----------------------- ����� ����� ������� ��� �������� ������������� ���������� ������
var
  i,j,o,p : integer;
begin
try
  result := true;
  for i := 14 to 19 do
  begin
    p := ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[i];
    if p > 0 then
    begin
      case ObjZav[p].TypeObj of
        41 :
        begin //--------------------------- �������� ��������� �������� ����������� � ����
          if ObjZav[p].bParam[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZav[p].ObjConstI[j];
              if o = ptr then
              begin //---------- ��������� ��������� ��������� ������� ��� ����� ���������
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
                begin //-------------------------------------------- ������� ����� � �����
                  if not ObjZav[p].ObjConstB[(j-1)*3+3] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end else
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                begin //------------------------------------------- ������� ����� � ������
                  if not ObjZav[p].ObjConstB[(j-1)*3+4] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //41
      end; //case
    end; // for
  end;
except
  reportf('������ [Marshrut.SignCircOtpravlVP]');
  result := false;
end;
end;
//========================================================================================
function NegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
//---------------------------------------------------------------- �������� ��������������
//-------------------------------------------------------------------------  ptr - �������
//------------------------------------------------------- pk - �������� ������� �� �������
//----------------------------------------- Group - �������� ���������� ��� ������ �������
var
  i,o,p : integer;
begin
  try
    result := true;
    //-------------------- ������ �������������� ����� ���� � ���������� ��������� �������
    if pk then
    begin //-------------------------------------------------------------- ������� � �����
      if (ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg) or //-------------- ������������ ����
      (ObjZav[Ptr].ObjConstB[8]) then //-------- ��� �������� ���������� ��������� �������
      begin //--------------------------------------------------- �� ���������� ����������
        o := ObjZav[Ptr].Neighbour[3].Obj; //----------------------- ������ �� �����������
        p := ObjZav[Ptr].Neighbour[3].Pin; //--------------------------- ����� �����������
        i := 100;
        while i > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 :   //-------------------------------------------------------------- �������
            begin
              case p of
                2 :   //--------------------------------------------------- ���� �� ������
                if ObjZav[o].bParam[2] then break; //---------- ������� � ������ �� ������

                3 : //------------------------------------------------  ���� �� ����������
                if ObjZav[o].bParam[1] then break; //----------- ������� � ������ �� �����

                else  ObjZav[Ptr].bParam[3] := false; break; //------ ������ � ���� ������
              end;
              p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
            end;

            3,4 :  //-------------------------------------------------------- �������,����
            begin
              if not ObjZav[o].bParam[1] then //--------------- ��������� �������� �������
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,146, ObjZav[o].Liter,1);
                InsMsg(Group,o,146);
                result := false;
              end;
              break;
            end;

            else
            if p = 1 then
            begin
              p := ObjZav[o].Neighbour[2].Pin;
              o := ObjZav[o].Neighbour[2].Obj;
            end else
            begin
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end else
  begin  //-------------------------------------------------------------- ������� � ������
    if (ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg) or //---------------- ������������ ����
    (ObjZav[Ptr].ObjConstB[7]) then    //------- ��� �������� ���������� ��������� �������
    begin //------------------------------------------------------ �� ��������� ����������
      o := ObjZav[Ptr].Neighbour[2].Obj;
      p := ObjZav[Ptr].Neighbour[2].Pin;
      i := 100;
      while i > 0 do
      begin
        case ObjZav[o].TypeObj of
          2 :
          begin //---------------------------------------------------------------- �������
            case p of
              2 :
              begin //------------------------------------------------------ ���� �� �����
                if ObjZav[o].bParam[2] then break; //---------- ������� � ������ �� ������
              end;
              3 :
              begin //----------------------------------------------------- ���� �� ������
                if ObjZav[o].bParam[1] then break; //----------- ������� � ������ �� �����
              end;
              else ObjZav[Ptr].bParam[3] := false; break; //--------- ������ � ���� ������
            end;
            p := ObjZav[o].Neighbour[1].Pin;
            o := ObjZav[o].Neighbour[1].Obj;
          end;

          3,4 :
          begin //----------------------------------------------------------- �������,����
            if not ObjZav[o].bParam[1] then //----------------- ��������� �������� �������
            begin
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,146, ObjZav[o].Liter,1);
              InsMsg(Group,o,146);
              result := false;
            end;
            break;
          end;

          else
          if p = 1 then
          begin
            p := ObjZav[o].Neighbour[2].Pin;
            o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin
            p := ObjZav[o].Neighbour[1].Pin;
            o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end;
except
  reportf('������ [Marshrut.NegStrelki]');
  result := false;
end;
end;
//========================================================================================
function SigCircNegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
//------------------------------------------ �������� �������������� ��� ���������� ������
var
  i,o,p : integer;
begin
  try
    result := true;
    //-------------------- ������ �������������� ����� ���� � ���������� ��������� �������
    if pk then
    begin //---------------------------------------------------------------- ������� � �����
      if (ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg) or //---------------- ������������ ����
      (ObjZav[Ptr].ObjConstB[8]) then //---------- ��� �������� ���������� ��������� �������
      begin //�� ���������� ����������
        o := ObjZav[Ptr].Neighbour[3].Obj;
        p := ObjZav[Ptr].Neighbour[3].Pin;
        i := 100;
        while i > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 :
            begin // �������
              case p of
                2 :
                begin // ���� �� �����
                  if ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
                end;

                3 :
                begin // ���� �� ������
                  if ObjZav[o].bParam[1] then break; // ������� � ������ �� �����
                end;

                else  ObjZav[Ptr].bParam[3] := false; break; // ������ � ���� ������
              end;
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;

            3,4 :
            begin // �������,����
              if not ObjZav[o].bParam[1] then // ��������� �������� �������
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,146, ObjZav[o].Liter,1); InsMsg(Group,o,146);
                result := false;
              end;
              break;
            end;
            else
              if p = 1 then
              begin
                p := ObjZav[o].Neighbour[2].Pin;
                o := ObjZav[o].Neighbour[2].Obj;
              end else
              begin
                p := ObjZav[o].Neighbour[1].Pin;
                o := ObjZav[o].Neighbour[1].Obj;
              end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(i);
        end;
      end;
    end else
    begin // ������� � ������
      if (ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg) or // ������������ ����
      (ObjZav[Ptr].ObjConstB[7]) then         // ��� �������� ���������� ��������� �������
      begin //�� ��������� ����������
        o := ObjZav[Ptr].Neighbour[2].Obj;
        p := ObjZav[Ptr].Neighbour[2].Pin;
        i := 100;
        while i > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 :
            begin // �������
              case p of
                2 :
                begin // ���� �� �����
                  if ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
                end;
                3 :
                begin // ���� �� ������
                  if ObjZav[o].bParam[1] then break; // ������� � ������ �� �����
                end;
                else ObjZav[Ptr].bParam[3] := false; break; // ������ � ���� ������
              end;
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;

            3,4 :
            begin // �������,����
              if not ObjZav[o].bParam[1] then // ��������� �������� �������
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,146, ObjZav[o].Liter,1);
                InsMsg(Group,o,146);
                result := false;
              end;
              break;
            end;

            else
            if p = 1 then
            begin
              p := ObjZav[o].Neighbour[2].Pin;
              o := ObjZav[o].Neighbour[2].Obj;
            end else
            begin
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(i);
        end;
      end;
    end;
  except
    reportf('������ [Marshrut.SigCircNegStrelki]');
    result := false;
  end;
end;
//========================================================================================
function VytajkaRM(ptr : SmallInt) : Boolean;
//------------------------------------------ �������� ������� �������� �� ���������� �����
var
  i,j,g,o,p,q : Integer;
  b,opi : boolean;
begin
try
  result := false;
  MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
  if ptr < 1 then exit;

  // ���������� ����
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4  : ObjZav[o].bParam[8] := false;
          43 : begin // ������ ���
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // ���� �������� ��� ��������
              ObjZav[ObjZav[o].UpdateObject].bParam[8] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // ���������� ������
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : ObjZav[o].bParam[8] := false;
          44 : begin // ������ ���
            if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] then ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] := false;
          end;
        end;
      end;
    end;
  end;
  // ���������� ������� ������� � ������
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 :
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false;
              ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := true;
            end;
          44 : begin // ���
            if ObjZav[o].bParam[2] and
               ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] and
               not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] then
            begin
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false;
              ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := true;
            end;
          end;
        end;
      end;
    end;
  end;
  // ���������� ������� ������� � �����
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 :
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false;
              ObjZav[o].bParam[12] := true; ObjZav[o].bParam[13] := false;
            end;
          44 : begin // ���
            if ObjZav[o].bParam[1] and
               ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] and
               not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] then
            begin
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false;
              ObjZav[ObjZav[o].UpdateObject].bParam[12] := true; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // ���������� ������� ������� �� ����������
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[12] := true; ObjZav[o].bParam[13] := true;
            end;
          end;
        end;
      end;
    end;
  end;
  // ��������� ������� ��� ��� ������ �������
  for i := 1 to WorkMode.LimitObjZav do
  begin
    if (ObjZav[i].TypeObj = 44) and (ObjZav[i].BaseObject = ptr) then
    begin
      if ObjZav[ObjZav[ObjZav[i].UpdateObject].UpdateObject].bParam[7] and
         not ObjZav[ObjZav[ObjZav[i].UpdateObject].UpdateObject].bParam[8] then
      begin
        ObjZav[ObjZav[i].UpdateObject].bParam[12] := ObjZav[i].bParam[1];
        ObjZav[ObjZav[i].UpdateObject].bParam[13] := ObjZav[i].bParam[2];
      end;
    end;
  end;

  // ��������� ������� �� �������
  if ObjZav[ptr].bParam[6] then
  begin // ���
    inc(MarhTracert[1].MsgCount);
    MarhTracert[1].Msg[MarhTracert[1].MsgCount] :=
    GetShortMsg(1,105,ObjZav[ptr].Liter,1);
    InsMsg(1,ptr,105);
    exit;
  end;
  if ObjZav[ptr].bParam[1] then
  begin // ��
    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ptr].Liter,1); InsMsg(1,ptr,258); exit;
  end;
  if ObjZav[Ptr].bParam[4] then
  begin // ���� ��������� �������� �� ������� - ���������:
  // ��������� ���������� �������� �� �������
    if not ObjZav[Ptr].bParam[5] then
    begin
      if ObjZav[ptr].bParam[3] then
      begin // ������� ��� �� ��������
        inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,445,ObjZav[Ptr].Liter,1); InsWar(1,ptr,445);
      end;
    end;
  // ���������� ����� �� �������� (���������� ������ ��� ����������)
    b := false; opi := false;
    for i := 1 to WorkMode.LimitObjZav do
    begin
      if (ObjZav[i].TypeObj = 48) and (ObjZav[i].BaseObject = ptr) then
      begin
        if not ObjZav[i].ObjConstB[3] then
        begin // �������������� ����������� ������ �� ���� ������ �� ����������� ������
          opi := true;
          if ObjZav[i].bParam[1] then b := true;
        end;
      end;
    end;
    if opi and not b then
    begin // ��� ���� ��������� �� ����������� ������
      inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,427,ObjZav[Ptr].Liter,1); InsMsg(1,ptr,427); exit;
    end;
  end;

  // ��������� �������������� ������� �������� �� �������
  g := ObjZav[ptr].ObjConstI[17];
  if g > 0 then
  begin
    for i := 1 to 5 do
    begin // �������� �������������� ������� �� ������
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4 : begin // ����
            if not ObjZav[o].bParam[2] or not ObjZav[o].bParam[3] then
            begin // ���������� ������� �� ���� (����������� ����� �������� �� ����)
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,341,ObjZav[o].Liter,1); InsMsg(1,o,341); exit;
            end;
          end;

          6 : begin // ���������� ����
            if ObjZav[o].bParam[2] then
            begin // ���������� �����������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,145,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,145); exit;
            end;
          end;

          23 : begin // ������ � ���������� �������
            if ObjZav[o].bParam[1] then
            begin // ���� ���
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,256,ObjZav[o].Liter,1); InsMsg(1,o,256); exit;
            end else
            if ObjZav[o].bParam[2] then
            begin // ���� ���
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,257,ObjZav[o].Liter,1); InsMsg(1,o,257); exit;
            end;
          end;

          25 : begin // ���������� �������
            if not ObjZav[o].bParam[1] then
            begin // ��� ���������� �������� �� ����������� �������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,426,ObjZav[o].Liter,1); InsMsg(1,o,426); exit;
            end;
          end;

          33 : begin // ���������� ������
            if ObjZav[o].bParam[1] then
            begin
              inc(MarhTracert[1].MsgCount);
              if ObjZav[o].ObjConstB[1] then
              begin
                MarhTracert[1].Msg[MarhTracert[1].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]]; InsMsg(1,o,3);
              end else
              begin
                MarhTracert[1].Msg[MarhTracert[1].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]]; InsMsg(1,o,2);
              end;
              exit;
            end;
          end;

          45 :
          begin //-------------------------------------------------------- ���� ����������
            if ObjZav[o].bParam[1] then
            begin //----------------------- �������� ���������� � ���� �������� ����������
              inc(MarhTracert[1].MsgCount);
              MarhTracert[1].Msg[MarhTracert[1].MsgCount] :=
              GetShortMsg(1,444,ObjZav[o].Liter,1);
              InsMsg(1,o,444);
              exit;
            end;
          end;

        end;
      end;
    end;
  end;

  // ��������� ������ �������
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            if not ObjZav[o].bParam[2] then
            begin // ������� �������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,82,ObjZav[o].Liter,1); InsMsg(1,o,82); exit;
            end;
            if not ObjZav[o].bParam[5] then
            begin // ������� �� ��������
              for p := 20 to 24 do // ����� ������� � ���������� ���������
                if (ObjZav[o].ObjConstI[p] > 0) and (ObjZav[o].ObjConstI[p] <> ptr) then
                begin
                  if not ObjZav[ObjZav[o].ObjConstI[p]].bParam[3] then
                  begin
                    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ObjZav[o].ObjConstI[p]].Liter,1); InsMsg(1,ObjZav[o].ObjConstI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZav[o].bParam[7] then
            begin // ������� ������� �� �������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,110,ObjZav[o].Liter,1); InsMsg(1,o,110); exit;
            end;
          end;
          44 : begin // ���
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[2] then
            begin // ������� �������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,82,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].UpdateObject,82); exit;
            end;
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[5] then
            begin // ������� �� ��������
              for p := 20 to 24 do // ����� ������� � ���������� ���������
                if (ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p] > 0) and (ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p] <> ptr) then
                begin
                  if not ObjZav[ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p]].bParam[3] then
                  begin
                    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p]].Liter,1); InsMsg(1,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] then
            begin // ������� ������� �� �������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,110,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].UpdateObject,110); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  // ��������� ��������� �������
  g := ObjZav[ptr].ObjConstI[20];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] or ObjZav[o].bParam[3] or ObjZav[o].bParam[4] then
        begin // ������ ������
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,114,ObjZav[o].Liter,1); InsMsg(1,o,114); exit;
        end;
      end;
    end;
  end;

  // ��������� ������� �������� �������� ������� � ������
  g := ObjZav[ptr].ObjConstI[21];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
        begin // ������� �� ����� ��������
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
        end;
      end;
    end;
  end;
  // ��������� ������� �������� �������� ������� � �����
  g := ObjZav[ptr].ObjConstI[22];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
        begin // ������� �� ����� ��������
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
        end;
      end;
    end;
  end;
  // ��������� ������� �������� ������� ������� � ������
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // ������� �� ����� ��������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and not ObjZav[ObjZav[o].UpdateObject].bParam[2] then
            begin // ������� �� ����� ��������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // ��������� ������� �������� ������� ������� � �����
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // ������� �� ����� ��������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and not ObjZav[ObjZav[o].UpdateObject].bParam[2] then
            begin // ������� �� ����� ��������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // ��������� ������� �������� ������� �� ����������
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not (ObjZav[o].bParam[1] xor ObjZav[o].bParam[2]) then
            begin // ������� �� ����� ��������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not (ObjZav[ObjZav[o].UpdateObject].bParam[1] xor ObjZav[ObjZav[o].UpdateObject].bParam[2]) then
            begin // ������� �� ����� ��������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // ��������� ���� ������
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4 : begin // ����
            if not ObjZav[o].bParam[4] and (not ObjZav[o].bParam[2] or not ObjZav[o].bParam[3]) then
            begin // ���������� �������� ������� �� ����
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,341,ObjZav[o].Liter,1); InsMsg(1,o,341); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  if WorkMode.RazdUpr then
  begin // � ������ ����������� ���������� ��������� ��������� ������� � �������� ������� �������

  // ��������� ������� ���
    g := ObjZav[ptr].ObjConstI[15];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        q := ObjZav[g].ObjConstI[i];
        if q > 0 then
        begin
          case ObjZav[q].TypeObj of
            43 : begin // ������ ���
              if ObjZav[q].bParam[1] then
              begin // ��������� ��������� ��������� �������
              // ��������������� ����� �� ���� �� ����������� ������
                opi := false;
                if ObjZav[q].ObjConstB[1] then p := 2 else p := 1;
                o := ObjZav[q].Neighbour[p].Obj; p := ObjZav[q].Neighbour[p].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // �������
                      case p of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // ���� ����������� ������ �������
                            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break;
                            opi := true; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // ���� ����������� ������ �������
                            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break;
                            opi := true; break;
                          end;
                        end;
                      end;
                      p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // ���
                      opi := true; break;
                    end;
                  else
                    if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (p < 1) then break;
                  dec(j);
                end;

              // ������� �� ����������� � ����� ��� ����, ������������ �� ��������
                if opi then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,425,ObjZav[ObjZav[q].UpdateObject].Liter,1); InsMsg(1,ObjZav[q].UpdateObject,425); exit;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  // ��������� ������� ������� � ������
    g := ObjZav[ptr].ObjConstI[23];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
              begin // ������� �� ����� �������� � -
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,267); exit;
              end;
              if not SigCircNegStrelki(o,false,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter,1); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter,1); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // ������� �� ������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. ����������?';
                InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZav[o].UpdateObject,false,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin //-------------------------------------------------- ������� �� ������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1)+ '. ����������?';
                InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // ��������� ������� ������� � �����
    g := ObjZav[ptr].ObjConstI[24];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
              begin // ������� �� ����� �������� � +
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,268); exit;
              end;
              if not SigCircNegStrelki(o,true,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter,1); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter,1); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // ������� �� ������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. ����������?';
                InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZav[o].UpdateObject,true,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // ������� �� ������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1)+ '. ����������?';
                InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // ��������� �������� ������� � ������
    g := ObjZav[ptr].ObjConstI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // ������� �� ����� �������� � -
            inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,267); exit;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // ������� �� ������
            inc(MarhTracert[1].WarCount);
            MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
            GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. ����������?';
            InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;
  // ��������� �������� ������� � �����
    g := ObjZav[ptr].ObjConstI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // ������� �� ����� �������� � +
            inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,268); exit;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // ������� �� ������
            inc(MarhTracert[1].WarCount);
            MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
            GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. ����������?';
            InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;

  end else
  if WorkMode.MarhUpr then
  begin // � ������ ����������� ���������� ��������� ����������� ����������� � ��������� ���������� �������������

    // ��������� ������� ������� � ������
    g := ObjZav[ptr].ObjConstI[23];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[2] and not ObjZav[o].bParam[12] and ObjZav[o].bParam[13] then
              begin // ������� �� ����� �������� ���������� ���������
                if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[o].BaseObject].bParam[22] or
                   ObjZav[ObjZav[o].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,267); exit;
                end;
                if ObjZav[ObjZav[o].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,80); exit;
                end;
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // ��������� �� ����������
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,159,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,159); exit;
                end;
              end;
              if not NegStrelki(o,false,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter,1); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter,1); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // ������� �� ������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. ����������?';
                InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not ObjZav[ObjZav[o].UpdateObject].bParam[2] and
                 not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[12] and
                 ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[13] then
              begin // ������� �� ����� �������� ���������� ���������
                if not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[22] or
                   ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,267); exit;
                end;
                if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,80); exit;
                end;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[18] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[18] then
              begin // ��������� �� ����������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,151); exit;
              end;
              if not NegStrelki(ObjZav[o].UpdateObject,false,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // ������� �� ������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1)+ '. ����������?';
                InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // ��������� ������� ������� � �����
    g := ObjZav[ptr].ObjConstI[24];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if ObjZav[o].bParam[12] and ObjZav[o].bParam[13] then
              begin // ���� ���� �� + � - ������� ��� ����� ������� 202
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // ��������� �� ����������
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,151); exit;
                end;
              end else
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[12] and not ObjZav[o].bParam[13] then
              begin // ������� �� ����� �������� � �����
                if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[o].BaseObject].bParam[22] or
                   ObjZav[ObjZav[o].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,268); exit;
                end;
                if ObjZav[ObjZav[o].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,80); exit;
                end;
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // ��������� �� ����������
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,121,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,121); exit;
                end;
              end;
              if not NegStrelki(o,true,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter,1); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter,1); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // ������� �� ������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. ����������?';
                InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and
                 ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[12] and
                 not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[13] then
              begin // ������� �� ����� �������� � �����
                if not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[22] or
                   ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,268); exit;
                end;
                if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,80); exit;
                end;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[18] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[18] then
              begin // ��������� �� ����������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,151); exit;
              end;
              if not NegStrelki(ObjZav[o].UpdateObject,true,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // ������� �� ������
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1)+ '. ����������?';
                InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // ��������� �������� ������� � ������
    g := ObjZav[ptr].ObjConstI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // ������� �� ����� �������� � -
            if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
               not ObjZav[ObjZav[o].BaseObject].bParam[22] or
               ObjZav[ObjZav[o].BaseObject].bParam[24] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,267); exit;
            end;
            if ObjZav[ObjZav[o].BaseObject].bParam[4] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,80); exit;
            end;
            if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
            begin // ��������� �� ����������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,235,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,235); exit;
            end;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // ������� �� ������
            inc(MarhTracert[1].WarCount);
            MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
            GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. ����������?';
            InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;

    // ��������� �������� ������� � �����
    g := ObjZav[ptr].ObjConstI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // ������� �� ����� �������� � +
            if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
               not ObjZav[ObjZav[o].BaseObject].bParam[22] or
               ObjZav[ObjZav[o].BaseObject].bParam[24] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,268); exit;
            end;
            if ObjZav[ObjZav[o].BaseObject].bParam[4] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,8); exit;
            end;
            if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
            begin // ��������� �� ����������
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,236,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,236); exit;
            end;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // ������� �� ������
            inc(MarhTracert[1].WarCount);
            MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
            GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. ����������?';
            InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;
  end;

  if MarhTracert[1].MsgCount > 0 then
  begin
    ResetTrace; exit;
  end;

  ObjZav[ptr].bParam[8] := true; // ������� ������ ������� ��
  result := true;
except
  reportf('������ [Marshrut.VytajkaRM]');
  result := false;
end;
end;
//========================================================================================
function VytajkaZM(ptr : SmallInt) : Boolean;
//----------------------------------------------- ����������� ��������� ����������� ������
var
  i,g,o : Integer;
begin
try
  result := false;
  if ptr < 1 then exit;

  // �������� �������
  ObjZav[ptr].bParam[14] := true;

  // ��������� ������ �������
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            ObjZav[o].bParam[14] := true;
          end;
          44 : begin
            if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] then
              ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // �������� ����
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4  : ObjZav[o].bParam[8] := true;
          43 : ObjZav[ObjZav[o].UpdateObject].bParam[8] := true;
        end;
      end;
    end;
  end;

  //--------------------------------------------------- ��������� ������� ������� � ������
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 :
          begin
            ObjZav[o].bParam[13] := false;
            ObjZav[o].bParam[7]  := true;
            ObjZav[o].bParam[14] := true;
          end;
          44 :
          begin
            ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[11] then
            ObjZav[ObjZav[o].UpdateObject].bParam[7] := true;
           ObjZav[ObjZav[o].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // ��������� ������� ������� � �����
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := true;
            ObjZav[o].bParam[14] := true;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false;
            if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[10] then
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := true;
            ObjZav[ObjZav[o].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // ��������� ������� ������� �� ����������
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := true;
            ObjZav[o].bParam[13] := false; ObjZav[o].bParam[7] := true;
            ObjZav[o].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

except
  reportf('������ [Marshrut.VytajkaZM]');
  result := false;
end;
end;
//========================================================================================
function VytajkaOZM(ptr : SmallInt) : Boolean;
//---------------------------------------------- ����������� ���������� ����������� ������
var
  i,g,o : Integer;
begin
try
  result := false;
  if ptr < 1 then exit;

  // ���������� �������
  ObjZav[ptr].bParam[14] := false;
  ObjZav[ptr].bParam[8]  := false; // �������� ������� ������ ������� ��

  // ���������� ������ �������
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            ObjZav[o].bParam[8] := true; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] := true; ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // ���������� ������� ������� � ������
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := false; ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false; ObjZav[ObjZav[o].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // ���������� ������� ������� � �����
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := false; ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false; ObjZav[ObjZav[o].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // ���������� ������� ������� �� ����������
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := false;
            ObjZav[o].bParam[13] := false; ObjZav[o].bParam[7] := false;
            ObjZav[o].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

except
  reportf('������ [Marshrut.VytajkaOZM]');
  result := false;
end;
end;
//========================================================================================
function VytajkaCOT(ptr : SmallInt) : string;
//------------------------------------------------------- �������� ������� ������ ��������
var
  i,g,o : Integer;
begin
try
  result := '';
  MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
  if ptr < 1 then exit;
  // ��������� ������� �� �������
  if ObjZav[ptr].bParam[2] then
  begin // ��
    result := GetShortMsg(1,259,ObjZav[ptr].Liter,1); exit;
  end;

  // ��������� ������ �������
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            if not ObjZav[o].bParam[1] then
            begin
              result := GetShortMsg(1,83,ObjZav[o].Liter,1); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[1] then
            begin
              result := GetShortMsg(1,83,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter,1); exit;
            end;
          end;
        end;
      end;
    end;
  end;
except
  reportf('������ [Marshrut.VytajkaCOT]'); result := '';
end;
end;
//========================================================================================
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
//--------------------------------- �������� ������ ��, �������� ������������ ��� ��������
var
  sp1,sp2 : integer;
begin
try
  sp1 := ObjZav[ObjZav[ObjZav[Obj].BaseObject].ObjConstI[8]].UpdateObject;
  sp2 := ObjZav[ObjZav[ObjZav[Obj].BaseObject].ObjConstI[9]].UpdateObject;
  case mode of
    1 : begin // ��������� ��
      if (sp1 > 0) and not ObjZav[sp1].bParam[2] then result := sp1 else
      if (sp2 > 0) and not ObjZav[sp2].bParam[2] then result := sp2 else
        result := ObjZav[Obj].UpdateObject;
    end;
    2 : begin // ��������� ��
      if (sp1 > 0) and not ObjZav[sp1].bParam[1] then result := sp1 else
      if (sp2 > 0) and not ObjZav[sp2].bParam[1] then result := sp2 else
        result := ObjZav[Obj].UpdateObject;
    end;
  else
    result := Obj;
  end;
except
  reportf('������ [Marshrut.GetStateSP]'); result := Obj;
end;
end;
//========================================================================================
procedure SetNadvigParam(Ptr : SmallInt);
//------------------------------------ ���������� ������� �� �� ��������� �������� �������
var
  max,o,p,nadv : integer;
begin
try
  //------------------------------------- ����� ������ �������� ������� � ���������� �����
  max := 1000; nadv := 0;
  o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin;
  while max > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 : begin // �������
        case p of
          2 : begin
            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
          end;
          3 : begin
            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
            begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
          end;
        else
          if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
          begin
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin
            p := ObjZav[o].Neighbour[3].Pin; o := ObjZav[o].Neighbour[3].Obj;
          end else
            break;
        end;
      end;
      32 : begin // ������
        nadv := o; break;
      end;
    else
      if p = 1 then
      begin
        p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
      end else
      begin
        p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
      end;
    end;
    dec(max);
  end;
  if nadv > 0 then
  begin // ��������� ������� �� �� ���������� ��������
    ObjZav[Ptr].iParam[2] := nadv;
    max := 1000;
    o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin;
    while max > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // �������
          case p of
            2 : begin
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
              begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
            end;
            3 : begin
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
              begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
            end;
          else
            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin
              p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
            end else
            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
            begin
              p := ObjZav[o].Neighbour[3].Pin; o := ObjZav[o].Neighbour[3].Obj;
            end else
              break;
          end;
        end;
        32 : begin // ������
          break;
        end;

        3 : begin // ��,��
          ObjZav[o].iParam[3] := nadv; // �������� ��������� ��
          if p = 1 then
          begin
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
        5 : begin // ��������
          if p = 1 then
          begin // �������� �������� �������� ��������� ��
            ObjZav[o].iParam[2] := nadv;
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin // ��������� �������� �������� ��������� ��
            ObjZav[o].iParam[3] := nadv;
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
      else
        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;
      dec(max);
    end;
  end;
except
  reportf('������ [Marshrut.SetNadvigParam]');
end;
end;
//========================================================================================
//----------------------------------------------- ���������� / ����� ������������ ��������
function AutoMarsh(Ptr : SmallInt; mode : Boolean) : Boolean;
var
  i,j,o,p,g,signal,hvost : integer;
  vkl : boolean;
  jmp : TOZNeighbour;
begin
  try
    vkl := true;

    if mode then //----------------------------- ������� ���������/���������� ������������
    begin //-------------------------------------------------------- �������� ������������
      for i := 10 to 12 do //--- ������ �� ������� �������� ������������ �������� ��������
      begin           //--------- ���������� ���������� ������������ ���� �������� �������
        o := ObjZav[Ptr].ObjConstI[i]; //------------------------------ ��������� ��������
        if o > 0 then
        begin
          signal := ObjZav[o].BaseObject;
          if not ObjZav[signal].bParam[4] and WorkMode.Upravlenie then //- �������� ������
          begin //----------------------------------------------------- �� ������ ��������
            result := false;
            ShowShortMsg(429,LastX,LastY,ObjZav[signal].Liter);
            InsArcNewMsg(signal,429+$4000,1); //----------------------- �� ������ ������ $
            exit;
          end;

          for j := 1 to 10 do //--------- ������ �� �������� �������� ������������ �������
          begin //-------------------------------------------- ��������� ��������� �������
            p := ObjZav[o].ObjConstI[j];
            if p > 0 then
            begin
              if not ObjZav[p].bParam[1] and WorkMode.Upravlenie then
              begin //----------------------------------- ��� �������� ��������� ���������
                result := false;
                ShowShortMsg(268,LastX,LastY,ObjZav[ObjZav[p].BaseObject].Liter);
                InsArcNewMsg(ObjZav[o].BaseObject,268+$4000,1); // ������� ��� �������� ��
                exit;
              end;
              hvost:= ObjZav[p].BaseObject;
              if (ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19])and //������� �����
              WorkMode.Upravlenie then
              begin //-------------------------------------------------- ������� �� ������
                result := false;
                ShowShortMsg(120,LastX,LastY,ObjZav[ObjZav[p].BaseObject].Liter);
                InsArcNewMsg(ObjZav[o].BaseObject,120+$4000,1);
                exit;
              end;
            end;
          end;
        end;
      end;

      //------------------------------------------ ��������� ������������ ��� ������������
      for i := 10 to 12 do
      begin
        o := ObjZav[Ptr].ObjConstI[i];
        if o > 0 then
        begin
          g := ObjZav[o].ObjConstI[25]; //-------------------------------------- ����� ���
          MarhTracert[g].Rod := MarshP;
          MarhTracert[g].Finish := false;
          MarhTracert[g].WarCount := 0;
          MarhTracert[g].MsgCount := 0;
          MarhTracert[g].ObjStart := ObjZav[o].BaseObject;
          MarhTracert[g].Counter := 0;
          j := 1000;

          jmp := ObjZav[ObjZav[o].BaseObject].Neighbour[2];

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          //MarhTracert[g].Level := tlSignalCirc;//--------------- ����� ���������� ������
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTracert[g].Level := tlSetAuto; //-------------- ����� ��������� ������������
           //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTracert[g].FindTail := true;

          while j > 0 do
          begin
            case StepTrace(jmp,MarhTracert[g].Level,MarhTracert[g].Rod,g) of
              trStop, trEnd, trEndTrace : break;
            end;
            dec(j);
          end;
          if j < 1 then vkl := false; //------------------------ ������ �������� ���������
          if MarhTracert[g].MsgCount > 0 then vkl := false;
        end;
      end;

      if not vkl and WorkMode.Upravlenie then
      begin //--------------------------------------- �������� � ��������� �� ������������
        InsArcNewMsg(Ptr,476+$4000,1);
        ShowShortMsg(476,LastX,LastY,ObjZav[Ptr].Liter); //������������ �� ����� ���� ���.
        SingleBeep4 := true;
        result := false;
        exit;
      end;

      //------------------------------------------------- ���������� �������� ������������
      for i := 10 to 12 do
      begin
        o := ObjZav[Ptr].ObjConstI[i];
        if o > 0 then
        begin
          ObjZav[o].bParam[1] := vkl;
          AutoMarshON(ObjZav[Ptr].ObjConstI[i],ObjZav[Ptr].ObjConstB[1]);
        end;
      end;
      ObjZav[Ptr].bParam[1] := vkl;
      result := vkl;
    end else
    begin //------------------------------------------------------- ��������� ������������
      for i := 10 to 12 do
      if ObjZav[Ptr].ObjConstI[i] > 0 then
      begin //--------------------------------- �������� ������������ ���� �������� ������
        ObjZav[ObjZav[Ptr].ObjConstI[i]].bParam[1] := false;
        AutoMarshOFF(ObjZav[Ptr].ObjConstI[i],ObjZav[Ptr].ObjConstB[1]);
      end;
      ObjZav[Ptr].bParam[1] := false;
      result := true;
    end;
  except
    reportf('������ [Marshrut.AutoMarsh]');
    result := false;
  end;
end;
//========================================================================================
function AutoMarshReset(Ptr : SmallInt) : Boolean;
//------------------------ ����� ������������ ��� ������ ������� ������ ��������� ��������
var
  i : integer;
begin
try
  if (Ptr > 0) and (ObjZav[Ptr].TypeObj = 47) then
  begin
    if ObjZav[Ptr].bParam[1] then
    begin
      for i := 10 to 12 do
      begin
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin //------------------------------- �������� ������������ ���� �������� ������
          ObjZav[ObjZav[Ptr].ObjConstI[i]].bParam[1] := false;
          AutoMarshOFF(ObjZav[Ptr].ObjConstI[i],ObjZav[Ptr].ObjConstB[1]);
        end;
      end;
      ObjZav[Ptr].bParam[1] := false;
      InsArcNewMsg(Ptr,422+$4000,1);
      AddFixMessage(GetShortMsg(1,422, ObjZav[Ptr].Liter,1),4,3);
    end;
    result := true;
  end else
    result := false;
except
  reportf('������ [Marshrut.AutoMarshReset]'); result := false;
end;
end;
//========================================================================================
//---------------- �������� �������� ������������ �� �������� ������ �������� ������������
function AutoMarshON(Ptr : SmallInt; Napr : Boolean) : Boolean;
var
  o,p,j,vid : integer;
begin
  result := false;
  if ObjZav[Ptr].BaseObject = 0 then exit;

  for j := 1 to 10 do
  if ObjZav[Ptr].ObjConstI[j] > 0 then
  begin
    o := ObjZav[Ptr].ObjConstI[j];
    if Napr then ObjZav[o].bParam[33] := true
    else ObjZav[o].bParam[25] := true;
    ObjZav[o].bParam[4] := ObjZav[o].bParam[33] or ObjZav[o].bParam[25];
  end;

  j := 100;
  o := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Obj;
  p := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Pin;
  ObjZav[ObjZav[Ptr].BaseObject].bParam[33] := true;
  while j > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 :  //--------------------------------------------------------------------- �������
      begin
        vid := ObjZav[o].VBufferIndex;
        OVBuffer[vid].Param[28] := ObjZav[o].bParam[4];
        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin;
          o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      3 :  //----------------------------------------------- ������ ������������ �� ������
      begin
        ObjZav[o].bParam[33] := true;

        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin;
          o := ObjZav[o].Neighbour[2].Obj;
        end  else
        begin
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      4 : //------------------------------------------------------------------------- ����
      begin
        ObjZav[o].bParam[33] := true;

        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin;
          o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      5 :  //-------------------------------------------------------------------- ��������
      begin
        if p = 1 then
        begin
          if ObjZav[o].ObjConstB[5] then break;
          ObjZav[o].bParam[33] := true;
          p := ObjZav[o].Neighbour[2].Pin;
          o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          if ObjZav[o].ObjConstB[6] then break;
          ObjZav[o].bParam[33] := true;
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      15 :
      begin //------------------------------------------------------------------------- ��
        ObjZav[o].bParam[33] := true; break;
      end;

      else //--------------------------------------------------------------- ��� ���������
      if p = 1 then
      begin
        p := ObjZav[o].Neighbour[2].Pin;
        o := ObjZav[o].Neighbour[2].Obj;
      end else
      begin
        p := ObjZav[o].Neighbour[1].Pin;
        o := ObjZav[o].Neighbour[1].Obj;
      end;
    end;

    if o < 1 then break;
    dec(j);
  end;
  result := true;
end;
//========================================================================================
//-------------------- ����� �������� ������������ � �������� ������ �������� ������������
function AutoMarshOFF(Ptr : SmallInt; Napr : Boolean) : Boolean;
var
  o,p,j,vid : integer;
begin
  result := false;
  if ObjZav[Ptr].BaseObject = 0 then exit;
  for j := 1 to 10 do
  if ObjZav[Ptr].ObjConstI[j] > 0 then
  begin
    o := ObjZav[Ptr].ObjConstI[j];
    if Napr then ObjZav[o].bParam[33] := false
    else ObjZav[o].bParam[25] := false;
    ObjZav[o].bParam[4] := ObjZav[o].bParam[25] or ObjZav[o].bParam[33];
  end;
  j := 100;
  o := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Obj;
  p := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Pin;
  ObjZav[ObjZav[Ptr].BaseObject].bParam[33] := false;
  while j > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 :
      begin //-------------------------------------------------------------------- �������
        //--------------------- ���� ������� ��� ��� ������� � ������������ ����� �� �����
        vid := ObjZav[o].VBufferIndex;
        OvBuffer[vid].Param[28] := ObjZav[o].bParam[4];
        if p = 1 then
        begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else
        begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      3 :
      begin //--------------------------------------------------------------------- ������
        ObjZav[o].bParam[33] := false;
        if p = 1 then
        begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else
        begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      4 :
      begin //----------------------------------------------------------------------- ����
        ObjZav[o].bParam[33] := false;
        if p = 1 then
        begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else
        begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      5 :
      begin //------------------------------------------------------------------- ��������
        if p = 1 then
        begin
          if ObjZav[o].ObjConstB[5] then break;
          ObjZav[o].bParam[33] := false;
          p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          if ObjZav[o].ObjConstB[6] then break;
          ObjZav[o].bParam[33] := false;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      15 :
      begin //------------------------------------------------------------------------- ��
        ObjZav[o].bParam[33] := false;
        break;
      end;
      else //--------------------------------------------------------------- ��� ���������
        if p = 1 then
        begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else
        begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
    end;
    if o < 1 then break;
    dec(j);
  end;
  result := true;
end;
//========================================================================================
function StepTraceStrelka(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------ ��������� ������� � �������� ����� ������ ���� "�������"
begin
  case Lvl of //-------------------------------------------- ������������� �� ���� �������
    tlFindTrace    :  result := StepStrelFindTrassa(Con,Lvl,Rod,Group,jmp);
    tlContTrace    :  result := StepStrelContTrassa(Con,Lvl,Rod,Group,jmp);
    tlVZavTrace    :  result := StepStrelZavTrassa(Con,Lvl,Rod,Group,jmp);
    tlCheckTrace   :  result := StepStrelCheckTrassa(Con,Lvl,Rod,Group,jmp);
    tlZamykTrace   :  result := StepStrelZamykTrassa(Con,Lvl,Rod,Group,jmp);

    tlSetAuto, tlSignalCirc : result := StepStrelSignalCirc(Con,Lvl,Rod,Group,jmp);

    tlOtmenaMarh   :  result := StepStrelOtmenaMarh(Con,Lvl,Rod,Group,jmp);
    tlRazdelSign   :  result := StepStrelRazdelSign(Con,Lvl,Rod,Group,jmp);
    tlFindIzvest   :  result := StepStrelFindIzvest(Con,Lvl,Rod,Group,jmp);
    tlFindIzvStrel :  result := StepStrelFindIzvStrel(Con,Lvl,Rod,Group,jmp);
    tlPovtorMarh   :  result := StepStrelPovtorMarh(Con,Lvl,Rod,Group,jmp);
    tlAutoTrace    :  result := StepStrelAutoTrace(Con,Lvl,Rod,Group,jmp);
    else              result := trEnd;
  end;
end;
//========================================================================================
function StepTraceSP(var Con:TOZNeighbour; const Lvl:TTracertLevel;
Rod:Byte;Group:Byte;jmp:TOZNeighbour):TTracertResult;
//----------------------------------------------------------------------- ��� ����� ������
var
  k : integer;
  tail : boolean;
begin
  case Lvl of
    tlFindTrace    : result := StepSPforFindTrace (Con, Lvl, Rod, Group, jmp);
    tlContTrace    : result := StepSPforContTrace (Con, Lvl, Rod, Group, jmp);
    tlVZavTrace    : result := StepSPforZavTrace  (Con, Lvl, Rod, Group, jmp);
    tlCheckTrace   : result := StepSPforCheckTrace(Con, Lvl, Rod, Group, jmp);
    tlZamykTrace   : result := StepSPforZamykTrace(Con, Lvl, Rod, Group, jmp);

    tlSetAuto,  tlSignalCirc   : result := StepSPSignalCirc   (Con, Lvl, Rod, Group, jmp);

    tlOtmenaMarh   : result := StepSPOtmenaMarh   (Con, Lvl, Rod, Group, jmp);
    tlRazdelSign   : result := StepSPRazdelSign   (Con, Lvl, Rod, Group, jmp);
    tlPovtorRazdel : result := StepSPPovtorRazdel (Con, Lvl, Rod, Group, jmp);
    tlAutoTrace    : result := StepSPAutoTrace    (Con, Lvl, Rod, Group, jmp);
    tlFindIzvest   : result := StepSPFindIzvest   (Con, Lvl, Rod, Group, jmp);
    tlFindIzvStrel : result := StepSPFindIzvStrel (Con, Lvl, Rod, Group, jmp);
    tlPovtorMarh   : result := StepSPPovtorMarh   (Con, Lvl, Rod, Group, jmp);
    else             result := trNextStep;
  end;
end;
//========================================================================================
function StepTracePut (var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------- (4) ��������� ���������� ���� ����������� ����� ����
//---------- Con - ����������� � �������� ��������, � �������� ������ ����� �� ������ ����
//---------- Lvl -------------------------------------------- ������� ����������� ��������
//---------- Rod ------------------------------------------------------------ ��� ��������
//---------- Group ------------------------------------ ����� �������� � ������ ����������
//---------- jmp ---------------------------------------- ������ ������������ ������� ����

var
  k : integer;
  tail : boolean;
begin
  case Lvl of

    tlFindTrace    : result := StepPutFindTrassa  (Con, Lvl, Rod, Group, jmp);
    tlContTrace    : result := StepPutContTrassa  (Con, Lvl, Rod, Group, jmp);
    tlVZavTrace    : result := StepPutZavTrassa   (Con, Lvl, Rod, Group, jmp);
    tlCheckTrace   : result := StepPutCheckTrassa (Con, Lvl, Rod, Group, jmp);
    tlZamykTrace   : result := StepPutZamykTrassa (Con, Lvl, Rod, Group, jmp);

    tlSetAuto,  tlSignalCirc : result := StepPutSignalCirc  (Con, Lvl, Rod, Group, jmp);

    tlOtmenaMarh   : result := StepPutOtmenaMarh  (Con, Lvl, Rod, Group, jmp);
    tlRazdelSign   : result := StepPutRazdelSign  (Con, Lvl, Rod, Group, jmp);
    tlAutoTrace    : result := StepPutAutoTrace   (Con, Lvl, Rod, Group, jmp);
    tlFindIzvest   : result := StepPutFindIzvest  (Con, Lvl, Rod, Group, jmp);
    tlFindIzvStrel : result := StepPutFindIzvStrel(Con, Lvl, Rod, Group, jmp);
    tlPovtorRazdel,
    tlPovtorMarh   : result := StepPutPovtorMarh  (Con, Lvl, Rod, Group, jmp);
         else        result := trEnd;
  end;
end;
//========================================================================================
function StepTraceSvetofor(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod :Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------ ������ ��� ����� �������� �� ����
//- Con : TOZNeighbour - ��� ����� Con = jmp (������ ������), ��� ������ Con - ���� ������
//--------------------------------------- Lvl : TTracertLevel ---- ���� ������ � ���������
//------------------------------------------------------------ Rod:Byte ----- ��� ��������
//------------------------------------------ Group:Byte ����� �������� � ������ ����������
//------------------------- jmp : TOZNeighbour ------  ����� � �������, �� �������� ������
//------- ����� ������� jmp.Obj - ��� ��������, ����� ������� ������� �������� ��� �� ����
begin
  case Lvl of
    tlFindTrace    :  result := StepSvetoforFindTrace  (Con, Lvl, Rod, Group, jmp);
    tlContTrace    :  result := StepSvetoforContTrace  (Con, Lvl, Rod, Group, jmp);
    tlVZavTrace    :  result := StepSvetoforZavTrace   (Con, Lvl, Rod, Group, jmp);
    tlCheckTrace   :  result := StepSvetoforCheckTrace (Con, Lvl, Rod, Group, jmp);
    tlZamykTrace   :  result := StepSvetoforZamykTrace (Con, Lvl, Rod, Group, jmp);

    tlSetAuto, tlSignalCirc : result := StepSignalCirc (Con, Lvl, Rod, Group, jmp);

    tlOtmenaMarh   :  result := StepSigOtmenaMarh      (Con, Lvl, Rod, Group, jmp);
    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign   :  result := StepSigAutoPovtorRazdel(Con, Lvl, Rod, Group, jmp);
    tlFindIzvest   :  result := StepSigFindIzvest      (Con, Lvl, Rod, Group, jmp);
    tlFindIzvStrel :  result := StepSigFindIzvStrel    (Con, Lvl, Rod, Group, jmp);
    tlPovtorMarh   :  result := StepSigPovtorMarh      (Con, Lvl, Rod, Group, jmp);
    else              result := trEnd;
  end;
end;
//========================================================================================
function StepTraceAB(var Con:TOZNeighbour; const Lvl:TTracertLevel;
Rod : Byte;Group:Byte;jmp:TOZNeighbour):TTracertResult;
//---------------------------------------- (15) ��������� ����������� ����� ��������������
//--------------------------------------------------- ������������ ������  ObjZav[jmp.Obj]
begin
  case Lvl of
    tlFindTrace : //--------------------------------------------------------- ����� ������
    begin
      result := trNextStep;
      if not MarhTracert[Group].LvlFNext then
      begin
        if Con.Pin = 1 then  //--------------------------- ���� ������� �� ������� ����� 1
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2]; //--------- �� ��������� �� ������� ����� 2
          case Con.TypeJmp of
            LnkRgn : result := trRepeat; //----------- ����� ������ ���������� - ���������
            LnkEnd : result := trRepeat; //---------------------- ����� ������ - ���������
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1]; //���� ������ �� ����� 2, �� ��������� �� 1
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end;
    end;

    tlContTrace :  //----- ������� ������ �� ��������������� ����� ��� ����������� �������
    begin
      case Rod of
        MarshP :
          if ObjZav[jmp.Obj].ObjConstB[1]     //--------- ���� ���� ����������� �� �������
          then result := trEndTrace
          else result := trStop;
        MarshM : result := trStop;
        else
          MarhTracert[Group].FullTail := true;
          result := trEndTrace;
      end;
    end;

    tlVZavTrace :  //---------------- ��������� ���������� �� ������ (����� ������ � ����)
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace : //-------------- ��������� ������ �� ����������� ������������� ��������
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[6] then //-------------------------- ���� ����� ��
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] and //- ������������ �������� ���������� � ...
            (ObjZav[jmp.Obj].bParam[7] or //------------ ���� ����������� � ���� 1 ��� ...
            ObjZav[jmp.Obj].bParam[8]) then //------------------ ���� ����������� � ���� 2
            begin //-  ���������� �������� �� ���������� - ��������� ����������� ���������
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,363, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,363); //---------------------- ��������� ���� ��������!
                                         //--- ��������� ����������� ��������� �� �������!
              MarhTracert[Group].GonkaStrel := false;
            end else
            begin //-------------------------------------- ������ �������������� ���������
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,133, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,133); // ���������� ������� �����������
                                         // �������������� ������ �� ������� $?
            end;
          end;

          if ObjZav[jmp.Obj].ObjConstB[1] then //------------- ���� ����������� �� �������
          begin
            if ObjZav[jmp.Obj].ObjConstB[2] then
            begin //--------------------- ���� ���� ����� ����������� - ��������� ��������
              if ObjZav[jmp.Obj].ObjConstB[3] then
              begin //----------------------------------------- ���� ����������� ���������
                if ObjZav[jmp.Obj].ObjConstB[4] then
                begin //------------------------------------------------ ������� �� ������
                  if (not ObjZav[jmp.Obj].bParam[7]) or
                  (ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8]) then
                  begin //---------------- �������� �� ��������� ��� ��������� �����������
                    result := trBreak;
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,132, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,132);//�� ��������� �������� ����� �����������...
                    MarhTracert[Group].GonkaStrel := false;
                  end else
                  if not ObjZav[jmp.Obj].ObjConstB[10] then  //--------- ���� �� ���������
                  begin
                    if not ObjZav[jmp.Obj].bParam[4] then //------------ �� �� �����������
                    begin
                      result := trBreak;
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                      InsMsg(Group,jmp.Obj,128);//- �� ����������� �������. �� �����������
                    end;
                  end else //---------------------------------------------- ���� ���������
                  begin
                    if not ObjZav[jmp.Obj].bParam[4] and //------------ �� �� �����������
                    not ObjZav[jmp.Obj].bParam[5]//------------------------- ����� �������
                    then
                    begin
                      result := trBreak;
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,262, ObjZav[jmp.Obj].Liter,1);
                      InsMsg(Group,jmp.Obj,262);//-------------------------- ����� �������
                    end;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[5] then //------------ ������� �� �����������
                begin
                  if ObjZav[jmp.Obj].bParam[7] then
                  begin //--------------------------------- �������� ��������� �����������
                    result := trBreak;
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,132, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,132);//�� ��������� �������� ����� �����������...
                    MarhTracert[Group].GonkaStrel := false;
                  end else
                  if ObjZav[jmp.Obj].bParam[8] then
                  begin
                    if not ObjZav[jmp.Obj].bParam[4] then //--------------------------- ��
                    begin
                      result := trBreak;
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                      InsMsg(Group,jmp.Obj,128);//�� ����������� ����������� �� �����������
                    end;
                  end;
                end;
              end else
              begin //--------------------- �������� ����� ����������� ��������� ���������
                if not ObjZav[jmp.Obj].ObjConstB[10] then  //----- ���� �� ��������� � ...
                begin
                  if not ObjZav[jmp.Obj].bParam[4] then //----------------- �� �����������
                  begin
                    result := trBreak;
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,128);// �� ����������� ����������� �� �����������
                  end;
                end else //------------------------------------------------ ���� ���������
                begin
                  if not ObjZav[jmp.Obj].bParam[4] and //--------------- �� �� �����������
                  not ObjZav[jmp.Obj].bParam[5]//--------------------------- ����� �������
                  then
                  begin
                    result := trBreak;
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,262, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,262);//---------------------------- ����� �������
                  end;
                end;
              end;
            end;
          end else
          begin //--------------------------------------------- ��� ����������� �� �������
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,131, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,131);//----------------------- ��� ����������� �� �������
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].ObjConstB[3] then  //------------- ���� ������������ ��������
          begin
            if ObjZav[jmp.Obj].ObjConstB[4] then //------------ ���� ��� ��������� - �����
            begin //------------------- � � ���������� - ����������� �� ������������� ����
              if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] then // ��
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,129);//----------------------- ����� ������� ��������
              end;
            end else
            begin //-------------------------------------- ����������� �� ����������� ����
              if not ObjZav[jmp.Obj].bParam[2] then //--------------------------------- ��
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,129);//----------------------- ����� ������� ��������
              end;
            end;
          end else //--------------------------------- ���� ��� ������������� ��������� ��
          begin
            if not ObjZav[jmp.Obj].bParam[2] then //----------------------------------- ��
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,129);//------------------------- ����� ������� ��������
            end;
          end;

          if ObjZav[jmp.Obj].bParam[9] then //------------------------ ��������� ���.�����
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,130, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,130);  //------- ��������� ������������� ����� �� �������
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].bParam[12] or
          ObjZav[jmp.Obj].bParam[13] then //- ������� ������������ ���������� ("��������")
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,432); //-------------------------------  ������� $ ������
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //--------------- ������ ��� �������� �� ��.�.
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,462);//------------- ������� �������� �� ����������� ��
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,467);//������� �������� �� ����������� ����.���� �� $
              end;
              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------- ������ ��� �������� �� ���.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,472);
              end;
            end;
          end else
          begin //--------------------------------------- ����� �������� ��������� �������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Liter,1); // ������� $ �� �������������������
            InsWar(Group,jmp.Obj,474);
          end;
        end;

        MarshM :
        begin
          //
        end;
        else   result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        if result = trBreak then exit;
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        if result = trBreak then exit;
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[6] then //------------------------------------- ��
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] and
            (ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[8]) then
            begin //-------------- ������������ �������� - ��������� ����������� ���������
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,363, ObjZav[jmp.Obj].Liter,1);
              //------ ��������� ���� ��������! ��������� ����������� ��������� �� �������
              InsMsg(Group,jmp.Obj,363);
            end else
            begin //-------------------------------------- ������ �������������� ���������
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,133, ObjZav[jmp.Obj].Liter,1);
              //---------- ���������� ������� ����������� �������������� ������ �� �������
              InsWar(Group,jmp.Obj,133);
            end;
          end;

          if ObjZav[jmp.Obj].ObjConstB[1] then
          begin //-------------------------------------------- ���� ����������� �� �������
            if ObjZav[jmp.Obj].ObjConstB[2] then
            begin //--------------------- ���� ���� ����� ����������� - ��������� ��������
              if ObjZav[jmp.Obj].ObjConstB[3] then
              begin //----------------------------------------- ���� ����������� ���������
                if ObjZav[jmp.Obj].ObjConstB[4] then
                begin //------------------------------------------------ ������� �� ������
                  if (not ObjZav[jmp.Obj].bParam[7]) or
                  (ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8]) then
                  begin //---------------- �������� �� ��������� ��� ��������� �����������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,132, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,132);
                  end else
                  if not ObjZav[jmp.Obj].ObjConstB[10] and //---------- �� ��������� � ...
                  not ObjZav[jmp.Obj].bParam[4] then //-------------------- �� �����������
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,128);
                  end;
                end else //---------------------------------------- ������� �� �����������
                if ObjZav[jmp.Obj].ObjConstB[5] then
                begin //------------------------------------------- ������� �� �����������
                  if ObjZav[jmp.Obj].bParam[7] then
                  begin //--------------------------------- �������� ��������� �����������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,132, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,132);//�� ��������� �������� ����� ����������� ��
                  end else
                  if ObjZav[jmp.Obj].bParam[8] then
                  begin
                    if not ObjZav[jmp.Obj].bParam[4] then //--------------------------- ��
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                      InsMsg(Group,jmp.Obj,128);
                    end;
                  end;
                end;
              end else
              begin //--------------------- �������� ����� ����������� ��������� ���������
                if not ObjZav[jmp.Obj].bParam[4] then //------------------------------- ��
                begin
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                  InsMsg(Group,jmp.Obj,128);
                end;
              end;
            end;
          end else
          begin //--------------------------------------------- ��� ����������� �� �������
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,131, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,131);
          end;

          if ObjZav[jmp.Obj].ObjConstB[3] then
          begin
            if ObjZav[jmp.Obj].ObjConstB[4] then
            begin //------------------------------------ ����������� �� ������������� ����
              if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] then // ��
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,129); //---------------------- ����� ������� ��������
              end;
            end else
            begin //-------------------------------------- ����������� �� ����������� ����
              if not ObjZav[jmp.Obj].bParam[2] then //--------------------------------- ��
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,129);  //--------------------- ����� ������� ��������
              end;
            end;
          end else
          begin
            if not ObjZav[jmp.Obj].bParam[2] then //----------------------------------- ��
            begin
              if Lvl= tlAutoTrace then exit;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,129);//------------------------- ����� ������� ��������
            end;
          end;

          if ObjZav[jmp.Obj].bParam[9] then //------------------------ ��������� ���.�����
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,130, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,130); //------ ��������� ������������� ����� �� ������� $
          end;

          if ObjZav[jmp.Obj].bParam[12] or
          ObjZav[jmp.Obj].bParam[13] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,432); //-------------------------------- ������� $ ������
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            //----------------------------------------------- ������ ��� �������� �� ��.�.
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,462); //---------- ������� �������� �� ����������� �� $
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and
            ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,467); //------ ������� �������� �� �� ����. ���� �� $
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,472); //----- ������� �������� �� �� �����. ���� �� $
              end;
            end;
          end else
          begin //--------------------------------------- ����� �������� ��������� �������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,474); //---------------- ������� $ �� �������������������
          end;
        end;

        MarshM :
        begin
         //
        end;
        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        if result = trBreak then exit;
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            if result = trBreak then exit;
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            end;
          end;
        end;

        tlPovtorMarh :
        begin
          MarhTracert[Group].ObjEnd := jmp.Obj; // ������������� ����� �������� �����������
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlZamykTrace :
        begin
          ObjZav[jmp.Obj].bParam[14] := true;
          ObjZav[jmp.Obj].bParam[15] := true;
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlOtmenaMarh : begin
          ObjZav[jmp.Obj].bParam[14] := false;
          ObjZav[jmp.Obj].bParam[15] := false;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlFindIzvest :
        begin
          if ObjZav[jmp.Obj].ObjConstB[2] then
          begin // ���� ����� �����������
            if ObjZav[jmp.Obj].ObjConstB[3] then
            begin // ���� ����������� ���������
              if ObjZav[jmp.Obj].ObjConstB[4] then
              begin // ������� ������������� �� ������
                if ObjZav[jmp.Obj].bParam[7] and not ObjZav[jmp.Obj].bParam[8] then
                begin
                  if ObjZav[jmp.Obj].bParam[4] then
                  begin // ������� �� ������
                    if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                    begin // ������ �����������
                      result := trBreak;
                    end else
                      result := trStop;
                  end else
                    result := trStop;
                end else
                if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                begin // ������ �����������
                  result := trBreak;
                end else
                  result := trStop;
              end else
              if ObjZav[jmp.Obj].ObjConstB[5] then
              begin // ������� ������������� �� �����������
                if not ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8] then
                begin
                  if not ObjZav[jmp.Obj].bParam[4] then
                  begin // ������� �� ������
                    if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                    begin // ������ �����������
                      result := trBreak;
                    end else
                      result := trStop;
                  end else
                  if not ObjZav[jmp.Obj].bParam[2] then result := trBreak else result := trStop;
                end else
                  result := trStop;
              end else
                result := trStop;
            end else
            begin // �������� ��������� ���������
              if not ObjZav[jmp.Obj].bParam[4] then
              begin // ������� �� ������
                if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                begin // ������ �����������
                  result := trBreak;
                end else
                  result := trStop;
              end else
              if not ObjZav[jmp.Obj].bParam[2] then result := trBreak else result := trStop;
            end;
          end else
          if ObjZav[jmp.Obj].ObjConstB[4] then
          begin // ������� ������������� �� ������
            if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
            begin // ������ �����������
              result := trBreak;
            end else
              result := trStop;
          end else
            result := trStop;
        end;

        tlFindIzvStrel :    result := trStop;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTracePriglas(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------------- ��������������� ������ (7)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlCheckTrace :
    begin
      result := trNextStep;
      if ObjZav[jmp.Obj].bParam[1] then //--------------------------------------------- ��
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,116, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,116); //------------ ������ ���������� ��������������� ������
        MarhTracert[Group].GonkaStrel := false;
      end;

      if Con.Pin = 1 then   //---------------------------------- ��������� ���������������
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else  //----------------------------------------------- �������� ���������������
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      if ObjZav[jmp.Obj].bParam[1] then //--------------------------------------------- ��
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,116, ObjZav[jmp.Obj].Liter,1);//---- ������ ���������� ���������������
        InsMsg(Group,jmp.Obj,116);
      end;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTraceUKSPS(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------------------------------------------------- ����� (14)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlCheckTrace :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if ObjZav[jmp.Obj].BaseObject = MarhTracert[Group].ObjStart then
          begin
            if ObjZav[jmp.Obj].bParam[1] then //-------------------------------------- ���
            begin
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,124, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,124);
            end else
            begin
              if ObjZav[jmp.Obj].bParam[3] then //------------------------------------ 1��
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,125, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,125);
                MarhTracert[Group].GonkaStrel := false;
              end;

              if ObjZav[jmp.Obj].bParam[4] then //------------------------------------ 2��
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,126, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,126);
                MarhTracert[Group].GonkaStrel := false;
              end;

              if ObjZav[jmp.Obj].bParam[5] then //------------------------------------ ���
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,127, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,127);
                MarhTracert[Group].GonkaStrel := false;
              end;
            end;
          end;
        end;

        MarshM,MarshL :
        begin
        end;

        else result := trStop;  exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if ObjZav[jmp.Obj].BaseObject = MarhTracert[Group].ObjStart then
          begin
            if ObjZav[jmp.Obj].bParam[1] then //-------------------------------------- ���
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,124, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,124);
            end else
            begin
              if ObjZav[jmp.Obj].bParam[3] then //------------------------------------ 1��
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,125, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,125);
              end;

              if ObjZav[jmp.Obj].bParam[4] then //------------------------------------ 2��
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,126, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,126);
              end;

              if ObjZav[jmp.Obj].bParam[5] then //------------------------------------ ���
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,127, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,127);
              end;
            end;
          end;
        end;

        MarshM,MarshL :
        begin
        end;

        else result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTraceVSN(var Con:TOZNeighbour; const Lvl:TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------------------- ��������������� ����� ����������� �� (16)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else     result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else     result := trNextStep;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else     result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc,
    tlCheckTrace :
    begin
      case Rod of
        MarshP : begin      end;
        MarshM : begin      end;
        else  result := trStop;  exit;
      end;

      result := trNextStep;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    else
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else  result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end;
  end;
end;
//========================================================================================
function StepTraceUvazManRn(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------- ������ � ���������� ������� (23)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,244, '',1);
          InsMsg(Group,jmp.Obj,244);    //----------------------- "��� �������� ���������"
          MarhTracert[Group].GonkaStrel := false;
        end;

        MarshM :
        begin
         case Con.Pin of
          1 :
          begin
            if not ObjZav[jmp.Obj].bParam[1] then //---------------------------------- ���
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,245, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,245);
              MarhTracert[Group].GonkaStrel := false;
            end;
          end;

          else
            if not ObjZav[jmp.Obj].bParam[2] then //---------------------------------- ���
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,245, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,245);
              MarhTracert[Group].GonkaStrel := false;
            end;
         end;
        end;
        else
          result := trStop;
          exit;
        end;

        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
          end;
        end;
      end;

      tlAutoTrace,
      tlPovtorRazdel,
      tlRazdelSign,
      tlSignalCirc :
      begin
        result := trNextStep;
        case Rod of
          MarshP :
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,244, '',1);
            InsMsg(Group,jmp.Obj,244);
          end;

          MarshM :
          begin
              case Con.Pin of
                1 :
                begin
                  if not ObjZav[jmp.Obj].bParam[1] then //---------------------------- ���
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,245, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,245);
                  end;
                end;
              else
                if not ObjZav[jmp.Obj].bParam[2] then //------------------------------ ���
                begin
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,245, ObjZav[jmp.Obj].Liter,1);
                  InsMsg(Group,jmp.Obj,245);
                end;
              end;
            end;
          else
            result := trStop;
            exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceZaprosPoezdOtpr(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//--------------------------------------------- ������ �������� ��������� ����������� (24)
begin
  case Lvl of
    tlFindTrace : result := trRepeat;

    tlContTrace :
    begin
      MarhTracert[Group].FullTail := true;
      result := trEndTrace;
    end;

    tlVZavTrace : result := trStop;

    tlCheckTrace :
    begin
      result := trEndTrace;
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[13] then //------------------------------------ ��
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,246, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,246); //------------------- ��� �������� ��������� ������
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].bParam[3] then //--------------------------------------- ����
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,105);//-------- ������ ������ ����������� ������� �������
            MarhTracert[Group].GonkaStrel := false;
          end;

          if not ObjZav[jmp.Obj].bParam[8] then //------------------------------------- ��
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,248, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,248); //---------- ���������� ���������� �������� �������
          end;

          if ObjZav[jmp.Obj].bParam[9] then //---------------------------------------- ���
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,249, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,249); //-------- ���������� ���������� ���������� �������
          end;

          if not ObjZav[jmp.Obj].bParam[7] then //-------------------------------------- �
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,250, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,250); //------------------------- ����� ������� �� ������
          end;

          if ObjZav[jmp.Obj].bParam[14] or
          ObjZav[jmp.Obj].bParam[15] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,432);  //------------------------------ ������� $ ������#
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //--------------- ������ ��� �������� �� ��.�.
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Title,1);
              InsWar(Group,jmp.Obj,462); //--------------- ������� �������� �� �����������
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Title,1);
                InsWar(Group,jmp.Obj,467); // ������� �������� �� �� ����������� ���� �� $
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Title,1);
                InsWar(Group,jmp.Obj,472); //-- ������� �������� �� �� ����������� ���� ��
              end;
            end;
          end else
          begin //--------------------------------------- ����� �������� ��������� �������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Title,1);
            InsWar(Group,jmp.Obj,474);
          end;
        end;

        MarshM : begin        end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trEndTrace;
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[13] then //------------------------------------ ��
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,246, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,246);   //----------------- ��� �������� ��������� ������
          end;

          if ObjZav[jmp.Obj].bParam[3] then //--------------------------------------- ����
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,105);
          end;

          if not ObjZav[jmp.Obj].bParam[8] then //------------------------------------- ��
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,248, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,248);  //--------- ���������� ���������� �������� �������
          end;

          if ObjZav[jmp.Obj].bParam[9] then //---------------------------------------- ���
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,249, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,249); //-------- ���������� ���������� ���������� �������
          end;

          if not ObjZav[jmp.Obj].bParam[7] then //-------------------------------------- �
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,250, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,250); //------------------------- ����� ������� �� ������
          end;

          if ObjZav[jmp.Obj].bParam[14] or
          ObjZav[jmp.Obj].bParam[15] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,432); //-------------------------------- ������� $ ������
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //--------------- ������ ��� �������� �� ��.�.
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Title,1);
              InsWar(Group,jmp.Obj,462); //------------ ������� �������� �� ����������� ��
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Title,1);
                InsWar(Group,jmp.Obj,467); //-- ������� �������� �� �� ����������� ���� ��
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Title,1);
                InsWar(Group,jmp.Obj,472); //----------------- ����� ���������� �������� $
              end;
            end;
          end else
          begin //--------------------------------------- ����� �������� ��������� �������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Title,1);
            InsWar(Group,jmp.Obj,474);   //-------------- ������� $ �� �������������������
          end;
        end;

        MarshM : begin      end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlFindIzvest :
    begin
      if (not ObjZav[jmp.Obj].bParam[5] and
      not ObjZav[jmp.Obj].bParam[8]) or
      not ObjZav[jmp.Obj].bParam[7] then //---------------------------- ������ �����������
      result := trBreak
      else result := trStop;
    end;

    tlFindIzvStrel : result := trStop;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTracePAB(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//-------------------------------------------------------------------------------- ���(26)
begin
  case Lvl of
    tlFindTrace :
    begin
      result := trNextStep;
      if not MarhTracert[Group].LvlFNext then
      begin
        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end;
    end;

    tlPovtorMarh,
    tlContTrace :
    begin
      case Rod of
        MarshP :
          if ObjZav[jmp.Obj].ObjConstB[1] then result := trEndTrace
          else result := trStop;

        MarshM : result := trStop;

        else result := trEndTrace;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if ObjZav[jmp.Obj].bParam[12] or
          ObjZav[jmp.Obj].bParam[13] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,432);  //------------------------------ ������� $ ������#
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //------------------ ������ ��� �������� �� ��
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,462); //------------ ������� �������� �� ����������� ��
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,467); // ������� �������� �� �� ����������� ���� �� $
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,472); // ������� �������� �� �� ����������� ���� �� $
              end;
            end;
          end else
          begin //--------------------------------------- ����� �������� ��������� �������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,474); //---------------- ������� $ �� �������������������
          end;

          if not ObjZav[jmp.Obj].bParam[7] then //------------------- �������� �� ��������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,130, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,130); //-------- ��������� ������������� ����� �� �������
            MarhTracert[Group].GonkaStrel := false;
          end else
          if not ObjZav[jmp.Obj].bParam[1] then //---------------- ������� ����� �� ������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,318, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,318); //----------------------- ������� $ ����� �� ������
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[jmp.Obj].bParam[2] then //------------------- �������� �������� ������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,319, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,319); //------------ �������� �������� ������ �� ��������
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[jmp.Obj].bParam[4] then //-------- ������ �������� �� �������� �������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,320, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,320); // ������ �������� ����������� ������ �� �������� $
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[jmp.Obj].bParam[6] then //----------------------- �������� �����������
          begin
            if not ObjZav[jmp.Obj].bParam[5] then //���� ��������� �������� �� �����������
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,299, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,299); //---------------- ������� $ ����� �� �����������
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,237, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,237); //------------- ��� �������� ����������� �� �������
          end;

          if not ObjZav[jmp.Obj].bParam[9] then //---------------------- ����� �����������
          begin
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);  //--------------------------------- ������� $ �����
          end;
        end;

        MarshM :  begin  end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if ObjZav[jmp.Obj].bParam[12] or
          ObjZav[jmp.Obj].bParam[13] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,432); //-------------------------------- ������� $ ������
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //--------------- ������ ��� �������� �� ��.�.
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,462); //---------- ������� �������� �� ����������� �� $
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,467);
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,472); //-- ������� �������� �� �� ����������� ���� ��
              end;
            end;
          end else
          begin //-------------------------------------- ����� �������� ���������� �������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,474);
          end;

          if not ObjZav[jmp.Obj].bParam[7] then //------------------- �������� �� ��������
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,130, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,130); //------ ��������� ������������� ����� �� ������� $
          end else
          if not ObjZav[jmp.Obj].bParam[1] then //---------------- ������� ����� �� ������
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,318, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,318); //----------------------- ������� $ ����� �� ������
          end else
          if ObjZav[jmp.Obj].bParam[2] then //------------------- �������� �������� ������
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,319, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,319); //---------- �������� �������� ������ �� �������� $
          end else
          if ObjZav[jmp.Obj].bParam[4] then //-------- ������ �������� �� �������� �������
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,320, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,320); // ������ �������� ����������� ������ �� �������� $
          end else
          if ObjZav[jmp.Obj].bParam[6] then //----------------------- �������� �����������
          begin
            if not ObjZav[jmp.Obj].bParam[5] then //���� ��������� �������� �� �����������
            begin
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,299, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,299); //---------------- ������� $ ����� �� �����������
            end;
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,237, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,237);  //------------ ��� �������� ����������� �� �������
          end;

          if not ObjZav[jmp.Obj].bParam[9] then //---------------------- ����� �����������
          begin
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //---------------------------------- ������� $ �����
          end;
        end;

        MarshM : begin  end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlFindIzvest :
      if not ObjZav[jmp.Obj].bParam[9] then  result := trBreak  //----- ������ �����������
      else result := trStop;


    tlFindIzvStrel : result := trStop;

    else
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end;
  end;
end;
//========================================================================================
function StepTraceDZOhr(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------------------------------------- ���������� ������� (27)
var
  o,k,m : integer;
  tr : boolean;
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;

    tlVZavTrace : //------------------------- �������� ��������� ��������� ��� �����������
    begin
      o := ObjZav[jmp.Obj].ObjConstI[1]; //------------------------ �������������� �������
      k := ObjZav[jmp.Obj].ObjConstI[3]; //------------------------------ �������� �������
      if (o > 0) and (k > 0) then
      begin
        tr := ObjZav[k].bParam[6] or ObjZav[k].bParam[7] or
        ObjZav[k].bParam[10] or ObjZav[k].bParam[11] or
        ObjZav[k].bParam[12] or ObjZav[k].bParam[13];

        m := ObjZav[k].BaseObject;

        if (ObjZav[m].ObjConstI[8] = k) and (ObjZav[m].ObjConstI[9] > 0) then
        m := ObjZav[m].ObjConstI[9]
        else
        if ObjZav[m].ObjConstI[8] > 0
        then m := ObjZav[m].ObjConstI[8] else m := 0;

        if m > 0 then
        tr := tr or ObjZav[k].bParam[6] or ObjZav[k].bParam[7] or
        ObjZav[m].bParam[10] or ObjZav[m].bParam[11] or
        ObjZav[m].bParam[12] or ObjZav[m].bParam[13];

        if ObjZav[jmp.Obj].ObjConstB[5] or tr then
        begin //---------------------------- ����������� ����� �������� ������� � ��������
          if ObjZav[jmp.Obj].ObjConstB[1] then //�������������� ������� ���������� � �����
          begin
            if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11])
            or ObjZav[o].bParam[12]) then
            begin
              if ObjZav[jmp.Obj].ObjConstB[3] then //-------- �������� ������ ���� � �����
              begin
                if (ObjZav[k].bParam[10] and ObjZav[k].bParam[11]) or
                ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[7]) or
                ObjZav[k].bParam[13] then
                begin
                  if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and //-- ������ ��
                  not ObjZav[k].bParam[14] then //-- �� ������ ���������� ������� � ������
                  begin
                    result := trStop;
                    exit; //----------------------- �������� ������������ � ������ - �����
                  end;
                end;
              end else
              if ObjZav[jmp.Obj].ObjConstB[4] then //------- �������� ������ ���� � ������
              begin
                if (ObjZav[k].bParam[10] and not ObjZav[k].bParam[11]) or
                ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[6]) or
                ObjZav[k].bParam[12] then
                begin
                  if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and //-- ������ ��
                  not ObjZav[k].bParam[14] then //-- �� ������ ���������� ������� � ������
                  begin
                    result := trStop; exit; //------ �������� ������������ � ����� - �����
                  end;
                end;
              end;
            end;
          end else
          if ObjZav[jmp.Obj].ObjConstB[2] then//�������������� ������� ���������� � ������
          begin
            if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or
            ObjZav[o].bParam[13]) then
            begin
              if ObjZav[jmp.Obj].ObjConstB[3] then //-------- �������� ������ ���� � �����
              begin
                if (ObjZav[k].bParam[10] and ObjZav[k].bParam[11]) or
                ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[7]) or
                ObjZav[k].bParam[13] then
                begin
                  if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and //-- ������ ��
                  not ObjZav[k].bParam[14] then //-- �� ������ ���������� ������� � ������
                  begin
                    result := trStop; exit; //----- �������� ������������ � ������ - �����
                  end;
                end;
              end else
              if ObjZav[jmp.Obj].ObjConstB[4] then //------- �������� ������ ���� � ������
              begin
                if (ObjZav[k].bParam[10] and not ObjZav[k].bParam[11]) or
                ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[6]) or
                ObjZav[k].bParam[12] then
                begin
                  if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and //-- ������ ��
                  not ObjZav[k].bParam[14] then //-- �� ������ ���������� ������� � ������
                  begin
                    result := trStop; exit; //------ �������� ������������ � ����� - �����
                  end;
                end;
              end;
            end;
          end;
        end else
        begin //------------------------- �� ����������� ����� �������� ������� � ��������
          if ((jmp.Pin = 1) and not ObjZav[jmp.Obj].ObjConstB[6]) or
          ((jmp.Pin = 2) and not ObjZav[jmp.Obj].ObjConstB[7]) then
          begin
            if ObjZav[jmp.Obj].ObjConstB[1] then //- �������������� ������� ���������� � +
            begin
              if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or
              ObjZav[o].bParam[12]) then
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] then //------ �������� ������ ���� � �����
                begin
                  if not (ObjZav[k].bParam[1] and not ObjZav[k].bParam[2]) then
                  begin //--------------------- �������� �� ����� �������� � ����� - �����
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268,ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,268); //- ��� �������� ����� �������
                    result := trStop;
                    exit;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[4] then //----- �������� ������ ���� � ������
                begin
                  if not (not ObjZav[k].bParam[1] and ObjZav[k].bParam[2]) then
                  begin //-------------------- �������� �� ����� �������� � ������ - �����
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,267,ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,267); // ��� �������� ������ �������
                    result := trStop;
                    exit;
                  end;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[2] then //- �������������� ������� ���������� � -
            begin
              if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or
              ObjZav[o].bParam[13]) then
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] then //------ �������� ������ ���� � �����
                begin
                  if not (ObjZav[k].bParam[1] and not ObjZav[k].bParam[2]) then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268,ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,268); //- ��� �������� ����� �������
                    result := trStop;
                    exit;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[4] then //----- �������� ������ ���� � ������
                begin
                  if not (not ObjZav[k].bParam[1] and ObjZav[k].bParam[2]) then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,267,ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,267); // ��� �������� ������ �������
                    result := trStop; exit;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;

      //--------------------------------------------------- ����� ��������� ������� ������
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      //------------ �������� ����������� ��������� �������� ������� � ��������� ���������
      o := ObjZav[jmp.Obj].ObjConstI[1]; //------------------------ �������������� �������
      k := ObjZav[jmp.Obj].ObjConstI[3]; //------------------------------ �������� �������

      if (o > 0) and (k > 0) then
      begin
        if ObjZav[jmp.Obj].ObjConstB[1] then
        begin
          if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or
          ObjZav[o].bParam[12]) then //----------�������������� ������� ���������� � �����
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] then //-- �������� ������� ������ ���� � �����
            begin
              if ObjZav[o].ObjConstI[20] = k then
              begin //--------- ������� �������� ����������� �������� �������� ����� �����
                if ObjZav[ObjZav[k].BaseObject].bParam[7] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);// �� ��������(���. � �������� +)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if not ObjZav[k].bParam[1] then
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
                inc(MarhTracert[Group].GonkaList); // ��������� ����� �������, � ���������

                if not ObjZav[k].bParam[2] then //----------------- ��� �������� ���������
                begin
                  if not ObjZav[k].bParam[6] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,81); //------ ������� $ ��� ��������
                    result := trBreak;
                    MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);// �� ��������(���. � �������� +)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- ���� ��������� ��� �
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... ���� �������� ���
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,80); //------------ ������� $ ��������
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                begin //------------------------------------------ �������� ������� ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,118, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,118);//�� ������ ��� $ � �������� �� +
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                begin //--------------------------------------- �������� ������� �� ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,136, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,136);// ��� �� ������(������ ���� ��+)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[k].bParam[18] then
                begin //--------------------------------------- �������� ������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,121, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,121);//��� ��������� (� �������� �� +)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[4] then //- �������� ������� ������ ���� � ������
            begin
              if ObjZav[o].ObjConstI[20] = k then
              begin //--------- ������� �������� ����������� �������� �������� ����� �����
                if ObjZav[ObjZav[k].BaseObject].bParam[6] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- ���� ��������� ��� �
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... ���� �������� ���
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTracert[Group].GonkaStrel := false;
                end;

              if not ObjZav[k].bParam[2] then
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
                inc(MarhTracert[Group].GonkaList); // ��������� ����� ������������ �������
                if not ObjZav[k].bParam[1] then
                begin //------------------------------------------- ��� �������� ���������
                  if not ObjZav[k].bParam[7] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,81);
                    result := trBreak;
                    MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,157, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,157);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                begin //------------------------------------------ �������� ������� ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,158, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,158);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                begin //--------------------------------------- �������� ������� �� ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,137, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,137);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[k].bParam[18] then
                begin //--------------------------------------- �������� ������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,159, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,159);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end;
          end;
        end else
        if ObjZav[jmp.Obj].ObjConstB[2] then
        begin
          if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or
          ObjZav[o].bParam[13]) then //-------- �������������� ������� ���������� � ������
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] then //-- �������� ������� ������ ���� � �����
            begin
              if ObjZav[o].ObjConstI[20] = k then
              begin //--------- ������� �������� ����������� �������� �������� ����� �����
                if ObjZav[ObjZav[k].BaseObject].bParam[7] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);//�� �������� (������� ����� � +)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- ���� ��������� ��� �
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... ���� �������� ���
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTracert[Group].GonkaStrel := false;
                end;

              if not ObjZav[k].bParam[1] then
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
                inc(MarhTracert[Group].GonkaList); // ��������� ����� ������������ �������

                if not ObjZav[k].bParam[2] then
                begin //------------------------------------------- ��� �������� ���������
                  if not ObjZav[k].bParam[6] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,81);
                    result := trBreak;
                    MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- ���� ��������� ��� �
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... ���� �������� ���
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                begin //------------------------------------------ �������� ������� ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,118, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,118);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                begin //--------------------------------------- �������� ������� �� ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,136, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,136);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[k].bParam[18] then
                begin //--------------------------------------- �������� ������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,121, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,121);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[4] then //- �������� ������� ������ ���� � ������
            begin
              if ObjZav[o].ObjConstI[20] = k then
              begin //--------- ������� �������� ����������� �������� �������� ����� �����
                if ObjZav[ObjZav[k].BaseObject].bParam[6] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- ���� ��������� ��� �
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... ���� �������� ���
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTracert[Group].GonkaStrel := false;
                end;
                
              if not ObjZav[k].bParam[2] then
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
                inc(MarhTracert[Group].GonkaList); //- ��������� ����� ����������� �������

                if not ObjZav[k].bParam[1] then
                begin //------------------------------------------- ��� �������� ���������
                  if not ObjZav[k].bParam[7] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,81);
                    result := trBreak;
                    MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,157, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,157);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                begin //------------------------------------------ �������� ������� ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,158, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,158);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                begin //--------------------------------------- �������� ������� �� ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,137, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,137);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[k].bParam[18] then
                begin //--------------------------------------- �������� ������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,159, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,159);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end;
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      //------------ �������� ����������� ��������� �������� ������� � ��������� ���������
      o := ObjZav[jmp.Obj].ObjConstI[1]; //------------------------ �������������� �������
      k := ObjZav[jmp.Obj].ObjConstI[3]; //------------------------------ �������� �������

      if (o > 0) and (k > 0) then
      begin
        if ObjZav[jmp.Obj].ObjConstB[1] then
        begin
          if ObjZav[o].bParam[1] then //-------- �������������� ������� ���������� � �����
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] then //-- �������� ������� ������ ���� � �����
            begin
              if ObjZav[k].bParam[1] then
              begin //------------------------------------ ��������� ������� ����� � �����
                if ObjZav[k].bParam[7] then
                begin //----------------------------- �������� ������� ������� � �����
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,236);
                end;
              end else
              begin
                if not ObjZav[k].bParam[2] then
                begin //------------------------------------------- ��� �������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,81);
                end else
                begin //---------------------------------------- �������� ������� � ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,236);
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[4] then //- �������� ������� ������ ���� � ������
            begin
              if ObjZav[k].bParam[2] then
              begin //------------------------------------- ��������� ������� ����� � ����
                if ObjZav[k].bParam[6] then
                begin //---------------------------------- �������� ������� ������� � ����
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,235);
                end;
              end else
              begin
                if not ObjZav[k].bParam[1] then
                begin //------------------------------------------- ��� �������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,81); //--- ������� $ �� ����� ��������
                end else
                begin //----------------------------------------- �������� ������� � �����
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,235); //-- �������� ���. � + (����� -)
                end;
              end;
            end;
          end;
        end else
        if ObjZav[jmp.Obj].ObjConstB[2] then
        begin
          if ObjZav[o].bParam[2] then //------- �������������� ������� ���������� � ������
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] then //-- �������� ������� ������ ���� � �����
            begin
              if ObjZav[k].bParam[1] then
              begin //------------------------------------ ��������� ������� ����� � �����
                if ObjZav[k].bParam[7] then
                begin //--------------------------------- �������� ������� ������� � �����
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,236);//--- �������� ���. � - (����� +)
                end;
              end else
              begin
                if not ObjZav[k].bParam[2] then
                begin //------------------------------------------- ��� �������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,81); //--- ������� $ �� ����� ��������
                end else
                begin //---------------------------------------- �������� ������� � ������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,236);//--- �������� ���. � - (����� +)
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[4] then //- �������� ������� ������ ���� � ������
            begin
              if ObjZav[k].bParam[2] then
              begin //----------------------------00------- ��������� ������� ����� � ����
                if ObjZav[k].bParam[6] then
                begin //-------------------------00------- �������� ������� ������� � ����
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,235); //00 �������� ���. � + (����� -)
                end;
              end else
              begin
                if not ObjZav[k].bParam[1] then
                begin //-----------------------00------------------ ��� �������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,81); //--- ������� $ �� ����� ��������
                end else
                begin //----------------------------------------- �������� ������� � �����
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,235); //-- �������� ���. � + (����� -)
                end;
              end;
            end;
          end;
        end;
      end;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTraceIzvPer(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp:TOZNeighbour) : TTracertResult;
//-------------------------------------------------------------- ��������� �� ������� (28)
var
  o : integer;
begin
  case Lvl of
    tlFindTrace :  //-------------------------------------------------------- ����� ������
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      o := ObjZav[jmp.Obj].BaseObject; //--------------------------------- ������ ��������
      if ObjZav[o].bParam[4] then //--------------------------------------- �� �� ��������
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,107, ObjZav[o].Liter,1);
        result := trBreak;
        InsMsg(Group,o,107);
        MarhTracert[Group].GonkaStrel := false;
      end;

      if ObjZav[o].bParam[1] then //----------------------------------- ������ �� ��������
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,143, ObjZav[o].Liter,1);
        result := trBreak;
        InsWar(Group,o,143);
        MarhTracert[Group].GonkaStrel := false;
      end;

      if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then // ������������� �� ��������
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,144, ObjZav[o].Liter,1);
        result := trBreak;
        InsWar(Group,o,144);
        MarhTracert[Group].GonkaStrel := false;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      o := ObjZav[jmp.Obj].BaseObject;
      if ObjZav[o].bParam[4] then //--------------------------------------- �� �� ��������
      begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,107, ObjZav[o].Liter,1);
            InsMsg(Group,o,107);
          end;
          if ObjZav[o].bParam[1] then
          begin // ������ �� ��������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,143, ObjZav[o].Liter,1);
            InsWar(Group,o,143);
          end;
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin // ������������� �� ��������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,144, ObjZav[o].Liter,1); InsWar(Group,o,144);
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceDZSP(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------------------------- �� ������ (29)
var
  o,k : integer;
  p : boolean;
begin
      case Lvl of
        tlFindTrace :
        begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
              else     result := trNextStep;
            end;
          end
          else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
              else     result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace :
        begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
              else     result := trNextStep;
            end;
          end
          else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
              else     result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace :
        begin
          result := trNextStep;
          if ((Con.Pin = 1) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[1]) or
          ((Con.Pin = 1) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2]) or
          ((Con.Pin = 2) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
          ((Con.Pin = 2) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[4]) then
          begin
            for k := 1 to 10 do
            begin
              o := ObjZav[jmp.Obj].ObjConstI[k];
              if o > 0 then
              begin
                case ObjZav[o].TypeObj of
                  8 :
                  begin // ���
                    if ((not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                    (ObjZav[o].bParam[1] and ObjZav[o].bParam[2])) and not ObjZav[o].bParam[3] then
                    begin // ���� ������� � ����������� � �� ����� �������� ���������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[o].Liter,1);
                      InsMsg(Group,o,109); result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end
                    else
                    if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] and
                    not ObjZav[o].bParam[3] and (Rod = MarshP) then
                    begin //--- ���� ���������� � ������� � ����������� � �������� �������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[o].Liter,1);
                      InsMsg(Group,o,108); result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end else
                    if not ObjZav[o].bParam[27] then
                    begin //------------------------- �� ���������������� ��������� �� ���
                      if ObjZav[o].bParam[3] then
                      begin //------------------------------ ���� �������� �� ������������
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,253, ObjZav[o].Liter,1);
                        InsWar(Group,o,253); result := trBreak;
                      end;
                      if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
                      begin // ���� ����������
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[o].Liter,1);
                        InsWar(Group,o,108); result := trBreak;
                      end else
                      if (not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                      (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
                      begin //--------------------------- ���� �� ����� �������� ���������
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,109, ObjZav[o].Liter,1);
                        InsWar(Group,o,109);
                        result := trBreak;
                      end;
                    end;
                    if result = trBreak then ObjZav[o].bParam[27] := true;
                  end;

                  33 : begin // ��������� ������
                    if ObjZav[o].bParam[1] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[o].ObjConstB[1] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]];
                        InsMsg(Group,o,3);
                      end else
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]];
                        InsMsg(Group,o,2);
                      end;
                      MarhTracert[Group].GonkaStrel := false;
                      result := trBreak;
                    end;
                  end;
                  // ������ ������� ������������
                  else
                end;
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc :
        begin
          result := trNextStep;
          if ((Con.Pin = 1) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[1]) or
          ((Con.Pin = 1) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2]) or
          ((Con.Pin = 2) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
          ((Con.Pin = 2) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[4]) then
          begin
            for k := 1 to 10 do
            begin
              o := ObjZav[jmp.Obj].ObjConstI[k];
              if o > 0 then
              begin
                case ObjZav[o].TypeObj of
                  8 :
                  begin // ���
                    if ((not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                    (ObjZav[o].bParam[1] and ObjZav[o].bParam[2])) and not ObjZav[o].bParam[3] then
                    begin // ���� ������� � ����������� � �� ����� �������� ���������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[o].Liter,1);
                      InsMsg(Group,o,109);
                    end else
                    if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] and
                    not ObjZav[o].bParam[3] and (Rod = MarshP) then
                    begin // ���� ���������� � ������� � ����������� � �������� �������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[o].Liter,1);
                      InsMsg(Group,o,108);
                    end else
                    if not ObjZav[o].bParam[27] then
                    begin
                      p := false;
                      if ObjZav[o].bParam[3] then
                      begin // ���� �������� �� ������������
                        p := true;
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,253, ObjZav[o].Liter,1);
                        InsWar(Group,o,253);
                      end;
                      if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
                      begin // ���� ����������
                        p := true;
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[o].Liter,1);
                        InsWar(Group,o,108);
                      end else
                      if (not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                      (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
                      begin // ���� �� ����� �������� ���������
                        p := true;
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,109, ObjZav[o].Liter,1);
                        InsWar(Group,o,109);
                      end;
                      if p then ObjZav[o].bParam[27] := true;
                    end;
                  end;

                  33 : begin // ��������� ������
                    if ObjZav[o].bParam[1] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[o].ObjConstB[1] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]];
                        InsMsg(Group,o,3);
                      end
                      else
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]];
                        InsMsg(Group,o,2);
                      end;
                    end;
                  end;
                  // ������ ������� ������������
                else

                end;
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        else
        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
            else     result := trNextStep;
          end;
        end
        else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
            else     result := trNextStep;
          end;
        end;
      end;
    end;
//========================================================================================
function StepTracePoezdSogl(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//--------------------------------------------------------- ������ ��������� �������� (30)
var
  sig_uvaz,uch_uvaz,start_tras : integer;
begin
  start_tras := MarhTracert[Group].ObjStart;
  sig_uvaz := ObjZav[jmp.Obj].BaseObject;
  uch_uvaz := ObjZav[jmp.Obj].UpdateObject;
  case Lvl of
    tlFindTrace :
    begin
      if ObjZav[Con.Obj].RU = ObjZav[start_tras].RU then
      begin //-------------------------- ���������� ����������� ���� ���� ����� ����������
        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
            else result := trNextStep;
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
            else result := trNextStep;
          end;
        end;
      end
      else result := trRepeat;
    end;

    tlContTrace :
    begin
      if ObjZav[Con.Obj].RU = ObjZav[start_tras].RU then
      begin //-------------------------- ���������� ����������� ���� ���� ����� ����������
        result := trNextStep;
        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
          end;
        end;
      end
      else result := trEndTrace; //��������� ����������� ��������, ������ ����� ����������
    end;

    tlVZavTrace :
    begin
      result := trNextStep;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if jmp.Obj = MarhTracert[Group].ObjLast then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin //-------------------------------------------------- ������ ������ ���
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,105, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,105);//- "������ ������ ����������� ������� �������"
                result := trBreak;
              end;

              if not ObjZav[sig_uvaz].bParam[4] then
              begin //--------------------------------------------- ��� ��������� ��������
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,246, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,246);  //----------- "��� �������� ��������� ������"
                result := trBreak;
              end;
            end;
          end;
        end;
      end;

      if jmp.Obj <> MarhTracert[Group].ObjLast then
      begin
        if uch_uvaz > 0 then
        begin //------------------------------------ ��������� ������������ ������� ������
          if not ObjZav[uch_uvaz].bParam[2] or not ObjZav[uch_uvaz].bParam[3] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[uch_uvaz].Liter,1);
            InsMsg(Group,uch_uvaz,113); //-------- "�� ���� ���������� ���������� �������"
            result := trBreak;
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;

      MarhTracert[Group].TailMsg := ' �� '+ ObjZav[ObjZav[jmp.Obj].BaseObject].Liter;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlSignalCirc :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] <>
          ObjZav[jmp.Obj].BaseObject then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin //-------------------------------------------------- ������ ������ ���
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,105, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,105);
              end;

              if not ObjZav[sig_uvaz].bParam[4] then
              begin //--------------------------------------------- ��� ��������� ��������
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,246, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,246);
              end;
            end;
          end;
        end;
      end;

      if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] = sig_uvaz  then
      begin
        if uch_uvaz > 0 then
        begin //------------------------------------ ��������� ������������ ������� ������
          if ObjZav[uch_uvaz].bParam[2] and ObjZav[uch_uvaz].bParam[3] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,163, ObjZav[uch_uvaz].Liter,1);
            InsMsg(Group,uch_uvaz,163);
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] <>  sig_uvaz then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin //-------------------------------------------------- ������ ������ ���
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,105, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,105);
              end;

              if not ObjZav[sig_uvaz].bParam[4] then
              begin //--------------------------------------------- ��� ��������� ��������
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,246, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,246);
              end;
            end;
          end;
        end;
      end;

      if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] = sig_uvaz then
      begin
        if uch_uvaz  > 0 then
        begin //------------------------------------ ��������� ������������ ������� ������
          if not ObjZav[uch_uvaz].bParam[2] or not ObjZav[uch_uvaz].bParam[3] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[uch_uvaz].Liter,1);
            InsMsg(Group,uch_uvaz,113);
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlZamykTrace :
    begin
      MarhTracert[Group].TailMsg := ' �� '+ ObjZav[sig_uvaz].Liter;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end;
    end;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTraceUvazGor(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------------------------------- ������ � ������ (������) (32)
var
  o : integer;
begin
      case Lvl of
        tlFindTrace : begin
          result := trRepeat;
        end;

        tlPovtorMarh,
        tlContTrace :
        begin
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlVZavTrace : begin
          result := trStop;
        end;

        tlCheckTrace : begin
          result := trBreak;
          MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter;
          if ObjZav[jmp.Obj].bParam[10] then
          begin // ��� ���� ������� ������� �� �����
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,355, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,355); MarhTracert[Group].GonkaStrel := false; exit;
          end;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter,1); InsMsg(Group,MarhTracert[Group].ObjStart,106); MarhTracert[Group].GonkaStrel := false; exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // ���������� ������ ��������� ���������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,123); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ��
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,83); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ���
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,105); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // ��� �������� �������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,103); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                 not (ObjZav[ObjZav[o].BaseObject].bParam[2] and ObjZav[ObjZav[o].BaseObject].bParam[3]) then
              begin // ���������� �������� ������� �� ���� �������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); MarhTracert[Group].GonkaStrel := false; exit;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // ��� �������� ��������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,104); MarhTracert[Group].GonkaStrel := false; exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign :
        begin
          result := trStop;
          if ObjZav[jmp.Obj].bParam[10] then
          begin // ��� ���� ������� ������� �� �����
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,355, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,355); exit;
          end;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter,1); InsMsg(Group,MarhTracert[Group].ObjStart,106); exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // ���������� ������ ��������� ���������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,123); exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ��
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,83); exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ���
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,105); exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // ��� �������� �������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,103); exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if Con.Pin = 1 then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[2] then
                begin // ���������� ������ �������� ������� �� ���� �������
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end else
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // ���������� �������� �������� ������� �� ���� �������
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // ��� �������� ��������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,104); exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlSignalCirc :
        begin
          result := trStop;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter,1); InsMsg(Group,MarhTracert[Group].ObjStart,106); exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // ���������� ������ ��������� ���������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,123); exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ��
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,83); exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ���
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,105); exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // ��� �������� �������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,103); exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if Con.Pin = 1 then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[2] then
                begin // ���������� ������ �������� ������� �� ���� �������
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end else
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // ���������� �������� �������� ������� �� ���� �������
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // ��� �������� ��������
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,104); exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlFindIzvest : begin
          if ObjZav[jmp.Obj].bParam[11] then
          begin // ������ �����������
            result := trBreak;
          end else
            result := trStop;
        end;

        tlFindIzvStrel : result := trStop;

        else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceMarNadvig(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//-------------------------------------------------------- �������� �������� �������  (38)
begin
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          MarhTracert[Group].PutNadviga := jmp.Obj; // ��������� ������ ������� �������� ������� � ����
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc : begin
          MarhTracert[Group].PutNadviga := jmp.Obj; // ��������� ������ ������� �������� ������� � ����
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceMarshOtpr(var Con : TOZNeighbour;
const Lvl : TTracertLevel; Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------------------------- �������� �������� ����������� (41)
var
  k,o,hvost,s_v_put : integer;
begin
  result := trNextStep;
  s_v_put := jmp.Obj;
  case Lvl of
    tlFindTrace : //--------------------------------------------------------- ����� ������
    begin
      result := trNextStep;
      if Con.Pin = 1 then Con := ObjZav[s_v_put].Neighbour[2]
      else Con := ObjZav[s_v_put].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlPovtorMarh,
    tlContTrace,
    tlVZavTrace,
    tlFindIzvest,
    tlFindIzvStrel :
    begin
      result := trNextStep;
      if Con.Pin = 1 then  Con := ObjZav[s_v_put].Neighbour[2]
      else  Con := ObjZav[s_v_put].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;

      if Con.Pin = 1 then //--------------------- ���� � ������ ��  ������� ��� 1 (������)
      begin
        Con := ObjZav[s_v_put].Neighbour[2];
        if (Rod = MarshP) and ObjZav[s_v_put].ObjConstB[1] then //�������� � ��������� ���
        begin
          ObjZav[s_v_put].bParam[21] := true; //-------- ����������� ��������� �����������
          for k := 1 to 4 do //----------------------- ������ �� ��������� �������� � ����
          begin
            o := ObjZav[s_v_put].ObjConstI[k]; //------------- ����� ������ ������� � ����
            if o > 0 then
            begin
              hvost := ObjZav[o].BaseObject;

              if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
              begin //------------------------- ������� � ���� �� ����� �������� ���������
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,81, ObjZav[hvost].Liter,1);
                InsMsg(Group,hvost,81);//----------- ������� $ �� ����� �������� ���������
                MarhTracert[Group].GonkaStrel := false;
                exit;
              end else
              if (ObjZav[hvost].bParam[4] or //------ ���� � ������� ���.��������� ��� ...
              ObjZav[hvost].bParam[14]) and //----------------- ����������� ��������� �...
              ObjZav[hvost].bParam[21] then //------------------------ ��� ��������� �� ��
              begin //--------------------------- �������� ������� ������������ � ��������
                if (ObjZav[s_v_put].ObjConstB[k*3+1] and //���������� �� "-" ������� � ...
                ObjZav[hvost].bParam[6]) or //-------------------- ���� ������� �� ��� ...
                (ObjZav[s_v_put].ObjConstB[k*3] and //---- ���������� �� "+" ������� � ...
                ObjZav[hvost].bParam[7]) then //-------------------------- ���� ������� ��
                begin //------------------------ ����������� � ������ �������� �����������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[hvost].Liter,1); //----------- ������� $ ��������
                  InsMsg(Group,hvost,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if (not ObjZav[o].bParam[1] or ObjZav[o].bParam[2]) and //- �� � ����� � ...
              (not ObjZav[hvost].bParam[21]) and (Rod = MarshP) then //-- ������� ��������
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,80, ObjZav[hvost].Liter,1);
                InsMsg(Group,hvost,80);//----------- ������� $ �� ����� �������� ���������
                MarhTracert[Group].GonkaStrel := false;
                exit;
              end;

              if ObjZav[s_v_put].ObjConstB[k*3+2] then // ���� ������������� ����� �������
              begin
                if ObjZav[s_v_put].ObjConstB[k*3] and //---------- ���������� �� "+" � ...
                not ObjZav[o].bParam[1] then  //----------------------- ������� �� � �����
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then //--- ��� ������� ������� ...
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    if not ObjZav[hvost].bParam[21] then //-���� �������� ������� ��������
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,117, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,117); //-------------- ���������� ������ ��������
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if not ObjZav[hvost].bParam[22] then //------- �������� ������� ������
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,118, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,118); //--------------- ���������� ������ ������
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[hvost].bParam[15] or   //-------- ���� ������� �� ������ ���
                    ObjZav[hvost].bParam[19] then   //-------------------- �� ����� ������
                    begin //----------------------------------- �������� ������� �� ������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,136, ObjZav[hvost].Liter,1);//----- ������� $ �� ������.
                      InsMsg(Group,hvost,136);//����� ��������� ������ ���� ���������� � +
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[o].bParam[18] then //------------ �������� ������� ���������
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,121, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,121);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- ���� ��������� ������� � ����
                    if ObjZav[hvost].bParam[21] and //----- ���� ��� ��������� �� �� � ...
                    ObjZav[hvost].bParam[22] then  //----------------- ��� ��������� �� ��
                    begin //------------------------------- ������� �������� � �� ��������
                      if ObjZav[hvost].bParam[15] or //------------- ������� �� ������ ���
                      ObjZav[hvost].bParam[19] then //-------------------- �� ����� ������
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,136); //"������� �� ������, ������� �������� +"
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;

                      if ObjZav[o].bParam[18] then
                      begin //--------------------------------- �������� ������� ���������
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,121, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,121); //------- ������� ��������� �� ����������
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZav[hvost].bParam[15] or
                      ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                        GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                        InsWar(Group,hvost,136); //----- ������� �� ������, ������� � ����
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and
                not ObjZav[o].bParam[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    if not ObjZav[hvost].bParam[21] then
                    begin //------------------------------------ �������� ������� ��������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,117, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,117); //---------------------- ������ �� ��������
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if not ObjZav[hvost].bParam[22] then
                    begin //-------------------------------------- �������� ������� ������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,118, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,118);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[hvost].bParam[15] or
                    ObjZav[hvost].bParam[19] then
                    begin //----------------------------------- �������� ������� �� ������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,137);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[o].bParam[18] then
                    begin //----------------------------------- �������� ������� ���������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,159, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,159);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- ���� ��������� ������� � ����
                    if ObjZav[hvost].bParam[21] and
                    ObjZav[hvost].bParam[22] then
                    begin //------------------------------- ������� �������� � �� ��������
                      if ObjZav[hvost].bParam[15] or
                      ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,137);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;

                      if ObjZav[o].bParam[18] then
                      begin //--------------------------------- �������� ������� ���������
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,159, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,159);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                        GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                        InsWar(Group,hvost,137);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end;
                  end;
                end;
              end else
              begin //--------------------- ���������� ����� ������� � ���� �� �����������
                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if (ObjZav[s_v_put].ObjConstI[k+4] = 0) or
                  (ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22]) then
                  begin //- ��� ����.�����. ��� ������� � ���� ��� ��� ���������,���������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[o].Liter,1);
                    InsMsg(Group,hvost,268);
                    MarhTracert[Group].GonkaStrel := false;
                    exit;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if (ObjZav[s_v_put].ObjConstI[k+4] = 0) or
                  (ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22]) then
                  begin //-- ��� ����.�����.��� ������� � ���� ��� ��� ���������,���������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,267, ObjZav[o].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,267);
                    MarhTracert[Group].GonkaStrel := false;
                    exit;
                  end;
                end;
              end;
            end;
          end;
        end
        else ObjZav[s_v_put].bParam[21] := false;
      end else
      begin
        Con := ObjZav[s_v_put].Neighbour[1];

        if (Rod = MarshP) and ObjZav[s_v_put].ObjConstB[2] then
        begin
          ObjZav[s_v_put].bParam[21] := true;
          for k := 1 to 4 do
          begin
            o := ObjZav[s_v_put].ObjConstI[k];
            if o > 0 then
            begin
              hvost := ObjZav[o].BaseObject;
              if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
              begin //------------------------- ������� � ���� �� ����� �������� ���������
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,81, ObjZav[hvost].Liter,1);
                InsMsg(Group,hvost,81);
                MarhTracert[Group].GonkaStrel := false; exit;
              end else

              if (ObjZav[hvost].bParam[4] or ObjZav[hvost].bParam[14]) and
              ObjZav[hvost].bParam[21] then
              begin //--------------------------- �������� ������� ������������ � ��������
                if (ObjZav[s_v_put].ObjConstB[k*3+1] and ObjZav[hvost].bParam[6]) or
                (ObjZav[s_v_put].ObjConstB[k*3] and ObjZav[hvost].bParam[7]) then
                begin //------------------------ ����������� � ������ �������� �����������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[hvost].Liter,1);
                  InsMsg(Group,hvost,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if (not ObjZav[o].bParam[1] or ObjZav[o].bParam[2]) and //- �� � ����� � ...
              (not ObjZav[hvost].bParam[21]) and (Rod = MarshP) then //-- ������� ��������
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,80, ObjZav[hvost].Liter,1);
                InsMsg(Group,hvost,80);//------------------------------ ������� $ ��������
                MarhTracert[Group].GonkaStrel := false;
                exit;
              end;

              if ObjZav[s_v_put].ObjConstB[k*3+2] then
              begin //------------------------ ���������� ����� ������� � ���� �����������
                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    if not ObjZav[hvost].bParam[21] then
                    begin //------------------------------------ �������� ������� ��������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,117, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,117);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if not ObjZav[hvost].bParam[22] then
                    begin //-------------------------------------- �������� ������� ������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,118, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,118);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                    begin //----------------------------------- �������� ������� �� ������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,136);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[o].bParam[18] then
                    begin //----------------------------------- �������� ������� ���������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,121, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,121);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- ���� ��������� ������� � ����
                    if ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22] then
                    begin //------------------------------- ������� �������� � �� ��������
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,136);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;

                      if ObjZav[o].bParam[18] then
                      begin //--------------------------------- �������� ������� ���������
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,121, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,121);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                        GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                        InsWar(Group,hvost,136);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    if not ObjZav[ObjZav[o].BaseObject].bParam[21] then
                    begin //------------------------------------ �������� ������� ��������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,117, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,117);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if not ObjZav[hvost].bParam[22] then
                    begin //-------------------------------------- �������� ������� ������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,118, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,118);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                    begin //----------------------------------- �������� ������� �� ������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,137);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[o].bParam[18] then
                    begin //----------------------------------- �������� ������� ���������
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,159, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,159);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- ���� ��������� ������� � ����
                    if ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22] then
                    begin //------------------------------- ������� �������� � �� ��������
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,137);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;

                      if ObjZav[o].bParam[18] then
                      begin //--------------------------------- �������� ������� ���������
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,159, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,159);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                        GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                        InsWar(Group,hvost,137);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end;
                  end;
                end;
              end else
              begin //--------------------- ���������� ����� ������� � ���� �� �����������
                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if (ObjZav[s_v_put].ObjConstI[k+4] = 0) or
                  (ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22]) then
                  begin //- ��� ����.�����. ��� ������� � ���� ��� ��� ���������,���������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[o].Liter,1);
                    InsMsg(Group,hvost,268);
                    MarhTracert[Group].GonkaStrel := false; exit;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if (ObjZav[s_v_put].ObjConstI[k+4] = 0) or
                  (ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22]) then
                  begin //- ��� ����.�����. ��� ������� � ���� ��� ��� ���������,���������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,267, ObjZav[o].Liter,1);
                    InsMsg(Group,hvost,267);
                    MarhTracert[Group].GonkaStrel := false; exit;
                  end;
                end;
              end;
            end;
          end;
        end
        else ObjZav[s_v_put].bParam[21] := false;
      end;

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
      end;
    end;

    //----------------------- ������������ ��������� ������ �������� ---------------------
    tlZamykTrace :
    begin
      ObjZav[s_v_put].bParam[21] := false;//---- ������� ����������� ��������� �����������

      if Con.Pin = 1 then
      begin
        Con := ObjZav[s_v_put].Neighbour[2];

        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;

        if ObjZav[s_v_put].ObjConstB[1] then //--------------------- ���� ��������� 1->2
        begin
          if Rod = MarshP then ObjZav[s_v_put].bParam[20] := true //�������� �����������
          else ObjZav[s_v_put].bParam[20] := false;
        end;
      end else
      if Con.Pin = 2 then
      begin
        Con := ObjZav[s_v_put].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;

        if ObjZav[s_v_put].ObjConstB[2] then //--------------------- ���� ��������� 2->1
        begin
          if Rod = MarshP then ObjZav[s_v_put].bParam[20] := true //�������� �����������
          else ObjZav[s_v_put].bParam[20] := false;
        end;
      end
      else  ObjZav[s_v_put].bParam[20] := false; //------------ ������ ����� �����������
    end;

    tlAutoTrace,
    tlSignalCirc,
    tlPovtorRazdel,
    tlRazdelSign :
    begin
      result := trNextStep;
      if Con.Pin = 1 then
      begin
        if ObjZav[s_v_put].ObjConstB[1] then
        begin
          if Rod = MarshP then
          begin
            ObjZav[s_v_put].bParam[20] := true;
            ObjZav[s_v_put].bParam[21] := true;
            for k := 1 to 4 do
            begin
              o := ObjZav[s_v_put].ObjConstI[k];
              if o > 0 then
              begin
                if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
                begin //----------------------- ������� � ���� �� ����� �������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[o].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[o].BaseObject,81);
                end;

                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else
                  if ObjZav[ObjZav[o].BaseObject].bParam[21] and
                  ObjZav[ObjZav[o].BaseObject].bParam[22] then
                  begin //--------------------------------------- ��� ���������, ���������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else
                  if not ObjZav[ObjZav[s_v_put].UpdateObject].bParam[2] then
                  begin //������.������ ��������� ������� � ���� ��� ��������� �������� ��
                    if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[5] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[10] then
                      begin //-------------------------------- ���������� ������ ���������
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,481, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],481);
                      end else //------------------------------------- ���������� ��������
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,272, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],272);
                      end;
                    end;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else

                  if ObjZav[ObjZav[o].BaseObject].bParam[21] and
                  ObjZav[ObjZav[o].BaseObject].bParam[22] then
                  begin //--------------------------------------- ��� ���������, ���������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else

                  if not ObjZav[ObjZav[s_v_put].UpdateObject].bParam[2] then
                  begin //-- ������.������ ��������� ���. � ���� ��� ��������� �������� ��
                    if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[5] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[10] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,481, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],481);
                      end else // ���������� ��������

                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,272, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],272);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end else
          begin
            ObjZav[s_v_put].bParam[20] := false;
            ObjZav[s_v_put].bParam[21] := false;
          end;
        end else
        begin
          ObjZav[s_v_put].bParam[20] := false;
          ObjZav[s_v_put].bParam[21] := false;
        end;

        if result = trNextStep then
        begin
          Con := ObjZav[s_v_put].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end else
      begin
        if ObjZav[s_v_put].ObjConstB[2] then
        begin
          if Rod = MarshP then
          begin
            ObjZav[s_v_put].bParam[20] := true;
            ObjZav[s_v_put].bParam[21] := true;
            for k := 1 to 4 do
            begin
              o := ObjZav[s_v_put].ObjConstI[k];
              if o > 0 then
              begin
                if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
                begin //----------------------- ������� � ���� �� ����� �������� ���������
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[o].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[o].BaseObject,81);
                end;

                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else
                  if ObjZav[ObjZav[o].BaseObject].bParam[21] and
                  ObjZav[ObjZav[o].BaseObject].bParam[22] then
                  begin //--------------------------------------- ��� ���������, ���������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else

                  if not ObjZav[ObjZav[s_v_put].UpdateObject].bParam[2] then
                  begin //-- ������.������ ��������� ��� � ���� ��� ���������� �������� ��
                    if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[5] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      //-------------------------------------- ���������� ������ ���������
                      if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[10] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,481, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],481);
                      end else //------------------------------------- ���������� ��������
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,272, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],272);
                      end;
                    end;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else
                  if ObjZav[ObjZav[o].BaseObject].bParam[21] and
                  ObjZav[ObjZav[o].BaseObject].bParam[22] then
                  begin //--------------------------------------- ��� ���������, ���������
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else

                  if not ObjZav[ObjZav[s_v_put].UpdateObject].bParam[2] then
                  begin //-- ������.������ ��������� ���. � ���� ��� ��������� �������� ��
                    if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[5] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[10] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,481, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],481);
                      end else // ���������� ��������
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,272, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],272);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end else
          begin
            ObjZav[s_v_put].bParam[20] := false;
            ObjZav[s_v_put].bParam[21] := false;
          end;
        end else
        begin
          ObjZav[s_v_put].bParam[20] := false;
          ObjZav[s_v_put].bParam[21] := false;
        end;
        if result = trNextStep then
        begin
          Con := ObjZav[s_v_put].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end;
    end;

    tlOtmenaMarh :
    begin
      if ObjZav[s_v_put].bParam[5] then ObjZav[s_v_put].bParam[20] := false;
      ObjZav[s_v_put].bParam[21] := false;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[s_v_put].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[s_v_put].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    else result := trNextStep;
   end;
end;
//========================================================================================
function StepTracePerezamStrInPut(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------ �������� ������������� ��������� ������ ��� ������� � ���� (42)
var
  k,o : integer;
begin
  case Lvl of
    //----------------------------- � � � � �   � � � � � � ------------------------------
    tlFindTrace :
    begin
      result := trNextStep;
      //------------- ��� ������ ������ ��������� �������� ��������� ������ ������� � ����
      if Rod = MarshP then
      MarhTracert[Group].VP := jmp.Obj;

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlVZavTrace,   //--------- �������� ������������������ �� ������ (���������� � ������)
    tlContTrace :  //----- ������� ������ �� ��������������� ����� ��� ����������� �������
    begin
      result := trNextStep;

      if Rod = MarshP then MarhTracert[Group].VP := jmp.Obj; //��������� ������ ��� ������

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    //--------------------------- � � � � � � � �   � � � � � �  -------------------------
    tlCheckTrace :
    begin
      if Rod = MarshP then
      begin
        for k := 1 to 4 do //--------------------- ������ �� 4-� ��������� �������� � ����
        begin
          o := ObjZav[jmp.Obj].ObjConstI[k];
          if o > 0 then
          begin //-------------------- ��������� ������� ����������� �� "-" ������� � ����
            if ObjZav[o].bParam[13] then
            begin// ��������� ����������� ���� ���� ���� �� "-" ������� � ����
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,482, ObjZav[ObjZav[o].BaseObject].Liter,1);
              InsWar(Group,ObjZav[o].BaseObject,482);
              break;
            end;
          end;
        end;
      end;
      result := trNextStep;

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else  Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlPovtorMarh,
    tlFindIzvest,
    tlFindIzvStrel :
    begin
      result := trNextStep;

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlZamykTrace :
    begin
      result := trNextStep;
      if Rod = MarshP then ObjZav[jmp.Obj].bParam[1] := true; //- ������� ��������� ������

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlAutoTrace,
    tlSignalCirc,
    tlPovtorRazdel,
    tlRazdelSign :
    begin
      if Rod = MarshP then MarhTracert[Group].VP:= jmp.Obj;//������� ������ ������� � ����
      result := trNextStep;

      if Rod = MarshP then ObjZav[jmp.Obj].bParam[1] := true; //- ������� ��������� ������

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlOtmenaMarh :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    else result := trNextStep;
  end;
end;
//========================================================================================
function StepTraceOPI(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------------------------------- ��� (43)
var
  j,k,o : integer;
  tr : boolean;
begin
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          tr := true;
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              o := ObjZav[jmp.Obj].BaseObject;
              if o > 0 then
              begin // ��������������� ����� �� ���� �� ����������� ������
                k := 2;
                o := ObjZav[jmp.Obj].Neighbour[k].Obj; k := ObjZav[jmp.Obj].Neighbour[k].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // �������
                      case k of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // ������� ����� ��������� � ����� �� ������
                            tr := false; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // ������� ����� ��������� � ����� �� �����
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // ���
                      break;
                    end;
                  else
                    if k = 1 then begin k := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (k < 1) then break;
                  dec(j);
                end;
              end;
              if tr then // ��� ��������� ������� �� ������ �� ����� ����� �����
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end else
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // �� � ���
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              o := ObjZav[jmp.Obj].BaseObject;
              if o > 0 then
              begin // ��������������� ����� �� ���� �� ����������� ������
                k := 1;
                o := ObjZav[jmp.Obj].Neighbour[k].Obj; k := ObjZav[jmp.Obj].Neighbour[k].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // �������
                      case k of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // ������� ����� ��������� � ����� �� ������
                            tr := false; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // ������� ����� ��������� � ����� �� �����
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // ���
                      break;
                    end;
                  else
                    if k = 1 then begin k := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (k < 1) then break;
                  dec(j);
                end;
              end;
              if tr then // ��� ��������� ������� �� ������ �� ����� ����� �����
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end else
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // �� � ���
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // �� � ���
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258);
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // �� � ���
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258);
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceZonaOpov(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------------------- ���� ���������� (45)
begin
      case Lvl of
        tlFindTrace :
        begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;

        tlVZavTrace,
        tlFindIzvest,
        tlZamykTrace,
        tlOtmenaMarh,
        tlFindIzvStrel,
        tlPovtorMarh,
        tlContTrace :
        begin
          result := trNextStep;
          if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
          else Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlSetAuto,  
        tlSignalCirc,
        tlPovtorRazdel,
        tlRazdelSign,
        tlCheckTrace :
        begin
          result := trNextStep;
          if ObjZav[jmp.Obj].bParam[1] then
          begin //------------------------------------------- �������� ���������� ��������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,456, ObjZav[jmp.Obj].Liter,1); //-- $ ���������� �������� ��������
            InsWar(Group,jmp.Obj,456);
          end;
          if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
          else Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlAutoTrace :
        begin
          result := trNextStep;
          if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
          else Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        else result := trNextStep;
      end;
    end;
//========================================================================================
function StepTraceProchee(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//--------------------------------------- ������ ������� (������� ����� ���� ��� ��������)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;
    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelFindTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  Strelka : integer;
//---------------------------------------------------- ������ �� ������� ��� ������ ������
begin
  Strelka :=  jmp.Obj;
  result := trNextStep;
  case Con.Pin of //--------------- ������������� �� ����� ����� ����� ��������� � �������
    1 : //------------------------------------------------------------------ ������ ������
    begin
      if ObjZav[Strelka].ObjConstB[1] then //--------------------------- ���� ������������
      begin //------------------------- ������������ ������� ������������ ������ �� ������
        Con := ObjZav[Strelka].Neighbour[3]; //------------------ ����� ������ - �� ������
        ObjZav[Strelka].bParam[10] := true; //--------------------- �������� ������ ������
        ObjZav[Strelka].bParam[11] := true; //--------------------- �������� ������ ������
      end
      else
      begin //------------------------------------------------------------ ������� �������
        if ObjZav[Strelka].ObjConstB[3] then //---------- ���� �������� �������� �� ������
        begin
          if not ObjZav[Strelka].bParam[10] then //---------- ���� �� ���� ������� �������
          begin //----------------------------------------- ������� ���� �� ������ �������
            Con := ObjZav[Strelka].Neighbour[3]; //----------- ��������� �� ������� ������
            ObjZav[Strelka].bParam[10] := true; //----------------- �������� ������ ������
            ObjZav[Strelka].bParam[11] := true; //----------------- �������� ������ ������
          end else
          begin //----------------------------- ��� ������ ������� ������ �� ����� �������
            Con := ObjZav[Strelka].Neighbour[2]; //------ ����� �� ��������� ������� �����
            ObjZav[Strelka].bParam[11] := false; //---------------- �������� ������ ������
          end;
        end else//---------------------------------------- ���� �������� �������� �� �����
        begin
          if ObjZav[Strelka].bParam[10] then //-------- ���� ������ ������ ����������� ���
          begin //-------------------------------- �� ������ ������ ���� �� ������ �������
            Con := ObjZav[Strelka].Neighbour[3];
            ObjZav[Strelka].bParam[11] := true; //-------------- �������� ��������� ������
          end else
          begin //---------------------------------------- ������� ������ �� ����� �������
            Con := ObjZav[Strelka].Neighbour[2];
            ObjZav[Strelka].bParam[10] := true; //-------------- �������� ��������� ������
          end;
        end;
      end;

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
        else result := trNextStep;
      end;
    end;

    2 ://--------------------------------------------------------------- �� ������ � �����
    begin
      ObjZav[Strelka].bParam[12] := true; //------------ �������� ������ �� ������ � �����
      Con := ObjZav[Strelka].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
        else result := trNextStep;
      end;
    end;

    3 ://-------------------------------------------------------------- �� ������ � ������
    begin
      ObjZav[Strelka].bParam[13] := true; //----------- �������� ������ �� ������ � ������
      Con := ObjZav[Strelka].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelContTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------------------- ������ ����� ������� ��� ��������� ������
var
  p : boolean;
  k : integer;
begin
  result := trNextStep;
  p := false;

  case Con.Pin of
    1 ://------------------------------------------------- ��������������� ���� �� �������
    begin
      if MarhTracert[Group].VP >0 then //--------- ���� �� ��� ����������� �������� ������
      begin //-------------------------------------------- ������ �� ������ ������� � ����
        //--- �������� ��������� ������� � ����, ���� ��� ���  � ����� �� �������� ������
        for k := 1 to 4 do //---------------------------- ����� ���� �� 4-� ������� � ����
        if(ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and //-- ���� ��� �������
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then //-------- ������� ������ ������
        begin //-------------------------------------------- ������������ ������� �� �����
          Con := ObjZav[jmp.Obj].Neighbour[2]; //------------- �������� ��������� �� �����
          ObjZav[jmp.Obj].bParam[10] := true;  //------------------ ���������� 1-�� ������
          ObjZav[jmp.Obj].bParam[11] := false; //----------------------- ����� 2-�� ������
          ObjZav[jmp.Obj].bParam[12] := false; //---------------- ����� ���������� � �����
          ObjZav[jmp.Obj].bParam[13] := false; //--------------- ����� ���������� � ������
          result := trNextStep;
          p := true;
          break;
        end;

        if not p then
        begin //----------------------- ������� �� ������� � ������� ������ ������� � ����
          con := ObjZav[jmp.Obj].Neighbour[1]; //-------------- ��������� �� ������� �����
          result := trBreak; //--------------------------------------- �������� �� �������
        end;
      end else //------------------------------------------------------ ��� ������� � ����

      if ObjZav[jmp.Obj].ObjConstB[1] then //------------------- ���� ������������ �������
      begin //------------------ ������������ ������� ������ ������������ ������ �� ������
        Con := ObjZav[jmp.Obj].Neighbour[3]; //---------------- ����� ��������� �� �������
        ObjZav[jmp.Obj].bParam[10] := true; //------------- ���� ������ ������ �����������
        ObjZav[jmp.Obj].bParam[11] := true; //------------- ���� ������ ������ �����������
        ObjZav[jmp.Obj].bParam[12] := false; //--------------------- ���������� �� � �����
        ObjZav[jmp.Obj].bParam[13] := false; //-------------------- ���������� �� � ������
        result := trNextStep;
      end else
      begin //------------------------------------------ ��� ������� � ���� � ������������
        con := ObjZav[jmp.Obj].Neighbour[1]; //-------------------- ��������� ����� ������
        result := trBreak; //----------------------------------------- �������� �� �������
      end;
    end;

    2 :
    begin //---------------------------------- ���������� ������ �� ������� �� ������� "+"
      ObjZav[jmp.Obj].bParam[12] := true; //------------ �������� ������ �� ������ � �����
      Con := ObjZav[jmp.Obj].Neighbour[1]; //----------- ��������� �� ������� ����� �� ���
      case Con.TypeJmp of  //--------------------------------------------- ���� ����������
        LnkRgn : result := trStop; //--------------------------- �������� ��������� ������
        LnkEnd : result := trStop; //--------------------------- �������� ��������� ������
        else result := trNextStep;
      end;
    end;

    3 :
    begin //--------------------------------------------- ���������� ������ �� ������� "-"
      ObjZav[jmp.Obj].bParam[13] := true; //----------- �������� ������ �� ������ � ������
      Con := ObjZav[jmp.Obj].Neighbour[1];//------------ ��������� �� ������� ����� �� ���
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
        else  result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelZavTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------------- ������ ����� ������� ��� �������� ������������
var
  k : integer;
begin
  result := trNextStep;
  case Con.Pin of
    1 :
    begin //-------------------------��������������� ����, ��������� �� ������ �������
      if MarhTracert[Group].VP > 0 then //���� ���� ������� � ���� � �������� ��������
      begin //--------------------------------------------- ���� ������ ������� � ����
        for k := 1 to 4 do
        if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and//���� ���.� ����
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then //������� ������ ������ �� +
        begin //------------------------------ ��������� ����������� ������� �� ������
          if ObjZav[jmp.Obj].bParam[10] and ObjZav[jmp.Obj].bParam[11]
          then exit;
        end;
      end;

      if ObjZav[jmp.Obj].bParam[10] and not ObjZav[jmp.Obj].bParam[11] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end else
      if ObjZav[jmp.Obj].bParam[10] and ObjZav[jmp.Obj].bParam[11] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[12]  then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].bParam[13] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepStrelCheckTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------ ��� ����� ������� ��� �������� ������������� �� ������ ��������
var
  zak : boolean;
  o : integer;
begin
  result := trNextStep;
  //------------------ ������� ��������� ��������� �������� ����������� �� �������� � ����
  if not CheckOtpravlVP(jmp.Obj,Group) then result := trBreak;

  //------------------------------------ ������ ��������� ���������� ���� ����� �� �������
  if not CheckOgrad(jmp.Obj,Group) then result := trBreak;

  if ObjZav[jmp.Obj].ObjConstB[6] then //------------------ ���� ������� "�������" �� ����
  zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16] //-------- ������� �������� ��� ���
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17]; //------ ����� ������� ������

  if ObjZav[jmp.Obj].bParam[16] or zak then //----------- ���� �� ������� ������� ��������
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1);  //------- ������� $ ������� ��� ��������
    InsMsg(Group,jmp.Obj,119);
    MarhTracert[Group].GonkaStrel := false;
  end;

  case Con.Pin of
    1 : //-------------------------------------------------- ���� �� ������� ����� ����� 1
    begin
      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin //-------------------------- ������� �� ������������ ��� ������� �� ����������
        if ObjZav[jmp.Obj].ObjConstB[6] then    //------------------- ���� ������� �������
        zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //---------------------------- ������� ������� ��� ���������������� ��������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);//---- ������� $ ������� ��� ���������������� ��������
          MarhTracert[Group].GonkaStrel := false;
        end;
      end;

      if (not MarhTracert[Group].Povtor and //------------ �� ��������� ������� �������� �
      (ObjZav[jmp.Obj].bParam[10] and //---------------------- ������ ������ ����������� �
      not ObjZav[jmp.Obj].bParam[11])) or //------------- �� ������ ������ ����������� ���

      (MarhTracert[Group].Povtor and  //--------------------- ��������� ������� �������� �
      (ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and //---------------------- ���� �� �
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7])) then//---- ��� �� (���. ���� � +)
      begin
        if not NegStrelki(jmp.Obj,true,Group)
        then result := trBreak;//------------------------------------------ ��������������

        if ObjZav[jmp.Obj].bParam[1] then //--------------------------------- ���� ���� ��
        begin
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then //--------- ���� �� ������
          begin //------------------------------ ������� �� ������ - ������ ��������������
            if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then //---- ���� �����. ����.
            begin //---------------------- ��������� �������������� ��� ���������� �������
              if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3]=jmp.Obj then //�� ������
              begin
                result := trBreak;
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
                InsWar(Group,jmp.Obj,120); //------------------------- ������� $ �� ������
              end;
            end else
            begin
              if not MarhTracert[Group].Dobor then
              begin
                ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj;
                ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
              end;
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);//--------- ������� $ �� ������
            end;
          end;
        end else
        begin
          if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
          inc(MarhTracert[Group].GonkaList);//-- ��������� ���� ����������� ������� ������
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
          begin //--------------------------------------= ������� �� ������ - ������������
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,136, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);

            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,136);
            //������� $ �� ������. ����� ���������� �������� ������ ���� ���������� � ����

            MarhTracert[Group].GonkaStrel := false;
          end;

          if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then //----��������� ������
          begin
            o := GetStateSP(1,jmp.Obj);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,82, ObjZav[o].Liter,1);
            InsMsg(Group,o,82); //-------------------------------------  ������� $ �������
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstB[3] and//���� ���� ��������� ��� �
          not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[20] then //..... ���� �������� ���
          begin
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
            ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,392, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,392);// ���� �������� ������� ��������. ��������� �������
            MarhTracert[Group].GonkaStrel := false;
          end;



          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] then //------ ��������� � ������
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); //------------ ������� $ ��������
            MarhTracert[Group].GonkaStrel := false;
          end;

          if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then //------ ������� �� ��
          begin
            o := GetStateSP(2,jmp.Obj);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[o].Liter,1);
            InsMsg(Group,o,83); //---------------------------------------- ������� $ �����
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].bParam[18] then
          begin //---------------------------------------- ������� ��������� �� ����������
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,121, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);

            //-------------------- ������� $ ��������� �� ���������� (� �������� �� �����)
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,121);

            MarhTracert[Group].GonkaStrel := false;
          end;

          if MarhTracert[Group].Povtor then
          begin //---------------------------------- �������� ��������� ��������� ��������
            if not ObjZav[jmp.Obj].bParam[2] then //------------------------------- ��� ��
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //------ ������� $ ��� ��������
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else
          begin //-------------------------------- �������� ��������� ����������� ��������
            if not ObjZav[jmp.Obj].bParam[2] and  //----------------------------- ��� �� �
            not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then  //-------------- ��� ��
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //------ ������� $ ��� ��������
              MarhTracert[Group].GonkaStrel := false;
            end;
          end;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);
          MarhTracert[Group].GonkaStrel := false;
        end
        else  con := ObjZav[jmp.Obj].Neighbour[2];

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end else //-------------------------------------------------- ������� �� ���� � ����
      if (not MarhTracert[Group].Povtor and //------------------- �� ������ �������� � ...
      (ObjZav[jmp.Obj].bParam[10] and //------------------------------ ������ ������ � ...
      ObjZav[jmp.Obj].bParam[11])) or //---------------------------- ������ ������ ��� ...
      (MarhTracert[Group].Povtor and  //------------------------------------- ������ � ...
      (not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and  //-------------- ��� �� � ...
      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7])) then //---------------------- ���� ��
      begin
        if  not NegStrelki(jmp.Obj,false,Group) then result := trBreak; //------ ���������

        if ObjZav[jmp.Obj].bParam[2] then //-------------------------------------- ���� ��
        begin
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then //----- ���� ���.�� ������
          begin //------------------------------ ������� �� ������ - ������ ��������������
            if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then  //-------- �������� ���
            begin //---------------------- ��������� �������������� ��� ���������� �������
              if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then //--- ��� ���
              begin
                result := trBreak;
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
                InsWar(Group,ObjZav[jmp.Obj].BaseObject,120); //------ ������� $ �� ������
              end;
            end else //---------------------------------------------- �� ���� �������� ���
            begin
              if not MarhTracert[Group].Dobor then  //------------------- �� ����� "�����"
              begin
                ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj; //----- ���������
                ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true; //-----  ���� �����
              end;
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
            end;
          end;
        end else //---------------------------------------------------------------- ��� ��
        begin
          if not MarhTracert[Group].Povtor and //--------------- �� ������� �������� � ...
          not MarhTracert[Group].Dobor //-------------------------------------- �� "�����"
          then inc(MarhTracert[Group].GonkaList);//--- ��������� ����� ����������� �������

          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
          begin //--------------------------------------- ������� �� ������ - ������������
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,137, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);

            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,137);
            //������� $ �� ������.����� ���������� �������� ������ ���� ���������� � �����

            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstB[3] and//���� ���� ��������� ��� �
          not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[20] then //..... ���� �������� ���
          begin
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
            ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,392, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,392);// ���� �������� ������� ��������. ��������� �������
            MarhTracert[Group].GonkaStrel := false;
          end;

          if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then //---- ��������� �� ��
          begin
            o := GetStateSP(1,jmp.Obj);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,82, ObjZav[o].Liter,1); InsMsg(Group,o,82);//--- ������� $ �������
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] or ObjZav[jmp.Obj].bParam[4] then
          begin //---------------------------------------------------- ��������. ���������
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); //------------ ������� $ ��������
            MarhTracert[Group].GonkaStrel := false;
          end else
          if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then //------- ��������� ��
          begin
            o := GetStateSP(2,jmp.Obj);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[o].Liter,1);
            InsMsg(Group,o,83); //---------------------------------------- ������� $ �����
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[jmp.Obj].bParam[18] then
          begin //---------------------------------------- ������� ��������� �� ����������
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,159, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);

            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,159);
            //------------------- ������� $ ��������� �� ���������� (� �������� �� ������)

            MarhTracert[Group].GonkaStrel := false;
          end;

          if MarhTracert[Group].Povtor then
          begin //---------------------------------- �������� ��������� ��������� ��������
            if not ObjZav[jmp.Obj].bParam[1] then //------------------------------- ��� ��
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //------ ������� $ ��� ��������
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else
          begin //-------------------------------- �������� ��������� ����������� ��������
            if not ObjZav[jmp.Obj].bParam[1] and  //------------------------------- ��� ��
            not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
              MarhTracert[Group].GonkaStrel := false;
            end;
          end;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then //------------------- ���� ��
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);  //------------- ������� $ ��������
          MarhTracert[Group].GonkaStrel := false;
        end;

        con := ObjZav[jmp.Obj].Neighbour[3]; //------------ ����� �� ������� �� ����������
        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
        exit;
      end
      else result := trStop;
    end;

    2 : //------------------------------------------------ ���� ����� ������ ����� �������
    begin
      if  not NegStrelki(jmp.Obj,true,Group) then result := trBreak; //--------- ���������

      if ObjZav[jmp.Obj].bParam[1] then //----------------------------------- ���� ���� ��
      begin
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
        begin //-------------------------------- ������� �� ������ - ������ ��������������
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
          begin //------------------------ ��������� �������������� ��� ���������� �������
            if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then
            begin
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
            end;
          end else
          begin
            if not MarhTracert[Group].Dobor then
            begin
              ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj;
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
            end;
            result := trBreak;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
          end;
        end;
      end else
      begin
        if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor
        then inc(MarhTracert[Group].GonkaList); //---- ��������� ����� ����������� �������

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
        begin //----------------------------------------- ������� �� ������ - ������������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,136, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,136);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then  //----- ��������� �� ��
        begin
          o := GetStateSP(1,jmp.Obj);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,82, ObjZav[o].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,82);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstB[3] and//���� ���� ��������� ��� �
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[20] then //..... ���� �������� ���
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
          ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,392, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,392);//-- ���� �������� ������� ��������. ��������� �������
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] then  //----------- ���. ���������
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then  //-------- ��������� ��
        begin
          o := GetStateSP(2,jmp.Obj);
          result := trBreak; inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[o].Liter,1); InsMsg(Group,o,83);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[jmp.Obj].bParam[18] then
        begin //------------------------------------------ ������� ��������� �� ����������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,121, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,121);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if MarhTracert[Group].Povtor then
        begin //------------------------------------ �������� ��������� ��������� ��������
          if not ObjZav[jmp.Obj].bParam[2] then //--------------------------------- ��� ��
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
            MarhTracert[Group].GonkaStrel := false;
          end;
        end else
        begin //---------------------------------- �������� ��������� ����������� ��������
          if not ObjZav[jmp.Obj].bParam[2] and
          not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;

      if (not MarhTracert[Group].Povtor and //---------------------------- �� ������ � ...
      ObjZav[jmp.Obj].bParam[12]) or //----------------- ������������� ����������� ��� ...

      (MarhTracert[Group].Povtor and //-------------------------------------- ������ � ...
      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and  //----------------------- �� � ...
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7]) then  //------------------ ��� ��
      begin
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then //-------------------- ��� ��
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); //-------------- ������� $ ��������
          MarhTracert[Group].GonkaStrel := false;
        end else
        if not ObjZav[jmp.Obj].bParam[1] and //------------------------- ���� ��� �� � ...
        not ObjZav[jmp.Obj].bParam[2] and //--------------------------------- ��� �� � ...
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then //---------------- ��� ��...
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);//----------- ������� $ ��� ��������
          MarhTracert[Group].GonkaStrel := false;
        end;

        con := ObjZav[jmp.Obj].Neighbour[1]; //---------------- ����� ����� ���� (����� 1)

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    3 : //----------------------------------------------- ���� �� ������� ����� ����������
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then//----������� ������������ � ������� ����������
      begin
        if ObjZav[jmp.Obj].ObjConstB[6] //-------------------------------- ������� �������
        //----------------------- ����� ����� �������� �� FR4 ������� ��� ����������������
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        //----------------------- ����� ����� �������� �� FR4 ������� ��� ����������������
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //---------------------------- ������� ������� ��� ���������������� ��������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);//------- ������� $ ������� ��� ���������������� ����.
          MarhTracert[Group].GonkaStrel := false;
        end;
      end;

      if  not NegStrelki(jmp.Obj,false,Group)
      then result := trBreak; //------------------------------------------- ��������������

      if ObjZav[jmp.Obj].bParam[2] then //----------------------------------- ���� ���� ��
      begin
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
        begin //-------------------------------- ������� �� ������ - ������ ��������������
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
          begin //------------------------ ��������� �������������� ��� ���������� �������
            if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then
            begin
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
            end;
          end else
          begin
            if not MarhTracert[Group].Dobor then
            begin
              ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj;
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
            end;
            result := trBreak;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);//----------- ������� $ �� ������
          end;
        end;
      end else //------------------------------------------------------------- ���� ��� ��
      begin
        if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor
        then inc(MarhTracert[Group].GonkaList);//------��������� ����� ����������� �������

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
        begin //----------------------------------------- ������� �� ������ - ������������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,137, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,137);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then //--------- ��������� ��
        begin
          o := GetStateSP(1,jmp.Obj);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,82, ObjZav[o].Liter,1);
          InsMsg(Group,o,82);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstB[3] and//���� ���� ��������� ��� �
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[20] then //..... ���� �������� ���
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
          ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,392, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,392); //- ���� �������� ������� ��������. ��������� �������
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] or  ObjZav[jmp.Obj].bParam[4] then
        begin  //---------------------------------------------------------- ���. ���������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then //--------- ��������� ��
        begin
          o := GetStateSP(2,jmp.Obj);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[o].Liter,1);
          InsMsg(Group,o,83);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[jmp.Obj].bParam[18] then //------------- ������� ��������� �� ����������
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,159, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,159);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if MarhTracert[Group].Povtor then //-------- �������� ��������� ��������� ��������
        begin
          if not ObjZav[jmp.Obj].bParam[1] then
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
            MarhTracert[Group].GonkaStrel := false;
          end;
        end else
        begin //---------------------------------- �������� ��������� ����������� ��������
          if not ObjZav[jmp.Obj].bParam[1] and //---------------------------- ��� �� � ...
          not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then //----------------- ��� ��
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //-------- ������� $ ��� ��������
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;

      if (not MarhTracert[Group].Povtor and //------------------- �� ������ �������� � ...
      ObjZav[jmp.Obj].bParam[13]) or //------------ ���������� � �������� � ������ ��� ...

      (MarhTracert[Group].Povtor and //----------------------------- ������ �������� � ...
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and //------- ��� �� � ������ � ...
      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7]) then  //------------- ���� �� � ������
      begin
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then //---------- ���� � ������ ��
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);
          MarhTracert[Group].GonkaStrel := false;
        end else  //------------------------------------------------- ���� � ������ ��� ��
        if not ObjZav[jmp.Obj].bParam[1] and  //----------------------------- ��� �� � ...
        not ObjZav[jmp.Obj].bParam[2] and  //-------------------------------- ��� �� � ...
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then //---------- ��� �� � ������
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //------------ ������� ��� ��������
          MarhTracert[Group].GonkaStrel := false;
        end;

        con := ObjZav[jmp.Obj].Neighbour[1]; //------------ ������� �� ������� ����� ��� 1

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepStrelZamykTrassa(var Con : TOZNeighbour; const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//--------------------------------������ ����� ������� �� ����� ��������� ��������� ������
var
  p,mk : boolean;
begin
  result := trNextStep;
  case Con.Pin of
    1 :
    begin
      p := false; mk := false;
      if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and
      not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then
      begin //--------------------------------------------------------- ��� ��������� � ��
        if ObjZav[jmp.Obj].bParam[10] then
        begin
          if ObjZav[jmp.Obj].bParam[11] then
          begin //-------------------------------------------------- ����������� �� ������
            mk := true;
            p := false;
          end else
          begin //--------------------------------------------------- ����������� �� �����
            p := true;
            mk := false;
          end;
        end;
      end else //--------------------------------------------------- ���� ��������� ��� ��
      begin
        if ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] then
        begin //--------------------------------------------------- ���� �������� �� �����
          p := true;
          mk := false;
        end else
        if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
        begin //-------------------------------------------------- ���� �������� �� ������
          mk := true;
          p := false;
        end;
      end;

      if p and //--------------------------------------------------------- ���� ���� � ...
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then //--------------------- ��� ��
      begin
        con := ObjZav[jmp.Obj].Neighbour[2]; //------------------ ������� �� ������� �����

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;

        if result = trNextStep then
        begin
          if not ObjZav[jmp.Obj].ObjConstB[1] then //--------------------- �� ������������
          begin
            inc(MarhTracert[Group].StrCount);
            MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount] := jmp.Obj;
            MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := true;
            MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := false;
          end;
          ObjZav[jmp.Obj].bParam[6] := true;   //-------------------------------------- ��
          ObjZav[jmp.Obj].bParam[7] := false;  //-------------------------------------- ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := true;   //------------------- ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false;  //------------------- ��
          ObjZav[jmp.Obj].bParam[10] := false; //---------------- �� 1-�� ������ �� ������
          ObjZav[jmp.Obj].bParam[11] := false; //---------------- �� 2-�� ������ �� ������
          ObjZav[jmp.Obj].bParam[12] := false; //--------- ��������� �� � ����� ��  ������
          ObjZav[jmp.Obj].bParam[13] := false; //-------- ���������� �� � ������ �� ������
          ObjZav[jmp.Obj].bParam[14] := true;  //------------------------- ����. ���������

          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;//-------- ����. ���������
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;//-------- ����� ������
        end;
        exit;
      end else
      if mk and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;

        if result = trNextStep then
        begin
          if not ObjZav[jmp.Obj].ObjConstB[1] then
          begin
            inc(MarhTracert[Group].StrCount);
            MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount] := jmp.Obj;
            MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := false;
            MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := true;
          end;
          ObjZav[jmp.Obj].bParam[6] := false;  //-------------------------------------- ��
          ObjZav[jmp.Obj].bParam[7] := true;   //-------------------------------------- ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; //-------------------- ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := true;  //-------------------- ��

          ObjZav[jmp.Obj].bParam[10] := false; //-------------- �� ������ ������ �� ������
          ObjZav[jmp.Obj].bParam[11] := false; //-------------- �� ������ ������ �� ������
          ObjZav[jmp.Obj].bParam[12] := false; //----------- ����� ���������� ������������
          ObjZav[jmp.Obj].bParam[13] := false; //--------------- ����� ���������� � ������
          ObjZav[jmp.Obj].bParam[14] := true;  //------------------ ������ ����. ���������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;  //------ ����. ���������
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //------������� ������
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :   //------------------------------------------------------ ���� ����� ������ �����
    begin
      if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and  //------- �� �� ������� � ...
      not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then  //------------------ ��� ��
      begin
        if ObjZav[jmp.Obj].bParam[12] //-------------- ��� ���������� ����������� �� �����
        then result := trNextStep; //----------------------------------------- ���� ������
      end
      else //------------------------------------------------------- ���� ��������� ��� ��
      if ObjZav[jmp.Obj].bParam[1] and //----------------------------------- ���� �� � ...
      not ObjZav[jmp.Obj].bParam[2] //--------------------------------------------- ��� ��
      then result := trNextStep;  //------------------------------------------ ���� ������

      if result = trNextStep then //------------------------------------- ���� ���� ������
      begin
        con := ObjZav[jmp.Obj].Neighbour[1]; //---------------- ����� ����� ���� (����� 1)
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else
            ObjZav[jmp.Obj].bParam[6] := true;   //------------------------------ ����� ��
            ObjZav[jmp.Obj].bParam[7] := false;  //--------------------------- �� ����� ��
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := true;  //------------------ ��
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; //------------------ ��
            ObjZav[jmp.Obj].bParam[10] := false; //------------ �� ������ ������ �� ������
            ObjZav[jmp.Obj].bParam[11] := false; //------------ �� ������ ������ �� ������
            ObjZav[jmp.Obj].bParam[12] := false; //------- ��� ���������� � ����� � ������
            ObjZav[jmp.Obj].bParam[13] := false; //------ ��� ���������� � ������ � ������
            ObjZav[jmp.Obj].bParam[14] := true;  //----------------------- ����. ���������
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true; //----- ����. ���������
            ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //--- ������� ������
        end;
      end;
    end;

    3 : //----------------------------------------------------- ���� �� ������� ����������
    begin
      if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and //------��� ��������� �� � ...
      not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then //------------------- ��� ��
      begin
        if ObjZav[jmp.Obj].bParam[13] then  //------------------ ���������� ����� � ������
        result := trNextStep; //---------------------------------------------- ���� ������
      end
      else //------------------------------------------------------- ���� ��������� ��� ��
      if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then//��� ��, ���� ��
      result := trNextStep;  //--------------------------- ������� �� ������ - ���� ������

      if result = trNextStep then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1]; //---------------- ����� ����� ���� (����� 1)
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else
            ObjZav[jmp.Obj].bParam[6] := false; //---------------------------- �� ����� ��
            ObjZav[jmp.Obj].bParam[7] := true;  //------------------------------- �� �����
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; //------------------ ��
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := true;  //------------------ ��
            ObjZav[jmp.Obj].bParam[10] := false; //------------ �� ������ ������ �� ������
            ObjZav[jmp.Obj].bParam[11] := false; //------------ �� ������ ������ �� ������
            ObjZav[jmp.Obj].bParam[12] := false; //------- ��� ���������� � ����� � ������
            ObjZav[jmp.Obj].bParam[13] := false; //------ ��� ���������� � ������ � ������
            ObjZav[jmp.Obj].bParam[14] := true;  //----------------------- ����. ���������
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;//------ ����. ���������
            ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------- ��� ����� ������� ��� �������� "���������� ������"
var
  k : integer;
  zak : boolean;
begin
  result := trNextStep;
  //------------------ ��������� ��������� �������� ����������� �� �������� � ����
  if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;
  //----------------------------------- ��������� ���������� ���� ����� �� �������

  if not SignCircOgrad(jmp.Obj,Group) then result := trStop; //--- ���������� ����

  if ObjZav[jmp.Obj].ObjConstB[6]
  then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16]
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];

  if ObjZav[jmp.Obj].bParam[16] or zak then
  begin //------------------------------------------- ������� ������� ��� ��������
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,119);
  end;

  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin //------------------------------------------------- ��� �������� ���������
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
    InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
  end else
  if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group)
  then result := trStop; //---------------------------------------- ��������������

  case Con.Pin of
    1 :
    begin
      //------- ��������� ����������� �� ������ ������� � ���� � �������� ��������
      if MarhTracert[Group].VP > 0 then
      begin //----------------------------------------- ���� ������ ������� � ����
        for k := 1 to 4 do
        if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // ������ ������� � ����
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // ������� ������ ������ �� �����
        begin // ��������� ����������� ������� �� ������
          if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,482, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,482);
          end;
        end;
      end;

      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin //-------------------- ������� �� ������������ ��� ������� �� ����������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //---------------------- ������� ������� ��� ���������������� ��������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
      begin //-------------------------- ������� �� ������ - ������ ��������������
        ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
      end;

      //---------------------------------------------- ����������� ������� � �����
      if ObjZav[jmp.Obj].bParam[1] then con := ObjZav[jmp.Obj].Neighbour[2]
      else //------------------------------------------ ����������� ������� � ������
      if ObjZav[jmp.Obj].bParam[2] then con := ObjZav[jmp.Obj].Neighbour[3]
      else result := trStop; //------------------------------ ��� �������� ���������

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin //------------------------------------------ ����������� ������� � �����
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin //-------------------------- ������� �� ������ - ������ ��������������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin //----------------------------------------- ����������� ������� � ������
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);//---- ������� $ �� �� ��������
      end
      else result := trStop; //------------------------------ ��� �������� ���������
      Con := ObjZav[jmp.Obj].Neighbour[1];

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242); //��� ��������� �� + ������� $
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then
      begin //------------------------------ ������� ������������ � ������� ����������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //------------------------ ������� ������� ��� ���������������� ��������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453); //������� $ ������� ��� ���������������� ��������
        end;
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin //-------------------------------------------- ����������� ������� � �����
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160); //----- ������� $ �� �� ��������
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin //------------------------------------------- ����������� ������� � ������
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin //---------------------------- ������� �� ������ - ������ ��������������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end
      else result := trStop; //-------------------------------- ��� �������� ���������

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------- ������ ����� ������� ��� �������� ��� ������ ��������
var
  o : integer;
begin
  result := trNextStep;
  case Con.Pin of
    1 :
    begin
      if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and
      not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then
      begin //----------------------------------------------------- ��� ��������� � ��
        if ObjZav[jmp.Obj].bParam[6] then
        begin
          con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNextStep;
          end;
          if result = trNextStep then
          begin
            ObjZav[jmp.Obj].bParam[6] := false; //------------------------------------- ��
            ObjZav[jmp.Obj].bParam[7] := false; //------------------------------------- ��
            o := 0;

            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0)
            and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj) then
            o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
            else
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj) then
            o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

            if (o > 0) then
            begin //--------------------- ���������� ������� ����� ��� ��������� �������
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // ��
            end else
            begin //-------------------------------- �������� ����� ������� � ������� ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // ��
            end;

            ObjZav[jmp.Obj].bParam[10] := false; //--------------- ������
            ObjZav[jmp.Obj].bParam[11] := false; // ������
            ObjZav[jmp.Obj].bParam[12] := false; // ������
            ObjZav[jmp.Obj].bParam[13] := false; // ������
            ObjZav[jmp.Obj].bParam[14] := false; // ����. ���������
            SetPrgZamykFromXStrelka(jmp.Obj);
            ObjZav[jmp.Obj].iParam[1]  := 0;
          end;
          exit;
        end else
        if ObjZav[jmp.Obj].bParam[7] then
        begin
          con := ObjZav[jmp.Obj].Neighbour[3];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNextStep;
          end;

          if result = trNextStep then
          begin
            ObjZav[jmp.Obj].bParam[6] := false; // ��
            ObjZav[jmp.Obj].bParam[7] := false; // ��
            o := 0;

            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
            else
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
            then o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

            if (o > 0) then
            begin // ���������� ������� ����� ��� ��������� �������
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // ��
            end else
            begin // �������� ����� ������� � ������� ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // ��
            end;
            ObjZav[jmp.Obj].bParam[10] := false; // ������
            ObjZav[jmp.Obj].bParam[11] := false; // ������
            ObjZav[jmp.Obj].bParam[12] := false; // ������
            ObjZav[jmp.Obj].bParam[13] := false; // ������
            ObjZav[jmp.Obj].bParam[14] := false; // ����. ���������
            SetPrgZamykFromXStrelka(jmp.Obj);
            ObjZav[jmp.Obj].iParam[1]  := 0;
          end;
          exit;
        end
        else result := trStop;
      end else
      begin // ���� ��������� ��� �� - ������ �� ���������� ��������� �������
        if ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] then
        begin // ������ �� ����� �������
          con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else result := trNextStep;
          end;

          if result = trNextStep then
          begin
            ObjZav[jmp.Obj].bParam[6] := false; // ��
            ObjZav[jmp.Obj].bParam[7] := false; // ��
            o := 0;
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
            else
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

            if (o > 0) then
            begin // ���������� ������� ����� ��� ��������� �������
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // ��
            end else
            begin // �������� ����� ������� � ������� ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // ��
            end;
            ObjZav[jmp.Obj].bParam[10] := false; // ������
            ObjZav[jmp.Obj].bParam[11] := false; // ������
            ObjZav[jmp.Obj].bParam[12] := false; // ������
            ObjZav[jmp.Obj].bParam[13] := false; // ������
            ObjZav[jmp.Obj].bParam[14] := false; // ����. ���������
            SetPrgZamykFromXStrelka(jmp.Obj);
            ObjZav[jmp.Obj].iParam[1]  := 0;
          end;
          exit;
        end else
        if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
        begin // ������ �� ������ �������
          con := ObjZav[jmp.Obj].Neighbour[3];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNextStep;
          end;

          if result = trNextStep then
          begin
            ObjZav[jmp.Obj].bParam[6] := false; // ��
            ObjZav[jmp.Obj].bParam[7] := false; // ��
            o := 0;

            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
            else
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

            if (o > 0) then
            begin // ���������� ������� ����� ��� ��������� �������
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // ��
            end else
            begin // �������� ����� ������� � ������� ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ��
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // ��
            end;
            ObjZav[jmp.Obj].bParam[10] := false; // ������
            ObjZav[jmp.Obj].bParam[11] := false; // ������
            ObjZav[jmp.Obj].bParam[12] := false; // ������
            ObjZav[jmp.Obj].bParam[13] := false; // ������
            ObjZav[jmp.Obj].bParam[14] := false; // ����. ���������
            SetPrgZamykFromXStrelka(jmp.Obj);
            ObjZav[jmp.Obj].iParam[1]  := 0;
          end;
          exit;
        end
        else result := trStop; // ������� �� ����� �������� ��������� - ������ �� ������
      end;
    end;

    2 :
    begin
      con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
        else result := trNextStep;
      end;

      if result = trNextStep then
      begin
        ObjZav[jmp.Obj].bParam[6] := false; // ��
        ObjZav[jmp.Obj].bParam[7] := false; // ��
        o := 0;

        if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
        (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
        then o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
        else
        if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
        (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
        then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

        if (o > 0) then
        begin // ���������� ������� ����� ��� ��������� �������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // ��
        end else
        begin // �������� ����� ������� � ������� ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // ��
        end;

        ObjZav[jmp.Obj].bParam[10] := false; // ������
        ObjZav[jmp.Obj].bParam[11] := false; // ������
        ObjZav[jmp.Obj].bParam[12] := false; // ������
        ObjZav[jmp.Obj].bParam[13] := false; // ������
        ObjZav[jmp.Obj].bParam[14] := false; // ����. ���������
        SetPrgZamykFromXStrelka(jmp.Obj);
        ObjZav[jmp.Obj].iParam[1]  := 0;
      end;
    end;

    3 :
    begin
      con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
        else result := trNextStep;
      end;

      if result = trNextStep then
      begin
        ObjZav[jmp.Obj].bParam[6] := false; // ��
        ObjZav[jmp.Obj].bParam[7] := false; // ��
        o := 0;
        if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
        (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
        then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
        else
        if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
        (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
        then o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

        if (o > 0) then
        begin // ���������� ������� ����� ��� ��������� �������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // ��
        end else
        begin // �������� ����� ������� � ������� ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ��
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // ��
        end;

        ObjZav[jmp.Obj].bParam[10] := false; // ������
        ObjZav[jmp.Obj].bParam[11] := false; // ������
        ObjZav[jmp.Obj].bParam[12] := false; // ������
        ObjZav[jmp.Obj].bParam[13] := false; // ������
        ObjZav[jmp.Obj].bParam[14] := false; // ����. ���������
        SetPrgZamykFromXStrelka(jmp.Obj);
        ObjZav[jmp.Obj].iParam[1]  := 0;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------- ������ ����� ������� ��� ���������� �������� �������
var
  zak : boolean;
  k : integer;
begin
  result := trNextStep;
  // ��������� ��������� �������� ����������� �� �������� � ����
  if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;

  // ��������� ���������� ���� ����� �� �������
  if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // ���������� ����

  if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16]
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];

  if ObjZav[jmp.Obj].bParam[16] or zak then
  begin // ������� ������� ��� ��������
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,119);
  end;

  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin // ��� �������� ���������
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
    InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
  end else
  if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group)
  then result := trStop; // ��������������

  case Con.Pin of
    1 :
    begin
      // ��������� ����������� �� ������ ������� � ���� � �������� ��������
      if MarhTracert[Group].VP > 0 then
      begin // ���� ������ ������� � ����
        for k := 1 to 4 do
        if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // ������ ������� � ����
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // ������� ������ ������ �� �����
        begin // ��������� ����������� ������� �� ������
          if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,482, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,482);
          end;
        end;
      end;

      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin // ������� �� ������������ ��� ������� �� ����������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
      begin // ������� �� ������ - ������ ��������������
        ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // ����������� ������� � �����
        ObjZav[jmp.Obj].bParam[10] := true;
        ObjZav[jmp.Obj].bParam[11] := false;// +
        con := ObjZav[jmp.Obj].Neighbour[2];
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // ����������� ������� � ������
        ObjZav[jmp.Obj].bParam[10] := true;
        ObjZav[jmp.Obj].bParam[11] := true; // -
        con := ObjZav[jmp.Obj].Neighbour[3];
      end
      else  result := trStop; // ��� �������� ���������

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // ������� � �����
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // ������� � ������
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end
      else  result := trStop; // ��� �������� ���������

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then ObjZav[jmp.Obj].bParam[12] := true; // +

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then
      begin // ������� ������������ � ������� ����������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // ������� � �����
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // ������� � ������
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end
      else result := trStop;// ��� �������� ���������

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then ObjZav[jmp.Obj].bParam[13] := true; // -
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------ ������ ����� ������� ��� �������� ������� �� ������������
var
  zak : boolean;
begin
  result := trNextStep;
  //-------------------------- ��������� ��������� �������� ����������� �� �������� � ����
  if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;

  // ��������� ���������� ���� ����� �� �������
  if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // ���������� ����

  if ObjZav[jmp.Obj].ObjConstB[6]
  then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16]
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];

  if ObjZav[jmp.Obj].bParam[16] or zak then
  begin //--------------------------------------------------- ������� ������� ��� ��������
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,119);
  end;

  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin //--------------------------------------------------------- ��� �������� ���������
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
    InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
  end else
  if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group)
  then result := trStop; //------------------------------------------------ ��������������

  case Con.Pin of
    1 :
    begin
      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin //-------------------------- ������� �� ������������ ��� ������� �� ����������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //---------------------------- ������� ������� ��� ���������������� ��������
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
      begin //---------------------------------- ������� �� ������ - ������ ��������������
        ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
      end;

      if ObjZav[jmp.Obj].bParam[1]
      then con := ObjZav[jmp.Obj].Neighbour[2]  //------------ ����������� ������� � �����
      else
      if ObjZav[jmp.Obj].bParam[2]
      then  con := ObjZav[jmp.Obj].Neighbour[3]//------------ ����������� ������� � ������
      else result := trStop; //------------------------------------ ��� �������� ���������

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // ����������� ������� � �����
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // ����������� ������� � ������
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end
      else result := trStop; // ��� �������� ���������

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then
      begin // ������� ������������ � ������� ����������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // ����������� ������� � �����
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // ����������� ������� � ������
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end
      else  result := trStop;// ��� �������� ���������

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelPovtorRazdel(var Con : TOZNeighbour;const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------- �������� ��� ���������� �������� � ���������� ������
var
  k : integer;
  zak : boolean;
begin
  result := trNextStep;
  if ObjZav[jmp.Obj].ObjConstB[6]
  then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16]
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];

  if ObjZav[jmp.Obj].bParam[16] or zak then
  begin // ������� ������� ��� ��������
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,119);
  end;

  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin // ��� �������� ���������
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
    InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
  end else
  if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group)
  then result := trStop; // ��������������

  case Con.Pin of
    1 :
    begin
      // ��������� ����������� �� ������ ������� � ���� � �������� ��������
      if MarhTracert[Group].VP > 0 then
      begin // ���� ������ ������� � ����
        for k := 1 to 4 do
        if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // ������ ������� � ����
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // ������� ������ ������ �� �����
        begin // ��������� ����������� ������� �� ������
          if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,482, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,482);
          end;
        end;
      end;

      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin // ������� �� ������������ ��� ������� �� ����������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
      begin // ������� �� ������ - ������ ��������������
        ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // ����������� ������� � �����
        if not ObjZav[jmp.Obj].bParam[6] then
        begin // ������� �� �� ��������
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
        end else
        begin
          ObjZav[jmp.Obj].bParam[10] := true;
          ObjZav[jmp.Obj].bParam[11] := false;// +
          con := ObjZav[jmp.Obj].Neighbour[2];
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // ����������� ������� � ������
        if not ObjZav[jmp.Obj].bParam[7] then
        begin // ������� �� �� ��������
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
        end else
        begin
          ObjZav[jmp.Obj].bParam[10] := true;
          ObjZav[jmp.Obj].bParam[11] := true; // -
                  con := ObjZav[jmp.Obj].Neighbour[3];
        end;
      end
      else result := trStop;// ��� �������� ���������

      // ��������� ���������� ���� ����� �� �������
      if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // ���������� ����

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // ����������� ������� � �����
        if not ObjZav[jmp.Obj].bParam[6] then
        begin // ������� �� �� ��������
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // ����������� ������� � ������
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end
      else  result := trStop; // ��� �������� ���������

      Con := ObjZav[jmp.Obj].Neighbour[1];
      // ��������� ���������� ���� ����� �� �������
      if not SignCircOgrad(jmp.Obj,Group)
      then result := trStop; // ���������� ����

      if result <> trStop then  ObjZav[jmp.Obj].bParam[12] := true; // +

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then
      begin // ������� ������������ � ������� ����������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // ����������� ������� � �����
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // ����������� ������� � ������
        if not ObjZav[jmp.Obj].bParam[7] then
        begin // ������� �� �� ��������
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end
      else  result := trStop; // ��� �������� ���������

      Con := ObjZav[jmp.Obj].Neighbour[1];
      // ��������� ���������� ���� ����� �� �������
      if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // ���������� ����

      if result <> trStop then ObjZav[jmp.Obj].bParam[13] := true; // -

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//-------------------------------------------- ������ ����� ������� ��� ������ �����������
begin
  result := trNextStep;
  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin // ���� ������� �� ����� �������� ��������� - �������� ������ �����������
    result := trStop;
    exit;
  end;
  case Con.Pin of
    1 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // �� �����
        con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
        exit;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // �� ������
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end
      else  result := trStop;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1]  then
      begin // �� �����
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else  result := trStop;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].bParam[2] then
      begin // �� ������
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepStrelFindIzvStrel(var Con : TOZNeighbour; const Lvl :TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------- ������ ����� ������� ��� �������� ����������� �������������� �������
var
  zak : boolean;
  o,j,k : integer;
begin
  result := trNextStep;
  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin // ���� ������� �� ����� �������� ��������� - �������� ������ �����������
    result := trStop;
    exit;
  end;

  o := ObjZav[jmp.Obj].BaseObject;
  zak := false;

  if Rod = MarshP then
  begin // ��������� ��������� ������� (� ����) � �������� ����������� � ����
    for j := 14 to 19 do
    begin
      if ObjZav[ObjZav[o].ObjConstI[j]].TypeObj = 41 then
      begin // �������� �������� ����������� � ���� �� �������� � ����
        if ObjZav[ObjZav[o].ObjConstI[j]].BaseObject = Marhtracert[Group].ObjStart then
        begin // ������� ���������� � �������� �������� ��� ��������
          zak := true;
          break;
        end;
      end;
    end;
  end;

  if not zak then
  begin // ��������� ���������� �������� �������
    k := ObjZav[jmp.Obj].UpdateObject;
    if not (ObjZav[ObjZav[o].ObjConstI[12]].bParam[1] or // ���
    ObjZav[jmp.Obj].bParam[5] or     // ������� �������� ��������
    not ObjZav[k].bParam[2] or       // ��������� �� ��
    ObjZav[o].bParam[18] or          // ��������� �� ���������� FR4
    ObjZav[jmp.Obj].bParam[18]) then // ��������� �� ���������� ��-���
    Marhtracert[Group].IzvStrNZ := true;
  end;

  case Con.Pin of
    1 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // �� �����
        con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // �� ������
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1]  then
      begin // �� �����
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].bParam[2] then
      begin // �� ������
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepStrelPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------ ������ ����� ������� ��� ��������� ������� ��������
begin
  result := trNextStep;
  if not ObjZav[jmp.Obj].bParam[14] then
  begin //------------------------------------------------------ ��������� ������ ��������
    if (MarhTracert[Group].MsgCount > 10) or (MarhTracert[Group].MsgCount = 0) then
    MarhTracert[Group].MsgCount := 1;
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    result := trStop;
    InsMsg(Group,MarhTracert[Group].ObjStart,228);
  end else
  case Con.Pin of
    1 :
    begin
      if ObjZav[jmp.Obj].bParam[6] and
      not ObjZav[jmp.Obj].bParam[7] then
      begin
        inc(MarhTracert[Group].StrCount);
        MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount]   := jmp.Obj;
        MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := true;
        MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := false;
        con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end else
      if not ObjZav[jmp.Obj].bParam[6] and ObjZav[jmp.Obj].bParam[7] then
      begin
        inc(MarhTracert[Group].StrCount);
        MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount]   := jmp.Obj;
        MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := false;
        MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := true;
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[6]  then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].bParam[7] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepSvetoforFindTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//----------------------------------------------------- ��� ����� ������ ��� ������ ������
begin
  if ObjZav[Con.Obj].RU = ObjZav[MarhTracert[Group].ObjStart].RU then
  begin //------------------------------ ���������� ����������� ���� ���� ����� ����������
    if ObjZav[jmp.Obj].ObjConstB[1] then result := trRepeat //-----  ����� �����������
    else
    if Con.Pin = 1 then //------------------------ ���� ����� �� ������ �� ������� ����� 1
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2]; //------- �������� ��������� ������� �� ����� 2
      case Con.TypeJmp of
        LnkRgn : result := trRepeat; //----------- ���������� �� ����� ������ - ����������
        LnkEnd : result := trRepeat; //----------- ���������� �� ����� ������ - ����������
        else result := trNextStep;
      end;
    end else //-------------------------------------------------- ����� �� ������� ����� 2
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1]; //---------------- �������� ��������� � ����� 1
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
        else result := trNextStep;
      end;
    end;
  end
  else result := trRepeat;
end;
//========================================================================================
function StepSvetoforContTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//---------------------------------------------------- ��������� ������ �� ��������� �����
var
  i,j,k : integer;
begin
  if ObjZav[Con.Obj].RU = ObjZav[MarhTracert[Group].ObjStart].RU then
  begin //------------------------------ ���������� ����������� ���� ���� ����� ����������
    //----------------------------------- ���� ������ ������, ����� ����������� �/�, �����
    if ObjZav[jmp.Obj].ObjConstB[1] then  result := trEndTrace
    else
    if Con.Pin = 1 then
    begin //-------------------------------------------------------------- �������� ������
      if (((Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[7]) or//--- ������ � ����� �.1 ���
      ((Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[5])) and //--------- ����� � ����� �.1
                                                                 //----------------- � ...
      (ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] or //--- ���� STAN ��� DSP
      ObjZav[jmp.Obj].bParam[18] or //----------------------------------------  ��� ��(��)
                                        //---------------------------------------  ��� ...
      (ObjZav[jmp.Obj].ObjConstB[2] and //----------------- �������� ������ �������� � ...
      (ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4] or //----- �1 ��� �2 ��� ...
      ObjZav[jmp.Obj].bParam[8] or ObjZav[jmp.Obj].bParam[9])) or //---- � �� STAN ��� ���
                                            //------------------------------------ ��� ...
      (ObjZav[jmp.Obj].ObjConstB[3] and  //-------------- �������� ������ ���������� � ...
      (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or //--- ��1 ��� ��2 ��� ...
      ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7]))) then //--- �� STAN ��� ���
      result := trEndTrace //------ ��������� ����������� ���� �������� ������� ��� ������
      else
      case Rod of
        MarshP : //----------------------------------------------------- �������� ��������
        begin
          if ObjZav[jmp.Obj].ObjConstB[16] and //------------ ��� �������� ��������� � ...
          ObjZav[jmp.Obj].ObjConstB[2] then //------------------- �������� ������ ��������
          result := trEndTrace //-------------------------------- ��������� ����� ��������
          else
          if ObjZav[jmp.Obj].ObjConstB[5] then
          begin //----------- ���� ����� ��������� �������� � ����� 1 ��������� ( � �����)
            MarhTracert[Group].FullTail := true; //-------- ������� ������ ������ ��������
            MarhTracert[Group].FindNext := true; //------ �������� ����������� �����������
            if ObjZav[jmp.Obj].ObjConstB[2] //------------------- �������� ������ ��������
            then
            begin
              result := trEnd;     //------------------------- ����� ����������� ���������
              MarhTracert[Group].ObjEnd := jmp.Obj; // ������� ����� ��������� �� ��������
            end
            else result := trEndTrace; //------------------------ ��������� ����� ��������
          end
          else result := trNextStep; //----- ��� ����� ��������� �������� � ���������,����
        end;

        MarshM : //--------------------------------------------------- ���������� ��������
        begin
          if ObjZav[jmp.Obj].ObjConstB[7] then //----- ���� ����� ���������� � �.1 �������
          begin
            MarhTracert[Group].FullTail := true; //------------------------ ������� ������
            MarhTracert[Group].FindNext := true; //----- ��������� ����������� �����������
            if ObjZav[jmp.Obj].ObjConstB[3] //----------------- �������� ������ ����������
            then
            begin
              result := trEnd;  //---------------------------- ����� ����������� ���������
              MarhTracert[Group].ObjEnd := jmp.Obj;
            end
            else result := trEndTrace;
          end
          else result := trNextStep; //---- ��� ����� ���������� � �.1 - ������ ������
        end;

        else result := trEnd; //------ ��������� ��� �������� - ��������� ����� ������
      end;

      if result = trNextStep then //-------------------------- ���� ���� ������ ������
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2]; //- ���������� ��������� �� �������� (�2)
        case Con.TypeJmp of
          LnkRgn : result := trStop; //----------------------- ����� ������ ����������
          LnkEnd : result := trStop; //----------------------------- ����� �����������
        end;
      end;
    end else
    begin //------------------------ ��������� ������ (����� �� ������ �� ������� �.2)
      case Rod of
        MarshP : //-------------------------- ��������� ������� ��� �������� -------------
        begin
          if ObjZav[jmp.Obj].ObjConstB[5] //---- �������� ����� ���� � �.1 �� ��������
          then result := {trEndPlus} trNextStep //- ���� ����� ��������, �� �������� ���� ���������
          else //-------------------------------------- ���� ��������� ����� ��� � �.1
          begin
            if ObjZav[jmp.Obj].Neighbour[1].TypeJmp = 0 then //------------ ������ ���
            result := trStop //-------------------- ����� ���� ��� ��������� �� ������
            else result := trNextStep; //-------------------------------- ����� ������
          end;
        end;

        MarshM : //------------------------- ��������� ������� ��� ��������---------------
        begin
          if ObjZav[jmp.Obj].ObjConstB[8] //���� ������� �������� ����� �������� �� �����
          then
          begin
            result := trEndTrace;
            if jmp.Pin = 1  then jmp := ObjZav[jmp.Obj].Neighbour[2]
            else jmp := ObjZav[jmp.Obj].Neighbour[1];
          end
          else
            if ObjZav[jmp.Obj].ObjConstB[7]//���� ����� �������� � �.1 (�� ��������� ����.)
            then result := trNextStep //----------------------------  �� ���������� ������
            else
            begin
              j :=  MarhTracert[Group].Counter;
              for i := 0 to j do
              begin
                k := MarhTracert[Group].ObjTrace[j-1];
                if (ObjZav[k].TypeObj = 3) or (ObjZav[k].TypeObj = 4) then
                begin
                  MarhTracert[Group].ObjEnd := k;
                  break;
                end else
                begin
                  MarhTracert[Group].ObjTrace[j] := 0;
                  dec(MarhTracert[Group].Counter);
                end;
              end;
              result := trEnd; //------------------------------------------- ����� ����
            end;

        end;

        else result := trEnd; //------------------ ������� ����������, �� ������������
      end;

      if result = trNextStep then //------------------------- ���� ����� ������ ������
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1]; //----- ��������������� ��������� ����� 1
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          LnkFull : result := trNextStep;
          LnkNecentr : result := trEndTrace;
        end;
      end;

      if result = trEndPlus then  result := trEndTrace; //--- ����� ������� @@@@@@@@@@@@

    end;
  end
  else result := trEndTrace;//��������� ����������� �������� ���� ������ ����� ����������
end;
//========================================================================================
function StepSvetoforZavTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//-------------------------------------------------------- �������� ������������ �� ������
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trEndTrace;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trEndTrace;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSvetoforCheckTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//---------------------------------------------- �������� ������������� �� ������ ��������
begin
  result := trNextStep;
  if (ObjZav[jmp.Obj].bParam[12] or  //--------------------- ���������� � STAN ��� ...
  ObjZav[jmp.Obj].bParam[13]) and //--------------------------- ���������� � DSP � ...
  (jmp.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]) // �� ���������
  then
  begin //------------------------------------ ������������ �������� � �������� ������
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,123); //----------------------------- �������� $ ������������
    MarhTracert[Group].GonkaStrel := false;
  end;

  if ObjZav[jmp.Obj].bParam[18] and //------------------------------- ���� �� (��� ��)
  (jmp.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]) then //- ������
  begin //--------------------------- �������� �� ������� ���������� � �������� ������
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,232, ObjZav[jmp.Obj].Liter,1);//------- ������ $ �� ������� ����������
    InsMsg(Group,jmp.Obj,232);
    MarhTracert[Group].GonkaStrel := false;
  end;

  if Con.Pin = 1 then //-------------------------------------- ����� � �������� ������
  begin //----------------------------------------------------- ������������ ���������
    if ((not ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP)) or//��� �-����� � �1 ���
    (not ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM))) and //��� �-����� � �1 �
    (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or  //---- ��1 ��� ��2 ���
    ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then //--------- �1 ��� �2
    begin
      result := trBreak;
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,114);  //----------------------- ������ ���������� ������ $
      MarhTracert[Group].GonkaStrel := false;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;

    if MarhTracert[Group].FindTail //----------- ���� ������� ��������� � ����� ������
    then MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter;
  end else
  begin //------- ���� ����� �� ��������� ������, �� �������� ������������� ����������
    if ObjZav[jmp.Obj].bParam[1] or   //---------------------------------- ��1 ��� ...
    ObjZav[jmp.Obj].bParam[2] or   //------------------------------------- ��2 ��� ...
    ObjZav[jmp.Obj].bParam[3] or   //-------------------------------------- �1 ��� ...
    ObjZav[jmp.Obj].bParam[4] then //---------------------------------------------- �2
    begin
      result := trBreak;
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,114);  //----------------------- ������ ���������� ������ $
      MarhTracert[Group].GonkaStrel := false;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;

    if MarhTracert[Group].FindTail then //----------------------- ���� ������ ����� ������
    begin
      if (ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 5) and (jmp.Pin = 1)
      then //---------------------------------------------- ���� ����� �� �������� �������
       MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter
      else
        if ObjZav[MarhTracert[Group].ObjEnd].ObjConstB[3] and (Rod = MarshM) then
        MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter
        else
        if ObjZav[MarhTracert[Group].ObjEnd].ObjConstB[2] and (Rod = MarshP) then
        MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter
        else
        begin
          result := trBreak;
        end;
//        MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter;
    end;
  end;
end;
//========================================================================================
function StepSvetoforZamykTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//------------------- ��������� ������ ��������, ���� ��������� ����������� ������� ������
begin
  if Con.Pin = 1 then  //--------------------------------------------- �������� ������
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      if MarhTracert[Group].FindTail //---------------------- ���� ������ ����� ������
      then MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter;

      //---------------------------------- �������� �������� ������ � �������� �������
      if ObjZav[MarhTracert[Group].ObjStart].bParam[7] then //���������� ������� �����
      begin
        if ObjZav[jmp.Obj].ObjConstB[3] then //---------------- ���� ���������� ������
        begin
          MarhTracert[Group].SvetBrdr := jmp.Obj;//������� ������ ������� ����-�������
          ObjZav[jmp.Obj].bParam[7] := true;  //----------------------------------- ��
          ObjZav[jmp.Obj].bParam[14] := true; //---------------------- ����. ���������
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; // ������ ��������
        end;
      end else

      if ObjZav[MarhTracert[Group].ObjStart].bParam[9] then //- �������� ������� �����
      begin
        if ObjZav[jmp.Obj].ObjConstB[2] then //------------------ ���� �������� ������
        begin
          MarhTracert[Group].SvetBrdr := jmp.Obj;//������� ������ ������� ����-�������
          ObjZav[jmp.Obj].bParam[8] := true;  //------------------------------------ �
          ObjZav[jmp.Obj].bParam[14] := true; //----------- ���������� ����. ���������
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; // ������ ��������
        end;
      end;
    end;
  end else //--------------------------------- ����� �� ��������� ������ (�� ����� �2)
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trEndTrace;
      else  result := trNextStep;
    end;

    if MarhTracert[Group].FindTail then
    begin
      if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 5 then //-- ���� ����� �� �������
      MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter
      else MarhTracert[Group].TailMsg := ' �� '+ ObjZav[jmp.Obj].Liter;
    end;

    ObjZav[jmp.Obj].bParam[14] := true;  //--------------------------- ����. ���������
    ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //------ ������ ��������
  end;
end;
//========================================================================================
function StepSignalCirc(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//------------------------ ���������� ������ (��������� �������� �������, ������ ��������)
begin
  result := trNextStep;
  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
  begin //------------------------------------------------------ ������������ ��������
    if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,123);   //------------------------- �������� $ ������������
    end;
  end else
  if ObjZav[jmp.Obj].bParam[18] then
  begin //--------------------------------------------- �������� �� ������� ����������
    if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,232, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,232); //-------------------- ������ $ �� ������� ����������
    end;
  end
  else result := trNextStep;

  if Con.Pin = 1 then
  begin //----------------------------------------------------- ������������ ���������
    case Rod of
      MarshP :
      begin
        if ObjZav[jmp.Obj].ObjConstB[5] then //------------------------------- ���� �2
        begin
          if ObjZav[jmp.Obj].bParam[5] and //----------------------- ������� � ��� ...
          not (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or// ��1 ��� ��2
          ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then //��� �1 ��� �2
          begin //--------------------- ������� �� ������� ����������� ����� ���������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,115, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,115); //- ������� �� ��������! ���������� �����������
          end;
          result := trEndTrace;
        end;

        if ObjZav[jmp.Obj].ObjConstB[19] then
        begin //--------------- �������� �������������� ������� ��� ��������� ��������
          if not ObjZav[jmp.Obj].bParam[4] then
          begin //------------------------------------------------------ ������ ������
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,391, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,391); //----------------------------- ������ $ ������
          end;
        end;
      end;

      MarshM :
      begin
        if ObjZav[jmp.Obj].ObjConstB[7] then   //- �������� ���������� ����� � ����� 1
        begin
          if ObjZav[jmp.Obj].bParam[5] and not //----------------------- ������� � ���
          (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or //��1 ��� ��2 ���
          ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then //--- �1 ��� �2
          begin //--------------------- ������� �� ������� ����������� ����� ���������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,115, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,115); //- ������� �� ��������! ���������� �����������
          end;
          result := trEndTrace;
        end;

        if ObjZav[jmp.Obj].ObjConstB[20] then
        begin //------------- �������� �������������� ������� ��� ����������� ��������
          if not ObjZav[jmp.Obj].bParam[2] then //---------------------------- ��� ��2
          begin //------------------------------------------------------ ������ ������
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,391, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,391);
          end;
        end;
      end;

      else result := trEnd;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[2]; //-------------- ��������� �� ������� ����� 2
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin //---------------------------------------- ������������ ���������� ����� � �.2
    if ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) //�������� ����� �������� � �.2
    then result := trStop
    else
    if ObjZav[jmp.Obj].ObjConstB[8] and (Rod =MarshM)//�������� ����� ���������� � �.2
    then result := trStop
    else
    if ObjZav[jmp.Obj].bParam[1] or   //------------------------------------------ ��1
    ObjZav[jmp.Obj].bParam[2] or   //--------------------------------------------- ��2
    ObjZav[jmp.Obj].bParam[3] or   //---------------------------------------------- �1
    ObjZav[jmp.Obj].bParam[4] then //---------------------------------------------- �2
    begin
      result := trStop;
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,114); //------------------------ ������ ���������� ������ $
    end;

    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepSigOtmenaMarh(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//-------------------------------------- ������ ��������, ���������� ���� "�" ��� ��������
begin
  result := trNextStep;
  if Con.Pin = 1 then
  begin //------------------------------------------------------------ �������� ������
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn :
      begin
        ObjZav[jmp.Obj].bParam[14] := false;
        result := trEnd;
      end;

      LnkEnd :
      begin
        ObjZav[jmp.Obj].bParam[14] := false;
        result := trStop;
      end;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin     //----------------------- ����� ����� ������ ��������� ��������
      if Rod = MarshM then
      begin // ����������
        if ObjZav[jmp.Obj].ObjConstB[7] then result := trStop
        else ObjZav[jmp.Obj].bParam[14] := false;
      end else
      if Rod = MarshP then
      begin // ��������
        if ObjZav[jmp.Obj].ObjConstB[5] then result := trStop
        else ObjZav[jmp.Obj].bParam[14] := false;
      end;
    end;
  end else
  begin // ��������� ������
    ObjZav[jmp.Obj].bParam[14] := false;
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;      // ����� ����� ������ ��������� ��������
      else   // ����� ����� ������ ��������� ��������
      if Rod = MarshM then
      begin // ����������
        if ObjZav[jmp.Obj].ObjConstB[8]
        then result := trStop
        else result := trNextStep;
      end else
      if Rod = MarshP then
      begin // ��������
        if ObjZav[jmp.Obj].ObjConstB[6]
        then result := trStop
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepSigAutoPovtorRazdel(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//------------------ ������ ��� ������������, ���������� �������� ��� ������� � ����������
begin
  result := trNextStep;
  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
  begin // ������������ ��������
    if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,123);
    end;
  end else
  if ObjZav[jmp.Obj].bParam[18] then
  begin // �������� �� ������� ����������
    if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,232, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,232);
    end;
  end
  else result := trNextStep;

  if Con.Pin = 1 then
  begin // ������������ ���������
    case Rod of
      MarshP :
      begin
        if ObjZav[jmp.Obj].ObjConstB[5] then
        begin
          if ObjZav[jmp.Obj].bParam[5] and not
          (ObjZav[jmp.Obj].bParam[1] or
          ObjZav[jmp.Obj].bParam[2] or
          ObjZav[jmp.Obj].bParam[3] or
          ObjZav[jmp.Obj].bParam[4]) then // o
          begin // ������� �� ������� ����������� ����� ���������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,115, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,115);
          end;
          result := trEndTrace;
        end else
        begin
          if ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[21] then
          begin // ������ ���������� ������
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,114);
          end;
        end;

        if ObjZav[jmp.Obj].ObjConstB[19] then
        begin // �������� �������������� ������� ��� ��������� ��������
          if not ObjZav[jmp.Obj].bParam[4] then
          begin // ������ ������
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,391, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,391);
          end;
        end;
      end;

      MarshM :
      begin
        if ObjZav[jmp.Obj].ObjConstB[7] then
        begin
          if ObjZav[jmp.Obj].bParam[5] and
          not (ObjZav[jmp.Obj].bParam[1] or
          ObjZav[jmp.Obj].bParam[2] or
          ObjZav[jmp.Obj].bParam[3] or
          ObjZav[jmp.Obj].bParam[4]) then // o
          begin // ������� �� ������� ����������� ����� ���������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,115, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,115);
          end;
          result := trEndTrace;
        end else
        begin
          if ObjZav[jmp.Obj].bParam[3] or
          ObjZav[jmp.Obj].bParam[4] or
          ObjZav[jmp.Obj].bParam[8] or
          ObjZav[jmp.Obj].bParam[9] or
          ObjZav[jmp.Obj].bParam[21] then
          begin // ������ ���������� ������
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,114);
          end;
        end;

        if ObjZav[jmp.Obj].ObjConstB[20] then
        begin // �������� �������������� ������� ��� ����������� ��������
          if not ObjZav[jmp.Obj].bParam[2] then
          begin // ������ ������
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,391, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,391);
          end;
        end;
      end;
      else result := trEnd;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
      end;
    end;
  end else
  begin // ������������ ����������
    if ObjZav[jmp.Obj].bParam[1] or   // ��1
    ObjZav[jmp.Obj].bParam[2] or   // ��2
    ObjZav[jmp.Obj].bParam[3] or   // �1
    ObjZav[jmp.Obj].bParam[4] then // �2
    begin
      result := trStop;
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,114);
    end;

    case Rod of
      MarshP : if ObjZav[jmp.Obj].ObjConstB[6] then result := trEndTrace;
      MarshM : if ObjZav[jmp.Obj].ObjConstB[8] then result := trEndTrace;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          // ������� �� ����������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          result := trEnd;
          InsMsg(Group,jmp.Obj,77);
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepSigFindIzvest(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//--------------------------------------------- ������ ����� ������ ��� ������ �����������
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else  result := trNextStep;
    end;
  end else
  begin //---------------------------------------- ��������� ������� ��� ��������� �������
    if ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[4] then  //---- �������� ������
    inc(MarhTracert[Group].IzvCount)
    else
    if ObjZav[jmp.Obj].bParam[6] or
    ObjZav[jmp.Obj].bParam[7] or
    ObjZav[jmp.Obj].bParam[1] then
    begin //---------- ��������� ������� ����������� ������ ��� ������ �� �������� �������
      if not ObjZav[jmp.Obj].bParam[2] then
      begin //------------------------------------------------------------ �������� ������
        result := trStop;
        exit;
      end;
      inc(MarhTracert[Group].IzvCount);
    end else
    if ObjZav[jmp.Obj].bParam[8] or
    ObjZav[jmp.Obj].bParam[9] or
    ObjZav[jmp.Obj].bParam[3] then
    begin //------------ ��������� ������� ��������� ������ ��� ������ �� �������� �������
      if not ObjZav[jmp.Obj].bParam[4] then
      begin //------------------------------------------------------------ �������� ������
        result := trStop;
        exit;
      end;
      inc(MarhTracert[Group].IzvCount);
    end;
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSigFindIzvStrel(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------- ������ ����� ������ ��� ������ ����������� ������� �� �������������� �������
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin // ��������� ������� ��� ��������� �������
    if ((Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
    ((Rod = MarshP) and (ObjZav[jmp.Obj].ObjConstB[2] or ObjZav[jmp.Obj].bParam[2])) then
    begin // �������� ������������ �������������� �������
      result := trStop;
      exit;
    end
    else Con := ObjZav[jmp.Obj].Neighbour[1];

    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSigPovtorMarh(var Con :TOZNeighbour; const Lvl :TTracertLevel; Rod :Byte;
Group :Byte; jmp :TOZNeighbour) : TTracertResult;
//--------------------- ������� ������� ����� ������ ��� ������� ��������� ������ ��������
//------------------------------------ Con - ���������, � �������� ������ ������ �� ������
//----------------------------------------------------- Lvl - ����������� ���� �����������
//------------------------------------------------------- Rod - ��� ������������� ��������
//-------------------------------------------------------- Group - ����� ���������� ������
//------------------------------------- jmp - �����, �� �������� ������ ������ �� ��������
//--- ������� ���������� ��������� ����������� ����� ������ �� ���������� ������ ���������
var
  old_con : TOZNeighbour;
begin
  result := trNextStep; //------------ ���������� ���������, ��� ������ ������ ���� ������
  old_con := Con;
  //------------------------------------ ��������� ������� ������ ��������� ����� ��������
  if Con.Pin = 1 then //-------------- ���� ����� �� ������ � ����� 1 (�������� ���������)
  begin
    case Rod of
      MarshP : //-------------------------------------------------- ��� ��������� ��������
        if ObjZav[jmp.Obj].ObjConstB[5] //------------- ���� � ����� 1 ���� ����� ��������
        then result := trEndTrace; //---------------------- ����� ��������� = ����� ������
      MarshM : //------------------------------------------------ ��� ����������� ��������
        if ObjZav[jmp.Obj].ObjConstB[7] //----------- ���� � ����� 1 ���� ����� ����������
        then result := trEndTrace; //---------------------- ����� ��������� = ����� ������
      else  result := trEnd;    //---------------- ��� ������������� ��������� ����� �����
    end;

    if result = trNextStep then //- ���� � ����� 1 �� ���� ��������, � ������ ������������
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2]; //- �������� ����� ��������� �� ������� ����� 2
      case Con.TypeJmp of
        LnkRgn : result := trStop; //----------------- ���� ������ � ������ �����, �� ����
        LnkEnd : result := trStop; //---------------------- ���� ��������� ������, �� ����
      end;
    end;
  end else //--------- ���� ����� �� ������ � ����� 2 ��������� ������� ������ �� ��������
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[5] or ObjZav[jmp.Obj].ObjConstB[6]
        then result := trEndTrace;//------------------------------ � ����� � ����� 1 ��� 2

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[7] or ObjZav[jmp.Obj].ObjConstB[8]
        then result := trEndTrace;//------------------------------ � ����� � ����� 1 ��� 2
    end;
  end;
  Con := old_con;
  if result = trNextStep then //---------------------------- ���� ������������ �����������
  begin
    if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
    else Con := ObjZav[jmp.Obj].Neighbour[1];

    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd :
      begin  //---------------------------------------------------- ������� �� ����������
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,77);
        result := trEnd;
      end;
    end;
  end;

end;
//========================================================================================
function StepSPforFindTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//--------------------------------------------- ������ ����� �� ��� ������ ������ ��������
begin
  if Con.Pin = 1 then  //------------------------------ ����� �� ������ �� ������� ����� 1
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[1]   //---- ���� ���� �������� � ����������� 1->2
        then result := trNextStep
        else result := trRepeat;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[3]   //-- ���� ���� ���������� � ����������� 1->2
        then result := trNextStep
        else result := trRepeat;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end else
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[2]  //--------- ���� ���� �������� � ����������� 2->1
        then result := trNextStep
        else result := trRepeat;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[4]   //------ ���� ���� ���������� � ����������� 2->1
        then result := trNextStep
        else result := trRepeat;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepSPforContTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[1]  //--------- ���� ���� �������� � ����������� 1->2
        then result := trNextStep
        else result := trStop;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[3] //-------- ���� ���� ���������� � ����������� 1->2
        then result := trNextStep
        else result := trEnd;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;
    if result = trEnd then  MarhTracert[Group].ObjLast := jmp.Obj;
  end else
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[2]then //-------���� ���� �������� � ����������� 2->1
        result := trNextStep
        else result := trStop;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[4]//--------- ���� ���� ���������� � ����������� 2->1
        then result := trNextStep
        else result := trEnd;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    if result = trEnd then  MarhTracert[Group].ObjLast := jmp.Obj;

  end;
end;
//========================================================================================
function StepSPforZavTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSPforCheckTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  tail : boolean;
  k : integer;
begin
  result := trNextStep;

  if not ObjZav[jmp.Obj].bParam[2] or //--------------------------------- ���� "�" ��� ...
  (not MarhTracert[Group].Povtor and //------------- ��� �������� ��������� �������� � ...
  (ObjZav[jmp.Obj].bParam[14] or //-------------------- ���� ����������� ��������� ��� ...
  not ObjZav[jmp.Obj].bParam[7])) then //------ ��������������� ��������� STAN �����������
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,82); //---------------------------------------- ������� $ �������
    MarhTracert[Group].GonkaStrel := false;
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //- ������ ��� ��������
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,134); //--------------------------- ������� $ ������ ��� ��������
    MarhTracert[Group].GonkaStrel := false;
  end;

  //""""""""""""""""""""""""""""""" ��������� ��������� ����������� """"""""""""""""""""""

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then //--- ���� ��. ����
  begin
    if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then //----- ������ ��� ��
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then//������ ��� ��=
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);//------ ������� �������� �� ����������� ����. ���� �� $
      end;

      if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then//--- ������ ��� ��~
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //---- ������� �������� �� ����������� �����. ���� �� $
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- ��
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84); //----------- ����������� ������������� ���������� ������� $
    MarhTracert[Group].GonkaStrel := false;
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //--------------------------------------------- ��
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85);  //---------------------------- ������� $ ������� � ��������
    MarhTracert[Group].GonkaStrel := false;
  end;

  case Rod of
    MarshP :
    begin
      if not ObjZav[jmp.Obj].bParam[1] then //-------------------------- ��������� �������
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,83);   //------------------------------------ ������� $ �����
        MarhTracert[Group].GonkaStrel := false;
      end;
    end;

    MarshM :
    begin
      if not ObjZav[jmp.Obj].bParam[1] then //----------------------- ��������� ������� ��
      begin
        if ObjZav[jmp.Obj].ObjConstB[5] then  //---------------------------------- ���� ��
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83); //------------------------------------ ������� $ �����
          MarhTracert[Group].GonkaStrel := false;
        end else
        begin
          tail := false;

          for k := 1 to MarhTracert[Group].CIndex do
          if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then
          begin
            tail := true;
            break;
          end;

          if tail then  //-------------------------------------------- ���� ����� ��������
          begin
            MarhTracert[Group].TailMsg := ' �� ������� ������� '+ ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //---------------------------------- ������� $ �����
            result := trEnd;
          end else  //--------------------------------------- ���� �� � ����� ��������
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83); //---------------------------------- ������� $ �����
            result := trBreak;
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;
    end;

    else
      result := trStop;
      exit; //------------------------------------ ���� �� �������� �������, �� ����������
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepSPforZamykTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not ObjZav[jmp.Obj].bParam[1] and    //--------------------- ���� ����� ������� � ...
  not ObjZav[jmp.Obj].ObjConstB[5] and    //------------------------ ���� ������� �� � ...
  (Rod = MarshM) then //----------------------------------------------- ���������� �������
  begin //---------------- ������ �������������� � ���������� �������� � ��������� �������
    MarhTracert[Group].TailMsg := ' �� ������� ������� '+ ObjZav[jmp.Obj].Liter;
    MarhTracert[Group].FindTail := false;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      if ObjZav[jmp.Obj].bParam[2]
      then ObjZav[jmp.Obj].bParam[14] := true; //------------------------- ����. ���������

      ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //---------- ������ ������
      ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr; //------- ������ ���������

      if not ObjZav[jmp.Obj].ObjConstB[5] and //---------------------------- ���� �� � ...
      (Rod = MarshM) then //------------------------------------------- ���������� �������
      begin //-------------------------------------------- ��� �� � �������� ��������� 1��
        ObjZav[jmp.Obj].bParam[15] := true;  //--------------------------------------- 1��
        ObjZav[jmp.Obj].bParam[16] := false; //--------------------------------------- 2��
      end else
      begin //----------------------------------------------------------- ����� ����� ����
        ObjZav[jmp.Obj].bParam[15] := false; //--------------------------------------- 1��
        ObjZav[jmp.Obj].bParam[16] := false; //--------------------------------------- 2��
      end;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      if ObjZav[jmp.Obj].bParam[2] //--------------------- ���� ��� "�" �� �������� ������
      then ObjZav[jmp.Obj].bParam[14] := true;  //---- �� ���������� ����������� ���������

      ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //---------- ������ ������
      ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr; //------- ������ ���������

      if not ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshM) then
      begin //-------------------------------------------- ��� �� � �������� ��������� 2��
        ObjZav[jmp.Obj].bParam[15] := false; //--------------------------------------- 1��
        ObjZav[jmp.Obj].bParam[16] := true;  //--------------------------------------- 2��
      end else
      begin //----------------------------------------------------------------- ����� ����
        ObjZav[jmp.Obj].bParam[15] := false; //--------------------------------------- 1��
        ObjZav[jmp.Obj].bParam[16] := false; //--------------------------------------- 2��
      end;
    end;
  end;
end;
//========================================================================================
function StepSPSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  result := trNextStep;

  //""""""""""""""""""""""" ��������� ��������� ����������� """"""""""""""""""""""""""""""
  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //-- ������ ��� ������.
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,134); //--------------------------- ������� $ ������ ��� ��������
    result :=  trBreak;
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or  //----------------- ���� �� ����������� ���� ��� ...
  ObjZav[jmp.Obj].ObjConstB[9] then   //------------------------------ �� ����������� ����
  begin
    if ObjZav[jmp.Obj].bParam[24] or //--- ���� ������ ��� �������� �� ��.�. � ��� ��� ���
    ObjZav[jmp.Obj].bParam[27] then //---------------- ������ ��� �������� �� ��.�. � STAN
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and //------------------------- ��� ������� ����������
    ObjZav[jmp.Obj].ObjConstB[9] then //--- ���� �� ����������� ���� � �� ����������� ����
    begin
      if ObjZav[jmp.Obj].bParam[25] or //-------- ������ ��� �������� �� ����.�. � ��� ���
      ObjZav[jmp.Obj].bParam[28] then //------------ ������ ��� �������� �� ����.�. � STAN
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467); //-------- ������� �������� �� �� ����������� ���� �� $
      end;
      if ObjZav[jmp.Obj].bParam[26] or
      ObjZav[jmp.Obj].bParam[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //-------- ������� �������� �� �� ����������� ���� �� $
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- ��
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84); //----------- ����������� ������������� ���������� ������� $
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //--------------------------------------------- ��
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85); //----------------------------- ������� $ ������� � ��������
  end;

  if Rod = MarshP then
  begin
    if not ObjZav[jmp.Obj].bParam[1] then //---------------------------- ��������� �������
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,83); //---------------------------------------- ������� $ �����
    end;
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[1] then   //----- ��� �������� � ����������� 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //----------------------- ��� �������� ��������� �� $
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then  //---- ��� ���������� � ����������� 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162);  //-------------------- ��� ���������� ��������� �� $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ ��������� �������
        begin
          if ObjZav[jmp.Obj].bParam[15] then //--------------------------------------- 1��
          begin
            MarhTracert[Group].TailMsg :=' �� ������� ������� '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //---------------------------------- ������� $ �����
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

  end else //-------------------------------------------------------- ���� ����� � ����� 2
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[2] then //-------- ���� ��� �������� � ����. 1<-2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161);  //---------------------- ��� �������� ��������� �� $
        end;
      end;

      MarshM :
      begin

        if not ObjZav[jmp.Obj].ObjConstB[4] then    //���� ��� ���������� � �������. 1<-2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //--------------------- ��� ���������� ��������� �� $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZav[jmp.Obj].bParam[16] then //--------------------------------------- 2��
          begin
            MarhTracert[Group].TailMsg :=' �� ������� ������� '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;

      end;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepSPOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin
  if Con.Pin = 1 then  sosed := 2
  else sosed := 1;

  Con := ObjZav[jmp.Obj].Neighbour[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else  result := trNextStep;
  end;

  if result = trNextStep then
  begin
    ObjZav[jmp.Obj].bParam[14] := false; //------------------------------- ����. ���������
    ObjZav[jmp.Obj].bParam[8]  := true;  //---------------------------------------- ������
    ObjZav[jmp.Obj].iParam[1]  := 0;
    ObjZav[jmp.Obj].iParam[2]  := 0;
    ObjZav[jmp.Obj].bParam[15] := false; //------------------------------------------- 1��
    ObjZav[jmp.Obj].bParam[16] := false; //------------------------------------------- 2��
  end;
end;
//========================================================================================
function StepSPRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  result := trNextStep;
  if not ObjZav[jmp.Obj].bParam[2] then //--------------------------------- ��������� ����
  begin
    if ObjZav[jmp.Obj].ObjConstB[5] then //----------------------------------- ���� ��� ��
    begin //--------------------------------------------------- �� - ������ ��������������
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,82);   //------------------------------------ ������� $ �������
    end else
    begin //--------------------------------------------------------------------------- ��
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[15] and
          not ObjZav[jmp.Obj].ObjConstB[16] then //------------------------------ ��� ����
          begin //-------------------------------------------------- ������ ��������������
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,82); //-------------------------------- ������� $ �������
          end else
          begin //----------------------------------------------------------- ������������
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,82); //-------------------------------- ������� $ �������
          end;
        end;

        MarshM :
        begin
          if Con.Pin = 1 then
          begin
            if ObjZav[jmp.Obj].bParam[15] and
            not ObjZav[jmp.Obj].ObjConstB[16] then //-------------------- ���� 1�� ��� 2��
            begin //------------------------------------------------ ������ ��������������
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,82); //------------------------------ ������� $ �������
            end else
            begin //--------------------------------------------------------- ������������
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,82); //------------------------------ ������� $ �������
            end;
          end else
          begin
            if not ObjZav[jmp.Obj].bParam[15] and
            ObjZav[jmp.Obj].ObjConstB[16] then //------------------------ ���� 2�� ��� 1��
            begin //------------------------------------------------ ������ ��������������
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,82); //------------------------------ ������� $ �������
            end else
            begin //--------------------------------------------------------- ������������
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,82); //------------------------------ ������� $ �������
            end;
          end;
        end;

        else
          inc(MarhTracert[Group].MsgCount); //------------------------------- ������������
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,82); //---------------------------------- ������� $ �������
      end;
    end;
  end;

  if not ObjZav[jmp.Obj].bParam[7] or
  ObjZav[jmp.Obj].bParam[14] then //-------------------------------- ����������� ���������
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,82); //---------------------------------------- ������� $ �������
  end;

  if ObjZav[jmp.Obj].bParam[12] or
  ObjZav[jmp.Obj].bParam[13] then //------------- ������ ��� �������� � ��� ��� ��� � STAN
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,134);
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or
  ObjZav[jmp.Obj].ObjConstB[9] then //---------------------- ���� ������� ����������������
  begin
    if ObjZav[jmp.Obj].bParam[24] or
    ObjZav[jmp.Obj].bParam[27] then //----------------------- ������ ��� �������� �� ��.�.
    begin
      inc(MarhTracert[Group].WarCount);         //------------------------- ��������������
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462);  //----------------- ������� �������� �� ����������� �� $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then //----- ��� ����
    begin
      if ObjZav[jmp.Obj].bParam[25] or
      ObjZav[jmp.Obj].bParam[28] then //------------------- ������ ��� �������� �� ����.�.
      begin
        inc(MarhTracert[Group].WarCount);       //------------------------- ��������������
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);//--------- ������� �������� �� �� ����������� ���� �� $
      end;

      if ObjZav[jmp.Obj].bParam[26] or
      ObjZav[jmp.Obj].bParam[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTracert[Group].WarCount);       //------------------------- ��������������
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //-------- ������� �������� �� �� ����������� ���� �� $
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- ��
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84);
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //--------------------------------------------- ��
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85); //----------------------------- ������� $ ������� � ��������
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ ��������� �������
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);  //----------------------------------- ������� $ �����
        end;

        if not ObjZav[jmp.Obj].ObjConstB[1] then //------- ��� �������� � ����������� 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //----------------------- ��� �������� ��������� �� $
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //--------------------- ��� ���������� ��������� �� $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- ��������� �������
          if not ObjZav[jmp.Obj].ObjConstB[5] then //---------------------------------- ��
          begin
            MarhTracert[Group].TailMsg := ' �� ������� ������� '+ ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //---------------------------------- ������� $ �����
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      ObjZav[jmp.Obj].bParam[8] := false;
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end else
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ ��������� �������
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);
        end;

        if not ObjZav[jmp.Obj].ObjConstB[2] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161);   //--------------------- ��� �������� ��������� �� $
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[4] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //----------------- ��� ���������� ��������� �� $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- ��������� �������
          if not ObjZav[jmp.Obj].ObjConstB[5] then //---------------------------------- ��
          begin
            MarhTracert[Group].TailMsg :=' �� ������� ������� '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      ObjZav[jmp.Obj].bParam[8] := false;
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepSPPovtorRazdel(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  result := trNextStep;
  if not ObjZav[jmp.Obj].bParam[2] then //-------------------------------------- ���������
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,82);
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then//- ������ ��� ��������.
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,134);  //-------------------------- ������� $ ������ ��� ��������
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then  //-------- ���� ��
  begin
    if ObjZav[jmp.Obj].bParam[24] or
    ObjZav[jmp.Obj].bParam[27] then //----------------------- ������ ��� �������� �� ��.�.
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or
      ObjZav[jmp.Obj].bParam[28] then //------------------- ������ ��� �������� �� ����.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);
      end;

      if ObjZav[jmp.Obj].bParam[26] or
      ObjZav[jmp.Obj].bParam[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472);
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- ��
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84);  //---------- ����������� ������������� ���������� ������� $
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //----------------------------------------- ��
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85);  //---------------------------- ������� $ ������� � ��������
  end;

  if Con.Pin = 1 then //--------------------------------------------- ���� ����� � ����� 1
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ ��������� �������
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);  //----------------------------------- ������� $ �����
        end;

        if not ObjZav[jmp.Obj].ObjConstB[1] then //------- ��� �������� � ����������� 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //--------------------- "��� �������� ��������� �� $"
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[5] //-------------------------------- ���� ��� ��
        then ObjZav[jmp.Obj].bParam[15] := true; //----------------------------------- 1��

        if not ObjZav[jmp.Obj].ObjConstB[3] then  //---- ��� ���������� � ����������� 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //--------------------- ��� ���������� ��������� �� $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZav[jmp.Obj].bParam[15] then //--------------------------------------- 1��
          begin
            MarhTracert[Group].TailMsg :=' �� ������� ������� '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      ObjZav[jmp.Obj].bParam[8] := false;
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end else //-------------------------------------------------------- ���� ����� � ����� 2
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ ��������� �������
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);
        end;

        if not ObjZav[jmp.Obj].ObjConstB[2] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //--------------------- "��� �������� ��������� �� $"
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[5]
        then ObjZav[jmp.Obj].bParam[16] := true;

        if not ObjZav[jmp.Obj].ObjConstB[4] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //------------------- "��� ���������� ��������� �� $"
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZav[jmp.Obj].bParam[16] then //--------------------------------------- 1��
          begin
            MarhTracert[Group].TailMsg :=' �� ������� ������� '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      ObjZav[jmp.Obj].bParam[8] := false;
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
//----------------------------------------------------------- ����������� ��� ������������
function StepSPAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  result := trNextStep;

  if not ObjZav[jmp.Obj].bParam[2] {or not ObjZav[jmp.Obj].bParam[7]} then //--- ���������
  exit;
  {
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1); //---------------------- "������� $ �������"
    InsMsg(Group,jmp.Obj,82);
  end;
  }
  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //---- ������ ��� ����.
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1); //------- "������� $ ������ ��� ��������"
    InsMsg(Group,jmp.Obj,134);
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
  begin
    if ObjZav[jmp.Obj].bParam[24] or
    ObjZav[jmp.Obj].bParam[27] then //----------------------- ������ ��� �������� �� ��.�.
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462);//------------------- ������� �������� �� ����������� �� $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or
      ObjZav[jmp.Obj].bParam[28] then //------------------- ������ ��� �������� �� ����.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);
      end;

      if ObjZav[jmp.Obj].bParam[26] or
      ObjZav[jmp.Obj].bParam[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472);
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- ��
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84);//---------- "����������� ������������� ���������� ������� $"
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //--------------------------------------------- ��
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85);
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ ��������� �������
        begin
          exit;
          {
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);  //--------------- "������� $ �����"
          InsMsg(Group,jmp.Obj,83);
          }
        end;

        if not ObjZav[jmp.Obj].ObjConstB[1] then   //------------------- ��� �������� 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //--------------------- "��� �������� ��������� �� $"
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[5] then ObjZav[jmp.Obj].bParam[15] := true;

        if not ObjZav[jmp.Obj].ObjConstB[3] then  //------------------ ��� ���������� 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //------------------- "��� ���������� ��������� �� $"
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZav[jmp.Obj].bParam[15] then //--------------------------------------- 1��
          begin
            MarhTracert[Group].TailMsg :=' �� ������� ������� '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);    //----------------------------- "������� $ �����"
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);    //----------------------------- "������� $ �����"
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end else
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ ��������� �������
        begin
          exit;
          {
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);       //---------------------------- "������� $ �����"
          }
        end;
        if not ObjZav[jmp.Obj].ObjConstB[2] then    //---------------- ��� �������� 1 <- 2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161);
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[5] then ObjZav[jmp.Obj].bParam[16] := true;

        if not ObjZav[jmp.Obj].ObjConstB[4] then   //--------------- ��� ���������� 1 <- 2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,162);
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZav[jmp.Obj].bParam[16] then //--------------------------------------- 1��
          begin
            MarhTracert[Group].TailMsg :=' �� ������� ������� '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //-------------------------------- "������� $ �����"
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);  //------------------------------- "������� $ �����"
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepSPFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not ObjZav[jmp.Obj].bParam[1] then
  begin //------------------------------------------------------------------ ������� �����
    result := trBreak;
    exit;
  end else
  if ObjZav[jmp.Obj].bParam[2] then
  begin //-------------------------------------------------- ������� �� ������� � ��������
    if not((MarhTracert[Group].IzvCount = 0) and (MarhTracert[Group].Rod = MarshM)) then
    begin
      result := trStop;
      exit;
    end;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSPFindIzvStrel(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not ObjZav[jmp.Obj].bParam[1] then
  begin //------------------------------------------------------------------ ������� �����
    MarhTracert[Group].IzvStrFUZ := true;
    if ObjZav[jmp.Obj].ObjConstB[5] then
    begin //-------------------------------------------------- ���� �� - ��������� �������
      if ObjZav[jmp.Obj].bParam[2] or
      MarhTracert[Group].IzvStrNZ then //------------------------------ ������� �� �������
      MarhTracert[Group].IzvStrUZ := true;

      if MarhTracert[Group].IzvStrNZ then //------------------------ ���� ������� � ������
      begin //------------------- �������� ��������� � ����������� �������� ����� ��������
        result := trStop;
        exit;
      end;
    end else
    begin //-------------------------------- ���� �� - ��������� ������� ������� �� ������
      if MarhTracert[Group].IzvStrNZ then
      begin //---- ���� ������� - �������� ��������� � ����������� �������� ����� ��������
        MarhTracert[Group].IzvStrUZ := true;
        result := trStop;
        exit;
      end;
    end;
  end else
  if MarhTracert[Group].IzvStrFUZ then
  begin//-- ������� �������� � ���� ��������� ������� ����� ���-�� �������� ��������������
    MarhTracert[Group].IzvStrUZ := false;
    result := trStop;
    exit;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSPPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin

  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  if not ObjZav[jmp.Obj].bParam[14] and //--------------- ��� ������������ ��������� � ...
  ObjZav[jmp.Obj].bParam[7] then //------------------------ ��� ���������������� ���������
  begin //------------------------------------------------------ ��������� ������ ��������
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsMsg(Group,jmp.Obj,228);
    result := trStop;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[sosed];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepPutFindTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if Con.Pin = 1 then //------------------------------------ ���� ����� �� ������� ����� 1
  begin
    case Rod of
      MarshP :  //--------------------------------------------------------------- ��������
        if ObjZav[jmp.Obj].ObjConstB[1] //------------------------ ���� ���� �������� 1->2
        then result := trNextStep //--------------------------- ������� �� �������� ������
        else result := trRepeat; //--------------- ��� 1->2,  ������� � ���������� �������

      MarshM ://--------------------------------------------------------------- ����������
        if ObjZav[jmp.Obj].ObjConstB[3]//----------------------- ���� ���� ���������� 1->2
        then result := trNextStep //--------------------------- ������� �� �������� ������
        else result := trRepeat; //--------------- ��� 1->2,  ������� � ���������� �������

      else  result := trNextStep; //----------------------- �������� ��� ���������� ������
    end;

    if result = trNextStep then  //------------------------------- ���� ����������� ������
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2]; //----------------------- ��������� �� ������ 2
      case Con.TypeJmp of
        LnkRgn : result := trRepeat; //-------- ����� ������, ������� � ���������� �������
        LnkEnd : result := trRepeat;
      end;
    end;
  end else
  begin //---------------------------------------------- ���� ����� �� ������� ����� 2
    case Rod of
      MarshP : //------------------------------------------------------- ���� ��������
        if ObjZav[jmp.Obj].ObjConstB[2]
        then result := trNextStep
        else result := trRepeat;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[4]
        then result := trNextStep
        else result := trRepeat;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepPutContTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if Con.Pin = 1 then //--------------------------------- ����� �� ���� �� ������� ����� 1
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[1] then result := trNextStep
        else result := trStop;
      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[3] then result := trNextStep
        else result := trStop;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;
  end else   //------------------------------------------ ����� �� ���� �� ������� ����� 2
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[2] then result := trNextStep
        else result := trStop;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[4] then result := trNextStep
        else result := trStop;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
        LnkNecentr : result := trEndTrace;
      end;
    end;
  end;
end;
//========================================================================================
function StepPutZavTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;
  Con := ObjZav[jmp.Obj].Neighbour[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else result := trNextStep;
  end;
end;
//========================================================================================
function StepPutCheckTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  tail,Chi,Ni,ChKM,NKM : boolean;
  k,UTS,sosed,Put : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;
  Put := jmp.Obj;
  Chi := not ObjZav[Put].bParam[2];
  Ni :=  not ObjZav[Put].bParam[3];
  ChKM := ObjZav[Put].bParam[4];
  NKM :=  ObjZav[Put].bParam[15];
  UTS := ObjZav[Put].BaseObject;
  result := trNextStep;
  //--------------------------------------------------------------- ���� ��� ���� ���� ���
  if UTS > 0 then
  begin //------------------------------------------------------------------ ��������� ���
    case Rod of
      MarshP :
      begin
        if ObjZav[UTS].bParam[2] then
        begin //---------------------------------------------------------- ���� ����������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,108, ObjZav[Put].Liter,1);
          InsMsg(Group,Put,108);  //---------------------- "���������� ��������� ����"
          MarhTracert[Group].GonkaStrel := false;
        end else
        if not ObjZav[UTS].bParam[1] and not ObjZav[UTS].bParam[3] then
        begin //--------------------------- ���� �� ����� �������� ��������� � �� ��������
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,109, ObjZav[Put].Liter,1);
          InsMsg(Group,Put,109);//------- "��������� ���� �� ����� �������� ���������"
          MarhTracert[Group].GonkaStrel := false;
        end;
      end;

      MarshM :
      begin
        if not ObjZav[UTS].bParam[1] and ObjZav[UTS].bParam[2] and
        not ObjZav[UTS].bParam[3] then
        begin //-------------------------------------------- ���� ���������� � �� ��������
          if not ObjZav[Put].bParam[1] then
          begin //------------------------------------------------------------- ���� �����
            if not ObjZav[UTS].bParam[27] then
            begin //------------------------------------------- ��������� �� �������������
              ObjZav[ObjZav[Put].BaseObject].bParam[27] := true;
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,108, ObjZav[Put].Liter,1);
              InsWar(Group,Put,108);  //------------------ "���������� ��������� ����"
            end;
          end else
          begin //---------------------------------------------------------- ���� ��������
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,108, ObjZav[Put].Liter,1);
            InsMsg(Group,Put,108);  //-------------------- "���������� ��������� ����"
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;
    end;
  end;

  if ObjZav[Put].bParam[12] or ObjZav[Put].bParam[13] then //- ������ ��� ��������
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,135, ObjZav[Put].Liter,1);
    InsMsg(Group,Put,135); //------------------------------ ���� $ ������ ��� ��������
    MarhTracert[Group].GonkaStrel := false;
  end;

  if ObjZav[Put].ObjConstB[8] or ObjZav[Put].ObjConstB[9] then //--------- ���� ��
  begin
    if ObjZav[Put].bParam[24]
    or ObjZav[Put].bParam[27] then //-------------------- ������ ��� �������� �� ��.�.
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[Put].Liter,1);
      InsWar(Group,Put,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZav[Put].ObjConstB[8] and ObjZav[Put].ObjConstB[9] then
    begin
      if ObjZav[Put].bParam[25] or
      ObjZav[Put].bParam[28] then //------------------- ������ ��� �������� �� ����.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[Put].Liter,1); InsWar(Group,Put,467);
      end;

      if ObjZav[Put].bParam[26] or
      ObjZav[Put].bParam[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[Put].Liter,1);
        InsWar(Group,Put,472); //------------------------- ����� ���������� �������� $
      end;
    end;
  end;

  case Rod of
    MarshP : //---------------------------------------------------- ��� ��������� ��������
    begin
      if not MarhTracert[Group].Povtor and   //---------- ���� �� ��������� �������� � ...
      (ObjZav[Put].bParam[14] or  //--------------- ����������� ��������� ��� ...
      not ObjZav[Put].bParam[7] or //-------- ��������������� ��������� ������ ��� ...
      not ObjZav[Put].bParam[11]) then //---------- ��������������� ��������� ��������
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,110, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,110);
        MarhTracert[Group].GonkaStrel := false;
      end;

      if not (ObjZav[Put].bParam[1] and ObjZav[Put].bParam[16]) then //- ��������� � ��� �
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,112, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,112); //-------------------------------------------- ���� $ �����
        MarhTracert[Group].GonkaStrel := false;
      end;

      if Chi or Ni then //------------------------------------------------------ �� ��� ��
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,113, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,113);//------------------ �� ���� $ ���������� ���������� �������
        MarhTracert[Group].GonkaStrel := false;
      end;

      if not (ObjZav[Put].bParam[5] and ObjZav[Put].bParam[6]) then //----------- ~��(�&�)
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,111, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,111); //--------------------------- ���� $ ������� � ��������
        MarhTracert[Group].GonkaStrel := false;
      end;

      //---------------------------------------------------------- ������  ������� �� ����
      //----------------------------------------------------------------------------------
      if (((Con.Pin = 1) and OddRight) or ((Con.Pin = 2) and (not OddRight))) then
      begin //-----------  ��������� ����� �������� ��������� ���� ��� ������� �����������
        if ObjZav[Put].ObjConstB[11] then  //-------------------- ����� �������.�������� �
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[Put].Liter,1);
          InsWar(Group,Put,473); //----------------------- ����� ���������� �������� $
        end;
      end else //------------------------------------------------ �������� ������� �� ����
      begin //---------- ��������� ����� �������� ��������� ���� ��� ��������� �����������
        if ObjZav[Put].ObjConstB[10] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[Put].Liter,1);
          InsWar(Group,Put,473);
        end;
      end;
    end;

    //--------------------------------------------------- ��� ����������� �������� �� ����
    MarshM :
    begin
      if not MarhTracert[Group].Povtor and
      (ObjZav[Put].bParam[14] or //----------- ����������� ��������� �� ��-��� ��� ...
      not ObjZav[Put].bParam[7] or //-------- ��������������� ��������� FR3(�) ��� ...
      not ObjZav[Put].bParam[11]) then //-----------  ��������������� ��������� FR3(�)
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,110, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,110); //----------------------- ����������� ��������� $ � ���
        MarhTracert[Group].GonkaStrel := false;
      end;

      if not (ObjZav[Put].bParam[5] and ObjZav[Put].bParam[6]) then //--------- ~��(� & �)
      begin
        result := trBreak;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,111, ObjZav[Put].Liter,1);
        InsWar(Group,Put,111);   //----------------------------- ���� $ ������� � ��������
      end;

      //----------------------------------------------------------  ������ ������� �� ����
      if (((Con.Pin = 1) and OddRight) or ((Con.Pin = 2) and (not OddRight))) then
      begin
        if (not NKM and Ni) or Chi then//------------------------- �� ��� ��� ��� ����� ��
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[Put].Liter,1);
          result := trBreak;
          InsMsg(Group,Put,113); //----------- �� ���� $ ���������� ���������� �������
          MarhTracert[Group].GonkaStrel := false;
        end else
        if Ni then //------------------------------------------------------------------ ��
        begin
          if NKM then //--------------------------------------------------------- ���� ���
          begin
            tail := false;
            for k := 1 to MarhTracert[Group].CIndex do
            if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then
            begin
              tail := true;
              break;
            end;

            if tail then
            begin
              MarhTracert[Group].TailMsg := ' �� ��������� ���� '+ ObjZav[Put].Liter;
              MarhTracert[Group].FindTail := false;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,441, ObjZav[Put].Liter,1);
              InsWar(Group,Put,441);// �� ���� ���������� ��������� ���������� �������
            end else
            begin //--------��� �������� ����� ������ ����� ������ ���������� ���� - �����
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,113, ObjZav[Put].Liter,1);
              InsMsg(Group,Put,113);//-------- �� ���� $ ���������� ���������� �������
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[Put].Liter,1);
            InsMsg(Group,Put,113);//---------- �� ���� $ ���������� ���������� �������
            MarhTracert[Group].GonkaStrel := false;
          end;
          result := trBreak;
        end;
      end else //-------------------------------------------------------- �������� �������
      begin
        if (not ChKM and Chi) or Ni then //------ ����� ������ �������� ��� ����� ��������
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[Put].Liter,1);
          result := trBreak;
          InsMsg(Group,Put,113);//------------ �� ���� $ ���������� ���������� �������
          MarhTracert[Group].GonkaStrel := false;
        end else
        if Chi then //----------------------------------------------------------------- ��
        begin
          if ChKM then //------------------------------------------------------------- ���
          begin
            tail := false;

            for k := 1 to MarhTracert[Group].CIndex do
            if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then
            begin
              tail := true;
              break;
            end;

            if tail then
            begin
              MarhTracert[Group].TailMsg :=  ' �� ��������� ���� '+ ObjZav[Put].Liter;
              MarhTracert[Group].FindTail := false;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,441, ObjZav[Put].Liter,1);
              InsWar(Group,Put,441);// �� ���� ���������� ��������� ���������� �������
            end else
            begin //------ ���� �������� ����� ������ ����� ������ ���������� ���� - �����
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,113, ObjZav[Put].Liter,1);
              InsMsg(Group,Put,113);//-------- �� ���� $ ���������� ���������� �������
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else //------------------------------------------------------------- ��� ���
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[Put].Liter,1);
            InsMsg(Group,Put,113);//---------- �� ���� $ ���������� ���������� �������
            MarhTracert[Group].GonkaStrel := false;
          end;
          result := trBreak;
        end;
      end;

      if not (ObjZav[Put].bParam[1] and ObjZav[Put].bParam[16]) //- �����(� ��� �)
      then
      begin
        tail := false;

        for k := 1 to MarhTracert[Group].CIndex do
        if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then
        begin
          tail := true;
          break;
        end;

        if tail then
        begin
          MarhTracert[Group].TailMsg := ' �� ������� ���� '+ ObjZav[Put].Liter;
          MarhTracert[Group].FindTail := false;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,112, ObjZav[Put].Liter,1);
          InsWar(Group,Put,112);
        end else
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,112, ObjZav[Put].Liter,1);
          InsMsg(Group,Put,112);
          MarhTracert[Group].GonkaStrel := false;
        end;
        result := trBreak;
      end;
    end;

    else begin result := trStop; exit; end;  //------------------- ��� ���������� ��������
  end;

  Con := ObjZav[Put].Neighbour[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trStop;
    LnkEnd : result := trStop;
    LnkNecentr : result := trEndTrace;
  end;
end;
//========================================================================================
function StepPutZamykTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  if not ObjZav[jmp.Obj].bParam[1] then //------------------------------------- ���� �����
  begin
    MarhTracert[Group].TailMsg := ' �� ������� ���� '+ ObjZav[jmp.Obj].Liter;
    MarhTracert[Group].FindTail := false;
  end;

  Con := ObjZav[jmp.Obj].Neighbour[sosed]; //---------------------- ��������� ����� ������
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else  result := trNextStep;
  end;

  if result = trNextStep then  //--------------------------- ���� ������������ ���������
  begin
    ObjZav[jmp.Obj].bParam[8] := true;  //------------------------ ����� ����. ���������
    ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
    ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr;
  end;
end;
//========================================================================================
function StepPutSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  UTS : integer;
  Signal : integer;
begin
  result := trNextStep;
  UTS := ObjZav[jmp.Obj].BaseObject;
  if MarhTracert[Group].ObjStart >0 then 
  Signal := MarhTracert[Group].ObjStart;

  if UTS > 0 then
  begin //------------------------------------------------------------------ ��������� ���
    case Rod of
      MarshP :
      begin
        if ObjZav[UTS].bParam[2] then
        begin //---------------------------------------------------------- ���� ����������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1); //------- ���������� ��������� ���� $
          InsMsg(Group,jmp.Obj,108);
        end else
        if not ObjZav[UTS].bParam[1] and
        not ObjZav[UTS].bParam[3] then
        begin //--------------------------- ���� �� ����� �������� ��������� � �� ��������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,109, ObjZav[jmp.Obj].Liter,1);//------ ���� $ ��� �������� ���������
          InsMsg(Group,jmp.Obj,109);
        end;
      end;

      MarshM :
      begin
        if not ObjZav[UTS].bParam[1] and  ObjZav[UTS].bParam[2] and
        not ObjZav[UTS].bParam[3] then
        begin //-------------------------------------------- ���� ���������� � �� ��������
          if not ObjZav[jmp.Obj].bParam[1] then
          begin //------------------------------------------------------------- ���� �����
            if not ObjZav[UTS].bParam[27] then//--------------- ��������� �� �������������
            begin
              ObjZav[UTS].bParam[27] := true;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,108); //------------------- "���������� ��������� ����"
            end;
          end else
          begin //---------------------------------------------------------- ���� ��������
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,108);
          end;
        end;
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //---- �������� �������
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,135, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,135); //------------------------------ ���� $ ������ ��� ��������
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
  begin
    if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then //-- ������� �� ����.
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1); //-- ������� �������� �� ����������� �� $
      InsWar(Group,jmp.Obj,462);
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then //---- ��� ����. -�
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1); //--- ������� �������� �� �� ����. ����
        InsWar(Group,jmp.Obj,467);
      end;

      if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then //---- ��� ����. ~�
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);//--- ������� �������� �� �� ���.���� ��
        InsWar(Group,jmp.Obj,472);
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not(ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then //- �����(�&�)
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1); //------------------------ ���� $ �����
        InsMsg(Group,jmp.Obj,112);
      end;

      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //--- ~��(�&�)
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1); //----------- ���� $ ������� � ��������
        InsMsg(Group,jmp.Obj,111);
      end;

      if Con.Pin = 1 then //----------------------------- ����� �� ���� �� ������� ����� 1
      begin //------------ ��������� ����� �������� ��������� ���� ��� ������� �����������
        if ObjZav[jmp.Obj].ObjConstB[11] then //------- ���� ������� ����� ���������� ����
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);//-------- ����� ���������� �������� $
          InsWar(Group,jmp.Obj,473);
        end;
      end else //---------------------------------------- ����� �� ���� �� ������� ����� 2
      begin //---------- ��������� ����� �������� ��������� ���� ��� ��������� �����������
        if ObjZav[jmp.Obj].ObjConstB[10] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473);
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //--- ~��(�&�)
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1); //----------- ���� $ ������� � ��������
        InsWar(Group,jmp.Obj,111);
      end;

      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then //----- �����
      begin
        MarhTracert[Group].TailMsg := ' �� ������� ���� '+ ObjZav[jmp.Obj].Liter;
        MarhTracert[Group].FindTail := false;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,112);
      end;
    end;

    else result := trStop;
  end;

  if (((Con.Pin = 1) and (not OddRight))
  or ((Con.Pin = 2) and OddRight)) then //-------------- ����� �� ���� �� ������� ��������
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[1] then
        begin //-------------------------------------------- ��� �������� �������� �� ����
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77);  //----------------------------- ������� �� ����������
        end else
        if ObjZav[jmp.Obj].bParam[3] or   //------------------------------- ��� �� ��� ...
        (not ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[4]) then //---- �� � ���
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //----------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then      //-------------- ��� ���������� 1->2
        begin //----------------------- �� ����� ���� �������� ���������� �������� �� ����
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77);  //----------------------------- ������� �� ����������
        end;

        if (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4])//- �� ��� ���
        or  //-------------------------------------------------------------------- ��� ...
        (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15]) //-- �� ��� ���
        then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //-------------------------- ������ ���������� ������
        end;
      end;
    end;

    if ObjZav[jmp.Obj].bParam[3] and (ObjZav[jmp.Obj].ObjConstI[4]<>0)
    then //------------------------------------------------ ��� ��, � ������ �� ����������
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,457, ObjZav[jmp.Obj].Liter,1); //------------------------- ��� ���������
      InsMsg(Group,jmp.Obj,457);
    end;

    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin//-------------------------------------------------- ����� �� ���� � ������ �������
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[2] then  //-------------------- ��� �������� 1<-2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ ������� �� ����������
        end else
        if(ObjZav[jmp.Obj].bParam[2]) or //---------- ���� �� ��� ...
        (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then //--- �� � ���
        begin
          if not ObjZav[Signal].bParam[8] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,113); //-------------------- ���������� ���������� �������
          end;
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[4] then  //-------------------- ��� �������� 1<-2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ ������� �� ����������
        end;

        if (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15])// �� ��� ���
        or  //-------------------------------------------------------------------- ��� ...
        (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) then//�� ��� ���
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //-------------------------- ������ ���������� ������
        end;
      end;
    end;

    if ObjZav[jmp.Obj].bParam[2] and (ObjZav[jmp.Obj].ObjConstI[3]<>0)
    then //--------------------------------------------------------- ��� ��, � ������ ����
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,457, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,457);
    end;
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepPutOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  Con := ObjZav[jmp.Obj].Neighbour[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else result := trNextStep;
  end;

  if result = trNextStep then
  begin
    ObjZav[jmp.Obj].bParam[14] := false;  //------------------------------ ����. ���������
    ObjZav[jmp.Obj].bParam[8]  := true;  //---------------------------------------- ������
    ObjZav[jmp.Obj].iParam[sosed+1] := 0; //------------------------------ ������ ��������
  end;
end;
//========================================================================================
function StepPutRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  UTS : integer;
begin
  result := trNextStep;
  UTS := ObjZav[jmp.Obj].BaseObject;
  if  UTS > 0 then
  begin //------------------------------------------------------------------ ��������� ���
    case Rod of
      MarshP :
      begin
        if ObjZav[UTS].bParam[2] then
        begin //---------------------------------------------------------- ���� ����������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,108); //------------------------- ���������� ��������� ����
        end else
        if not ObjZav[UTS].bParam[1] and not ObjZav[UTS].bParam[3] then
        begin //--------------------------- ���� �� ����� �������� ��������� � �� ��������
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,109, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,109);//------- ��������� ���� $ �� ����� �������� ���������
        end;
      end;

      MarshM :
      begin
        if not ObjZav[UTS].bParam[1] and ObjZav[UTS].bParam[2] and
        not ObjZav[UTS].bParam[3] then
        begin //-------------------------------------------- ���� ���������� � �� ��������
          if not ObjZav[jmp.Obj].bParam[1] then
          begin //------------------------------------------------------------- ���� �����
            if not ObjZav[UTS].bParam[27] then
            begin //------------------------------------------- ��������� �� �������������
              ObjZav[UTS].bParam[27] := true;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,108); //--------------------- ���������� ��������� ����
            end;
          end else
          begin //---------------------------------------------------------- ���� ��������
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,108); //----------------------- ���������� ��������� ����
          end;
        end;
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[14] or
  not ObjZav[jmp.Obj].bParam[7] or
  not ObjZav[jmp.Obj].bParam[11] then //----------- ���� ����������� ��������� �����������
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,110, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,110); //--------------------------- ����������� ��������� $ � ���
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //- ������ ��� ��������
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,135, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,135);  //----------------------------- ���� $ ������ ��� ��������
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then //--- ���� ����� ��
  begin
    if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then //----- ������ ��� ��
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462);  //----------------- ������� �������� �� ����������� �� $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then //������ �� ����.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);// ������� �������� �� ����������� ����������� ���� �� $
      end;

      if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then //������ ��� ���.�.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //������� �������� �� ����������� ����������� ���� �� $
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // �����(�|�)
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,112); //--------------------------------------- ���� $ �����#
      end;

      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //--- ~��(�&�)
      begin
        inc(MarhTracert[Group].MsgCount);  //-------------------------------- ������������
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,111);     //----------------------- ���� $ ������� � ��������
      end;

      if Con.Pin = 1 then
      begin //------------ ��������� ����� �������� ��������� ���� ��� ������� �����������
        if ObjZav[jmp.Obj].ObjConstB[11] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473);//------------------------ ����� ���������� �������� $
        end;
      end else
      begin //---------- ��������� ����� �������� ��������� ���� ��� ��������� �����������
        if ObjZav[jmp.Obj].ObjConstB[10] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473); //----------------------- ����� ���������� �������� $
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~��(�&�)
      begin
        inc(MarhTracert[Group].WarCount); //------------------------------- ��������������
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,111); //--------------------------- ���� $ ������� � ��������
      end;

      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // �����(�|�)
      begin
        MarhTracert[Group].TailMsg := ' �� ������� ���� '+ ObjZav[jmp.Obj].Liter;
        MarhTracert[Group].FindTail := false;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,112);  //--------------------------------------- ���� $ �����
      end;
    end;

    else  result := trStop;
  end;

  if Con.Pin = 1 then    //------------------- ���� �� ���� � ����� 1 (� �������� �������)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[1] then
        begin //-------------------------------------------- ��� �������� �������� �� ����
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77);
        end else
        if not ObjZav[jmp.Obj].bParam[3] or //------------------------------------- �� ���
        (not ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[4]) then //---- �� � ���
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //----------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then
        begin //------------------------------------------ ��� �������� ���������� �� ����
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ ������� �� ����������
        end;

        if not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4] then//�� ��� ���
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //----------- �� ���� $ ���������� ���������� �������
        end;

        if not ObjZav[jmp.Obj].bParam[3] then // -------------------------------------- ��
        begin
          if ObjZav[jmp.Obj].bParam[15] then //--------------------------------------- ���
          begin
            MarhTracert[Group].TailMsg := ' �� ��������� ���� '+ ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,441, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,441); //�� ���� $ ���������� ��������� ���������� �������
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,113); //--------- �� ���� $ ���������� ���������� �������
          end;
        end;
      end;
    end;

    ObjZav[jmp.Obj].bParam[8] := false;
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else    //-------------------------------- ���� �� ���� � ����� 2 (� ������ �������)
  begin
    case Rod of
      MarshP : begin
        if not ObjZav[jmp.Obj].ObjConstB[2] then
        begin //---------------------------------------------- ��� ������ �������� �� ����
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //----------------------------- ������� �� ����������
        end else
        if not ObjZav[jmp.Obj].bParam[2] or  //------------------------------------ �� ���
        (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then //--  �� � ���
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[4] then
        begin //-------------------------------------------- ��� ������ ���������� �� ����
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ ������� �� ����������
        end;

        if not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15] then//�� ��� ���
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;

        if not ObjZav[jmp.Obj].bParam[2] then //---------------------------------- ���� ��
        begin
          if ObjZav[jmp.Obj].bParam[4] then //----------------------------------- ���� ���
          begin
            MarhTracert[Group].TailMsg := ' �� ��������� ���� '+ ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,441, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,441); //�� ���� $ ���������� ��������� ���������� �������
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,113);//---------- �� ���� $ ���������� ���������� �������
          end;
        end;
      end;
    end;

    ObjZav[jmp.Obj].bParam[8] := false;
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepPutAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  UTS : integer;
begin
  result := trNextStep;
  UTS := ObjZav[jmp.Obj].BaseObject;
  if  UTS > 0 then
  begin //------------------------------------------------------------------ ��������� ���
    case Rod of
      MarshP :
      begin
        if ObjZav[UTS].bParam[2] then
        begin //---------------------------------------------------------- ���� ����������
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,108); //------------------------- ���������� ��������� ����
        end else
        if not ObjZav[UTS].bParam[1] and not ObjZav[UTS].bParam[3] then
        begin //--------------------------- ���� �� ����� �������� ��������� � �� ��������
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,109, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,109);//------- ��������� ���� $ �� ����� �������� ���������
        end;
      end;

      MarshM :
      begin
        if not ObjZav[UTS].bParam[1] and ObjZav[UTS].bParam[2] and
        not ObjZav[UTS].bParam[3] then
        begin //-------------------------------------------- ���� ���������� � �� ��������
          if not ObjZav[jmp.Obj].bParam[1] then
          begin //------------------------------------------------------------- ���� �����
            if not ObjZav[UTS].bParam[27] then
            begin //------------------------------------------- ��������� �� �������������
              ObjZav[UTS].bParam[27] := true;
              result := trStop;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,108); //--------------------- ���������� ��������� ����
            end;
          end else
          begin //---------------------------------------------------------- ���� ��������
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,108); //----------------------- ���������� ��������� ����
          end;
        end;
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[14] then //----------------- ����������� ��������� �����������
  begin
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,110, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,110);  //-------------------------- ����������� ��������� $ � ���
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //- ������ ��� ��������
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,135, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,135); //------------------------------ ���� $ ������ ��� ��������
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
  begin
    if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then //----- ������ ��� ��
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then //- ������ ����. ��
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467); //������� �������� �� ����������� ����������� ���� �� $
      end;

      if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then //-- ������ ���. ��
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //������� �������� �� ����������� ����������� ���� �� $
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // �����(�|�)
      begin
        exit;
        {
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,112); //---------------------------------------- ���� $ �����
        }
      end;

      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //---- ��(�|�)
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,111); //--------------------------- ���� $ ������� � ��������
      end;

      if Con.Pin = 1 then
      begin //------------ ��������� ����� �������� ��������� ���� ��� ������� �����������
        if ObjZav[jmp.Obj].ObjConstB[11] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473); //----------------------- ����� ���������� �������� $
        end;
      end else
      begin //---------- ��������� ����� �������� ��������� ���� ��� ��������� �����������
        if ObjZav[jmp.Obj].ObjConstB[10] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473);
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //---- ��(�|�)
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,111);
      end;

      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // �����(�|�)
      begin
        MarhTracert[Group].TailMsg := ' �� ������� ���� '+ ObjZav[jmp.Obj].Liter;
        MarhTracert[Group].FindTail := false;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,112); //---------------------------------------- ���� $ �����
      end;
    end;

    else result := trStop;
  end;

  if (((Con.Pin = 1) and (not OddRight))
  or ((Con.Pin = 2) and OddRight)) then //------------------ ����� �� ������� 1 (��������)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[1] then
        begin //-------------------------------------------- ��� �������� �������� �� ����
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77);
        end else
        if not ObjZav[jmp.Obj].bParam[3] or (not ObjZav[jmp.Obj].bParam[2]
        and ObjZav[jmp.Obj].bParam[4]) then //---------------------------- �� ��� �� � ���
        begin
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then
        begin //------------------------------------------ ��� �������� ���������� �� ����
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ ������� �� ����������
        end;

        if (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15])// �� ��� ���
        or//-------------------------------------------------------------------------- ���
        (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) //--- �� ��� ���
        then
        begin
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else  //------------------------------------------------ ����� �� ������� 2 (������)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[2] then
        begin //---------------------------------------------- ��� ������ �������� �� ����
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ ������� �� ����������
        end else
        if not ObjZav[jmp.Obj].bParam[2] or //--------------------------------- �� ��� ...
        (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then //--- �� � ���
        begin
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[4] then
        begin //-------------------------------------------- ��� ������ ���������� �� ����
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ ������� �� ����������
        end;

        if (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) // �� ��� ���
        or  //------------------------------------------------------------------------ ���
        (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15]) //-- �� ��� ���
        then
        begin
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepPutFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then
  begin //--------------------------------------------------------------------- ���� �����
    result := trBreak;
    exit;
  end else
  if ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[3] then
  begin //----------------------------------------------------- ���� �� ������� � ��������
    if not((MarhTracert[Group].IzvCount = 0) and (MarhTracert[Group].Rod = MarshM)) then
    begin
      result := trStop;
      exit;
    end;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepPutFindIzvStrel(var Con :TOZNeighbour; const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then
  begin //------------------------------------------------------------------ ������� �����
    MarhTracert[Group].IzvStrFUZ := true;
    if MarhTracert[Group].IzvStrNZ then
    begin //------ ���� ������� - �������� ��������� � ����������� �������� ����� ��������
      MarhTracert[Group].IzvStrUZ := true;
      result := trStop;
      exit;
    end;
  end else
  if MarhTracert[Group].IzvStrFUZ then
  begin //������� �������� � ���� ��������� ������� ����� ��� - �� �������� ��������������
    MarhTracert[Group].IzvStrUZ := false;
    result := trStop;
    exit;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepPutPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not ObjZav[jmp.Obj].bParam[14] and not ObjZav[jmp.Obj].bParam[7] then
  begin //------------------------------------------------------ ��������� ������ ��������
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsMsg(Group,jmp.Obj,228); //--------------------------- ������ �������� �� $ ��������
    result := trStop;
  end else
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;

end.

