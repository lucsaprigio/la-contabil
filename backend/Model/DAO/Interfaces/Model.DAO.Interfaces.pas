unit Model.DAO.Interfaces;

interface

uses
  Model.Entity.NotasDestinadas,  Model.Entity.NotasDestinadasXML, Model.Entity.NFSaida, Model.Entity.Cliente, Model.Entity.NotasSaidaXML, DTO.NFExportacaoXML;

type
  IDAONotasDestinadas = interface
    ['{B08F3F7E-C233-41BE-8BCC-93AE65DD1030}']
    procedure SalvarNotasDestinadas(ANotaDestinada: TNotasDestinadas);
    procedure AtualizarStatus(AId: String; ANovoStatus: Integer);
  end;

  IDAONotasDestinadasXML = interface
    ['{C2BD9D54-E1B5-4C47-8460-42C8D458554B}']
    procedure SalvarXML(aNotaDestinadaXML : TNotasDestinadasXML);
  end;

  IDAONFSaida = interface
    ['{60A1512F-D596-41C6-8482-CAAE8A915676}']
    procedure SalvarNFSaida(aNF : TNotasSaida);
    function  BuscarNFSaida(aBusinessId, aNumero, aSerie, aModelo, aCpfCnpj: String) : TNotasSaida;
    function ListarNFSaida(aBusinessId : String; aNumero: String = '';
                            aSerie :String = ''; aModelo: String = '';
                            aCpfCnpj : String = '') : TArray<TNotasSaida>;
    function BuscarXMLExportacao(aBusinessId: string; aDataIni, aDataFim: TDateTime): TArray<TNFExportacaoDTO>;
  end;

  iDAOCliente = interface
    ['{6CF564FB-1FA3-4FF9-9D38-31316F380AD8}']
    procedure SalvarCliente(aCliente : TCliente);
    procedure AtualizarCliente(aCliente: TCliente);
    function BuscarCliente(aBusinessId: String; aIdCliente: String = ''; aCpfCnpj: String = ''): TCliente;
    function ListarClientes(aBusinessId: String; aNome: String = ''; aCpfCnpj: String = ''; aPessoa: String = ''; aAtivo: String = ''): TArray<TCliente>;
  end;

  iDAONFSaidaXML = interface
    ['{425B5FB9-2D30-4CB7-85B6-419CD7145479}']
     procedure SalvarNFXML(aNotaId: string; aXmlConteudo : WideString);
  end;

implementation

end.
