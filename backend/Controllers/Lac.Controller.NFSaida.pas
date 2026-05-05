unit Lac.Controller.NFSaida;

interface

uses
  Horse, System.JSON, Model.Entity.NFSaida, Lac.Model.DAO.NotasSaida,
  Lac.Infra.Connection, Model.DAO.Interfaces, Lac.Utils, REST.Json,
  System.SysUtils, System.DateUtils;

type
  TLacControllerNFSaida = class
    class procedure PostSalvarNFSaida(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetBuscarNFSaida(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetListarNFSaida(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TLacControllerNFSaida }

class procedure TLacControllerNFSaida.GetListarNFSaida(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lDAONFeSaida : IDAONFSaida;
  lConexao : IControllerConnection;
  lBusinessId, lNumero, lSerie, lModelo, lCpfCnpj :String;
  lNotas : TArray<TNotasSaida>;
  lJsonArray : TJSONArray;
  lNota : TNotasSaida;
begin
   lBusinessId := Req.Params.Field('businessId').AsString;

   lNumero      := Req.Query['numero'];
   lSerie       := Req.Query['serie'];
   lModelo      := Req.Query['modelo'];
   lCpfCnpj     := Req.Query['cpfcnpj'];

   if (not TLacUtils.IsValidID(lBusinessId)) then begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (GUID).');
    Exit;
  end;

  lConexao    := TControllerConection.New;
  lDAONFeSaida := TDAONFeSaida.New(lConexao);

  lNotas := lDAONFeSaida.ListarNFSaida(lBusinessId, lNumero, lSerie, lModelo, lCpfCnpj);

  try
   lJsonArray :=  TJSONArray.Create;

   // Loop para adicionar cada nota dentro do Array
   for lNota in lNotas do
   begin
      lJsonArray.AddElement(TJson.ObjectToJsonObject(lNota));
   end;

   Res.Send(lJsonArray);
  finally
   for lNota in lNotas do
      LNota.Free;
  end;
end;

class procedure TLacControllerNFSaida.PostSalvarNFSaida(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lDAONFeSaida : IDAONFSaida;
  lNota : TNotasSaida;
  lConexao : IControllerConnection;
  lJsonObj : TJSONObject;
begin
  lNota := nil;
  LJsonObj := nil;

  try
    try
      LJsonObj := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;

      if not Assigned(LJsonObj) then
        raise Exception.Create('JSON inválido ou mal formatado.');


      lNota := TNotasSaida.Create;

      lNota.BusinessId  := LJsonObj.GetValue<string>('businessId', '');
      lNota.ClienteId   := LJsonObj.GetValue<string>('clienteId', '');
      lNota.CpfCnpj     := LJsonObj.GetValue<string>('cpfCnpj', ''); // Isso vai acionar o seu Setter de validação!
      lNota.Numero      := LJsonObj.GetValue<Integer>('numero', 0);
      lNota.Serie       := LJsonObj.GetValue<Integer>('serie', 0);
      lNota.ChaveAcesso := LJsonObj.GetValue<string>('chaveAcesso', '');
      lNota.Protocolo   := LJsonObj.GetValue<string>('protocolo', '');
      lNota.Cfop        := LJsonObj.GetValue<string>('cfop', '');

      if LJsonObj.GetValue<string>('dataEmissao', '') <> '' then
        lNota.DataEmissao := ISO8601ToDate(LJsonObj.GetValue<string>('dataEmissao'));

      lNota.ValorTotal  := LJsonObj.GetValue<Double>('valorTotal', 0);
      lNota.BaseIcms    := LJsonObj.GetValue<Double>('baseIcms', 0);
      lNota.ValorIcms   := LJsonObj.GetValue<Double>('valorIcms', 0);
      lNota.BaseSt      := LJsonObj.GetValue<Double>('baseSt', 0);
      lNota.ValorSt     := LJsonObj.GetValue<Double>('valorSt', 0);
      lNota.ObsNf       := LJsonObj.GetValue<string>('obsNf', '');

      lConexao     := TControllerConection.New;
      lDAONFeSaida := TDAONFeSaida.New(lConexao);
      lDAONFeSaida.SalvarNFSaida(lNota);

      LJsonObj.AddPair('id', lNota.Id);
      Res.Status(THTTPStatus.Created).Send(LJsonObj);

    except
      on E: Exception do
        Res.Status(THTTPStatus.BadRequest).Send('{"erro": "' + E.Message + '"}');
    end;

  finally
    if Assigned(lNota) then lNota.Free;

    if Assigned(LJsonObj) and (Res.RawWebResponse.StatusCode <> 201) then
      LJsonObj.Free;
  end;
end;

class procedure TLacControllerNFSaida.GetBuscarNFSaida(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lDAONFeSaida : IDAONFSaida;
  lNota : TNotasSaida;
  lConexao : IControllerConnection;
  lBusinessId, lNumero, lSerie, lModelo, lCpfCnpj: String;
begin
  try
   lBusinessId := Req.Params.Field('businessId').AsString;

   lNumero      := Req.Query['numero'];
   lSerie       := Req.Query['serie'];
   lModelo      := Req.Query['modelo'];
   lCpfCnpj     := Req.Query['cpfcnpj'];

   lConexao     := TControllerConection.New;
   lDAONFeSaida := TDAONFeSaida.New(lConexao);

   lNota := lDAONFeSaida.BuscarNFSaida(lBusinessId, lNumero, lSerie, lModelo, lCpfCnpj);

   Res.Status(200).Send<TNotasSaida>(lNota);
  except on E: Exception do
     Res.Status(THTTPStatus.BadRequest).Send('{"erro": "' + E.Message + '"}');
  end;
end;
end.
