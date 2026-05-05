unit DTO.NFExportacaoXML;

interface

type
  TNFExportacaoDTO = class
  private
    FXmlConteudo: WideString;
    FModelo: String;
    FChave: String;
  published

  property Chave : String read FChave write FChave;
  property Modelo : String read FModelo write FModelo;
  property XmlConteudo : WideString read FXmlConteudo write FXmlConteudo;
  end;

implementation

{ TNFExportacaoDTO }
end.
