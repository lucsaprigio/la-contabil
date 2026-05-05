unit Model.Entity.Empresa;

interface

uses Lac.Utils, System.StrUtils, System.SysUtils;

type
  TEmpresa = class
  private
    FBusinessId: String;
    FCorporateName: String;
    FFantasyName: String;
    FCnpj: String;
    FIe: String;
    FEnvironment: Integer;
    FLastNSU: String;
    FCertBase64: String;
    FCertPassword: String;
    FCertExpiration: TDateTime;
    FUf: String;
    FDataUltConsulta: TDateTime;

    procedure SetBusinessId(const Value: String);
   public
    constructor Create;

    class function New: TEmpresa;

    property BusinessId: String read FBusinessId write SetBusinessId;
    property CorporateName: String read FCorporateName write FCorporateName;
    property FantasyName: String read FFantasyName write FFantasyName;
    property Cnpj: String read FCnpj write FCnpj;
    property Ie: String read FIe write FIe;
    property Uf: String read FUf write FUf;
    property Environment: Integer read FEnvironment write FEnvironment;
    property LastNSU: String read FLastNSU write FLastNSU;
    property CertBase64: String read FCertBase64 write FCertBase64;
    property CertPassword: String read FCertPassword write FCertPassword;
    property CertExpiration: TDateTime read FCertExpiration write FCertExpiration;
    property DataUltConsulta : TDateTime read FDataUltConsulta write FDataUltConsulta;
  end;

implementation

{ TEmpresa }

constructor TEmpresa.Create;
begin
   inherited Create;
end;

class function TEmpresa.New: TEmpresa;
begin
  Result := TEmpresa.Create;
  Result.BusinessId := TLacUtils.NewIDString;
end;

procedure TEmpresa.SetBusinessId(const Value: String);
begin
  if Trim(Value) = '' then begin
     FBusinessId := '';
     Exit;
  end;

  FBusinessId := TLacUtils.CleanID(Value);
end;

end.
