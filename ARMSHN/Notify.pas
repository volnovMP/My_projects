unit Notify;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Forms,
  ComCtrls,
  StdCtrls,
  MMSystem,
  Grids,
  ValEdit, Controls;

type
  TNotifyForm = class(TForm)
    PageControl: TPageControl;
    btnTestSound: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    cbNot1: TComboBox;
    cbNot2: TComboBox;
    cbNot3: TComboBox;
    cbNot4: TComboBox;
    cbNot5: TComboBox;
    cbNot6: TComboBox;
    cbNot7: TComboBox;
    cbNot8: TComboBox;
    cbNot9: TComboBox;
    cbNot10: TComboBox;
    cbRunStop1: TComboBox;
    cbRunStop2: TComboBox;
    cbRunStop3: TComboBox;
    cbRunStop4: TComboBox;
    cbRunStop5: TComboBox;
    cbRunStop6: TComboBox;
    cbRunStop7: TComboBox;
    cbRunStop8: TComboBox;
    cbRunStop9: TComboBox;
    cbRunStop10: TComboBox;
    veParams10: TValueListEditor;
    cbViewObj10: TComboBox;
    veParams9: TValueListEditor;
    cbViewObj9: TComboBox;
    veParams8: TValueListEditor;
    cbViewObj8: TComboBox;
    veParams7: TValueListEditor;
    cbViewObj7: TComboBox;
    veParams6: TValueListEditor;
    cbViewObj6: TComboBox;
    veParams5: TValueListEditor;
    cbViewObj5: TComboBox;
    veParams4: TValueListEditor;
    cbViewObj4: TComboBox;
    veParams3: TValueListEditor;
    cbViewObj3: TComboBox;
    veParams2: TValueListEditor;
    cbViewObj2: TComboBox;
    veParams1: TValueListEditor;
    cbViewObj1: TComboBox;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbNot1Change(Sender: TObject);
    procedure btnTestSoundClick(Sender: TObject);
    procedure cbNot2Change(Sender: TObject);
    procedure cbNot3Change(Sender: TObject);
    procedure cbNot4Change(Sender: TObject);
    procedure cbNot5Change(Sender: TObject);
    procedure cbNot6Change(Sender: TObject);
    procedure cbNot7Change(Sender: TObject);
    procedure cbNot8Change(Sender: TObject);
    procedure cbNot9Change(Sender: TObject);
    procedure cbNot10Change(Sender: TObject);
    procedure cbRunStop1Change(Sender: TObject);
    procedure cbRunStop2Change(Sender: TObject);
    procedure cbRunStop3Change(Sender: TObject);
    procedure cbRunStop4Change(Sender: TObject);
    procedure cbRunStop5Change(Sender: TObject);
    procedure cbRunStop6Change(Sender: TObject);
    procedure cbRunStop7Change(Sender: TObject);
    procedure cbRunStop8Change(Sender: TObject);
    procedure cbRunStop9Change(Sender: TObject);
    procedure cbRunStop10Change(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbViewObj1Change(Sender: TObject);
    procedure cbViewObj10Change(Sender: TObject);
    procedure cbViewObj9Change(Sender: TObject);
    procedure cbViewObj8Change(Sender: TObject);
    procedure cbViewObj7Change(Sender: TObject);
    procedure cbViewObj6Change(Sender: TObject);
    procedure cbViewObj5Change(Sender: TObject);
    procedure cbViewObj4Change(Sender: TObject);
    procedure cbViewObj3Change(Sender: TObject);
    procedure cbViewObj2Change(Sender: TObject);
    procedure veParams1StringsChange(Sender: TObject);
    procedure veParams2StringsChange(Sender: TObject);
    procedure veParams3StringsChange(Sender: TObject);
    procedure veParams4StringsChange(Sender: TObject);
    procedure veParams5StringsChange(Sender: TObject);
    procedure veParams6StringsChange(Sender: TObject);
    procedure veParams7StringsChange(Sender: TObject);
    procedure veParams8StringsChange(Sender: TObject);
    procedure veParams9StringsChange(Sender: TObject);
    procedure veParams10StringsChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadNotify;
    procedure SaveNotify;
  end;
  
function GetDatchik(Datchik : string) : Word;

var
  NotifyForm: TNotifyForm;

implementation

{$R *.dfm}

uses
  TypeALL,
  TabloSHN;


var
  ListObj : TStringList;
//  s : string;

procedure TNotifyForm.FormCreate(Sender: TObject);
  var i : integer; tt : TStringList;
begin
  tt := TStringList.Create; tt.Add('нет'); tt.Add('есть');
  ListObj := TStringList.Create;
  ListObj.Add('объект не выбран');


  for i := 1 to WorkMode.LimitObjZav do
  begin // получить список контролируемых объектов

    ListObj.Add(ObjZav[i].Title);

  end;


  NameFR := TStringList.Create;
  NameFR.Add('не задано');
  for i := 1 to WorkMode.LimitNameFR do
  begin // получить список датчиков
    NameFR.Add(LinkFR[i].Name);
  end;


  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyRegNotifyForm, false) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left') else Left := 0;
    if reg.ValueExists('top') then Top := reg.ReadInteger('top') else Top := 0;
    reg.CloseKey;
  end;
  LoadNotify;
  cbNot1.Items.Assign(NotifyWav); cbViewObj1.Items.Assign(ListObj);
  cbNot2.Items.Assign(NotifyWav); cbViewObj2.Items.Assign(ListObj);
  cbNot3.Items.Assign(NotifyWav); cbViewObj3.Items.Assign(ListObj);
  cbNot4.Items.Assign(NotifyWav); cbViewObj4.Items.Assign(ListObj);
  cbNot5.Items.Assign(NotifyWav); cbViewObj5.Items.Assign(ListObj);
  cbNot6.Items.Assign(NotifyWav); cbViewObj6.Items.Assign(ListObj);
  cbNot7.Items.Assign(NotifyWav); cbViewObj7.Items.Assign(ListObj);
  cbNot8.Items.Assign(NotifyWav); cbViewObj8.Items.Assign(ListObj);
  cbNot9.Items.Assign(NotifyWav); cbViewObj9.Items.Assign(ListObj);
  cbNot10.Items.Assign(NotifyWav); cbViewObj10.Items.Assign(ListObj);

  for i := 0 to 11 do
  begin
    veParams1.ItemProps[i].EditStyle := esPickList;
    veParams2.ItemProps[i].EditStyle := esPickList;
    veParams3.ItemProps[i].EditStyle := esPickList;
    veParams4.ItemProps[i].EditStyle := esPickList;
    veParams5.ItemProps[i].EditStyle := esPickList;
    veParams6.ItemProps[i].EditStyle := esPickList;
    veParams7.ItemProps[i].EditStyle := esPickList;
    veParams8.ItemProps[i].EditStyle := esPickList;
    veParams9.ItemProps[i].EditStyle := esPickList;
    veParams10.ItemProps[i].EditStyle := esPickList;
  end;

  veParams1.ItemProps[0].PickList := NameFR;
  veParams1.ItemProps[1].PickList := tt;
  veParams1.ItemProps[2].PickList := NameFR;
  veParams1.ItemProps[3].PickList := tt;
  veParams1.ItemProps[4].PickList := NameFR;
  veParams1.ItemProps[5].PickList := tt;
  veParams1.ItemProps[6].PickList := NameFR;
  veParams1.ItemProps[7].PickList := tt;
  veParams1.ItemProps[8].PickList := NameFR;
  veParams1.ItemProps[9].PickList := tt;
  veParams1.ItemProps[10].PickList := NameFR;
  veParams1.ItemProps[11].PickList := tt;
  veParams2.ItemProps[0].PickList := NameFR;
  veParams2.ItemProps[1].PickList := tt;
  veParams2.ItemProps[2].PickList := NameFR;
  veParams2.ItemProps[3].PickList := tt;
  veParams2.ItemProps[4].PickList := NameFR;
  veParams2.ItemProps[5].PickList := tt;
  veParams2.ItemProps[6].PickList := NameFR;
  veParams2.ItemProps[7].PickList := tt;
  veParams2.ItemProps[8].PickList := NameFR;
  veParams2.ItemProps[9].PickList := tt;
  veParams2.ItemProps[10].PickList := NameFR;
  veParams2.ItemProps[11].PickList := tt;
  veParams3.ItemProps[0].PickList := NameFR;
  veParams3.ItemProps[1].PickList := tt;
  veParams3.ItemProps[2].PickList := NameFR;
  veParams3.ItemProps[3].PickList := tt;
  veParams3.ItemProps[4].PickList := NameFR;
  veParams3.ItemProps[5].PickList := tt;
  veParams3.ItemProps[6].PickList := NameFR;
  veParams3.ItemProps[7].PickList := tt;
  veParams3.ItemProps[8].PickList := NameFR;
  veParams3.ItemProps[9].PickList := tt;
  veParams3.ItemProps[10].PickList := NameFR;
  veParams3.ItemProps[11].PickList := tt;
  veParams4.ItemProps[0].PickList := NameFR;
  veParams4.ItemProps[1].PickList := tt;
  veParams4.ItemProps[2].PickList := NameFR;
  veParams4.ItemProps[3].PickList := tt;
  veParams4.ItemProps[4].PickList := NameFR;
  veParams4.ItemProps[5].PickList := tt;
  veParams4.ItemProps[6].PickList := NameFR;
  veParams4.ItemProps[7].PickList := tt;
  veParams4.ItemProps[8].PickList := NameFR;
  veParams4.ItemProps[9].PickList := tt;
  veParams4.ItemProps[10].PickList := NameFR;
  veParams4.ItemProps[11].PickList := tt;
  veParams5.ItemProps[0].PickList := NameFR;
  veParams5.ItemProps[1].PickList := tt;
  veParams5.ItemProps[2].PickList := NameFR;
  veParams5.ItemProps[3].PickList := tt;
  veParams5.ItemProps[4].PickList := NameFR;
  veParams5.ItemProps[5].PickList := tt;
  veParams5.ItemProps[6].PickList := NameFR;
  veParams5.ItemProps[7].PickList := tt;
  veParams5.ItemProps[8].PickList := NameFR;
  veParams5.ItemProps[9].PickList := tt;
  veParams5.ItemProps[10].PickList := NameFR;
  veParams5.ItemProps[11].PickList := tt;
  veParams6.ItemProps[0].PickList := NameFR;
  veParams6.ItemProps[1].PickList := tt;
  veParams6.ItemProps[2].PickList := NameFR;
  veParams6.ItemProps[3].PickList := tt;
  veParams6.ItemProps[4].PickList := NameFR;
  veParams6.ItemProps[5].PickList := tt;
  veParams6.ItemProps[6].PickList := NameFR;
  veParams6.ItemProps[7].PickList := tt;
  veParams6.ItemProps[8].PickList := NameFR;
  veParams6.ItemProps[9].PickList := tt;
  veParams6.ItemProps[10].PickList := NameFR;
  veParams6.ItemProps[11].PickList := tt;
  veParams7.ItemProps[0].PickList := NameFR;
  veParams7.ItemProps[1].PickList := tt;
  veParams7.ItemProps[2].PickList := NameFR;
  veParams7.ItemProps[3].PickList := tt;
  veParams7.ItemProps[4].PickList := NameFR;
  veParams7.ItemProps[5].PickList := tt;
  veParams7.ItemProps[6].PickList := NameFR;
  veParams7.ItemProps[7].PickList := tt;
  veParams7.ItemProps[8].PickList := NameFR;
  veParams7.ItemProps[9].PickList := tt;
  veParams7.ItemProps[10].PickList := NameFR;
  veParams7.ItemProps[11].PickList := tt;
  veParams8.ItemProps[0].PickList := NameFR;
  veParams8.ItemProps[1].PickList := tt;
  veParams8.ItemProps[2].PickList := NameFR;
  veParams8.ItemProps[3].PickList := tt;
  veParams8.ItemProps[4].PickList := NameFR;
  veParams8.ItemProps[5].PickList := tt;
  veParams8.ItemProps[6].PickList := NameFR;
  veParams8.ItemProps[7].PickList := tt;
  veParams8.ItemProps[8].PickList := NameFR;
  veParams8.ItemProps[9].PickList := tt;
  veParams8.ItemProps[10].PickList := NameFR;
  veParams8.ItemProps[11].PickList := tt;
  veParams9.ItemProps[0].PickList := NameFR;
  veParams9.ItemProps[1].PickList := tt;
  veParams9.ItemProps[2].PickList := NameFR;
  veParams9.ItemProps[3].PickList := tt;
  veParams9.ItemProps[4].PickList := NameFR;
  veParams9.ItemProps[5].PickList := tt;
  veParams9.ItemProps[6].PickList := NameFR;
  veParams9.ItemProps[7].PickList := tt;
  veParams9.ItemProps[8].PickList := NameFR;
  veParams9.ItemProps[9].PickList := tt;
  veParams9.ItemProps[10].PickList := NameFR;
  veParams9.ItemProps[11].PickList := tt;
  veParams10.ItemProps[0].PickList := NameFR;
  veParams10.ItemProps[1].PickList := tt;
  veParams10.ItemProps[2].PickList := NameFR;
  veParams10.ItemProps[3].PickList := tt;
  veParams10.ItemProps[4].PickList := NameFR;
  veParams10.ItemProps[5].PickList := tt;
  veParams10.ItemProps[6].PickList := NameFR;
  veParams10.ItemProps[7].PickList := tt;
  veParams10.ItemProps[8].PickList := NameFR;
  veParams10.ItemProps[9].PickList := tt;
  veParams10.ItemProps[10].PickList := NameFR;
  veParams10.ItemProps[11].PickList := tt;

  cbNot1.ItemIndex := FixNotify[1].Sound;
  if FixNotify[1].Enable then cbRunStop1.ItemIndex := 1
  else cbRunStop1.ItemIndex := 0;
  cbViewObj1.ItemIndex := FixNotify[1].Obj;

  veParams1.Cells[1,1] := NameFR.Strings[FixNotify[1].Datchik[1]]; if FixNotify[1].State[1] then veParams1.Cells[1,2] := 'есть' else veParams1.Cells[1,2] := 'нет';
  veParams1.Cells[1,3] := NameFR.Strings[FixNotify[1].Datchik[2]]; if FixNotify[1].State[2] then veParams1.Cells[1,4] := 'есть' else veParams1.Cells[1,4] := 'нет';
  veParams1.Cells[1,5] := NameFR.Strings[FixNotify[1].Datchik[3]]; if FixNotify[1].State[3] then veParams1.Cells[1,6] := 'есть' else veParams1.Cells[1,6] := 'нет';
  veParams1.Cells[1,7] := NameFR.Strings[FixNotify[1].Datchik[4]]; if FixNotify[1].State[4] then veParams1.Cells[1,8] := 'есть' else veParams1.Cells[1,8] := 'нет';
  veParams1.Cells[1,9] := NameFR.Strings[FixNotify[1].Datchik[5]]; if FixNotify[1].State[5] then veParams1.Cells[1,10] := 'есть' else veParams1.Cells[1,10] := 'нет';
  veParams1.Cells[1,11] := NameFR.Strings[FixNotify[1].Datchik[6]]; if FixNotify[1].State[6] then veParams1.Cells[1,12] := 'есть' else veParams1.Cells[1,12] := 'нет';

  cbNot2.ItemIndex := FixNotify[2].Sound;
  if FixNotify[2].Enable then cbRunStop2.ItemIndex := 1 else cbRunStop2.ItemIndex := 0; cbViewObj2.ItemIndex := FixNotify[2].Obj;
  veParams2.Cells[1,1] := NameFR.Strings[FixNotify[2].Datchik[1]]; if FixNotify[2].State[1] then veParams2.Cells[1,2] := 'есть' else veParams2.Cells[1,2] := 'нет';
  veParams2.Cells[1,3] := NameFR.Strings[FixNotify[2].Datchik[2]]; if FixNotify[2].State[2] then veParams2.Cells[1,4] := 'есть' else veParams2.Cells[1,4] := 'нет';
  veParams2.Cells[1,5] := NameFR.Strings[FixNotify[2].Datchik[3]]; if FixNotify[2].State[3] then veParams2.Cells[1,6] := 'есть' else veParams2.Cells[1,6] := 'нет';
  veParams2.Cells[1,7] := NameFR.Strings[FixNotify[2].Datchik[4]]; if FixNotify[2].State[4] then veParams2.Cells[1,8] := 'есть' else veParams2.Cells[1,8] := 'нет';
  veParams2.Cells[1,9] := NameFR.Strings[FixNotify[2].Datchik[5]]; if FixNotify[2].State[5] then veParams2.Cells[1,10] := 'есть' else veParams2.Cells[1,10] := 'нет';
  veParams2.Cells[1,11] := NameFR.Strings[FixNotify[2].Datchik[6]]; if FixNotify[2].State[6] then veParams2.Cells[1,12] := 'есть' else veParams2.Cells[1,12] := 'нет';

  cbNot3.ItemIndex := FixNotify[3].Sound; if FixNotify[3].Enable then cbRunStop3.ItemIndex := 1 else cbRunStop3.ItemIndex := 0; cbViewObj3.ItemIndex := FixNotify[3].Obj;
  veParams3.Cells[1,1] := NameFR.Strings[FixNotify[3].Datchik[1]]; if FixNotify[3].State[1] then veParams3.Cells[1,2] := 'есть' else veParams3.Cells[1,2] := 'нет';
  veParams3.Cells[1,3] := NameFR.Strings[FixNotify[3].Datchik[2]]; if FixNotify[3].State[2] then veParams3.Cells[1,4] := 'есть' else veParams3.Cells[1,4] := 'нет';
  veParams3.Cells[1,5] := NameFR.Strings[FixNotify[3].Datchik[3]]; if FixNotify[3].State[3] then veParams3.Cells[1,6] := 'есть' else veParams3.Cells[1,6] := 'нет';
  veParams3.Cells[1,7] := NameFR.Strings[FixNotify[3].Datchik[4]]; if FixNotify[3].State[4] then veParams3.Cells[1,8] := 'есть' else veParams3.Cells[1,8] := 'нет';
  veParams3.Cells[1,9] := NameFR.Strings[FixNotify[3].Datchik[5]]; if FixNotify[3].State[5] then veParams3.Cells[1,10] := 'есть' else veParams3.Cells[1,10] := 'нет';
  veParams3.Cells[1,11] := NameFR.Strings[FixNotify[3].Datchik[6]]; if FixNotify[3].State[6] then veParams3.Cells[1,12] := 'есть' else veParams3.Cells[1,12] := 'нет';

  cbNot4.ItemIndex := FixNotify[4].Sound; if FixNotify[4].Enable then cbRunStop4.ItemIndex := 1 else cbRunStop4.ItemIndex := 0; cbViewObj4.ItemIndex := FixNotify[4].Obj;
  veParams4.Cells[1,1] := NameFR.Strings[FixNotify[4].Datchik[1]]; if FixNotify[4].State[1] then veParams4.Cells[1,2] := 'есть' else veParams4.Cells[1,2] := 'нет';
  veParams4.Cells[1,3] := NameFR.Strings[FixNotify[4].Datchik[2]]; if FixNotify[4].State[2] then veParams4.Cells[1,4] := 'есть' else veParams4.Cells[1,4] := 'нет';
  veParams4.Cells[1,5] := NameFR.Strings[FixNotify[4].Datchik[3]]; if FixNotify[4].State[3] then veParams4.Cells[1,6] := 'есть' else veParams4.Cells[1,6] := 'нет';
  veParams4.Cells[1,7] := NameFR.Strings[FixNotify[4].Datchik[4]]; if FixNotify[4].State[4] then veParams4.Cells[1,8] := 'есть' else veParams4.Cells[1,8] := 'нет';
  veParams4.Cells[1,9] := NameFR.Strings[FixNotify[4].Datchik[5]]; if FixNotify[4].State[5] then veParams4.Cells[1,10] := 'есть' else veParams4.Cells[1,10] := 'нет';
  veParams4.Cells[1,11] := NameFR.Strings[FixNotify[4].Datchik[6]]; if FixNotify[4].State[6] then veParams4.Cells[1,12] := 'есть' else veParams4.Cells[1,12] := 'нет';

  cbNot5.ItemIndex := FixNotify[5].Sound; if FixNotify[5].Enable then cbRunStop5.ItemIndex := 1 else cbRunStop5.ItemIndex := 0; cbViewObj5.ItemIndex := FixNotify[5].Obj;
  veParams5.Cells[1,1] := NameFR.Strings[FixNotify[5].Datchik[1]]; if FixNotify[5].State[1] then veParams5.Cells[1,2] := 'есть' else veParams5.Cells[1,2] := 'нет';
  veParams5.Cells[1,3] := NameFR.Strings[FixNotify[5].Datchik[2]]; if FixNotify[5].State[2] then veParams5.Cells[1,4] := 'есть' else veParams5.Cells[1,4] := 'нет';
  veParams5.Cells[1,5] := NameFR.Strings[FixNotify[5].Datchik[3]]; if FixNotify[5].State[3] then veParams5.Cells[1,6] := 'есть' else veParams5.Cells[1,6] := 'нет';
  veParams5.Cells[1,7] := NameFR.Strings[FixNotify[5].Datchik[4]]; if FixNotify[5].State[4] then veParams5.Cells[1,8] := 'есть' else veParams5.Cells[1,8] := 'нет';
  veParams5.Cells[1,9] := NameFR.Strings[FixNotify[5].Datchik[5]]; if FixNotify[5].State[5] then veParams5.Cells[1,10] := 'есть' else veParams5.Cells[1,10] := 'нет';
  veParams5.Cells[1,11] := NameFR.Strings[FixNotify[5].Datchik[6]]; if FixNotify[5].State[6] then veParams5.Cells[1,12] := 'есть' else veParams5.Cells[1,12] := 'нет';

  cbNot6.ItemIndex := FixNotify[6].Sound; if FixNotify[6].Enable then cbRunStop6.ItemIndex := 1 else cbRunStop6.ItemIndex := 0; cbViewObj6.ItemIndex := FixNotify[6].Obj;
  veParams6.Cells[1,1] := NameFR.Strings[FixNotify[6].Datchik[1]]; if FixNotify[6].State[1] then veParams6.Cells[1,2] := 'есть' else veParams6.Cells[1,2] := 'нет';
  veParams6.Cells[1,3] := NameFR.Strings[FixNotify[6].Datchik[2]]; if FixNotify[6].State[2] then veParams6.Cells[1,4] := 'есть' else veParams6.Cells[1,4] := 'нет';
  veParams6.Cells[1,5] := NameFR.Strings[FixNotify[6].Datchik[3]]; if FixNotify[6].State[3] then veParams6.Cells[1,6] := 'есть' else veParams6.Cells[1,6] := 'нет';
  veParams6.Cells[1,7] := NameFR.Strings[FixNotify[6].Datchik[4]]; if FixNotify[6].State[4] then veParams6.Cells[1,8] := 'есть' else veParams6.Cells[1,8] := 'нет';
  veParams6.Cells[1,9] := NameFR.Strings[FixNotify[6].Datchik[5]]; if FixNotify[6].State[5] then veParams6.Cells[1,10] := 'есть' else veParams6.Cells[1,10] := 'нет';
  veParams6.Cells[1,11] := NameFR.Strings[FixNotify[6].Datchik[6]]; if FixNotify[6].State[6] then veParams6.Cells[1,12] := 'есть' else veParams6.Cells[1,12] := 'нет';

  cbNot7.ItemIndex := FixNotify[7].Sound; if FixNotify[7].Enable then cbRunStop7.ItemIndex := 1 else cbRunStop7.ItemIndex := 0; cbViewObj7.ItemIndex := FixNotify[7].Obj;
  veParams7.Cells[1,1] := NameFR.Strings[FixNotify[7].Datchik[1]]; if FixNotify[7].State[1] then veParams7.Cells[1,2] := 'есть' else veParams7.Cells[1,2] := 'нет';
  veParams7.Cells[1,3] := NameFR.Strings[FixNotify[7].Datchik[2]]; if FixNotify[7].State[2] then veParams7.Cells[1,4] := 'есть' else veParams7.Cells[1,4] := 'нет';
  veParams7.Cells[1,5] := NameFR.Strings[FixNotify[7].Datchik[3]]; if FixNotify[7].State[3] then veParams7.Cells[1,6] := 'есть' else veParams7.Cells[1,6] := 'нет';
  veParams7.Cells[1,7] := NameFR.Strings[FixNotify[7].Datchik[4]]; if FixNotify[7].State[4] then veParams7.Cells[1,8] := 'есть' else veParams7.Cells[1,8] := 'нет';
  veParams7.Cells[1,9] := NameFR.Strings[FixNotify[7].Datchik[5]]; if FixNotify[7].State[5] then veParams7.Cells[1,10] := 'есть' else veParams7.Cells[1,10] := 'нет';
  veParams7.Cells[1,11] := NameFR.Strings[FixNotify[7].Datchik[6]]; if FixNotify[7].State[6] then veParams7.Cells[1,12] := 'есть' else veParams7.Cells[1,12] := 'нет';

  cbNot8.ItemIndex := FixNotify[8].Sound; if FixNotify[8].Enable then cbRunStop8.ItemIndex := 1 else cbRunStop8.ItemIndex := 0; cbViewObj8.ItemIndex := FixNotify[8].Obj;
  veParams8.Cells[1,1] := NameFR.Strings[FixNotify[8].Datchik[1]]; if FixNotify[8].State[1] then veParams8.Cells[1,2] := 'есть' else veParams8.Cells[1,2] := 'нет';
  veParams8.Cells[1,3] := NameFR.Strings[FixNotify[8].Datchik[2]]; if FixNotify[8].State[2] then veParams8.Cells[1,4] := 'есть' else veParams8.Cells[1,4] := 'нет';
  veParams8.Cells[1,5] := NameFR.Strings[FixNotify[8].Datchik[3]]; if FixNotify[8].State[3] then veParams8.Cells[1,6] := 'есть' else veParams8.Cells[1,6] := 'нет';
  veParams8.Cells[1,7] := NameFR.Strings[FixNotify[8].Datchik[4]]; if FixNotify[8].State[4] then veParams8.Cells[1,8] := 'есть' else veParams8.Cells[1,8] := 'нет';
  veParams8.Cells[1,9] := NameFR.Strings[FixNotify[8].Datchik[5]]; if FixNotify[8].State[5] then veParams8.Cells[1,10] := 'есть' else veParams8.Cells[1,10] := 'нет';
  veParams8.Cells[1,11] := NameFR.Strings[FixNotify[8].Datchik[6]]; if FixNotify[8].State[6] then veParams8.Cells[1,12] := 'есть' else veParams8.Cells[1,12] := 'нет';

  cbNot9.ItemIndex := FixNotify[9].Sound; if FixNotify[9].Enable then cbRunStop9.ItemIndex := 1 else cbRunStop9.ItemIndex := 0; cbViewObj9.ItemIndex := FixNotify[9].Obj;
  veParams9.Cells[1,1] := NameFR.Strings[FixNotify[9].Datchik[1]]; if FixNotify[9].State[1] then veParams9.Cells[1,2] := 'есть' else veParams9.Cells[1,2] := 'нет';
  veParams9.Cells[1,3] := NameFR.Strings[FixNotify[9].Datchik[2]]; if FixNotify[9].State[2] then veParams9.Cells[1,4] := 'есть' else veParams9.Cells[1,4] := 'нет';
  veParams9.Cells[1,5] := NameFR.Strings[FixNotify[9].Datchik[3]]; if FixNotify[9].State[3] then veParams9.Cells[1,6] := 'есть' else veParams9.Cells[1,6] := 'нет';
  veParams9.Cells[1,7] := NameFR.Strings[FixNotify[9].Datchik[4]]; if FixNotify[9].State[4] then veParams9.Cells[1,8] := 'есть' else veParams9.Cells[1,8] := 'нет';
  veParams9.Cells[1,9] := NameFR.Strings[FixNotify[9].Datchik[5]]; if FixNotify[9].State[5] then veParams9.Cells[1,10] := 'есть' else veParams9.Cells[1,10] := 'нет';
  veParams9.Cells[1,11] := NameFR.Strings[FixNotify[9].Datchik[6]]; if FixNotify[9].State[6] then veParams9.Cells[1,12] := 'есть' else veParams9.Cells[1,12] := 'нет';

  cbNot10.ItemIndex := FixNotify[10].Sound; if FixNotify[10].Enable then cbRunStop10.ItemIndex := 1 else cbRunStop10.ItemIndex := 0; cbViewObj10.ItemIndex := FixNotify[10].Obj;
  veParams10.Cells[1,1] := NameFR.Strings[FixNotify[10].Datchik[1]]; if FixNotify[10].State[1] then veParams10.Cells[1,2] := 'есть' else veParams10.Cells[1,2] := 'нет';
  veParams10.Cells[1,3] := NameFR.Strings[FixNotify[10].Datchik[2]]; if FixNotify[10].State[2] then veParams10.Cells[1,4] := 'есть' else veParams10.Cells[1,4] := 'нет';
  veParams10.Cells[1,5] := NameFR.Strings[FixNotify[10].Datchik[3]]; if FixNotify[10].State[3] then veParams10.Cells[1,6] := 'есть' else veParams10.Cells[1,6] := 'нет';
  veParams10.Cells[1,7] := NameFR.Strings[FixNotify[10].Datchik[4]]; if FixNotify[10].State[4] then veParams10.Cells[1,8] := 'есть' else veParams10.Cells[1,8] := 'нет';
  veParams10.Cells[1,9] := NameFR.Strings[FixNotify[10].Datchik[5]]; if FixNotify[10].State[5] then veParams10.Cells[1,10] := 'есть' else veParams10.Cells[1,10] := 'нет';
  veParams10.Cells[1,11] := NameFR.Strings[FixNotify[10].Datchik[6]]; if FixNotify[10].State[6] then veParams10.Cells[1,12] := 'есть' else veParams10.Cells[1,12] := 'нет';

  tt.Free;
end;

procedure TNotifyForm.FormDestroy(Sender: TObject);
begin
  if Assigned(ListObj) then ListObj.Free;
  if Assigned(NameFR) then NameFR.Free;
end;

procedure TNotifyForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
// поиск индекса датчика
function GetDatchik(Datchik : string) : Word;
  var i : integer;
begin
  result := 0;
  for i := 1 to WorkMode.LimitNameFR do
    if LinkFR3[i].Name = Datchik then
    begin
      result := i; break;
    end;
end;

//------------------------------------------------------------------------------
// Загрузка события
procedure TNotifyForm.LoadNotify;
  var i : integer;
begin
  reg.RootKey := HKEY_LOCAL_MACHINE;
  for i := 1 to 10 do
   if Reg.OpenKey(KeyRegNotifyForm+ '\Notify'+ IntToStr(i), false) then
    begin
      if reg.ValueExists('Enable') then FixNotify[i].Enable := reg.ReadBool('Enable') else FixNotify[i].Enable := false;
      if reg.ValueExists('Sound') then FixNotify[i].Sound := reg.ReadInteger('Sound') else FixNotify[i].Sound := 0;
      if reg.ValueExists('Obj') then FixNotify[i].Obj := reg.ReadInteger('Obj') else FixNotify[i].Obj := 0;
      if reg.ValueExists('Datchik1') then FixNotify[i].Datchik[1] := reg.ReadInteger('Datchik1') else FixNotify[i].Datchik[1] := 0;
      if reg.ValueExists('State1') then FixNotify[i].State[1] := reg.ReadBool('State1') else FixNotify[i].State[1] := false;
      if reg.ValueExists('Datchik2') then FixNotify[i].Datchik[2] := reg.ReadInteger('Datchik2') else FixNotify[i].Datchik[2] := 0;
      if reg.ValueExists('State2') then FixNotify[i].State[2] := reg.ReadBool('State2') else FixNotify[i].State[2] := false;
      if reg.ValueExists('Datchik3') then FixNotify[i].Datchik[3] := reg.ReadInteger('Datchik3') else FixNotify[i].Datchik[3] := 0;
      if reg.ValueExists('State3') then FixNotify[i].State[3] := reg.ReadBool('State3') else FixNotify[i].State[3] := false;
      if reg.ValueExists('Datchik4') then FixNotify[i].Datchik[4] := reg.ReadInteger('Datchik4') else FixNotify[i].Datchik[4] := 0;
      if reg.ValueExists('State4') then FixNotify[i].State[4] := reg.ReadBool('State4') else FixNotify[i].State[4] := false;
      if reg.ValueExists('Datchik5') then FixNotify[i].Datchik[5] := reg.ReadInteger('Datchik5') else FixNotify[i].Datchik[5] := 0;
      if reg.ValueExists('State5') then FixNotify[i].State[5] := reg.ReadBool('State5') else FixNotify[i].State[5] := false;
      if reg.ValueExists('Datchik6') then FixNotify[i].Datchik[6] := reg.ReadInteger('Datchik6') else FixNotify[i].Datchik[6] := 0;
      if reg.ValueExists('State6') then FixNotify[i].State[6] := reg.ReadBool('State6') else FixNotify[i].State[6] := false;
      reg.CloseKey;
    end;
end;

procedure TNotifyForm.PageControlChange(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------
// Сохранение события
procedure TNotifyForm.SaveNotify;
  var i : integer;
begin
  reg.RootKey := HKEY_LOCAL_MACHINE;
  for i := 1 to 10 do
    if Reg.OpenKey(KeyRegNotifyForm+ '\Notify'+IntToStr(i), true) then
    begin
      reg.WriteBool('Enable',FixNotify[i].Enable);
      reg.WriteInteger('Sound',FixNotify[i].Sound);
      reg.WriteInteger('Obj',FixNotify[i].Obj);
      reg.WriteInteger('Datchik1',FixNotify[i].Datchik[1]);
      reg.WriteBool('State1',FixNotify[i].State[1]);
      reg.WriteInteger('Datchik2',FixNotify[i].Datchik[2]);
      reg.WriteBool('State2',FixNotify[i].State[2]);
      reg.WriteInteger('Datchik3',FixNotify[i].Datchik[3]);
      reg.WriteBool('State3',FixNotify[i].State[3]);
      reg.WriteInteger('Datchik4',FixNotify[i].Datchik[4]);
      reg.WriteBool('State4',FixNotify[i].State[4]);
      reg.WriteInteger('Datchik5',FixNotify[i].Datchik[5]);
      reg.WriteBool('State5',FixNotify[i].State[5]);
      reg.WriteInteger('Datchik6',FixNotify[i].Datchik[6]);
      reg.WriteBool('State6',FixNotify[i].State[6]);
      reg.CloseKey;
    end;
end;

//------------------------------------------------------------------------------
// изменение звука события
procedure TNotifyForm.cbNot1Change(Sender: TObject);
begin
  FixNotify[1].Sound := cbNot1.ItemIndex;
end;

procedure TNotifyForm.cbNot2Change(Sender: TObject);
begin
  FixNotify[2].Sound := cbNot2.ItemIndex;
end;

procedure TNotifyForm.cbNot3Change(Sender: TObject);
begin
  FixNotify[3].Sound := cbNot3.ItemIndex;
end;

procedure TNotifyForm.cbNot4Change(Sender: TObject);
begin
  FixNotify[4].Sound := cbNot4.ItemIndex;
end;

procedure TNotifyForm.cbNot5Change(Sender: TObject);
begin
  FixNotify[5].Sound := cbNot5.ItemIndex;
end;

procedure TNotifyForm.cbNot6Change(Sender: TObject);
begin
  FixNotify[6].Sound := cbNot6.ItemIndex;
end;

procedure TNotifyForm.cbNot7Change(Sender: TObject);
begin
  FixNotify[7].Sound := cbNot7.ItemIndex;
end;

procedure TNotifyForm.cbNot8Change(Sender: TObject);
begin
  FixNotify[8].Sound := cbNot8.ItemIndex;
end;

procedure TNotifyForm.cbNot9Change(Sender: TObject);
begin
  FixNotify[9].Sound := cbNot9.ItemIndex;
end;

procedure TNotifyForm.btnTestSoundClick(Sender: TObject);
var a : integer;
begin
  a := PageControl.TabIndex;
  a := a+1;
  PlaySound(PAnsiChar(NotifyWav.Strings[FixNotify[PageControl.TabIndex+1].Sound]),0,SND_ASYNC);
end;

procedure TNotifyForm.cbNot10Change(Sender: TObject);
begin
  FixNotify[10].Sound := cbNot10.ItemIndex;
end;

//------------------------------------------------------------------------------
// Включить / отключить ожидание события
procedure TNotifyForm.cbRunStop1Change(Sender: TObject);
begin
  FixNotify[1].Enable := (cbRunStop1.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop2Change(Sender: TObject);
begin
  FixNotify[2].Enable := (cbRunStop2.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop3Change(Sender: TObject);
begin
  FixNotify[3].Enable := (cbRunStop3.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop4Change(Sender: TObject);
begin
  FixNotify[4].Enable := (cbRunStop4.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop5Change(Sender: TObject);
begin
  FixNotify[5].Enable := (cbRunStop5.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop6Change(Sender: TObject);
begin
  FixNotify[6].Enable := (cbRunStop6.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop7Change(Sender: TObject);
begin
  FixNotify[7].Enable := (cbRunStop7.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop8Change(Sender: TObject);
begin
  FixNotify[8].Enable := (cbRunStop8.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop9Change(Sender: TObject);
begin
  FixNotify[9].Enable := (cbRunStop9.ItemIndex = 1);
end;

procedure TNotifyForm.cbRunStop10Change(Sender: TObject);
begin
  FixNotify[10].Enable := (cbRunStop10.ItemIndex = 1);
end;

//------------------------------------------------------------------------------
// Изменение объекта просмотра
procedure TNotifyForm.cbViewObj1Change(Sender: TObject);
begin
  FixNotify[1].Obj := cbViewObj1.ItemIndex;
end;

procedure TNotifyForm.cbViewObj10Change(Sender: TObject);
begin
  FixNotify[10].Obj := cbViewObj10.ItemIndex;
end;

procedure TNotifyForm.cbViewObj9Change(Sender: TObject);
begin
  FixNotify[9].Obj := cbViewObj9.ItemIndex;
end;

procedure TNotifyForm.cbViewObj8Change(Sender: TObject);
begin
  FixNotify[8].Obj := cbViewObj8.ItemIndex;
end;

procedure TNotifyForm.cbViewObj7Change(Sender: TObject);
begin
  FixNotify[7].Obj := cbViewObj7.ItemIndex;
end;

procedure TNotifyForm.cbViewObj6Change(Sender: TObject);
begin
  FixNotify[6].Obj := cbViewObj6.ItemIndex;
end;

procedure TNotifyForm.cbViewObj5Change(Sender: TObject);
begin
  FixNotify[5].Obj := cbViewObj5.ItemIndex;
end;

procedure TNotifyForm.cbViewObj4Change(Sender: TObject);
begin
  FixNotify[4].Obj := cbViewObj4.ItemIndex;
end;

procedure TNotifyForm.cbViewObj3Change(Sender: TObject);
begin
  FixNotify[3].Obj := cbViewObj3.ItemIndex;
end;

procedure TNotifyForm.cbViewObj2Change(Sender: TObject);
begin
  FixNotify[2].Obj := cbViewObj2.ItemIndex;
end;

//------------------------------------------------------------------------------
// Изменение параметров
procedure TNotifyForm.veParams1StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[1].Datchik[1] := GetDatchik(veParams1.Cells[1,1]);
    2 : FixNotify[1].State[1] := (veParams1.Cells[1,2] = 'есть');
    3 : FixNotify[1].Datchik[2] := GetDatchik(veParams1.Cells[1,3]);
    4 : FixNotify[1].State[2] := (veParams1.Cells[1,4] = 'есть');
    5 : FixNotify[1].Datchik[3] := GetDatchik(veParams1.Cells[1,5]);
    6 : FixNotify[1].State[3] := (veParams1.Cells[1,6] = 'есть');
    7 : FixNotify[1].Datchik[4] := GetDatchik(veParams1.Cells[1,7]);
    8 : FixNotify[1].State[4] := (veParams1.Cells[1,8] = 'есть');
    9 : FixNotify[1].Datchik[5] := GetDatchik(veParams1.Cells[1,9]);
    10 : FixNotify[1].State[5] := (veParams1.Cells[1,10] = 'есть');
    11 : FixNotify[1].Datchik[6] := GetDatchik(veParams1.Cells[1,11]);
    12 : FixNotify[1].State[6] := (veParams1.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams2StringsChange(Sender: TObject);
begin
  case veParams2.Row of
    1 : FixNotify[2].Datchik[1] := GetDatchik(veParams2.Cells[1,1]);
    2 : FixNotify[2].State[1] := (veParams2.Cells[1,2] = 'есть');
    3 : FixNotify[2].Datchik[2] := GetDatchik(veParams2.Cells[1,3]);
    4 : FixNotify[2].State[2] := (veParams2.Cells[1,4] = 'есть');
    5 : FixNotify[2].Datchik[3] := GetDatchik(veParams2.Cells[1,5]);
    6 : FixNotify[2].State[3] := (veParams2.Cells[1,6] = 'есть');
    7 : FixNotify[2].Datchik[4] := GetDatchik(veParams2.Cells[1,7]);
    8 : FixNotify[2].State[4] := (veParams2.Cells[1,8] = 'есть');
    9 : FixNotify[2].Datchik[5] := GetDatchik(veParams2.Cells[1,9]);
    10 : FixNotify[2].State[5] := (veParams2.Cells[1,10] = 'есть');
    11 : FixNotify[2].Datchik[6] := GetDatchik(veParams2.Cells[1,11]);
    12 : FixNotify[2].State[6] := (veParams2.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams3StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[3].Datchik[1] := GetDatchik(veParams3.Cells[1,1]);
    2 : FixNotify[3].State[1] := (veParams3.Cells[1,2] = 'есть');
    3 : FixNotify[3].Datchik[2] := GetDatchik(veParams3.Cells[1,3]);
    4 : FixNotify[3].State[2] := (veParams3.Cells[1,4] = 'есть');
    5 : FixNotify[3].Datchik[3] := GetDatchik(veParams3.Cells[1,5]);
    6 : FixNotify[3].State[3] := (veParams3.Cells[1,6] = 'есть');
    7 : FixNotify[3].Datchik[4] := GetDatchik(veParams3.Cells[1,7]);
    8 : FixNotify[3].State[4] := (veParams3.Cells[1,8] = 'есть');
    9 : FixNotify[3].Datchik[5] := GetDatchik(veParams3.Cells[1,9]);
    10 : FixNotify[3].State[5] := (veParams3.Cells[1,10] = 'есть');
    11 : FixNotify[3].Datchik[6] := GetDatchik(veParams3.Cells[1,11]);
    12 : FixNotify[3].State[6] := (veParams3.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams4StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[4].Datchik[1] := GetDatchik(veParams4.Cells[1,1]);
    2 : FixNotify[4].State[1] := (veParams4.Cells[1,2] = 'есть');
    3 : FixNotify[4].Datchik[2] := GetDatchik(veParams4.Cells[1,3]);
    4 : FixNotify[4].State[2] := (veParams4.Cells[1,4] = 'есть');
    5 : FixNotify[4].Datchik[3] := GetDatchik(veParams4.Cells[1,5]);
    6 : FixNotify[4].State[3] := (veParams4.Cells[1,6] = 'есть');
    7 : FixNotify[4].Datchik[4] := GetDatchik(veParams4.Cells[1,7]);
    8 : FixNotify[4].State[4] := (veParams4.Cells[1,8] = 'есть');
    9 : FixNotify[4].Datchik[5] := GetDatchik(veParams4.Cells[1,9]);
    10 : FixNotify[4].State[5] := (veParams4.Cells[1,10] = 'есть');
    11 : FixNotify[4].Datchik[6] := GetDatchik(veParams4.Cells[1,11]);
    12 : FixNotify[4].State[6] := (veParams4.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams5StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[5].Datchik[1] := GetDatchik(veParams5.Cells[1,1]);
    2 : FixNotify[5].State[1] := (veParams5.Cells[1,2] = 'есть');
    3 : FixNotify[5].Datchik[2] := GetDatchik(veParams5.Cells[1,3]);
    4 : FixNotify[5].State[2] := (veParams5.Cells[1,4] = 'есть');
    5 : FixNotify[5].Datchik[3] := GetDatchik(veParams5.Cells[1,5]);
    6 : FixNotify[5].State[3] := (veParams5.Cells[1,6] = 'есть');
    7 : FixNotify[5].Datchik[4] := GetDatchik(veParams5.Cells[1,7]);
    8 : FixNotify[5].State[4] := (veParams5.Cells[1,8] = 'есть');
    9 : FixNotify[5].Datchik[5] := GetDatchik(veParams5.Cells[1,9]);
    10 : FixNotify[5].State[5] := (veParams5.Cells[1,10] = 'есть');
    11 : FixNotify[5].Datchik[6] := GetDatchik(veParams5.Cells[1,11]);
    12 : FixNotify[5].State[6] := (veParams5.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams6StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[6].Datchik[1] := GetDatchik(veParams6.Cells[1,1]);
    2 : FixNotify[6].State[1] := (veParams6.Cells[1,2] = 'есть');
    3 : FixNotify[6].Datchik[2] := GetDatchik(veParams6.Cells[1,3]);
    4 : FixNotify[6].State[2] := (veParams6.Cells[1,4] = 'есть');
    5 : FixNotify[6].Datchik[3] := GetDatchik(veParams6.Cells[1,5]);
    6 : FixNotify[6].State[3] := (veParams6.Cells[1,6] = 'есть');
    7 : FixNotify[6].Datchik[4] := GetDatchik(veParams6.Cells[1,7]);
    8 : FixNotify[6].State[4] := (veParams6.Cells[1,8] = 'есть');
    9 : FixNotify[6].Datchik[5] := GetDatchik(veParams6.Cells[1,9]);
    10 : FixNotify[6].State[5] := (veParams6.Cells[1,10] = 'есть');
    11 : FixNotify[6].Datchik[6] := GetDatchik(veParams6.Cells[1,11]);
    12 : FixNotify[6].State[6] := (veParams6.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams7StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[7].Datchik[1] := GetDatchik(veParams7.Cells[1,1]);
    2 : FixNotify[7].State[1] := (veParams7.Cells[1,2] = 'есть');
    3 : FixNotify[7].Datchik[2] := GetDatchik(veParams7.Cells[1,3]);
    4 : FixNotify[7].State[2] := (veParams7.Cells[1,4] = 'есть');
    5 : FixNotify[7].Datchik[3] := GetDatchik(veParams7.Cells[1,5]);
    6 : FixNotify[7].State[3] := (veParams7.Cells[1,6] = 'есть');
    7 : FixNotify[7].Datchik[4] := GetDatchik(veParams7.Cells[1,7]);
    8 : FixNotify[7].State[4] := (veParams7.Cells[1,8] = 'есть');
    9 : FixNotify[7].Datchik[5] := GetDatchik(veParams7.Cells[1,9]);
    10 : FixNotify[7].State[5] := (veParams7.Cells[1,10] = 'есть');
    11 : FixNotify[7].Datchik[6] := GetDatchik(veParams7.Cells[1,11]);
    12 : FixNotify[7].State[6] := (veParams7.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams8StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[8].Datchik[1] := GetDatchik(veParams8.Cells[1,1]);
    2 : FixNotify[8].State[1] := (veParams8.Cells[1,2] = 'есть');
    3 : FixNotify[8].Datchik[2] := GetDatchik(veParams8.Cells[1,3]);
    4 : FixNotify[8].State[2] := (veParams8.Cells[1,4] = 'есть');
    5 : FixNotify[8].Datchik[3] := GetDatchik(veParams8.Cells[1,5]);
    6 : FixNotify[8].State[3] := (veParams8.Cells[1,6] = 'есть');
    7 : FixNotify[8].Datchik[4] := GetDatchik(veParams8.Cells[1,7]);
    8 : FixNotify[8].State[4] := (veParams8.Cells[1,8] = 'есть');
    9 : FixNotify[8].Datchik[5] := GetDatchik(veParams8.Cells[1,9]);
    10 : FixNotify[8].State[5] := (veParams8.Cells[1,10] = 'есть');
    11 : FixNotify[8].Datchik[6] := GetDatchik(veParams8.Cells[1,11]);
    12 : FixNotify[8].State[6] := (veParams8.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams9StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[9].Datchik[1] := GetDatchik(veParams9.Cells[1,1]);
    2 : FixNotify[9].State[1] := (veParams9.Cells[1,2] = 'есть');
    3 : FixNotify[9].Datchik[2] := GetDatchik(veParams9.Cells[1,3]);
    4 : FixNotify[9].State[2] := (veParams9.Cells[1,4] = 'есть');
    5 : FixNotify[9].Datchik[3] := GetDatchik(veParams9.Cells[1,5]);
    6 : FixNotify[9].State[3] := (veParams9.Cells[1,6] = 'есть');
    7 : FixNotify[9].Datchik[4] := GetDatchik(veParams9.Cells[1,7]);
    8 : FixNotify[9].State[4] := (veParams9.Cells[1,8] = 'есть');
    9 : FixNotify[9].Datchik[5] := GetDatchik(veParams9.Cells[1,9]);
    10 : FixNotify[9].State[5] := (veParams9.Cells[1,10] = 'есть');
    11 : FixNotify[9].Datchik[6] := GetDatchik(veParams9.Cells[1,11]);
    12 : FixNotify[9].State[6] := (veParams9.Cells[1,12] = 'есть');
  end;
end;

procedure TNotifyForm.veParams10StringsChange(Sender: TObject);
begin
  case veParams1.Row of
    1 : FixNotify[10].Datchik[1] := GetDatchik(veParams10.Cells[1,1]);
    2 : FixNotify[10].State[1] := (veParams10.Cells[1,2] = 'есть');
    3 : FixNotify[10].Datchik[2] := GetDatchik(veParams10.Cells[1,3]);
    4 : FixNotify[10].State[2] := (veParams10.Cells[1,4] = 'есть');
    5 : FixNotify[10].Datchik[3] := GetDatchik(veParams10.Cells[1,5]);
    6 : FixNotify[10].State[3] := (veParams10.Cells[1,6] = 'есть');
    7 : FixNotify[10].Datchik[4] := GetDatchik(veParams10.Cells[1,7]);
    8 : FixNotify[10].State[4] := (veParams10.Cells[1,8] = 'есть');
    9 : FixNotify[10].Datchik[5] := GetDatchik(veParams10.Cells[1,9]);
    10 : FixNotify[10].State[5] := (veParams10.Cells[1,10] = 'есть');
    11 : FixNotify[10].Datchik[6] := GetDatchik(veParams10.Cells[1,11]);
    12 : FixNotify[10].State[6] := (veParams10.Cells[1,12] = 'есть');
  end;
end;

end.
