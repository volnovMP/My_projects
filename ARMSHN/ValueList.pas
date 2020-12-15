unit ValueList;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Registry, Buttons, Grids, ValEdit, Menus;

type
  TVlLstDlg = class(TForm)
    ValList: TValueListEditor;
    pmValueList: TPopupMenu;
    pmResetStat: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pmResetStatClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VlLstDlg : TVlLstDlg;

procedure UpdateKeyList(index : integer);   // �������� ������ �������� �������
procedure UpdateValueList(index : integer); // �������� ���������� � ��������� �������� �������

implementation

{$R *.dfm}

uses
  TypeALL,
  Commons,
  TabloSHN,
  KanalArmSrvSHN,
  CMenu;
//========================================================================================
procedure TVlLstDlg.FormCreate(Sender: TObject);
begin
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyRegValListForm, false) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left') else Left := 0;
    if reg.ValueExists('top')  then Top  := reg.ReadInteger('top')  else Top  := 0;
    if reg.ValueExists('height')  then Height  := reg.ReadInteger('height')  else Height := 345;
    reg.CloseKey;
  end;
end;

//========================================================================================
procedure TVlLstDlg.FormActivate(Sender: TObject);
begin
//
end;

//========================================================================================
procedure UpdateKeyList(index : integer); // �������� ������ �������� �������
begin
  VlLstDlg.ValList.Strings.Clear;
  TabloMain.TimerView.Enabled := true;
  if not VlLstDlg.Visible then VlLstDlg.Show;
end;

//========================================================================================
procedure UpdateValueList(index : integer); //----�������� ���������� � ��������� ��������
var
  st,nep,rdy : boolean;
  i,j,k,o : smallint;
  s,MsgS : string;
begin
  if not VlLstDlg.Visible then exit;
  VlLstDlg.ValList.Strings.Clear;
  case ObjZv[index].TypeObj of
    2 :
    begin //---------------------------------------------------------------------- �������
      if ObjZv[ObjZv[index].BasOb].ObCI[9] > 0 then
      begin //---------------------------------------------------------- ��������� �������
        o := ObjZv[index].BasOb;
        with ObjZv[o] do
        begin
          VlLstDlg.Caption:= '�������� : ������� '+ObjZv[index].Liter+' ('+Liter+')';
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep
          then VlLstDlg.ValList.Values['�������� ��������'] := '��������������' else
          if not rdy
          then VlLstDlg.ValList.Values['�������� ��������'] := '��� ������' else
          if st
          then VlLstDlg.ValList.Values['�������� ��������'] := '����' else
          VlLstDlg.ValList.Values['�������� ��������'] := '���';
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);

          if nep then VlLstDlg.ValList.Values['��������� ��������']:= '��������������'
          else
          if not rdy then VlLstDlg.ValList.Values['��������� ��������']:= '��� ������'
          else
          if st then VlLstDlg.ValList.Values['��������� ��������'] := '����'
          else VlLstDlg.ValList.Values['��������� ��������'] := '���';

          if (dtP[1]>0) or (siP[1]>0) or (siP[2]>0)or (siP[6] > 0) or (siP[7] > 0) then
          begin
            if dtP[1] > 0 then
            begin
              DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
              VlLstDlg.ValList.Values['������ ��������'] := s;
            end else VlLstDlg.ValList.Values['������ ��������'] := '�� �������������';

            if siP[1] > 0
            then VlLstDlg.ValList.Values['�� + ���������'] := IntToStr(siP[1]);

            if siP[2] > 0
            then VlLstDlg.ValList.Values['�� - ���������']:=IntToStr(siP[2]);

            if siP[6] > 0
            then VlLstDlg.ValList.Values['�� + �������'] := IntToStr(siP[6]);

            if siP[7] > 0
            then VlLstDlg.ValList.Values['�� - �������'] := IntToStr(siP[7]);
          end;

          if (dtP[2] > 0) or (siP[3] > 0) then
          begin
            if dtP[2] > 0 then
            begin
              DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
              VlLstDlg.ValList.Values['������������'] := s;
            end else VlLstDlg.ValList.Values['������������'] := '�� �������������';

            if siP[3] > 0 then
            VlLstDlg.ValList.Values['����������'] := IntToStr(siP[3]);
          end;

          if siP[4] > 0 then
          VlLstDlg.ValList.Values['��������� � +'] := IntToStr(siP[4]);

          if siP[5] > 0 then
          VlLstDlg.ValList.Values['��������� � -'] := IntToStr(siP[5]);

          if dtP[3] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[3]);
            VlLstDlg.ValList.Values['����� �������� � +'] := s;
          end;

          if dtP[4] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[4]);
            VlLstDlg.ValList.Values['����� �������� � -'] := s;
          end;

          st := GetFR4State(ObCI[1]-5);
          if st then VlLstDlg.ValList.Values['����������'] := '���������'
          else VlLstDlg.ValList.Values['����������'] := '��������';

          st := GetFR4State(ObCI[1]-4);
          if st then VlLstDlg.ValList.Values['�����'] := '����������'
          else VlLstDlg.ValList.Values['�����'] := '�� ����������';


          if ObjZv[index].ObCB[6] then
          begin //-------------------------------------------------------- ������� �������
            st := GetFR4State(ObCI[1]-2);
            if st then VlLstDlg.ValList.Values['��������'] := '�������'
            else VlLstDlg.ValList.Values['��������'] := '���������';
          end else
          begin //-------------------------------------------------------- ������� �������
            st := GetFR4State(ObCI[1]-3);
            if st then VlLstDlg.ValList.Values['��������'] := '�������'
            else VlLstDlg.ValList.Values['��������'] := '���������';
          end;

          if ObjZv[index].ObCB[6] then
          begin //-------------------------------------------------------- ������� �������
            st := GetFR4State(ObCI[1]);
            if st then VlLstDlg.ValList.Values['�������� ��'] := '�������'
            else VlLstDlg.ValList.Values['�������� ��'] := '���������';
          end else
          begin //-------------------------------------------------------- ������� �������
            st := GetFR4State(ObCI[1]-1);
            if st then VlLstDlg.ValList.Values['�������� ��'] := '�������'
            else VlLstDlg.ValList.Values['�������� ��'] := '���������';
          end;
        end;
      end else
      begin //---------------------------------------------------------- ��������� �������
        o := ObjZv[index].BasOb;
        with ObjZv[o] do
        begin
          VlLstDlg.Caption := '�������� : ������� '+ Liter;
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�������� ��������'] := '��������������'
          else
          if not rdy then VlLstDlg.ValList.Values['�������� ��������'] := '��� ������'
          else
          if st then VlLstDlg.ValList.Values['�������� ��������'] := '����'
          else VlLstDlg.ValList.Values['�������� ��������'] := '���';

          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��������� ��������']:= '��������������'
          else
          if not rdy then VlLstDlg.ValList.Values['��������� ��������']:= '��� ������'
          else
          if st then VlLstDlg.ValList.Values['��������� ��������'] := '����'
          else VlLstDlg.ValList.Values['��������� ��������'] := '���';

          if (dtP[1]>0) or (siP[1]>0) or (siP[2]>0) or (siP[6]>0) or (siP[7]>0) then
          begin
            if dtP[1] > 0 then
            begin
              DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
              VlLstDlg.ValList.Values['������ ��������'] := s;
            end else VlLstDlg.ValList.Values['������ ��������'] := '�� �������������';

            if siP[1] > 0
            then VlLstDlg.ValList.Values['�� + ���������']:=IntToStr(siP[1]);

            if siP[2] > 0
            then VlLstDlg.ValList.Values['�� - ���������']:=IntToStr(siP[2]);

            if siP[6] > 0
            then VlLstDlg.ValList.Values['�� + �������'] := IntToStr(siP[6]);

            if siP[7] > 0
            then VlLstDlg.ValList.Values['�� - �������'] := IntToStr(siP[7]);
          end;

          if (dtP[2] > 0) or (siP[3] > 0) then
          begin
            if dtP[2] > 0 then
            begin
              DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
              VlLstDlg.ValList.Values['������������'] := s;
            end
            else VlLstDlg.ValList.Values['������������'] := '�� �������������';

            if siP[3] > 0 then
            VlLstDlg.ValList.Values['����������'] := IntToStr(siP[3]);
          end;

          if siP[4]>0 then VlLstDlg.ValList.Values['��������� � +']:=IntToStr(siP[4]);
          if siP[5]>0 then VlLstDlg.ValList.Values['��������� � -']:=IntToStr(siP[5]);
          if dtP[3] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[3]);
            VlLstDlg.ValList.Values['����� �������� � +'] := s;
          end;

          if dtP[4] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[4]);
            VlLstDlg.ValList.Values['����� �������� � -'] := s;
          end;
          st := GetFR4State(ObCI[1]-5);
          if st then
          VlLstDlg.ValList.Values['����������'] := '���������'
          else VlLstDlg.ValList.Values['����������'] := '��������';
          st := GetFR4State(ObCI[1]-4);

          if st then VlLstDlg.ValList.Values['�����'] := '����������'
          else VlLstDlg.ValList.Values['�����'] := '�� ����������';
          st := GetFR4State(ObCI[1]-3);

          if st then VlLstDlg.ValList.Values['��������'] := '�������'
          else VlLstDlg.ValList.Values['��������'] := '���������';
          st := GetFR4State(ObCI[1]-1);
          if st then VlLstDlg.ValList.Values['�������� ��'] := '�������'
          else VlLstDlg.ValList.Values['�������� ��'] := '���������';
        end;
      end;
    end;

    3 :
    begin //------------------------------------------------------------------------ ��,��
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Liter;
        nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['���������'] := '��������������' else
        if not rdy then
        VlLstDlg.ValList.Values['���������'] := '��� ������' else
        if st then
        VlLstDlg.ValList.Values['���������'] := '����' else
        VlLstDlg.ValList.Values['���������'] := '���';
        nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);

        if nep then
        VlLstDlg.ValList.Values['���������'] := '��������������' else
        if not rdy then
        VlLstDlg.ValList.Values['���������'] := '��� ������' else
        if st then
        VlLstDlg.ValList.Values['���������'] := '����' else
        VlLstDlg.ValList.Values['���������'] := '���';

        nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['��'] := '��������������' else
        if not rdy then
        VlLstDlg.ValList.Values['��'] := '��� ������' else
        if st then
        VlLstDlg.ValList.Values['��'] := '����' else
        VlLstDlg.ValList.Values['��'] := '���';

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then
          VlLstDlg.ValList.Values['���'] := '����' else
          VlLstDlg.ValList.Values['���'] := '���';

          if ObjZv[o].dtP[3] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[3]);
            VlLstDlg.ValList.Values['����'] := s;
          end;
        end;

        if ObjZv[o].ObCI[6] > 0 then
        begin
          nep := false;
          rdy := true;
          st := GetFR3(ObCI[6],nep,rdy);

          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then
          VlLstDlg.ValList.Values['��'] := '����' else
          VlLstDlg.ValList.Values['��'] := '���';
        end;

        if (dtP[1] > 0) or (siP[1] > 0) then
        begin
          if dtP[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
            VlLstDlg.ValList.Values['������� ������'] := s;
          end
          else VlLstDlg.ValList.Values['������� ������'] := '�� �������������';

          if siP[1] > 0 then
          VlLstDlg.ValList.Values['���������� �.'] := IntToStr(siP[1]);
        end;

        if (dtP[2] > 0) or (siP[2] > 0) then
        begin
          if dtP[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
            VlLstDlg.ValList.Values['������������ ������'] := s;
          end
          else VlLstDlg.ValList.Values['������������ ������'] := '�� �������������';

          if siP[2] > 0 then
          VlLstDlg.ValList.Values['���������� �.'] := IntToStr(siP[2]);
        end;

        st := GetFR4State(ObCI[1]*8+2);
        if st then
        VlLstDlg.ValList.Values['��������'] := '�������'
        else VlLstDlg.ValList.Values['��������'] := '���������';

        if ObCB[8] or ObCB[9] then
        begin
          st := GetFR4State(ObCI[1]*8+3);
          if st then VlLstDlg.ValList.Values['�������� ��.�.'] := '�������'
          else VlLstDlg.ValList.Values['�������� ��.�.'] := '���������';

          if ObCB[8] and ObCB[9] then
          begin
            st := GetFR4State(ObCI[1]*8);
            if st then VlLstDlg.ValList.Values['�������� ����.�.'] := '�������'
            else VlLstDlg.ValList.Values['�������� ����.�.'] := '���������';
            st := GetFR4State(ObCI[1]*8+1);
            if st then VlLstDlg.ValList.Values['�������� ���.�.'] := '�������'
            else VlLstDlg.ValList.Values['�������� ���.�.'] := '���������';
          end;
        end;
      end;
    end;

    4 :
    begin //---------------------------------------------------------------------------- �
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : ' + Liter;
        if (ObCI[2] <> ObCI[9]) and (ObCI[2] > 0) and (ObCI[9] > 0) then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������(�)'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������(�)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������(�)'] := '����'
          else VlLstDlg.ValList.Values['���������(�)'] := '���';

          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������(�)'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������(�)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������(�)'] := '����'
          else VlLstDlg.ValList.Values['���������(�)'] := '���';
        end else
        if ObjZv[o].ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������'] := '����'
          else VlLstDlg.ValList.Values['���������'] := '���';
        end else
        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������'] := '����'
          else VlLstDlg.ValList.Values['���������'] := '���';
        end;
        nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['��'] := '��������������' else
        if not rdy then
        VlLstDlg.ValList.Values['��']:= '��� ������' else
        if st then VlLstDlg.ValList.Values['��'] := '����'
        else VlLstDlg.ValList.Values['��'] := '���';

        nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['��'] := '��������������' else
        if not rdy then
        VlLstDlg.ValList.Values['��'] := '��� ������' else
        if st then VlLstDlg.ValList.Values['��'] := '����'
        else VlLstDlg.ValList.Values['��'] := '���';

        if (ObCI[5] <> ObCI[7]) and (ObCI[7] > 0) then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';

          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end else
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;
        if (ObCI[6] <> ObCI[8]) and (ObCI[6] > 0) and (ObCI[8] > 0) then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��(�)'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��(�)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��(�)'] := '����'
          else VlLstDlg.ValList.Values['��(�)'] := '���';

          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��(�)'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��(�)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��(�)'] := '����'
          else VlLstDlg.ValList.Values['��(�)'] := '���';
        end else
        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end else
        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if (dtP[1] > 0) or (siP[1] > 0) then
        begin
          if dtP[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
            VlLstDlg.ValList.Values['������� ����'] := s;
          end
          else VlLstDlg.ValList.Values['������� ����'] := '�� �������������';

          if siP[1] > 0 then
          VlLstDlg.ValList.Values['���������� �.'] := IntToStr(siP[1]);
        end;

        if (dtP[2] > 0) or (siP[2] > 0) then
        begin
          if dtP[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
            VlLstDlg.ValList.Values['������������ ����'] := s;
          end
          else VlLstDlg.ValList.Values['������������ ����'] := '�� �������������';
          if siP[2] > 0 then
          VlLstDlg.ValList.Values['���������� �.'] := IntToStr(siP[2]);
        end;

        if (dtP[3] > 0) or (siP[3] > 0) then
        begin
          if dtP[3] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[3]);
            VlLstDlg.ValList.Values['���������� ����� ����'] := s;
          end
          else VlLstDlg.ValList.Values['���������� ����� ����'] := '�� �������������';
          if siP[3] > 0 then
          VlLstDlg.ValList.Values['���������� �.'] := IntToStr(siP[3]);
        end;

        st := GetFR4State(ObCI[2] div 8 * 8 + 2);
        if st then VlLstDlg.ValList.Values['��������'] := '�������'
        else VlLstDlg.ValList.Values['��������'] := '���������';

        if ObCB[8] or ObCB[9] then
        begin
          st := GetFR4State(ObCI[2] div 8 * 8 + 3);
          if st then VlLstDlg.ValList.Values['�������� ��.�.'] := '�������'
          else VlLstDlg.ValList.Values['�������� ��.�.'] := '���������';

          if ObCB[8] and ObCB[9] then
          begin
            st := GetFR4State(ObCI[2] div 8 * 8);
            if st then VlLstDlg.ValList.Values['�������� ����.�.'] := '�������'
            else VlLstDlg.ValList.Values['�������� ����.�.'] := '���������';
            st := GetFR4State(ObCI[1] div 8 * 8 + 1);
            if st then VlLstDlg.ValList.Values['�������� ���.�.'] := '�������'
            else VlLstDlg.ValList.Values['�������� ���.�.'] := '���������';
          end;
        end;
      end;
    end;

    5 :
    begin //--------------------------------------------------------------------- ��������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : ' + Liter;
        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ �'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������ �'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ �'] := '����'
          else VlLstDlg.ValList.Values['������ �'] := '���';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ �'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������ �'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ �'] := '����'
          else VlLstDlg.ValList.Values['������ �'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�'] := '����'
          else VlLstDlg.ValList.Values['�'] := '���';
        end;

        nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['�'] := '��������������' else
        if not rdy then
        VlLstDlg.ValList.Values['�'] := '��� ������' else
        if st then VlLstDlg.ValList.Values['�'] := '����������'
        else VlLstDlg.ValList.Values['�'] := '��������';

        if (dtP[1] > 0) or (siP[1] > 0) then
        begin
          if dtP[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
            VlLstDlg.ValList.Values['������������� �'] := s;
          end else VlLstDlg.ValList.Values['������������� �'] := '�� �������������';
          if siP[1]>0 then VlLstDlg.ValList.Values['���������� �']:=IntToStr(siP[1]);
        end;

        if (dtP[2] > 0) or (siP[2] > 0) then
        begin
          if dtP[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
            VlLstDlg.ValList.Values['����������'] := s;
          end else VlLstDlg.ValList.Values['����������'] := '�� �������������';
          if siP[2]>0 then VlLstDlg.ValList.Values['���������� �.']:=IntToStr(siP[2]);
        end;

        if ObCI[9] > 0 then
        begin
          if ObCI[25] = 0 then
          begin
            nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['��'] := '��������������' else
            if not rdy then
            VlLstDlg.ValList.Values['��'] := '��� ������' else
            if st then VlLstDlg.ValList.Values['��'] := '����������'
            else VlLstDlg.ValList.Values['��'] := '��������';
          end else
          begin
            nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['���'] := '��������������' else
            if not rdy then
            VlLstDlg.ValList.Values['���'] := '��� ������' else
            if st then VlLstDlg.ValList.Values['���'] := '����������'
            else VlLstDlg.ValList.Values['���'] := '��������';
          end;
        end;

        if ObCI[25] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[25],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObCI[26] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[26],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObCI[30] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[30],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[29] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[29],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['2��/���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['2��/���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['2��/���'] := '����'
          else VlLstDlg.ValList.Values['2��/���'] := '���';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������'] := '��������'
          else VlLstDlg.ValList.Values['���������'] := '���';
        end;

        if (dtP[3] > 0) or (siP[3] > 0) then
        begin
          if dtP[3] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZv[o].dtP[3]);
            VlLstDlg.ValList.Values['������� �� ������'] := s;
          end
          else VlLstDlg.ValList.Values['������� �� ������'] := '�� �������������';

          if siP[3]>0 then VlLstDlg.ValList.Values['���������� ��']:=IntToStr(siP[3]);
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��/���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��/���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��/���'] := '����'
          else VlLstDlg.ValList.Values['��/���'] := '���';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������ �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ �����'] := '����������'
          else VlLstDlg.ValList.Values['������ �����'] := '��������';
        end;

        if (dtP[4] > 0) or (siP[4] > 0) then
        begin
          if dtP[4] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[4]);
            VlLstDlg.ValList.Values['��������� �'] := s;
          end else VlLstDlg.ValList.Values['��������� �'] := '�� �������������';

          if siP[4] > 0 then
          begin
            VlLstDlg.ValList.Values['���������� �'] := IntToStr(siP[4]);
          end else VlLstDlg.ValList.Values['���������� �'] := '�� �������������';
        end;

        if (dtP[5] > 0) or (siP[5] > 0) then
        begin
          if dtP[5] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[5]);
            VlLstDlg.ValList.Values['��������� ��'] := s;
          end else VlLstDlg.ValList.Values['��������� ��'] := '�� �������������';

          if siP[5] > 0 then
          begin
            VlLstDlg.ValList.Values['���������� ��'] := IntToStr(siP[5]);
          end else VlLstDlg.ValList.Values['���������� ��'] := '�� �������������';
        end;

        if dtP[6] > 0 then
        begin
          DateTimeToString(s,'s,z',dtP[6]);
          VlLstDlg.ValList.Values['���������� ��'] := s;
        end;

        if(ObCI[20]>0)or(ObCI[21]>0)or(ObCI[22]>0)or(ObCI[23]>0)or(ObCI[24]>0) then
        begin
          if bP[18] then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';

          if ObCB[18] then
          begin
            if bP[21] then VlLstDlg.ValList.Values['���'] := '����'
            else VlLstDlg.ValList.Values['���'] := '���';
          end;
        end;

        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['��������'] := '�������'
        else VlLstDlg.ValList.Values['��������'] := '���������';
      end;
    end;

    6 :
    begin //-------------------------------------------------------------------------- ���
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if bP[5] then VlLstDlg.ValList.Values['�������������'] := '����';
      end;
    end;

    7 :
    begin //--------------------------------------------------------------------------- ��
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          if ObCI[3] > 0 then
          begin
            nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['��'] := '��������������' else
            if not rdy then
            VlLstDlg.ValList.Values['��'] := '��� ������' else
            if st then VlLstDlg.ValList.Values['��'] := '����'
            else VlLstDlg.ValList.Values['��'] := '���';

            nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['���'] := '��������������' else
            if not rdy
            then VlLstDlg.ValList.Values['���'] := '��� ������' else
            if st then VlLstDlg.ValList.Values['���'] := '����'
            else VlLstDlg.ValList.Values['���'] := '���';
          end else
          begin
            nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['���'] := '��������������' else
            if not rdy then
            VlLstDlg.ValList.Values['���'] := '��� ������' else
            if st then VlLstDlg.ValList.Values['���'] := '����'
            else VlLstDlg.ValList.Values['���'] := '���';
          end;
        end;
      end;
    end;

    8 :
    begin //-------------------------------------------------------------------------- ���
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObjZv[o].ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����������'] := '����'
          else VlLstDlg.ValList.Values['����������'] := '���';
        end;
      end;
    end;

    9 :
    begin //------------------------------------------------------------ ��������� �������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����'] := '����'
          else VlLstDlg.ValList.Values['����'] := '���';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;
      end;
    end;

    10 :
    begin //------------------------------------------------------------ �������� ��������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����' else
          VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����'] := '����'
          else VlLstDlg.ValList.Values['����'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������'] := '����'
          else VlLstDlg.ValList.Values['��������'] := '���';
        end;

        if ObjZv[o].ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������'] := '����'
          else VlLstDlg.ValList.Values['���������'] := '���';
        end;
      end;
    end;

    11 :
    begin //----------------------------------------------- �������� �������� ������������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������'] := '����'
          else VlLstDlg.ValList.Values['������'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������������'] := '����'
          else VlLstDlg.ValList.Values['�������������'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�����.��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�����.��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����.��������'] := '����'
          else VlLstDlg.ValList.Values['�����.��������'] := '���';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�����.��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�����.��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����.��������'] := '����'
          else VlLstDlg.ValList.Values['�����.��������'] := '���';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�����.���������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�����.���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����.���������'] := '����'
          else VlLstDlg.ValList.Values['�����.���������'] := '���';
        end;
      end;
    end;

    12 :
    begin //--------------------------------------------------------- �������� �������� ��
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�����.��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�����.��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����.��������'] := '����'
          else VlLstDlg.ValList.Values['�����.��������'] := '���';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�����.��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�����.��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����.��������'] := '����'
          else VlLstDlg.ValList.Values['�����.��������'] := '���';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�����.���������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�����.���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����.���������'] := '����'
          else VlLstDlg.ValList.Values['�����.���������'] := '���';
        end;
      end;
    end;

    13 :
    begin //---------------------------------------------------------- ���������� ��������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['"�����"'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['"�����"'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['"�����"'] := '����'
          else VlLstDlg.ValList.Values['"�����"'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������'] := '����'
          else VlLstDlg.ValList.Values['���������'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� ��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��������� ��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� ��'] := '����'
          else VlLstDlg.ValList.Values['��������� ��'] := '���';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ ��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������ ��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ ��'] := '����'
          else VlLstDlg.ValList.Values['������ ��'] := '���';
        end;
      end;
    end;

    14 :
    begin //------------------------------------------------------------------------ �����
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����������'] := '����'
          else VlLstDlg.ValList.Values['����������'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������1'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������1'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������1'] := '����������'
          else VlLstDlg.ValList.Values['������1'] := '��������';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������2'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������2'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������2'] := '����������'
          else VlLstDlg.ValList.Values['������2'] := '��������';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� �����1'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� �����1'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� �����1'] := '����������'
          else VlLstDlg.ValList.Values['�������� �����1'] := '��������';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� �����2'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� �����2'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� �����2'] := '����������'
          else VlLstDlg.ValList.Values['�������� �����2'] := '��������';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� �� �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� �� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� �� �����'] := '�������'
          else VlLstDlg.ValList.Values['������� �� �����'] := '��������';
        end;

      end;
    end;

    15 :
    begin //--------------------------------------------------------------- ��������������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Liter;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���� �'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���� �'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���� �'] := '��������'
          else VlLstDlg.ValList.Values['���� �'] := '���������';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� 1��/�'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������� 1��/�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� 1��/�'] := '�����'
          else VlLstDlg.ValList.Values['������� 1��/�'] := '��������';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� 2��/�'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������� 2��/�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� 2��/�'] := '�����'
          else VlLstDlg.ValList.Values['������� 2��/�'] := '��������';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���� ��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���� ��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���� ��'] := '�����������'
          else VlLstDlg.ValList.Values['���� ��'] := '�����';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������'] := '�����'
          else VlLstDlg.ValList.Values['�������'] := '��������';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����-����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����-����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����-����'] := '�����'
          else VlLstDlg.ValList.Values['����-����'] := '��������';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ ��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������ ��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ ��'] := '����'
          else VlLstDlg.ValList.Values['������ ��'] := '���';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�'] := '��������'
          else VlLstDlg.ValList.Values['�'] := '���������';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['3��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['3��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['3��'] := '�����'
          else VlLstDlg.ValList.Values['3��'] := '��������';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� ��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�������� ��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� ��'] := '����'
          else VlLstDlg.ValList.Values['�������� ��'] := '���';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�1'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�1'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�1'] := '��������'
          else VlLstDlg.ValList.Values['�1'] := '���������';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�2'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�2'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�2'] := '��������'
          else VlLstDlg.ValList.Values['�2'] := '���������';
        end;

        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['�������� ��������'] := '������'
        else VlLstDlg.ValList.Values['�������� ��������'] := '������';

        if ObCB[8] or ObCB[9] then
        begin
          st := GetFR4State(ObCI[1]*8+3);
          if st then VlLstDlg.ValList.Values['�������� ��.�.'] := '�������'
          else VlLstDlg.ValList.Values['�������� ��.�.'] := '���������';

          if ObCB[8] and ObCB[9] then
          begin
            st := GetFR4State(ObCI[1]*8);
            if st then VlLstDlg.ValList.Values['�������� ����.�.'] := '�������'
            else VlLstDlg.ValList.Values['�������� ����.�.'] := '���������';

            st := GetFR4State(ObCI[1]*8+1);
            if st then VlLstDlg.ValList.Values['�������� ���.�.'] := '�������'
            else VlLstDlg.ValList.Values['�������� ���.�.'] := '���������';
          end;
        end;
      end;
    end;

    16 :
    begin //----------------------------------------- ��������������� ����� ����������� ��
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������������� �����.������.'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������������� �����.������.'] := '��� ������'  else
          if st then VlLstDlg.ValList.Values['�������������� �����.������.'] := '��������'
          else VlLstDlg.ValList.Values['�������������� �����.������.'] := '���������';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������������� �����. ������']:= '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������������� �����. ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������������� �����. ������']:= '��������'
          else VlLstDlg.ValList.Values['�������������� �����. ������'] := '���������';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������������� �����. ������.']:='��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������������� �����. ������.'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������������� �����. ������.']:='��������'
          else VlLstDlg.ValList.Values['��������������� �����. ������.'] := '���������';
        end;


        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������������� �����. ������']:= '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������������� �����. ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������������� �����. ������']:= '��������'
          else VlLstDlg.ValList.Values['��������������� �����. ������'] := '���������';
        end;

      end;
    end;

    17 :
    begin //--------------------------------------------- ���������� �������� ���� �������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������'] := '����'
          else VlLstDlg.ValList.Values['���������'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������� ���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ���'] := '����'
          else VlLstDlg.ValList.Values['������� ���'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;
      end;
    end;

    18 :
    begin //---------------------------------------------------- ���������� ������ �������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� �� ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� �� ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� �� ������'] := '����'
          else VlLstDlg.ValList.Values['������� �� ������'] := '���';
        end
        else VlLstDlg.ValList.Values['������� �������'] := '�����������'
      end;
    end;

    19 :
    begin //---------------------------------------------- ��������������� ������� �������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;
      end;
    end;

    20 :
    begin //---------------------------------------------------------------- ����� �������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '���������'
          else VlLstDlg.ValList.Values['��'] := '�� ���������';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������'
          else if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;
      end;
    end;

    21 :
    begin //--------------------------------------------- �������� �������� ������� ������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Liter;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������'] := '��������'
          else VlLstDlg.ValList.Values['���������'] := '���';
        end;

        if (ObCI[5] > 0) and (siP[1]>0)
        then VlLstDlg.ValList.Values['�������� ��'] := IntToStr(siP[1]);

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����������'] := '��������'
          else VlLstDlg.ValList.Values['����������'] := '���';
        end;

        if (ObCI[6] > 0) and (siP[2] > 0)
        then VlLstDlg.ValList.Values['�������� ��'] := IntToStr(siP[2]);


        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������'] := '��������'
          else VlLstDlg.ValList.Values['��������'] := '���';
        end;

        if (ObCI[7] > 0) and (siP[3] > 0)
        then VlLstDlg.ValList.Values['�������� ��'] := IntToStr(siP[3]);

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '��������'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '��������'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '��������'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;
      end;
    end;

    22 :
    begin //------------------------------------------- �������� �������������� ����������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���1'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���1'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���1'] := '��������'
          else VlLstDlg.ValList.Values['���1'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '��������'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '��������'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if (ObCI[5] > 0) and (siP[1] > 0)
        then VlLstDlg.ValList.Values['�������� ��'] := IntToStr(siP[1]);
      end;
    end;

    23 :
    begin //----------------------------------------------------------------- ������ � ���
      with ObjZv[o] do
      begin
        o := index;
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������� �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������� �����'] := '����'
          else VlLstDlg.ValList.Values['���������� �����'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������� �����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������� �����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������� �����������'] := '����'
          else VlLstDlg.ValList.Values['���������� �����������'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ��������'] := '����'
          else VlLstDlg.ValList.Values['������� ��������'] := '���';
        end;
        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['�������� ��������'] := '������'
        else VlLstDlg.ValList.Values['�������� ��������'] := '������';
      end;
    end;

    24 :
    begin //------------------------------------------------------------------ ������ � ��
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ ��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������ ��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ ��'] := '����'
          else VlLstDlg.ValList.Values['������ ��'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����� ������ ��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['����� ������ ��']:= '��� ������' else
          if st then VlLstDlg.ValList.Values['����� ������ ��'] := '����'
          else VlLstDlg.ValList.Values['����� ������ ��'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ��������']:='��� ������' else
          if st then VlLstDlg.ValList.Values['������� ��������'] := '����'
          else VlLstDlg.ValList.Values['������� ��������'] := '���';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '�����'
          else VlLstDlg.ValList.Values['��'] := '��������';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ������ ��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ������ ��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ������ ��'] := '����'
          else VlLstDlg.ValList.Values['������� ������ ��'] := '���';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�'] := '�����'
          else VlLstDlg.ValList.Values['�'] := '��������';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� �� ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� �� ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� �� ������'] := '�������'
          else VlLstDlg.ValList.Values['������� �� ������'] := '���';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� �� ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� �� ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� �� ������'] := '����'
          else VlLstDlg.ValList.Values['������� �� ������'] := '���';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� �� �����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� �� �����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� �� �����������'] := '�������'
          else VlLstDlg.ValList.Values['������� �� �����������'] := '���';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� �� �����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� �� �����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� �� �����������'] := '����'
          else VlLstDlg.ValList.Values['������� �� �����������'] := '���';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[14],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;
        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['�������� ��������'] := '������'
        else VlLstDlg.ValList.Values['�������� ��������'] := '������';
      end;
    end;

    25 :
    begin //----------------------------------------------------------- ���������� �������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������� ��������'] := '����'
          else VlLstDlg.ValList.Values['���������� ��������'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������ ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ ��������'] := '����'
          else VlLstDlg.ValList.Values['������ ��������'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�/��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�/��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�/��'] := '����'
          else VlLstDlg.ValList.Values['�/��'] := '���';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����' else
          VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ��������'] := '����'
          else VlLstDlg.ValList.Values['������� ��������'] := '���';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;
      end;
    end;

    26 :
    begin //----------------------------------------------------------------- ������ � ���
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : ' + Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� �� �����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������� �� �����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� �� �����������'] := '�����'
          else VlLstDlg.ValList.Values['��������� �� �����������'] := '��������';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� ������'] := '����'
          else VlLstDlg.ValList.Values['�������� ������'] := '���';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���� ��������'] := '����'
          else VlLstDlg.ValList.Values['���� ��������'] := '���';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� �� ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������� �� ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� �� ������'] := '�����'
          else VlLstDlg.ValList.Values['��������� �� ������'] := '��������';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� ��������'] := '����'
          else VlLstDlg.ValList.Values['�������� ��������'] := '���';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����-����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����-����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����-����'] := '�����'
          else VlLstDlg.ValList.Values['����-����'] := '��������';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�����������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����������'] := '����������'
          else VlLstDlg.ValList.Values['�����������'] := '��������';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '�����'
          else VlLstDlg.ValList.Values['��'] := '��������';
        end;

        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['�������� ��������'] := '������'
        else VlLstDlg.ValList.Values['�������� ��������'] := '������';
        if ObCB[8] or ObCB[9] then

        begin
          st := GetFR4State(ObCI[1]*8+3);
          if st then VlLstDlg.ValList.Values['�������� ��.�.'] := '�������'
          else VlLstDlg.ValList.Values['�������� ��.�.'] := '���������';

          if ObCB[8] and ObCB[9] then
          begin
            st := GetFR4State(ObCI[1]*8);
            if st then VlLstDlg.ValList.Values['�������� ����.�.'] := '�������'
            else VlLstDlg.ValList.Values['�������� ����.�.'] := '���������';

            st := GetFR4State(ObCI[1]*8+1);
            if st then VlLstDlg.ValList.Values['�������� ���.�.'] := '�������'
            else VlLstDlg.ValList.Values['�������� ���.�.'] := '���������';
          end;
        end;
      end;
    end;

    30 :
    begin //------------------- �������� ��������� ����������� (��������� �������� ������)
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ ObjZv[index].Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ��������'] := '����'
          else VlLstDlg.ValList.Values['������� ��������'] := '���';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� ��������'] := '����'
          else VlLstDlg.ValList.Values['��������� ��������'] := '���';
        end;
      end;
    end;

    31 : begin //--------------------------------------------------- ����������� ���������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� �����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������� �����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� �����������'] := '����'
          else VlLstDlg.ValList.Values['��������� �����������'] := '���';
        end;
      end;
    end;

    32 :
    begin //-------------------------------------------------------------- ������ � ������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� �����'] := '�������'
          else VlLstDlg.ValList.Values['������� �����'] := '��������';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ �����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������ �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ �����'] := '�������'
          else VlLstDlg.ValList.Values['������ �����'] := '��������';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����� �����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����� �����'] := '�������'
          else VlLstDlg.ValList.Values['����� �����'] := '��������';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� �����'] := '�������'
          else VlLstDlg.ValList.Values['��������� �����'] := '��������';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����� �� ����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['����� �� ����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����� �� ����������'] := '����'
          else VlLstDlg.ValList.Values['����� �� ����������'] := '���';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ��������'] := '����'
          else VlLstDlg.ValList.Values['������� ��������'] := '���';
        end;
        
        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� �������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� �������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� �������'] := '����'
          else VlLstDlg.ValList.Values['�������� �������'] := '���';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� ��������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� ��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� ��������'] := '����'
          else VlLstDlg.ValList.Values['�������� ��������'] := '���';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������� �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������� �����'] := '����'
          else VlLstDlg.ValList.Values['���������� �����'] := '���';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� �����'] := '�����'
          else VlLstDlg.ValList.Values['��������� �����'] := '��������';
        end;
      end;
    end;

    33 :
    begin //----------------------------------------------------------------------- ������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['������ ' + Liter] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������ ' + Liter] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ ' + Liter] := '�������'
          else VlLstDlg.ValList.Values['������ ' + Liter] := '��������';
        end;
      end;
    end;

    34 :
    begin //---------------------------------------------------------------------- �������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� 1 ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� 1 ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� 1 ������'] := '����������'
          else VlLstDlg.ValList.Values['�������� 1 ������'] := '����';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� 2 ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� 2 ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� 2 ������'] := '����������'
          else VlLstDlg.ValList.Values['�������� 2 ������'] := '����';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� ���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�������� ���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� ���'] := '����'
          else VlLstDlg.ValList.Values['�������� ���'] := '���';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� 1 ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������� 1 ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� 1 ������'] := '���'

          else VlLstDlg.ValList.Values['��������� 1 ������'] := '����';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������� 2 ������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['��������� 2 ������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������� 2 ������'] := '���'
          else VlLstDlg.ValList.Values['��������� 2 ������'] := '����';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['��������������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��������������']:='��� ������' else
          if st then VlLstDlg.ValList.Values['��������������'] := '����������'
          else VlLstDlg.ValList.Values['��������������'] := '��������';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� ��������������']:='��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� ��������������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� ��������������'] := '����������'
          else VlLstDlg.ValList.Values['�������� ��������������'] := '��������';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������������ ����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������������ ����������'] := '��� ������' else
          if st then
          VlLstDlg.ValList.Values['������������ ����������'] := '��������� ��������'
          else  VlLstDlg.ValList.Values['������������ ����������'] := '�����';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�����������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����������'] := '������'
          else VlLstDlg.ValList.Values['�����������'] := '��������';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���1'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���1'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���1'] := '���������'
          else VlLstDlg.ValList.Values['���1'] := '��������';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���2'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���2'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���2'] := '���������'
          else VlLstDlg.ValList.Values['���2'] := '��������';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����� �������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['����� �������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����� �������'] := '�������'
          else VlLstDlg.ValList.Values['����� �������'] := '�����';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������� �������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������� �������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������� �������'] := '�������'
          else VlLstDlg.ValList.Values['���������� �������'] := '�����';
        end;

        if ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[14],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� ����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� ����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� ����������'] := '��������'
          else VlLstDlg.ValList.Values['�������� ����������'] := '���������';
        end;

        if ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[15],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ����'] := '�������'
          else VlLstDlg.ValList.Values['������� ����'] := '�����';
        end;

        if ObCI[16] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[16],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ����������'] := '�������'
          else VlLstDlg.ValList.Values['������� ����������'] := '��������';
        end;

        if ObCI[17] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[17],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['�������� �������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['�������� �������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������� �������'] := '�������'
          else VlLstDlg.ValList.Values['�������� �������'] := '�����';
        end;

        if ObCI[18] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[18],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '�������'
          else VlLstDlg.ValList.Values['���'] := '�����';
        end;

        if ObCI[19] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[19],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����������� ��� 1�'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['����������� ��� 1�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����������� ��� 1�'] := '�������'
          else VlLstDlg.ValList.Values['����������� ��� 1�'] := '�����';
        end;

        if ObCI[20] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[20],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['����������� ��� 2�'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['����������� ��� 2�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����������� ��� 2�'] := '�������'
          else VlLstDlg.ValList.Values['����������� ��� 2�'] := '�����';
        end;

        if ObCI[21] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[21],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������� 1�'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������� 1�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������� 1�'] := '�������'
          else VlLstDlg.ValList.Values['���������� 1�'] := '�����';
        end;

        if ObCI[22] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[22],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['���������� 2�'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['���������� 2�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���������� 2�'] := '�������'
          else VlLstDlg.ValList.Values['���������� 2�'] := '�����';
        end;

        if ObCI[23] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[23],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ��'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ��'] := '���������'
          else VlLstDlg.ValList.Values['������� ��'] := '�����';
        end;

        if ObCI[24] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[24],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ �����������'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������ �����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ �����������'] := '�������'
          else VlLstDlg.ValList.Values['������ �����������'] := '�����';
        end;

        if ObCI[25] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[25],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� ��������� �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� ��������� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� ��������� �����'] := '�������'
          else VlLstDlg.ValList.Values['������� ��������� �����'] := '�����';
        end;

        if ObCI[26] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[26],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������ �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������ �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������ �����'] := '������'
          else VlLstDlg.ValList.Values['������ �����'] := '��� ������';
        end;

        if ObCI[27] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[25],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������� �����'] := '��������������' else
          if not rdy then
          VlLstDlg.ValList.Values['������� �����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������� �����'] := '�������'
          else VlLstDlg.ValList.Values['������� �����'] := '�����';
        end;

      end;
    end;

    36 :
    begin //------------------------------------------------------------------------- ����
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[11] > 0 then  //---------------------------------- ���� ���� ������ ������
        begin
          MsgS := MsgList[ObCI[4]];
          MsgS := StringReplace(MsgS,'?','',[rfReplaceAll]);
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values[MsgS] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values[MsgS] := '��� ������' else
          if (not st and ObCB[1]) or (not ObCB[1] and st) then
          VlLstDlg.ValList.Values[MsgS] := '��������'
          else VlLstDlg.ValList.Values[MsgS] := '���������';
        end;
        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������2'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������2'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������2'] := '��������'
          else VlLstDlg.ValList.Values['������2'] := '���������';
        end;
        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������3'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������3'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������3'] := '��������'
          else VlLstDlg.ValList.Values['������3'] := '���������';
        end;
        if ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[14],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['������4'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['������4'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['������4'] := '��������'
          else VlLstDlg.ValList.Values['������4'] := '���������';
        end;
        if ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[15],nep,rdy);
          MsgS := MsgList[ObCI[22]];
          if nep then
          VlLstDlg.ValList.Values[MsgS] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values[MsgS] := '��� ������' else
          if st then VlLstDlg.ValList.Values[MsgS] := '��������'
          else VlLstDlg.ValList.Values[MsgS] := '���������';
        end;
      end;
    end;

    37 :
    begin //------------------------------------------------------------------------- ����
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��������'] := '���������'
          else VlLstDlg.ValList.Values['��������'] := '��������';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���.��������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���.��������'] := '��� ������' else
          if not st then VlLstDlg.ValList.Values['���.��������'] := '��������'
          else VlLstDlg.ValList.Values['���.��������'] := '����������';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���.��������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���.��������'] := '��� ������' else
          if not st then VlLstDlg.ValList.Values['���.��������'] := '��������'
          else VlLstDlg.ValList.Values['���.��������'] := '����������';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�������'] := '�����������'
          else VlLstDlg.ValList.Values['�������'] := '�����';
        end;

      if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��1'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��1'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��1'] := '�����������'
          else VlLstDlg.ValList.Values['��1'] := '�����';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��2'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��2'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��2'] := '�����������'
          else VlLstDlg.ValList.Values['��2'] := '�����';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����'] := '�����������'
          else VlLstDlg.ValList.Values['�����'] := '�����';
        end;

        if ObCI[8] > 0 then
        begin
          st := FR3[ObCI[8]] = 0;
          if st then VlLstDlg.ValList.Values['�������'] := '���������������'
          else VlLstDlg.ValList.Values['�������'] := '���';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then VlLstDlg.ValList.Values['����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����'] := '����'
          else VlLstDlg.ValList.Values['����'] := '���';
        end;

        if ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[14],nep,rdy);
          if nep then VlLstDlg.ValList.Values['����������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����������'] := '����'
          else VlLstDlg.ValList.Values['����������'] := '���';
        end;

        if ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[15],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�/�'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�/�'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�/�'] := '�����'
          else VlLstDlg.ValList.Values['�/�'] := '������';
        end;

      end;
    end;

    38 :
    begin //-------------------------------------------------------------- ������� �������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;
      end;
    end;

    39 :
    begin //------------------------------------------------------------------ �������� ��
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObjZv[o].ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObjZv[o].ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObjZv[o].ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObjZv[o].ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObjZv[o].ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;

        if ObjZv[o].ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '�����'
          else VlLstDlg.ValList.Values['���'] := '�������';
        end;
      end;
    end;

    43 :
    begin //-------------------------------------------------------------------------- ���
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����'
          else VlLstDlg.ValList.Values['���'] := '���';
        end;
      end;
    end;

    45 :
    begin //-------------------------------------------------------------------------- ���
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '��������'
          else VlLstDlg.ValList.Values['���'] := '���������';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����'
          else VlLstDlg.ValList.Values['��'] := '���';
        end;
      end;
    end;

    47 :
    begin //----------------------------------------------------------------- ������������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '��������'
          else VlLstDlg.ValList.Values['��'] := '���������';
        end;
      end;
    end;

    49 :
    begin //---------------------------------------------------------------- ������ � ����
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '������� ������'
          else VlLstDlg.ValList.Values['���'] := '������� ���������';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '�������� ��������'
          else VlLstDlg.ValList.Values['��'] := '�������� ����������';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����������'] := '����������'
          else VlLstDlg.ValList.Values['�����������'] := '��������';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['��'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['��'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['��'] := '����������'
          else VlLstDlg.ValList.Values['��'] := '��������';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '����������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;
      end;
    end;

    50 :
    begin //---------------------------------------------------- �������� ���������� �����
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObjZv[o].ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����(1)'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����(1)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����(1)'] := '�����'
          else VlLstDlg.ValList.Values['�����(1)'] := '��������';
        end;

        if ObjZv[o].ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������(1)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������(1)']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�����������(1)'] := '�����'
          else VlLstDlg.ValList.Values['�����������(1)'] := '��������';
        end;

        if ObjZv[o].ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����(2)'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����(2)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����(2)'] := '�����'
          else VlLstDlg.ValList.Values['�����(2)'] := '��������';
        end;

        if ObjZv[o].ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������(2)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������(2)']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�����������(2)'] := '�����'
          else VlLstDlg.ValList.Values['�����������(2)'] := '��������';
        end;

        if ObjZv[o].ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����(3)'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����(3)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����(3)'] := '�����'
          else VlLstDlg.ValList.Values['�����(3)'] := '��������';
        end;

        if ObjZv[o].ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������(3)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������(3)']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�����������(3)'] := '�����'
          else VlLstDlg.ValList.Values['�����������(3)'] := '��������';
        end;

        if ObjZv[o].ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����(4)'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����(4)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����(4)'] := '�����'
          else VlLstDlg.ValList.Values['�����(4)'] := '��������';
        end;

        if ObjZv[o].ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[8],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������(4)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������(4)']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�����������(4)'] := '�����'
          else VlLstDlg.ValList.Values['�����������(4)'] := '��������';
        end;

        if ObjZv[o].ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[9],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����(5)'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����(5)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����(5)'] := '�����'
          else VlLstDlg.ValList.Values['�����(5)'] := '��������';
        end;

        if ObjZv[o].ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[10],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������(5)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������(5)']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�����������(5)']:='�����'
          else VlLstDlg.ValList.Values['�����������(5)'] := '��������';
        end;

        if ObjZv[o].ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[11],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����(6)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����(6)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����(6)'] := '�����'
          else VlLstDlg.ValList.Values['�����(6)'] := '��������';
        end;

        if ObjZv[o].ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[12],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������(6)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������(6)']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�����������(6)'] := '�����'
          else VlLstDlg.ValList.Values['�����������(6)'] := '��������';
        end;

        if ObjZv[o].ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[13],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����(7)'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����(7)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����(7)'] := '�����'
          else VlLstDlg.ValList.Values['�����(7)'] := '��������';
        end;

        if ObjZv[o].ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[14],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������(7)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������(7)']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�����������(7)'] := '�����'
          else VlLstDlg.ValList.Values['�����������(7)'] := '��������';
        end;

        if ObjZv[o].ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[15],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����(8)'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����(8)'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�����(8)'] := '�����'
          else VlLstDlg.ValList.Values['�����(8)'] := '��������';
        end;

        if ObjZv[o].ObCI[16] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[16],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�����������(8)']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�����������(8)']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�����������(8)'] := '�����'
          else VlLstDlg.ValList.Values['�����������(8)'] := '��������';
        end;
      end;
    end;

    51 :
    begin //------------------------------------------------------------- ������ ��������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        for j := 1 to 10 do
        begin
          if ObCI[j] >0 then  MsgS := MsgList[ObCI[j+10]];
          nep := false; rdy := true; st := GetFR3(ObCI[j],nep,rdy);
          if nep then VlLstDlg.ValList.Values[MsgS] := '��������������'  else
          if not rdy then VlLstDlg.ValList.Values[MsgS] := '��� ������'  else
          if (not ObCb[j] and st) or ( not st and ObCb[j])
          then VlLstDlg.ValList.Values[MsgS] := '�������'
          else VlLstDlg.ValList.Values[MsgS] := '��������';
        end;
      end;
    end;

    60 :
    begin //---------------------------------------------------------- �������� ����������
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := '�������� : '+ Title;
        if ObjZv[o].ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '�������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObjZv[o].ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['���']:='��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '�������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObjZv[o].ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '�������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObjZv[o].ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['���']:='��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '�������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObjZv[o].ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['����'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['����'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['����'] := '�������'
          else VlLstDlg.ValList.Values['����'] := '��������';
        end;

        if ObjZv[o].ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['����']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['����']:='��� ������' else
          if st then VlLstDlg.ValList.Values['����'] := '�������'
          else VlLstDlg.ValList.Values['����'] := '��������';
        end;

        if ObjZv[o].ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['���'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '�������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObjZv[o].ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[8],nep,rdy);
          if nep then VlLstDlg.ValList.Values['���']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['���']:='��� ������' else
          if st then VlLstDlg.ValList.Values['���'] := '�������'
          else VlLstDlg.ValList.Values['���'] := '��������';
        end;

        if ObjZv[o].ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[9],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�19'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�19'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�19'] := '�������'
          else VlLstDlg.ValList.Values['�19'] := '��������';
        end;

        if ObjZv[o].ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[10],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�210']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�210']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�210']:='�������'
          else VlLstDlg.ValList.Values['�210'] := '��������';
        end;

        if ObjZv[o].ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[11],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�311']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�311'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�311'] := '�������'
          else VlLstDlg.ValList.Values['�311'] := '��������';
        end;

        if ObjZv[o].ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[12],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�412']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�412']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�412'] := '�������'
          else VlLstDlg.ValList.Values['�412'] := '��������';
        end;

        if ObjZv[o].ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[13],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�513'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�513'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�513'] := '�������'
          else VlLstDlg.ValList.Values['�513'] := '��������';
        end;

        if ObjZv[o].ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[14],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�614']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�614']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�614'] := '�������'
          else VlLstDlg.ValList.Values['�614'] := '��������';
        end;

        if ObjZv[o].ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[15],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�715'] := '��������������' else
          if not rdy then VlLstDlg.ValList.Values['�715'] := '��� ������' else
          if st then VlLstDlg.ValList.Values['�715'] := '�������'
          else VlLstDlg.ValList.Values['�715'] := '��������';
        end;

        if ObjZv[o].ObCI[16] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[16],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�816']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�816']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�816'] := '�������'
          else VlLstDlg.ValList.Values['�816'] := '��������';
        end;

        if ObjZv[o].ObCI[17] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[17],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�1718']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�1718']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�1718'] := '�������'
          else VlLstDlg.ValList.Values['�1718'] := '��������';
        end;

        if ObjZv[o].ObCI[18] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[18],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�1920']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�1920']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�1920'] := '�������'
          else VlLstDlg.ValList.Values['�1920'] := '��������';
        end;

        if ObjZv[o].ObCI[19] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[19],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�2122']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�2122']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�2122'] := '�������'
          else VlLstDlg.ValList.Values['�2122'] := '��������';
        end;

        if ObjZv[o].ObCI[20] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[20],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�2324']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�2324']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�2324'] := '�������'
          else VlLstDlg.ValList.Values['�2324'] := '��������';
        end;

        if ObjZv[o].ObCI[21] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[21],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�2526']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�2526']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�2526'] := '�������'
          else VlLstDlg.ValList.Values['�2526'] := '��������';
        end;

        if ObjZv[o].ObCI[22] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[22],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�2728']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�2728']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�2728'] := '�������'
          else VlLstDlg.ValList.Values['�2728'] := '��������';
        end;

        if ObjZv[o].ObCI[23] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[23],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�2930']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�2930']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�2930'] := '�������'
          else VlLstDlg.ValList.Values['�2930'] := '��������';
        end;

        if ObjZv[o].ObCI[24] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[24],nep,rdy);
          if nep then VlLstDlg.ValList.Values['�3132']:='��������������' else
          if not rdy then VlLstDlg.ValList.Values['�3132']:='��� ������' else
          if st then VlLstDlg.ValList.Values['�3132'] := '�������'
          else VlLstDlg.ValList.Values['�3132'] := '��������';
        end;
      end;
    end;
    else VlLstDlg.Caption := '�������� : ?';
  end;
  j := 0; k := 0;
  for i:= 0 to VlLstDlg.ValList.RowCount-1  do
  begin
    if Length(VlLstDlg.ValList.Keys[i]) > j
    then j := Length(VlLstDlg.ValList.Keys[i]);
    if Length(VlLstDlg.ValList.Cells[1,i]) > k
    then  k := Length(VlLstDlg.ValList.Cells[1,i])
  end;
  VlLstDlg.ValList.ColWidths[0] := (j+1)*8;
  VlLstDlg.ValList.ColWidths[1] := (k+1)*8;
  VlLstDlg.Width := (j+k+2)*8;
end;
//========================================================================================
//------------------------------------------------------------ ����� ���������� �� �������
procedure TVlLstDlg.pmResetStatClick(Sender: TObject);
  var o,i : integer;
begin
  case ObjZv[ID_ViewObj].TypeObj of
    2 :
    begin //---------------------------------------------------------------------- �������
      o := ObjZv[ID_ViewObj].BasOb;
      ObjZv[o].T[1].Activ := false; ObjZv[o].T[2].Activ := false;
      for i := 1 to High(ObjZv[1].dtP) do ObjZv[o].dtP[i] := 0;
      for i := 1 to High(ObjZv[1].siP) do ObjZv[o].siP[i] := 0;
    end;
    else
      for i := 1 to High(ObjZv[1].dtP) do ObjZv[ID_ViewObj].dtP[i] := 0;
      for i := 1 to High(ObjZv[1].siP) do ObjZv[ID_ViewObj].siP[i] := 0;
      for i := 1 to High(ObjZv[1].sbP) do ObjZv[ID_ViewObj].sbP[i] := false;
  end;
end;

end.

