unit Model.Entity.Cliente;

interface

uses
  System.SysUtils, System.RegularExpressions;

type
  TCliente = class

private
    FId: string;
    FBusinessId: string;
    FNomeRazao: string;
    FNomeFantasia: string;
    FCpfCnpj: string;
    FIe: string;
    FEmail: string;
    FTelefone: string;
    FLogradouro: string;
    FNumero: string;
    FComplemento: string;
    FBairro: string;
    FCidadeCodigo: Integer;
    FCidadeNome: string;
    FUf: string;
    FCep: string;
    FAtivo: string;
    FDataCadastro: TDateTime;
    FPessoa: string;

    // Assinaturas dos Setters com regras de negócio
    procedure SetId(const Value: string);
    procedure SetBusinessId(const Value: string);
    procedure SetCpfCnpj(const Value: string);
    procedure SetCep(const Value: string);
    procedure SetTelefone(const Value: string);
  public
    constructor Create(const aId: string = '');

  published
    property Id: string read FId write SetId;
    property BusinessId: string read FBusinessId write SetBusinessId;
    property NomeRazao: string read FNomeRazao write FNomeRazao;
    property NomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property CpfCnpj: string read FCpfCnpj write SetCpfCnpj;
    property Ie: string read FIe write FIe;
    property Email: string read FEmail write FEmail;
    property Telefone: string read FTelefone write SetTelefone;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property CidadeCodigo: Integer read FCidadeCodigo write FCidadeCodigo;
    property CidadeNome: string read FCidadeNome write FCidadeNome;
    property Uf: string read FUf write FUf;
    property Cep: string read FCep write SetCep;
    property Ativo: string read FAtivo write FAtivo;
    property DataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    property Pessoa: string read FPessoa;
  end;

implementation

{ TCliente }

constructor TCliente.Create(const aId: string);
begin
  if Trim(aId) = '' then
    FId := TGUID.NewGuid.ToString().Replace('{', '').Replace('}', '')
  else
    FId := aId;

  FAtivo := 'S';
  FDataCadastro := Now;
end;

procedure TCliente.SetBusinessId(const Value: string);
begin
  if Value.Trim = '' then
  begin
    FBusinessId := '';
    Exit;
  end;
  FBusinessId := Value.Replace('{', '').Replace('}', '');
end;

procedure TCliente.SetId(const Value: string);
begin
  if Value.Trim = '' then
  begin
    FId := '';
    Exit;
  end;
  FId := Value.Replace('{', '').Replace('}', '');
end;

procedure TCliente.SetCep(const Value: string);
begin
  FCep := TRegEx.Replace(Value, '[^0-9]', '');
end;

procedure TCliente.SetCpfCnpj(const Value: string);
var
  lDocLimpo: string;
begin
  lDocLimpo := TRegEx.Replace(Value, '[^0-9]', '');

  if (lDocLimpo <> '') and (Length(lDocLimpo) <> 11) and (Length(lDocLimpo) <> 14) then
    raise Exception.Create('Documento inválido! O CPF deve ter 11 dígitos e o CNPJ 14.');

  FCpfCnpj := lDocLimpo;

  if Length(FCpfCnpj) = 14 then
    FPessoa := 'J'
  else if Length(FCpfCnpj) = 11 then
    FPessoa := 'F'
  else
    FPessoa := '';
end;


procedure TCliente.SetTelefone(const Value: string);
begin
   FTelefone := TRegEx.Replace(Value, '[^0-9]', '');
end;

end.
