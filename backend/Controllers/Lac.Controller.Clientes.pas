unit Lac.Controller.Clientes;

interface

uses
  Horse, System.JSON, System.SysUtils, REST.Json,
  Model.Entity.Cliente, Model.DAO.Interfaces, Lac.Model.DAO.Clientes, Lac.Infra.Connection;

type
  TLacControllerClientes = class
    class procedure GetListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetBuscarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PostSalvarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PutAtualizarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TLacControllerClientes }

class procedure TLacControllerClientes.GetListarClientes(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lDAO: iDAOCliente;
  lConexao: IControllerConnection;
  lBusinessId, LNome, LCpfCnpj, LPessoa, LAtivo: string;
  lClientes: TArray<TCliente>;
  lJsonArray: TJSONArray;
  lCliente: TCliente;
begin
  lBusinessId := Req.Params['businessId'];

  lNome    := Req.Query['nome'];
  lCpfCnpj := Req.Query['cpf_cnpj'];
  lPessoa  := Req.Query['pessoa'];
  lAtivo   := Req.Query['ativo'];

  lConexao := TControllerConection.New;
  lDAO     := TDAOCliente.New(lConexao);

  lClientes := lDAO.ListarClientes(lBusinessId, LNome, LCpfCnpj, lPessoa, lAtivo);

  try
    lJsonArray := TJSONArray.Create;
    for lCliente in lClientes do
    begin
      lJsonArray.AddElement(TJson.ObjectToJsonObject(lCliente));
    end;

    Res.Status(200).Send(lJsonArray);
  finally
    for lCliente in lClientes do
      lCliente.Free;
  end;
end;

class procedure TLacControllerClientes.GetBuscarCliente(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lDAO : iDAOCliente;
  lConexao : IControllerConnection;
  lBusinessId, lIdCliente: String;
  lCliente : TCliente;
  lJsonObj : TJSONObject;
begin
  lBusinessId := Req.Params['businessId'];
  lIdCliente    := Req.Params['id'];

  lConexao := TControllerConection.New;
  lDAO     := TDAOCliente.New(lConexao);

  lCliente := lDAO.BuscarCliente(lBusinessId, lIdCliente);

  try
    if not Assigned(lCliente) then
    begin
      Res.Status(THTTPStatus.NotFound).Send('{"erro": "Cliente não encontrado"}');
      Exit;
    end;

    LJsonObj := TJson.ObjectToJsonObject(LCliente);

    Res.Send(LJsonObj);
  finally
    if Assigned(lCliente) then lCliente.Free;
  end;
end;

class procedure TLacControllerClientes.PostSalvarCliente(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lDAO: iDAOCliente;
  lCliente: TCliente;
  lConexao: IControllerConnection;
  lJsonObj: TJSONObject;
begin
  lCliente := nil;
  LJsonObj := nil;

  try
    try
      LJsonObj := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;

      if not Assigned(LJsonObj) then
        raise Exception.Create('JSON inválido ou mal formatado.');

      lCliente := TCliente.Create;

      lCliente.BusinessId   := LJsonObj.GetValue<string>('businessId', '');
      lCliente.NomeRazao    := LJsonObj.GetValue<string>('nomeRazao', '');
      lCliente.NomeFantasia := LJsonObj.GetValue<string>('nomeFantasia', '');
      lCliente.CpfCnpj      := LJsonObj.GetValue<string>('cpfCnpj', '');
      lCliente.Ie           := LJsonObj.GetValue<string>('ie', '');
      lCliente.Email        := LJsonObj.GetValue<string>('email', '');
      lCliente.Telefone     := LJsonObj.GetValue<string>('telefone', '');
      lCliente.Logradouro   := LJsonObj.GetValue<string>('logradouro', '');
      lCliente.Numero       := LJsonObj.GetValue<string>('numero', '');
      lCliente.Complemento  := LJsonObj.GetValue<string>('complemento', '');
      lCliente.Bairro       := LJsonObj.GetValue<string>('bairro', '');
      lCliente.CidadeCodigo := LJsonObj.GetValue<Integer>('cidadeCodigo', 0);
      lCliente.CidadeNome   := LJsonObj.GetValue<string>('cidadeNome', '');
      lCliente.Uf           := LJsonObj.GetValue<string>('uf', '');
      lCliente.Cep          := LJsonObj.GetValue<string>('cep', '');

      lConexao := TControllerConection.New;
      lDAO := TDAOCliente.New(lConexao);
      lDAO.SalvarCliente(LCliente);

      LJsonObj.AddPair('Id', LCliente.Id);
      Res.Status(THTTPStatus.Created).Send(LJsonObj);

    except
      on E: Exception do
        Res.Status(THTTPStatus.BadRequest).Send('{"erro": "' + E.Message + '"}');
    end;
  finally
    if Assigned(LCliente) then LCliente.Free;
    if Assigned(lJsonObj) and (Res.RawWebResponse.StatusCode <> 201) then lJsonObj.Free;
  end;

end;

class procedure TLacControllerClientes.PutAtualizarCliente(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lDAO: iDAOCliente;
  lCliente, lClienteExistente: TCliente;
  lConexao: IControllerConnection;
  lJsonObj  : TJSONObject;
begin
  lCliente := nil;
  lJsonObj := nil;

  try
    try
      lJsonObj := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      if not Assigned(lJsonObj) then
        raise Exception.Create('JSON inválido.');

      lCliente := TCliente.Create(Req.Params['id']);

      lCliente.BusinessId   := Req.Params['businessId'];

      lCliente.NomeRazao    := lJsonObj.GetValue<string>('nomeRazao', '');
      lCliente.NomeFantasia := lJsonObj.GetValue<string>('nomeFantasia', '');
      lCliente.Ie           := lJsonObj.GetValue<string>('ie', '');
      lCliente.Email        := lJsonObj.GetValue<string>('email', '');
      lCliente.Telefone     := lJsonObj.GetValue<string>('telefone', '');
      lCliente.Logradouro   := lJsonObj.GetValue<string>('logradouro', '');
      lCliente.Numero       := lJsonObj.GetValue<string>('numero', '');
      lCliente.Complemento  := lJsonObj.GetValue<string>('complemento', '');
      lCliente.Bairro       := lJsonObj.GetValue<string>('bairro', '');
      lCliente.CidadeCodigo := lJsonObj.GetValue<Integer>('cidadeCodigo', 0);
      lCliente.CidadeNome   := lJsonObj.GetValue<string>('cidadeNome', '');
      lCliente.Uf           := lJsonObj.GetValue<string>('uf', '');
      lCliente.Cep          := lJsonObj.GetValue<string>('cep', '');
      lCliente.Ativo        := lJsonObj.GetValue<string>('ativo', 'S');

      lConexao := TControllerConection.New;
      lDAO := TDAOCliente.New(LConexao);


      lClienteExistente := lDAO.BuscarCliente(lCliente.BusinessId,lCliente.Id);

      if not Assigned(lClienteExistente) then
        raise Exception.Create('Cliente não encontrado.');

      lDAO.AtualizarCliente(lCliente);
      Res.Status(THTTPStatus.OK).Send(lJsonObj);
    except
      on E: Exception do
        Res.Status(THTTPStatus.BadRequest).Send('{"erro": "' + E.Message + '"}');
    end;
  finally
    if Assigned(lCliente) then LCliente.Free;
    if Assigned(lJsonObj) and (Res.RawWebResponse.StatusCode <> 200) then lJsonObj.Free;
  end;

end;

end.
