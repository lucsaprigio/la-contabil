unit Lac.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Lac.Infra.Connection, Horse, Horse.Jhonson, FireDAC.Comp.Client,
  Lac.Router.Auth, Infra.HorseServer, FireDAC.UI.Intf, FireDAC.Stan.Async,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Stan.Intf,
  FireDAC.Comp.Script, FireDAC.Phys.MSSQL, Vcl.Menus, Lac.Schema.ScriptExecute,
  System.IOUtils, Lac.Database.Migrations;

type
  Tfrm_view_principal = class(TForm)
    pnlContainer: TPanel;
    memLog: TMemo;
    PopupMenu: TPopupMenu;
    PopupMenu1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PopupMenu1Click(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  frm_view_principal: Tfrm_view_principal;

implementation

uses
  Lac.Router.Usuario, Lac.Utils.Configuracao;

{$R *.dfm}

procedure Tfrm_view_principal.FormCreate(Sender: TObject);
begin

  TAppConfig.CarregarIni;

  TThread.CreateAnonymousThread(
  procedure
  begin
    TServerHorse.Start(9000,
    procedure(const AMsg : string) begin
      TThread.Synchronize(nil, procedure
      begin
         memLog.Lines.Add(AMsg);
      end);
    end);
  end).Start;
end;

procedure Tfrm_view_principal.FormDestroy(Sender: TObject);
begin
    TServerHorse.Stop;
end;

procedure Tfrm_view_principal.PopupMenu1Click(Sender: TObject);
var
  LPath: string;
begin
      TThread.Synchronize(nil, procedure
      begin
         memLog.Lines.Add('Rodando migrations...');
      end);

      TDatabaseMigrations.Run;
end;

end.
