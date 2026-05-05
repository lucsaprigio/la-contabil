unit Lac.Model.DAO.Clientes;

interface

uses
 Model.DAO.Interfaces, Model.Entity.Cliente, Lac.Infra.Connection,
  FireDAC.Comp.Client, System.SysUtils;

type
  TDAOCliente = class(TInterfacedObject, iDAOCliente)
    private
      FConexao : IControllerConnection;
    public
      constructor Create(aConexao : IControllerConnection);
      destructor Destroy; override;

      class function New(aConexao : IControllerConnection) : iDAOCliente;

      procedure SalvarCliente(aCliente: TCliente);
      procedure AtualizarCliente(aCliente: TCliente);

      function BuscarCliente(aBusinessId: String; aIdCliente: String = ''; aCpfCnpj: String = ''): TCliente;

      function ListarClientes(aBusinessId: String; aNome: String = ''; aCpfCnpj: String = '';
                              aPessoa: String = ''; aAtivo: String = ''): TArray<TCliente>;
  end;

implementation

{ TDAOCliente }

constructor TDAOCliente.Create(aConexao: IControllerConnection);
begin
    FConexao := aConexao;
end;

destructor TDAOCliente.Destroy;
begin
  inherited;
end;

class function TDAOCliente.New(aConexao: IControllerConnection): iDAOCliente;
begin
    Result := Self.Create(aConexao);
end;

procedure TDAOCliente.AtualizarCliente(aCliente: TCliente);
var
  lQry: TFDQuery;
begin
  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := FConexao.GetConnection;

    // Proteção dupla: O UPDATE sempre exige o ID e o BUSINESS_ID
    lQry.SQL.Text := ' UPDATE TB_CLIENTES SET ' +
                     '   NOME_RAZAO = :NOME_RAZAO, NOME_FANTASIA = :NOME_FANTASIA, ' +
                     '   IE = :IE, EMAIL = :EMAIL, TELEFONE = :TELEFONE, ' +
                     '   LOGRADOURO = :LOGRADOURO, NUMERO = :NUMERO, COMPLEMENTO = :COMPLEMENTO, ' +
                     '   BAIRRO = :BAIRRO, CIDADE_CODIGO = :CIDADE_CODIGO, CIDADE_NOME = :CIDADE_NOME, ' +
                     '   UF = :UF, CEP = :CEP, ATIVO = :ATIVO ' +
                     ' WHERE ID = :ID AND BUSINESS_ID = :BUSINESS_ID ';

    lQry.ParamByName('ID').AsString            := aCliente.Id;
    lQry.ParamByName('BUSINESS_ID').AsString   := aCliente.BusinessId;
    lQry.ParamByName('NOME_RAZAO').AsString    := aCliente.NomeRazao;
    lQry.ParamByName('NOME_FANTASIA').AsString := aCliente.NomeFantasia;
    lQry.ParamByName('IE').AsString            := aCliente.Ie;
    lQry.ParamByName('EMAIL').AsString         := aCliente.Email;
    lQry.ParamByName('TELEFONE').AsString      := aCliente.Telefone;
    lQry.ParamByName('LOGRADOURO').AsString    := aCliente.Logradouro;
    lQry.ParamByName('NUMERO').AsString        := aCliente.Numero;
    lQry.ParamByName('COMPLEMENTO').AsString   := aCliente.Complemento;
    lQry.ParamByName('BAIRRO').AsString        := aCliente.Bairro;
    lQry.ParamByName('CIDADE_CODIGO').AsInteger:= aCliente.CidadeCodigo;
    lQry.ParamByName('CIDADE_NOME').AsString   := aCliente.CidadeNome;
    lQry.ParamByName('UF').AsString            := aCliente.Uf;
    lQry.ParamByName('CEP').AsString           := aCliente.Cep;
    lQry.ParamByName('ATIVO').AsString         := aCliente.Ativo;

    lQry.ExecSQL;
  finally
    lQry.Free;
  end;
end;

procedure TDAOCliente.SalvarCliente(aCliente: TCliente);
var
  lQry: TFDQuery;
begin
  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := FConexao.GetConnection;

    lQry.SQL.Text := ' INSERT INTO TB_CLIENTES (' +
                     '   ID, BUSINESS_ID, NOME_RAZAO, NOME_FANTASIA, CPF_CNPJ, IE, ' +
                     '   EMAIL, TELEFONE, LOGRADOURO, NUMERO, COMPLEMENTO, BAIRRO, ' +
                     '   CIDADE_CODIGO, CIDADE_NOME, UF, CEP, ATIVO, DATA_CADASTRO ' +
                     ' ) VALUES (' +
                     '   :ID, :BUSINESS_ID, :NOME_RAZAO, :NOME_FANTASIA, :CPF_CNPJ, :IE, ' +
                     '   :EMAIL, :TELEFONE, :LOGRADOURO, :NUMERO, :COMPLEMENTO, :BAIRRO, ' +
                     '   :CIDADE_CODIGO, :CIDADE_NOME, :UF, :CEP, :ATIVO, :DATA_CADASTRO ' +
                     ' )';

    lQry.ParamByName('ID').AsString            := aCliente.Id;
    lQry.ParamByName('BUSINESS_ID').AsString   := aCliente.BusinessId;
    lQry.ParamByName('NOME_RAZAO').AsString    := aCliente.NomeRazao;
    lQry.ParamByName('NOME_FANTASIA').AsString := aCliente.NomeFantasia;
    lQry.ParamByName('CPF_CNPJ').AsString      := aCliente.CpfCnpj;
    lQry.ParamByName('IE').AsString            := aCliente.Ie;
    lQry.ParamByName('EMAIL').AsString         := aCliente.Email;
    lQry.ParamByName('TELEFONE').AsString      := aCliente.Telefone;
    lQry.ParamByName('LOGRADOURO').AsString    := aCliente.Logradouro;
    lQry.ParamByName('NUMERO').AsString        := aCliente.Numero;
    lQry.ParamByName('COMPLEMENTO').AsString   := aCliente.Complemento;
    lQry.ParamByName('BAIRRO').AsString        := aCliente.Bairro;
    lQry.ParamByName('CIDADE_CODIGO').AsInteger:= aCliente.CidadeCodigo;
    lQry.ParamByName('CIDADE_NOME').AsString   := aCliente.CidadeNome;
    lQry.ParamByName('UF').AsString            := aCliente.Uf;
    lQry.ParamByName('CEP').AsString           := aCliente.Cep;
    lQry.ParamByName('ATIVO').AsString         := aCliente.Ativo;
    lQry.ParamByName('DATA_CADASTRO').AsDateTime := aCliente.DataCadastro;

    lQry.ExecSQL;
  finally
    lQry.Free;
  end;

end;

function TDAOCliente.BuscarCliente(aBusinessId, aIdCliente,
  aCpfCnpj: String): TCliente;
var
  lQry: TFDQuery;
begin
  Result := nil;
  lQry := TFDQuery.Create(nil);

  try
    lQry.Connection := FConexao.GetConnection;

    lQry.SQL.Add(' SELECT * FROM TB_CLIENTES WHERE BUSINESS_ID = :BUSINESS_ID ');

    if Trim(aIdCliente) <> '' then
      lQry.SQL.Add(' AND ID = :ID ');

    if Trim(aCpfCnpj) <> '' then
      lQry.SQL.Add(' AND CPF_CNPJ = :CPF_CNPJ ');

    lQry.ParamByName('BUSINESS_ID').AsString := aBusinessId;

    if Trim(aIdCliente) <> '' then
      lQry.ParamByName('ID').AsString := aIdCliente;

    if Trim(aCpfCnpj) <> '' then
      lQry.ParamByName('CPF_CNPJ').AsString := aCpfCnpj;

    lQry.Open;

    if not lQry.IsEmpty then
    begin
      Result := TCliente.Create;
      Result.Id           := lQry.FieldByName('ID').AsString;
      Result.BusinessId   := lQry.FieldByName('BUSINESS_ID').AsString;
      Result.NomeRazao    := lQry.FieldByName('NOME_RAZAO').AsString;
      Result.NomeFantasia := lQry.FieldByName('NOME_FANTASIA').AsString;
      Result.CpfCnpj      := lQry.FieldByName('CPF_CNPJ').AsString;
      Result.Ie           := lQry.FieldByName('IE').AsString;
      Result.Email        := lQry.FieldByName('EMAIL').AsString;
      Result.Telefone     := lQry.FieldByName('TELEFONE').AsString;
      Result.Logradouro   := lQry.FieldByName('LOGRADOURO').AsString;
      Result.Numero       := lQry.FieldByName('NUMERO').AsString;
      Result.Complemento  := lQry.FieldByName('COMPLEMENTO').AsString;
      Result.Bairro       := lQry.FieldByName('BAIRRO').AsString;
      Result.CidadeCodigo := lQry.FieldByName('CIDADE_CODIGO').AsInteger;
      Result.CidadeNome   := lQry.FieldByName('CIDADE_NOME').AsString;
      Result.Uf           := lQry.FieldByName('UF').AsString;
      Result.Cep          := lQry.FieldByName('CEP').AsString;
      Result.Ativo        := lQry.FieldByName('ATIVO').AsString;
      Result.DataCadastro := lQry.FieldByName('DATA_CADASTRO').AsDateTime;
    end;

  finally
    lQry.Free;
  end;

end;


function TDAOCliente.ListarClientes(aBusinessId, aNome, aCpfCnpj, aPessoa,
  aAtivo: String): TArray<TCliente>;
var
  lQry: TFDQuery;
  lCliente: TCliente;
begin
  Result := nil;
  lQry := TFDQuery.Create(nil);

  try
    lQry.Connection := FConexao.GetConnection;

    lQry.SQL.Add(' SELECT * FROM TB_CLIENTES WHERE BUSINESS_ID = :BUSINESS_ID ');

    if Trim(aNome) <> '' then
      lQry.SQL.Add(' AND (NOME_RAZAO LIKE :NOME OR NOME_FANTASIA LIKE :NOME) ');

    if Trim(aCpfCnpj) <> '' then
      lQry.SQL.Add(' AND CPF_CNPJ = :CPF_CNPJ ');

    if Trim(aAtivo) <> '' then
      lQry.SQL.Add(' AND ATIVO = :ATIVO ');

    if Trim(aPessoa).ToUpper = 'F' then
      lQry.SQL.Add(' AND LEN(CPF_CNPJ) = 11 ')
    else if Trim(aPessoa).ToUpper = 'J' then
      lQry.SQL.Add(' AND LEN(CPF_CNPJ) = 14 ');

    lQry.ParamByName('BUSINESS_ID').AsString := aBusinessId;

    if Trim(aNome) <> '' then
      lQry.ParamByName('NOME').AsString := '%' + aNome + '%';

    if Trim(aCpfCnpj) <> '' then
      lQry.ParamByName('CPF_CNPJ').AsString := aCpfCnpj;

    if Trim(aAtivo) <> '' then
      lQry.ParamByName('ATIVO').AsString := aAtivo;

    lQry.Open;

    while not lQry.Eof do
    begin
      lCliente := TCliente.Create;
      lCliente.Id           := lQry.FieldByName('ID').AsString;
      lCliente.BusinessId   := lQry.FieldByName('BUSINESS_ID').AsString;
      lCliente.NomeRazao    := lQry.FieldByName('NOME_RAZAO').AsString;
      lCliente.NomeFantasia := lQry.FieldByName('NOME_FANTASIA').AsString;
      lCliente.CpfCnpj      := lQry.FieldByName('CPF_CNPJ').AsString;
      lCliente.Ie           := lQry.FieldByName('IE').AsString;
      lCliente.Email        := lQry.FieldByName('EMAIL').AsString;
      lCliente.Telefone     := lQry.FieldByName('TELEFONE').AsString;
      lCliente.Logradouro   := lQry.FieldByName('LOGRADOURO').AsString;
      lCliente.Numero       := lQry.FieldByName('NUMERO').AsString;
      lCliente.Complemento  := lQry.FieldByName('COMPLEMENTO').AsString;
      lCliente.Bairro       := lQry.FieldByName('BAIRRO').AsString;
      lCliente.CidadeCodigo := lQry.FieldByName('CIDADE_CODIGO').AsInteger;
      lCliente.CidadeNome   := lQry.FieldByName('CIDADE_NOME').AsString;
      lCliente.Uf           := lQry.FieldByName('UF').AsString;
      lCliente.Cep          := lQry.FieldByName('CEP').AsString;
      lCliente.Ativo        := lQry.FieldByName('ATIVO').AsString;
      lCliente.DataCadastro := lQry.FieldByName('DATA_CADASTRO').AsDateTime;

      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := lCliente;

      lQry.Next;
    end;

  finally
    lQry.Free;
  end;

end;

end.
