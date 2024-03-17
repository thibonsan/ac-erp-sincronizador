unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Phys.PGDef, FireDAC.Phys.PG, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, horse, horse.jhonson, DataSet.Serialize;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  System.JSON;

procedure TForm2.FormCreate(Sender: TObject);
begin
  THorse
    .Post('sincronizar/:tabela',
      procedure (Req: THorseRequest; Res: THorseResponse)
      begin
        try
          FDConnection1.StartTransaction;
          FDQuery1.SQL.Clear;
          FDQuery1.Open(Format('select * from %s where 1 = 1', [Req.Params['tabela']]));
          FDQuery1.LoadFromJson(Req.Body);
          FDConnection1.Commit;
          Memo1.Lines.Add('Sincronizada a tabela ' + Req.Params['tabela']);
          Memo1.Lines.Add(Req.Body);
          Res.Status(202);
        except
          FDConnection1.Rollback;
          Res.Status(404);
        end;
      end)
    .Get('sincronizado/:tabela',
      procedure (Req: THorseRequest; Res: THorseResponse)
      begin
        FDQuery1.Close;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('select * from ' + Req.Params['tabela']);
        FDQuery1.Open;
        Res.Send(FDQuery1.ToJsonObject.ToJson);
      end);

  THorse.Listen(9000);
end;

end.
