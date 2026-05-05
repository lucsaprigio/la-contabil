unit Model.Entity.NFSaida;

interface

uses
  System.SysUtils, System.RegularExpressions;

type
TNotasSaida = class
  private
    FId: string;
    FBusinessId: string;
    FClienteId: string;
    FCpfCnpj: string;
    FNumero: Integer;
    FSerie: Integer;
    FChaveAcesso: string;
    FProtocolo: string;
    FCfop: string;
    FDataEmissao: TDateTime;
    FValorTotal: Double;
    FBaseIcms: Double;
    FValorIcms: Double;
    FBaseSt : Double;
    FValorSt : Double;
    FObsNf : WideString;
    FModelo: Integer;

    // Assinaturas dos Getters e Setters
    function GetId: string;
    procedure SetId(const Value: string);

    procedure SetBusinessId(const Value: string);

    procedure SetClienteId(const Value: string);

    procedure SetCpfCnpj(const Value: string);

    function GetBaseSt: Double;
    procedure SetBaseSt(const Value: Double);

    function GetValorSt: Double;
    procedure SetValorSt(const Value: Double);

    function GetObsNf: WideString;
    procedure SetObsNf(const Value: WideString);

    procedure SetModelo(const Value: Integer);

  public
    constructor Create(const aId : String = '');

  published
    property Id: string read GetId write SetId;
    property BusinessId: string read FBusinessId write SetBusinessId;
    property ClienteId : string read FClienteId write SetClienteId;
    property CpfCnpj : String read FCpfCnpj write SetCpfCnpj;
    property Numero: Integer read FNumero write FNumero;
    property Serie: Integer read FSerie write FSerie;
    property ChaveAcesso: string read FChaveAcesso write FChaveAcesso;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Cfop: string read FCfop write FCfop;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property BaseIcms: Double read FBaseIcms write FBaseIcms;
    property ValorIcms: Double read FValorIcms write FValorIcms;
    property BaseSt: Double read GetBaseSt write SetBaseSt;
    property ValorSt: Double read GetValorSt write SetValorSt;
    property ObsNf: WideString read GetObsNf write SetObsNf;
    property Modelo: Integer read FModelo write SetModelo;
  end;

implementation

{ TNotasSaida }

constructor TNotasSaida.Create(const aId : String = '');
begin
    // Lembrar sempre que for instanciar, dar o .Create, enviar o ID se for consulta... Futuramente posso criar uma função para validação.
    if Trim(aId) = '' then
      FId := TGUID.NewGuid.toString().Replace('{', '').Replace('}', '')
    else
      FId := aId;
end;

function TNotasSaida.GetBaseSt: Double;
begin
     Result := FBaseSt;
end;

function TNotasSaida.GetId: string;
begin
    Result := FId;
end;

function TNotasSaida.GetValorSt: Double;
begin
     Result := FValorSt;
end;

function TNotasSaida.GetObsNf: WideString;
begin
    Result := FObsNf;
end;

procedure TNotasSaida.SetBaseSt(const Value: Double);
begin
      FBaseSt := Value;
end;

procedure TNotasSaida.SetBusinessId(const Value: string);
begin
   if Value.Trim = '' then begin
    FBusinessId := '';
    Exit;
  end;

    FBusinessId := Value.Replace('{', '').Replace('}', '');
end;

procedure TNotasSaida.SetValorSt(const Value: Double);
begin
      FValorSt := Value;
end;


procedure TNotasSaida.SetId(const Value: string);
begin
   if Value.Trim = '' then begin
    FId := '';
    Exit;
  end;

    FId := Value.Replace('{', '').Replace('}', '');
end;

procedure TNotasSaida.SetModelo(const Value: Integer);
begin
  FModelo := Value;
end;

procedure TNotasSaida.SetObsNf(const Value: WideString);
begin
      FObsNf := Value;
end;


procedure TNotasSaida.SetCpfCnpj(const Value: string);
var
  lDocLimpo : String;
begin
  lDocLimpo := TRegEx.Replace(Value, '[^0-9]', ''); 

  if (Length(lDocLimpo) <> 11) and (Length(lDocLimpo) <> 14) then
      raise Exception.Create('Documento inválido! O CPF deve ter 11 dígitos e o CNPJ 14.');

  FCpfCnpj := lDocLimpo;
end;

procedure TNotasSaida.SetClienteId(const Value: string);
begin
      FClienteId := Value;
end;

end.