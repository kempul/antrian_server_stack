unit AntrianServerUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, JvgStringGrid, JvExControls,
  JvNavigationPane, Vcl.ExtCtrls, JvComponentBase, Vcl.StdCtrls,
  JvStaticText, IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdContext, JvTimer, JvGradientHeaderPanel;

type
  TForm1 = class(TForm)
    panel2: TPanel;
    panel3: TPanel;
    idTCPServer1: TIdTCPServer;
    timer1: TJvTimer;
    panelHeaderLoketNow: TJvNavPanelHeader;
    panelHeaderAntriNow: TJvNavPanelHeader;
    panelHeaderPelayananNow: TJvNavPanelHeader;
    panelHeaderPoliNow: TJvNavPanelHeader;
    HeaderPanel1: TJvGradientHeaderPanel;
    HeaderPanel2: TJvGradientHeaderPanel;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure idTCPServer1Execute(AContext: TIdContext);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure timer1Timer(Sender: TObject);
  private
    { Private declarations }
    jsAntri : string;
    slMessage : TStringList;
    slDaftar, slLayanan : TStringList;
    procedure awal;
    procedure putarSuara_nunggu(antri : Integer; loket : Integer; poli : string);
    procedure UpdateDisplay(loket : integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
     uses OtlParallel, SynCommons, antrikanU;
{$R *.dfm}

procedure TForm1.awal;
begin

slMessage := TStringList.Create;
slDaftar := TStringList.Create;
slLayanan := TStringList.Create;
HeaderPanel1.LabelCaption := '';
HeaderPanel2.LabelCaption := '';
idTCPServer1.Active := True;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
slMessage.Free;
slDaftar.Free;
slLayanan.Free;
idTCPServer1.Active := False;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
{
panel3.Height := Form1.Height div 2;
toolpanel1.Width := panel3.Width div 3;
toolpanel2.Width := panel3.Width div 3;

toolpanel4.Width := panel2.Width div 3;
toolpanel5.Width := panel2.Width div 3;

panelH1.Height := toolPanel1.Height div 2;
}
panel2.Width := Form1.Width div 2;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
jsAntri := '{"loket" : 1,"antri" : 1}';
awal;
end;

procedure TForm1.idTCPServer1Execute(AContext: TIdContext);
var
  v0 : Variant;
  TheMessage : string;
begin
  TheMessage := AContext.Connection.IOHandler.ReadLn();
  slMessage.Add(TheMessage);
  timer1.Enabled := True;
end;

procedure TForm1.putarSuara_nunggu(antri, loket: Integer; poli : string);
var suara : Antrian;
begin
      suara := Antrian.Create(antri, loket, poli);
      try
        suara.mainkan;
      finally
        suara.Free;
      end;

end;


procedure TForm1.timer1Timer(Sender: TObject);
var v0 : Variant;
begin
timer1.Enabled := False;
if slMessage.Count > 0 then
begin
  v0 := _Json(slMessage[0]);
  UpdateDisplay(v0.loket);
  if v0.loket > 0 then
  begin
   // antrian

   panelHeaderAntriNow.Caption := IntToStr(v0.antri);
   panelHeaderLoketNow.Caption := 'Loket ' + IntToStr(v0.loket);
  end else
  begin
    //pelayanan
   panelHeaderPelayananNow.Caption := IntToStr(v0.antri);
   panelHeaderPoliNow.Caption := 'Poli ' + UpperCase(v0.poli);

  end;

  Application.ProcessMessages;
  putarSuara_nunggu(v0.antri, v0.loket, v0.poli);

  slMessage.Delete(0);

end;
timer1.Enabled := True;
end;

procedure TForm1.UpdateDisplay(loket : integer);
begin
if loket > 0 then
begin
  slDaftar.Insert(0, panelHeaderAntriNow.Caption + ' : ' + panelHeaderLoketNow.Caption);
  if slDaftar.Count > 3 then slDaftar.Delete(slDaftar.Count - 1);
  HeaderPanel1.LabelCaption := slDaftar.Text;

end else
begin
  slLayanan.Insert(0, panelHeaderPelayananNow.Caption + ' : ' + panelHeaderPoliNow.Caption);
  if slLayanan.Count > 3 then slLayanan.Delete(slLayanan.Count - 1);
  HeaderPanel2.LabelCaption := slLayanan.Text;
end;
end;

end.
