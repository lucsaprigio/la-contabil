unit Lac.Services.ExportacaoXML;

interface

uses
   System.SysUtils,
   System.IOUtils,
   System.Classes,
   System.Zip,
   System.NetEncoding,
   Lac.Model.DAO.NotasSaida,
   Model.DAO.Interfaces,
   DTO.NFExportacaoXML, Lac.Utils;

type

  iServiceExportacaoXML = interface
     ['{DC5F13F3-09ED-4CE4-B08C-0156D68A8E71}']
     function GerarLoteXML(aBusinessId: string; aDataInicio, aDataFim: TDateTime): string;
  end;

  TServiceExportacao = class(TInterfacedObject, iServiceExportacaoXML)
    private
      function ObterPastaModelo(aModelo: string): string;
      constructor Create;
   public
      class function New: iServiceExportacaoXML;

      function GerarLoteXML(aBusinessId: string; aDataInicio, aDataFim: TDateTime): string;
  end;

implementation

uses
  Lac.Infra.Connection;

{ TServiceExportacao }

constructor TServiceExportacao.Create;
begin
   inherited Create;
end;

class function TServiceExportacao.New: iServiceExportacaoXML;
begin
  Result := Self.Create;
end;

function TServiceExportacao.GerarLoteXML(aBusinessId: string; aDataInicio,
  aDataFim: TDateTime): string;
var
  lConexao : IControllerConnection;
  lDAONFSaida : IDAONFSaida;
  lDTOs: TArray<TNFExportacaoDTO>;
  lDTO : TNFExportacaoDTO;
  lZip               : TZipFile;
  lZipStream         : TMemoryStream;
  lXmlStream         : TStringStream;
  lStringStreamBase64: TStringStream;
  lNomeArquivoVirtual: string;
  lTotalArquivos     : Integer;
begin
  Result := '';
  lTotalArquivos := 0;

  LConexao := TControllerConection.New;
  LConexao.Connect;

  LDAONFSaida := TDAONFeSaida.New(LConexao);
  lDTOs := LDAONFSaida.BuscarXMLExportacao(aBusinessId, aDataInicio, aDataFim);

  if Length(lDTOs) = 0 then
  begin
    TLacUtils.GeraLog(Format('GerarLoteXML: nenhum XML encontrado para business %s no período informado.', [aBusinessId]));
    Exit;
  end;

  lZipStream := TMemoryStream.Create;
  try
    lZip := TZipFile.Create;
    try
      lZip.Open(lZipStream, zmWrite);

      for lDTO in lDTOs do
      begin
        if lDTO.Chave.Trim.IsEmpty then
          Continue;

        lNomeArquivoVirtual := ObterPastaModelo(lDTO.Modelo) + lDTO.Chave.Trim + '.xml';

        lXmlStream := TStringStream.Create(lDTO.XmlConteudo, TEncoding.UTF8);
        try
          // Salvar o XML Dentro da Pasta específica do modelo
          lZip.Add(lXmlStream, lNomeArquivoVirtual);
          Inc(lTotalArquivos);
        finally
          lXmlStream.Free;
        end;
      end;

      lZip.Close;

      if lTotalArquivos > 0 then
      begin
        // Lembrar de voltar a posição do stream por segurança
        lZipStream.Position := 0;

        lStringStreamBase64 := TStringStream.Create('');
        try
          TNetEncoding.Base64.Encode(lZipStream, lStringStreamBase64);
          Result := lStringStreamBase64.DataString; // Retornando o Base64
        finally
          lStringStreamBase64.Free;
        end;

        TLacUtils.GeraLog(Format('GerarLoteXML: %d arquivo(s) zipados em memória para business %s.', [lTotalArquivos, aBusinessId]));
      end
      else
        TLacUtils.GeraLog('GerarLoteXML: Nenhum arquivo válido processado.');

    finally
      LZip.Free;
    end;
  finally
    lZipStream.Free;

    for lDTO in lDTOs do
    begin
      if Assigned(lDTO) then
        lDTO.Free;
    end;
  end;

end;

function TServiceExportacao.ObterPastaModelo(aModelo: string): string;
begin
     if aModelo = '55' then
      Result := 'NFe/'
     else if aModelo = '65' then
      Result := 'NFCe/'
     else
      Result := 'Outros/';
end;

end.
