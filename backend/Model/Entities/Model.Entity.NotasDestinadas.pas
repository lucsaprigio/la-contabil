unit Model.Entity.NotasDestinadas;

interface

uses
  System.SysUtils, System.StrUtils, ACBrDFe.Conversao;

type
  TNotasDestinadas = class
  private
    class var FId: String;
    class var FBusinessId: String;
    class var FChaveAcesso: String;
    class var FCnpjEmitente: String;
    class var FNsu: String;
    class var FDtEmi: TDateTime;
    class var FNomeEmit: String;
    class var FVrTot: Double;
    class var FSitSefaz: Integer;
    class var FStatus: Integer;
    class var FProcessEntrada: Integer;

    function GerarUUID : string;

  public
    constructor Create(const AId : string = '');

    class property Id: String read FId write FId;
    class property BusinessId: String read FBusinessId write FBusinessId;
    class property ChaveAcesso: String read FChaveAcesso write FChaveAcesso;
    class property Nsu: String read FNsu write FNsu;
    class property CnpjEmit: String read FCnpjEmitente write FCnpjEmitente;
    class property NomeEmit: String read FNomeEmit write FNomeEmit;
    class property DtEmi: TDateTime read FDtEmi write FDtEmi;
    class property VrTot: Double read FVrTot write FVrTot;
    class property SitSefaz: Integer read FSitSefaz write FSitSefaz;
    class property Status: Integer read FStatus write FStatus;
    class property ProcessEntrada: Integer read FProcessEntrada write FProcessEntrada;
  end;

implementation

{ TNotasDestinadas }

constructor TNotasDestinadas.Create(const AId: string);
begin
    if AId.Trim.IsEmpty then
      FId := GerarUUID
    else
      FId := AId;

end;

function TNotasDestinadas.GerarUUID: string;
var
  LGUID : TGUID;
begin
   CreateGUID(LGUID);

   Result := GUIDToString(LGUID).Replace('{', '').Replace('}', '');
end;

end.
