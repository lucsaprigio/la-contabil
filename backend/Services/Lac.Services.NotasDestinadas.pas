unit Lac.Services.NotasDestinadas;

interface

uses
  Winapi.Windows, ACBrNFe, pcnRetDistDFeInt, System.SysUtils, Lac.Factory.NFe, ACBrDFe.Conversao,
  Lac.Infra.Connection, Model.Entity.NotasDestinadas,
  Lac.Model.DAO.NotasDestinadas, Lac.Model.DAO.NotasDestinadasXML, Model.Entity.NotasDestinadasXML;

type
  TServiceNotasDestinadas = class
  public
    procedure SincronizarSefaz(const aBusinessId: string; aCnpj: string; aUltNSU : String = '');
  end;

implementation

uses
  Lac.Model.DAO.Empresa, Model.DAO.Interfaces;

{ TServiceNotasDestinadas }

procedure TServiceNotasDestinadas.SincronizarSefaz(const aBusinessId: string; aCnpj: string; aUltNSU: string);
var
  LNFe: TACBrNFe;
  LUltimoNSU, lMaxNSURetorno, lUltNSURetorno: string;
  LItemSefaz: TdocZipCollectionItem;
  I: Integer;
  LConexao: IControllerConnection;
  LDAONotasDestinadas: IDAONotasDestinadas;
  LDAONotasDestinadasXML : IDAONotasDestinadasXML;
  LDAOEmpresa : TDAOEmpresa;

  LNotasDestinadasXML : TNotasDestinadasXML;
  LNotasDestinadas: TNotasDestinadas;
begin

  LNFe := TLacFactoryAcbr.New.ConfigurarACBrNFe(aBusinessId);

  if not Assigned(LNFe) then
    Exit;

  LConexao := TControllerConection.New;
  LConexao.Connect;

  LDAONotasDestinadas    := TDAOLacNotasDestinadas.New(LConexao);
  LDAONotasDestinadasXML := TDAONotasDestinadasXML.New(LConexao);

  if aUltNSU <> '' then
    LUltimoNSU := aUltNSU;

  LDAOEmpresa            := TDAOEmpresa.Create;

  try
   repeat

    LNFe.DistribuicaoDFePorUltNSU(LNFe.Configuracoes.WebServices.UFCodigo, aCnpj, LUltimoNSU);

    {$IFDEF DEBUG}
      OutputDebugString(PChar('Status: ' + IntToStr(LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.cStat)));
      OutputDebugString(PChar('Motivo: ' + LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.xMotivo));
    {$ENDIF}

    lUltNSURetorno := LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.ultNSU;
    lMaxNSURetorno := LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.maxNSU;

    if Trim(lUltNSURetorno) <> '' then
        LUltimoNSU := lUltNSURetorno;

      if LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.cStat = 138 then
      begin
        for I := 0 to LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count - 1 do
        begin

          LItemSefaz := TdocZipCollectionItem(LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[I]);

          LNotasDestinadas       := TNotasDestinadas.Create;

          try
            if LItemSefaz.schema = schresNFe then
            begin
              // É apenas um RESUMO da nota (A nota existe, mas você ainda não tem os produtos)
              LNotasDestinadas.ChaveAcesso := LItemSefaz.resDFe.chDFe;
              LNotasDestinadas.CnpjEmit := LItemSefaz.resDFe.CNPJCPF;
              LNotasDestinadas.NomeEmit := LItemSefaz.resDFe.xNome;
              LNotasDestinadas.DtEmi := LItemSefaz.resDFe.dhEmi;
              LNotasDestinadas.VrTot := LItemSefaz.resDFe.vNF;
              LNotasDestinadas.SitSefaz := StrToIntDef(SituacaoDFeToStr(LItemSefaz.resDFe.cSitDFe), 0);
              LNotasDestinadas.Nsu      := LItemSefaz.NSU;

              // No Model, coloquei para receber as informações direto na hora de instanciar, pois ele precisa de um ID invés de criar automático.
              LNotasDestinadasXML := TNotasDestinadasXML.Create(LNotasDestinadas.Id, LItemSefaz.XML);
              try
                LDAONotasDestinadas.SalvarNotasDestinadas(LNotasDestinadas);
                LDAONotasDestinadasXML.SalvarXML(LNotasDestinadasXML);
              finally
                LNotasDestinadasXML.Free;
              end;

            end;
            {
            else if LItemSefaz.schema = schprocNFe then
            begin
              // É o XML COMPLETO da nota (O fornecedor emitiu e você já pode dar entrada)
              // TLacDAONotasDestinadas.SalvarXMLCompleto(ABusinessId, LItemSefaz.NSU, LItemSefaz.XML);
            end
            else if LItemSefaz.schema = schresEvento then
            begin
              // É um EVENTO (Ex: Carta de Correção, Cancelamento da nota pelo fornecedor)
              // TLacDAONotasDestinadas.AtualizarStatusNota(LItemSefaz.NSU, LItemSefaz.XML);
            end
            else if LItemSefaz.schema = schprocEventoNFe then
                // Xml Completo de um Evento
            }
          finally
             LNotasDestinadas.Free;
          end;
        end;

      end;
       until (StrToIntDef(lUltNSURetorno, 0) >= (StrToIntDef(lMaxNSURetorno, 0 )))
             or (LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.CStat <> 138);

       LDAOEmpresa.AtualizarUltimoNSU(aBusinessId, LUltimoNSU, aCnpj );
  finally
    LNFe.Free;
  end;
end;

end.

