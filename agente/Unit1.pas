unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, Data.DB,
  FireDAC.Comp.DataSet, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDEventAlerter1: TFDEventAlerter;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FDEventAlerter1Timeout(Sender: TObject);
    procedure FDEventAlerter1Alert(ASender: TFDCustomEventAlerter;
      const AEventName: string; const AArgument: Variant);
    procedure Button3Click(Sender: TObject);
  private
    procedure RegistrarEvento;
    procedure DesativarEvento;
    procedure ExecutarEvento;
    procedure PostEvent(Tabela: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  RESTRequest4D, DataSet.Serialize;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not (Button1.Caption = 'Start') then
    DesativarEvento
  else
    RegistrarEvento;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ExecutarEvento;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  try
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('insert into sincronizar(valor1, valor2) values (:valor1, :valor2)');
    FDQuery1.ParamByName('valor1').AsInteger := 1;
    FDQuery1.ParamByName('valor2').AsInteger := 2;
    FDQuery1.ExecSQL;
    ExecutarEvento;
  except
    on E: Exception do
      raise Exception.Create('Error Message: ' + E.Message);
  end;
end;

procedure TForm1.DesativarEvento;
begin
  if not FDEventAlerter1.Active then
    Exit;

  Memo1.Lines.Add('Desativado');
  FDEventAlerter1.Unregister;
  Memo1.Lines.Add('Inativo');
  Button1.Caption := 'Start';
end;

procedure TForm1.ExecutarEvento;
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT POST_EVENT(''SINCRONIZAR'',''I'')');
  FDQuery1.Command.CommandKind := skOther;
  FDQuery1.Connection.StartTransaction;
  FDQuery1.ExecSQL;
  FDQuery1.GetResults;
  FDQuery1.Connection.Commit;
end;

procedure TForm1.FDEventAlerter1Alert(ASender: TFDCustomEventAlerter;
  const AEventName: string; const AArgument: Variant);
begin
  var sArgs: string;

  if VarIsArray(AArgument) then
  begin
    sArgs := EmptyStr;

    for var I := VarArrayLowBound(AArgument, 1) to VarArrayHighBound(AArgument, 1) do
    begin
      if not sArgs.IsEmpty then
        sArgs := sArgs + ', ';

        sArgs := sArgs + VarToStr(AArgument[I]);
    end;
  end
  else if VarIsNumeric(AArgument) then
    sArgs := '<NULL>'
  else if VarIsEmpty(AArgument) then
    sArgs := '<UNASSIGNED>'
  else
    sArgs := VarToStr(AArgument);

  Memo1.Lines.Add('Event - [' + AEventName + '] - [' + sArgs + ']');
  PostEvent(AEventName);
end;

procedure TForm1.FDEventAlerter1Timeout(Sender: TObject);
begin
  Memo1.Lines.Add('Timeout');
end;

procedure TForm1.PostEvent(Tabela: string);
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from sincronizar');
  FDQuery1.Open;

  var lResp := TRequest.New
    .BaseURL('http://localhost:9000/sincronizar/' + Tabela)
    .ContentType('application/json')
    .AddBody(FDQuery1.ToJsonObject)
    .Post;

  if lResp.StatusCode = 202 then
    Memo1.Lines.Add('Sincronizado a tabela ' + Tabela)
  else
    Memo1.Lines.Add('Erro ao tentar realizar a sincronização')
end;

procedure TForm1.RegistrarEvento;
begin
  if FDEventAlerter1.Active then
    Exit;

  FDEventAlerter1.Options.Kind := EmptyStr;
  FDEventAlerter1.Names.Clear;
  FDEventAlerter1.Names.Add('SINCRONIZAR');
  FDEventAlerter1.Options.Synchronize := True;
  Memo1.Lines.Add('Registrar');
  FDEventAlerter1.Register;
  Button1.Caption := 'Stop';
end;

end.
