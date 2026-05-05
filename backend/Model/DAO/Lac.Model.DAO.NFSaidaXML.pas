unit Lac.Model.DAO.NFSaidaXML;

interface

uses
  Model.DAO.Interfaces,
  Model.Entity.NotasSaidaXML,
  Lac.Infra.Connection,
  FireDAC.Comp.Client;

type
  TDAONFSaidaXML = class(TInterfacedObject, iDAONFSaidaXML)
  private
    FConexao: IControllerConnection;
  public
    constructor Create(aConexao: IControllerConnection);
    destructor Destroy; override;

    class function New(aConexao: IControllerConnection): iDAONFSaidaXML;

    procedure SalvarNFXML(aNotaId: string; aXmlConteudo: WideString);
  end;

implementation

{ TDAONFSaidaXML }

constructor TDAONFSaidaXML.Create(aConexao: IControllerConnection);
begin
  inherited Create;
  FConexao := aConexao;
end;

destructor TDAONFSaidaXML.Destroy;
begin
  inherited;
end;

class function TDAONFSaidaXML.New(aConexao: IControllerConnection): iDAONFSaidaXML;
begin
  Result := Self.Create(aConexao);
end;

procedure TDAONFSaidaXML.SalvarNFXML(aNotaId: string; aXmlConteudo: WideString);
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConexao.GetConnection;

    LQry.SQL.Text :=
      ' INSERT INTO TB_NOTAS_SAIDA_XML (' +
      '   SAIDA_ID,' +
      '   XML_CONTEUDO' +
      ' ) VALUES (' +
      '   :SAIDA_ID,' +
      '   :XML_CONTEUDO' +
      ' )';

    LQry.ParamByName('SAIDA_ID').AsString       := aNotaId;
    LQry.ParamByName('XML_CONTEUDO').AsWideString := aXmlConteudo;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

end.
