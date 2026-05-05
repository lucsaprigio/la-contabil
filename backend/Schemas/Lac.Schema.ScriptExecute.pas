unit Lac.Schema.ScriptExecute;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, Lac.Infra.Connection, FireDAC.UI.Intf, FireDAC.Comp.UI,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Stan.Intf,
  FireDAC.Comp.Script, Lac.Utils;

type
  TDatabaseSchema = class
    public
      class procedure Execute(const APath: string);
  end;

implementation

var
  Qry: TFDQuery;
  Connection : IControllerConnection;

{ TDatabaseSchema }

class procedure TDatabaseSchema.Execute(const APath: string);
var
  LScript : TFDScript;
begin
  Connection := TControllerConection.New;
  Qry := TFDQuery.Create(nil);

  Qry.Connection := Connection.GetConnection;
  try
    try

    Qry.ExecSQL;
    except on E: Exception do
      TLacUtils.GeraLog(E.Message);
    end;
  finally
   Qry.Free;
  end;
end;


end.
