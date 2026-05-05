unit Lac.Model.DAO.NotasSaida;

interface

uses
  Model.DAO.Interfaces, Model.Entity.NFSaida, Lac.Infra.Connection,
  FireDAC.Comp.Client, System.SysUtils, DTO.NFExportacaoXML;

type
  TDAONFeSaida = class(TInterfacedObject, IDAONFSaida)
    private
      FConexao : IControllerConnection;
    public
      constructor Create(aConexao : IControllerConnection);
      destructor Destroy; override;

      class function New(aConexao : IControllerConnection): IDAONFSaida;

      procedure SalvarNFSaida(aNF : TNotasSaida);
      function  BuscarNFSaida(aBusinessId, aNumero, aSerie, aModelo, aCpfCnpj: String) : TNotasSaida;
      function  ListarNFSaida(aBusinessId : String; aNumero: String = '';
                              aSerie :String = ''; aModelo: String = '';
                              aCpfCnpj : String = '') : TArray<TNotasSaida>;
      function BuscarXMLExportacao(aBusinessId: string; aDataIni, aDataFim: TDateTime): TArray<TNFExportacaoDTO>;
  end;

implementation

{ TDAONFeSaida }



constructor TDAONFeSaida.Create(aConexao : IControllerConnection);
begin
      FConexao := aConexao;
end;

destructor TDAONFeSaida.Destroy;
begin

  inherited;
end;


class function TDAONFeSaida.New(aConexao : IControllerConnection): IDAONFSaida;
begin
    Result := Self.Create(aConexao);
end;

function TDAONFeSaida.ListarNFSaida(aBusinessId, aNumero, aSerie, aModelo,
  aCpfCnpj: String): TArray<TNotasSaida>;
var
  lQry: TFDQuery;
  lNotasSaida : TNotasSaida;
begin
   Result := nil;

   lQry := TFDQuery.Create(nil);

   try
     lQry.Connection := FConexao.GetConnection;

     lQry.SQL.Text := ' SELECT * FROM TB_NOTAS_SAIDA' +
                      ' WHERE BUSINESS_ID = :BUSINESS_ID';

     if aNumero <> '' then
       lQry.SQL.Add(' AND NUMERO = :NUMERO');
     if aSerie <> '' then
      lQry.SQL.Add(' AND SERIE = :SERIE');
     if aModelo <> '' then
      lQry.SQL.Add(' AND MODELO = :MODELO');
     if aCpfCnpj <> '' then
      lQry.SQL.Add(' AND CPF_CNPJ = :CPF_CNPJ');

     lQry.ParamByName('BUSINESS_ID').AsString := aBusinessId;

     if lQry.FindParam('NUMERO') <> nil then
        lQry.ParamByName('NUMERO').AsString := aNumero;

     if lQry.FindParam('SERIE') <> nil then
        lQry.ParamByName('SERIE').AsString := aSerie;

     if lQry.FindParam('MODELO') <> nil then
        lQry.ParamByName('MODELO').AsString := aModelo;

     if lQry.FindParam('CPF_CNPJ') <> nil then
        lQry.ParamByName('CPF_CNPJ').AsString := aCpfCnpj;

     lQry.Open;

     while not lQry.Eof do
     begin
       lNotasSaida := TNotasSaida.Create;

       lNotasSaida.Id := lQry.FieldByName('ID').AsString;
       lNotasSaida.BusinessId := lQry.FieldByName('BUSINESS_ID').AsString;
       lNotasSaida.ClienteId := lQry.FieldByName('CLIENTE_ID').AsString;
       lNotasSaida.CpfCnpj := lQry.FieldByName('CPF_CNPJ_CLI').AsString;
       lNotasSaida.Numero := lQry.FieldByName('NUMERO').AsInteger;
       lNotasSaida.Serie := lQry.FieldByName('SERIE').AsInteger;
       lNotasSaida.ChaveAcesso := lQry.FieldByName('CHAVE_ACESSO').AsString;
       lNotasSaida.Protocolo := lQry.FieldByName('PROTOCOLO').AsString;
       lNotasSaida.Cfop := lQry.FieldByName('CFOP').AsString;
       lNotasSaida.DataEmissao := lQry.FieldByName('DATA_EMISSAO').AsDateTime;
       lNotasSaida.ValorTotal := lQry.FieldByName('VALOR_TOTAL').AsFloat;
       lNotasSaida.BaseIcms := lQry.FieldByName('BASE_ICMS').AsFloat;
       lNotasSaida.ValorIcms := lQry.FieldByName('VALOR_ICMS').AsFloat;
       lNotasSaida.BaseSt := lQry.FieldByName('BASE_ST').AsFloat;
       lNotasSaida.ValorSt := lQry.FieldByName('VALOR_ST').AsFloat;
       lNotasSaida.ObsNf := lQry.FieldByName('OBS_NF').AsWideString;

       SetLength(Result, Length(Result) + 1);

       Result[High(Result)] := lNotasSaida;

      lQry.Next;
     end;

   finally
      lQry.Free;
   end;
end;

function TDAONFeSaida.BuscarNFSaida(aBusinessId, aNumero, aSerie, aModelo,
  aCpfCnpj: String): TNotasSaida;
var
  lQry: TFDQuery;
begin
   Result := nil;

   lQry := TFDQuery.Create(nil);

   try
    lQry.Connection := FConexao.GetConnection;

    lQry.SQL.Text := ' SELECT * FROM TB_NOTAS_SAIDA' +
                     ' BUSINESS_ID = :BUSINESS_ID ' +
                     ' NUMERO      = :NUMERO' +
                     ' SERIE       = :SERIE' +
                     ' MODELO      = :MODELO';

    lQry.ParamByName('BUSINESS_ID').AsString :=  aBusinessId;
    lQry.ParamByName('NUMERO').AsString :=  aNumero;
    lQry.ParamByName('SERIE').AsString :=  aSerie;
    lQry.ParamByName('MODELO').AsString :=  aModelo;

    lQry.Open;

    if not lQry.IsEmpty then
    begin
      Result := TNotasSaida.Create;

      Result.Id          := lQry.FieldByName('ID').AsString;
      Result.BusinessId  := lQry.FieldByName('BUSINESS_ID').AsString;
      Result.ClienteId   := lQry.FieldByName('CLIENTE_ID').AsString;
      Result.CpfCnpj     := lQry.FieldByName('CPF_CNPJ_CLI').AsString;
      Result.Numero      := lQry.FieldByName('NUMERO').AsInteger;
      Result.Serie       := lQry.FieldByName('SERIE').AsInteger;
      Result.ChaveAcesso := lQry.FieldByName('CHAVE_ACESSO').AsString;
      Result.Protocolo   := lQry.FieldByName('PROTOCOLO').AsString;
      Result.Cfop        := lQry.FieldByName('CFOP').AsString;
      Result.DataEmissao := lQry.FieldByName('DATA_EMISSAO').AsDateTime;
      Result.ValorTotal  := lQry.FieldByName('VALOR_TOTAL').AsFloat;
      Result.BaseIcms    := lQry.FieldByName('BASE_ICMS').AsFloat;
      Result.ValorIcms   := lQry.FieldByName('VALOR_ICMS').AsFloat;
      Result.BaseSt      := lQry.FieldByName('BASE_ST').AsFloat;
      Result.ValorSt     := lQry.FieldByName('VALOR_ST').AsFloat;
      Result.ObsNf       := lQry.FieldByName('OBS_NF').AsWideString;
    end;

   finally
     lQry.Free;
   end;
end;

procedure TDAONFeSaida.SalvarNFSaida(aNF: TNotasSaida);
var
  lQry: TFDQuery;
begin
  lQry := TFDQuery.Create(nil);

  try
    lQry.Connection := FConexao.GetConnection;

    lQry.SQL.Text := ' INSERT INTO TB_NOTAS_SAIDA (' +
                     '   ID, BUSINESS_ID, CLIENTE_ID, CPF_CNPJ_CLI, NUMERO, SERIE, ' +
                     '   CHAVE_ACESSO, PROTOCOLO, CFOP, DATA_EMISSAO, VALOR_TOTAL, ' +
                     '   BASE_ICMS, VALOR_ICMS, BASE_ST, VALOR_ST, OBS_NF ' +
                     ' ) VALUES (' +
                     '   :ID, :BUSINESS_ID, :CLIENTE_ID, :CPF_CNPJ_CLI, :NUMERO, :SERIE, ' +
                     '   :CHAVE_ACESSO, :PROTOCOLO, :CFOP, :DATA_EMISSAO, :VALOR_TOTAL, ' +
                     '   :BASE_ICMS, :VALOR_ICMS, :BASE_ST, :VALOR_ST, :OBS_NF ' +
                     ' )';

    lQry.ParamByName('ID').AsString           := aNF.Id;
    lQry.ParamByName('BUSINESS_ID').AsString  := aNF.BusinessId;
    lQry.ParamByName('CLIENTE_ID').AsString   := aNF.ClienteId;
    lQry.ParamByName('CPF_CNPJ_CLI').AsString := aNF.CpfCnpj;
    lQry.ParamByName('NUMERO').AsInteger      := aNF.Numero;
    lQry.ParamByName('SERIE').AsInteger       := aNF.Serie;
    lQry.ParamByName('CHAVE_ACESSO').AsString := aNF.ChaveAcesso;
    lQry.ParamByName('PROTOCOLO').AsString    := aNF.Protocolo;
    lQry.ParamByName('CFOP').AsString         := aNF.Cfop;
    lQry.ParamByName('DATA_EMISSAO').AsDateTime := aNF.DataEmissao;
    lQry.ParamByName('VALOR_TOTAL').AsFloat   := aNF.ValorTotal;
    lQry.ParamByName('BASE_ICMS').AsFloat     := aNF.BaseIcms;
    lQry.ParamByName('VALOR_ICMS').AsFloat    := aNF.ValorIcms;
    lQry.ParamByName('BASE_ST').AsFloat       := aNF.BaseSt;
    lQry.ParamByName('VALOR_ST').AsFloat      := aNF.ValorSt;

    lQry.ParamByName('OBS_NF').AsWideString   := aNF.ObsNf;

    lQry.ExecSQL;

  finally
    lQry.Free;
  end;

end;

function TDAONFeSaida.BuscarXMLExportacao(aBusinessId: string; aDataIni,
  aDataFim: TDateTime): TArray<TNFExportacaoDTO>;
var
  lQry: TFDQuery;
  lDTO : TNFExportacaoDTO;
begin
  Result := nil;
  lQry := TFDQuery.Create(nil);

  try
    lQry.Connection := FConexao.GetConnection;

    lQry.SQL.Text := ' SELECT S.CHAVE_ACESSO, S.MODELO, X.XML_CONTEUDO' +
                    ' FROM TB_NOTAS_SAIDA AS S ' +
                    ' INNER JOIN TB_NOTAS_SAIDA_XML X ON S.ID = X.SAIDA_ID' +
                    ' WHERE S.DATA_EMISSAO BETWEEN :DATAINI AND :DATAFIM' +
                    ' AND S.BUSINESS_ID = :BUSINESS_ID';

    lQry.ParamByName('BUSINESS_ID').AsString := aBusinessId;
    lQry.ParamByName('DATAINI').AsDateTime := aDataIni;
    lQry.ParamByName('DATAFIM').AsDateTime := aDataFim;

    lQry.Open;

    while not lQry.Eof do
    begin
      lDTO := TNFExportacaoDTO.Create;

      lDTO.Chave       := lQry.FieldByName('CHAVE_ACESSO').AsString;
      lDTO.Modelo      := lQry.FieldByName('MODELO').AsString;
      lDTO.XmlConteudo := lQry.FieldByName('XML_CONTEUDO').asWideString;

      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := lDTO;

      lQry.Next;
    end;

  finally
    lQry.Free;
  end;

end;

end.
