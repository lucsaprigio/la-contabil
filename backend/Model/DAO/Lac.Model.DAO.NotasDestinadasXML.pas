unit Lac.Model.DAO.NotasDestinadasXML;

interface

uses
  Model.DAO.Interfaces, Lac.Infra.Connection, FireDAC.Comp.Client,
  Model.Entity.NotasDestinadasXML;

type
  TDAONotasDestinadasXML = class(TInterfacedObject, IDAONotasDestinadasXML)
  private
   FConexao : IControllerConnection;
  public
   constructor Create(aConexao : IControllerConnection);
   destructor Destroy; override;

   class function New(aConexao : IControllerConnection): IDAONotasDestinadasXML;

   procedure SalvarXML(aNotaDestinadaXML : TNotasDestinadasXML);
  end;

implementation


{ TDAONotasDestinadasXML }

constructor TDAONotasDestinadasXML.Create(aConexao: IControllerConnection);
begin
    FConexao := aConexao;
end;

destructor TDAONotasDestinadasXML.Destroy;
begin

  inherited;
end;

class function TDAONotasDestinadasXML.New(
  aConexao: IControllerConnection): IDAONotasDestinadasXML;
begin
    Result := Self.Create(aConexao);
end;

procedure TDAONotasDestinadasXML.SalvarXML(
  aNotaDestinadaXML: TNotasDestinadasXML);
var
  lQry: TFDQuery;
begin
  lQry := TFDQuery.Create(nil);

  try
    LQry.Connection := FConexao.getConnection;
    lQry.SQl.Text := ' INSERT INTO TB_NOTAS_DESTINADAS_XML (' +
                     ' DESTINADA_ID, XML_CONTEUDO )' +
                     ' VALUES (' +
                     ' :DESTINADA_ID, :XML_CONTEUDO )';

   if lQry.FindParam('DESTINADA_ID') <> nil then
      lQry.ParamByName('DESTINADA_ID').AsString := aNotaDestinadaXML.DestinadaID;

   if lQry.FindParam('XML_CONTEUDO') <> nil then
      lQry.ParamByName('XML_CONTEUDO').AsWideString := aNotaDestinadaXML.XMLConteudo;

   lQry.ExecSQL;

  finally
   lQry.Free;
  end;
end;

end.
