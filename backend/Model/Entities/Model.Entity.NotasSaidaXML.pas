unit Model.Entity.NotasSaidaXML;

interface

type
  TNotasSaidaXML = class
  private
    FSaidaId : String;
    FXmlConteudo : WideString;

    function GetSaidaId: string;
    function GetXmlConteudo: WideString;
    procedure SetSaidaId(const Value: string);
    procedure SetXmlConteudo(const Value: WideString);

  public
    property SaidaId : string read GetSaidaId write SetSaidaId;
    property XmlConteudo : WideString read GetXmlConteudo write  SetXmlConteudo;
  end;

implementation

{ TNotasSaidaXML }

function TNotasSaidaXML.GetSaidaId: string;
begin
     Result := FSaidaId;
end;

function TNotasSaidaXML.GetXmlConteudo: WideString;
begin
     Result := FXmlConteudo;
end;

procedure TNotasSaidaXML.SetSaidaId(const Value: string);
begin
    FSaidaId := Value;
end;

procedure TNotasSaidaXML.SetXmlConteudo(const Value: WideString);
begin
    FXmlConteudo := Value;
end;

end.
