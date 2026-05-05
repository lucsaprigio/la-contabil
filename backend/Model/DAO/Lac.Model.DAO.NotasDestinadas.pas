unit Lac.Model.DAO.NotasDestinadas;

interface

uses Model.Entity.NotasDestinadas, System.JSON, FIREDAC.Comp.Client, System.SysUtils,
  Lac.Infra.Connection, Data.DB, Model.DAO.Interfaces;

type
  TDAOLacNotasDestinadas = class(TInterfacedObject, IDAONotasDestinadas)
  private
    FConexao : IControllerConnection;
  public
    constructor Create(AConexao : IControllerConnection);
    class function New(AConexao : IControllerConnection) : IDAONotasDestinadas;

    procedure SalvarNotasDestinadas(ANotaDestinada: TNotasDestinadas);
    procedure AtualizarStatus(AId: String; ANovoStatus: Integer);
  end;

implementation

{ TDAOLacNotasDestinadas }

procedure TDAOLacNotasDestinadas.AtualizarStatus(AId: String;
  ANovoStatus: Integer);
begin
    // Implementar
end;

constructor TDAOLacNotasDestinadas.Create(AConexao: IControllerConnection);
begin
    FConexao := AConexao;
end;

class function TDAOLacNotasDestinadas.New(
  AConexao: IControllerConnection): IDAONotasDestinadas;
begin
  Result := Self.Create(AConexao);
end;

procedure TDAOLacNotasDestinadas.SalvarNotasDestinadas(ANotaDestinada: TNotasDestinadas);
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
   LQry.Connection := FConexao.getConnection;

   LQry.SQL.Text :=
          ' INSERT INTO TB_NOTAS_DESTINADAS('+
          ' ID, BUSINESS_ID, CHAVE_ACESSO, NSU, CNPJ_EMITENTE, NOME_EMITENTE, DATA_EMISSAO, VALOR_TOTAL' +
          ' SITUACAO_SEFAZ, STATUS_MANIFESTACAO, PROCESSADA_ENTRADA)' +
          ' VALUES (' +
          ' :ID, :BUSINESS_ID, :CHAVE_ACESSO, :NSU, :CNPJ_EMITENTE, :NOME_EMITENTE, :DATA_EMISSAO, :VALOR_TOTAL' +
          ' :SITUACAO_SEFAZ, :STATUS_MANIFESTACAO, :PROCESSADA_ENTRADA)' ;

   LQry.ParamByName('ID').AsString := ANotaDestinada.Id;
   LQry.ParamByName('BUSINESS_ID').AsString := ANotaDestinada.BusinessId;
   LQry.ParamByName('CHAVE_ACESSO').AsString := ANotaDestinada.ChaveAcesso;
   LQry.ParamByName('NSU').AsString := ANotaDestinada.Nsu;
   LQry.ParamByName('CNPJ_EMITENTE').AsString := ANotaDestinada.CnpjEmit;
   LQry.ParamByName('NOME_EMITENTE').AsString := ANotaDestinada.NomeEmit;
   LQry.ParamByName('DATA_EMISSAO').AsDateTime := ANotaDestinada.DtEmi;
   LQry.ParamByName('VALOR_TOTAL').AsFloat := ANotaDestinada.VrTot;
   LQry.ParamByName('SITUACAO_SEFAZ').AsInteger := ANotaDestinada.SitSefaz;
   LQry.ParamByName('STATUS_MANIFESTACAO').AsInteger:= ANotaDestinada.Status;
   LQry.ParamByName('PROCESSADA_ENTRADA').AsInteger := ANotaDestinada.ProcessEntrada;

  finally
   LQry.Free;
  end;
end;

end.
