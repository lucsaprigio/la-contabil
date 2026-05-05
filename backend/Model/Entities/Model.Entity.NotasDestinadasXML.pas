unit Model.Entity.NotasDestinadasXML;

interface

type
  TNotasDestinadasXML = class
  private

  FDestinadaID : string;
  FXMLConteudo : string;

  function GetDestinadaID: string;
  procedure SetDestinadaID(const Value: string);

  function GetXMLConteudo: String;
  procedure SetXMLConteudo(const Value: String);

  public
    constructor Create(const aDestinadaID: string = ''; const aXmlConteudo: string = '');

    property DestinadaID: string read GetDestinadaID write SetDestinadaID;
    property XMLConteudo: String read GetXMLConteudo write SetXMLConteudo;
  end;

implementation

{ TNotasDestinadasXML }

constructor TNotasDestinadasXML.Create(const aDestinadaID: string = ''; const aXmlConteudo: string = '');
begin
   FDestinadaId := aDestinadaID;
   FXMLConteudo := aXmlConteudo;
end;

function TNotasDestinadasXML.GetDestinadaID: string;
begin
   Result := FXMLConteudo;
end;

function TNotasDestinadasXML.GetXMLConteudo: String;
begin
    Result := FXMLConteudo;
end;

procedure TNotasDestinadasXML.SetDestinadaID(const Value: string);
begin
    FDestinadaID := Value;
end;

procedure TNotasDestinadasXML.SetXMLConteudo(const Value: String);
begin
   FXMLConteudo := Value;
end;

end.
