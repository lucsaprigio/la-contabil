unit Lac.Factory.NFe;

interface

uses
  ACBrNFe, pcnConversao, ACBrDFeSSL, Model.Entity.Empresa, Lac.Model.DAO.Empresa,
  System.NetEncoding, System.SysUtils, Lac.Utils.Configuracao;

type
  ILacFactoryAcbr = interface
  ['{0EE60AAB-138E-45C9-B180-10A73C7E3B94}']
     function ConfigurarACBrNFe(const ABusinessId: String) : TACBrNFe;
  end;

  TLacFactoryAcbr = class(TInterfacedObject, ILacFactoryAcbr)

    public

    class function New : ILacFactoryAcbr;
    function ConfigurarACBrNFe(const ABusinessId: String) : TACBrNFe;
  end;


implementation

uses
  System.IOUtils;

{ TLacFactoryAcbr }

function TLacFactoryAcbr.ConfigurarACBrNFe(const ABusinessId: String): TACBrNFe;
var
  LNFe : TACBrNFe;
  LEmpresa : TEmpresa;
  LCert64    : TBytes;
begin
  LNFe := TACBrNFe.Create(nil);

  LEmpresa :=  TDAOEmpresa.BuscarEmpresaPorID(ABusinessId);

  if not Assigned(LEmpresa) then
    raise Exception.Create('Empresa não encontrada.');

  try
    if Assigned(LEmpresa) then
    begin
      LNFe.Configuracoes.Geral.SSLLib          := libWinCrypt;
      LNFe.Configuracoes.Geral.SSLCryptLib     := cryWinCrypt;
      LNFe.Configuracoes.Geral.SSLHttpLib      := httpWinHttp;
      LNFe.Configuracoes.Geral.SSLXmlSignLib   := xsLibXml2;
      LNFe.Configuracoes.Geral.Salvar          := False;
      LNFe.Configuracoes.Arquivos.PathSchemas  := TPath.Combine(TAppConfig.CaminhoSchemas, 'NFe');

      LCert64                                  := TNetEncoding.Base64.DecodeStringToBytes(LEmpresa.CertBase64);

      LNFe.Configuracoes.Certificados.DadosPFX := TEncoding.ANSI.GetString(LCert64);
      LNFe.Configuracoes.Certificados.Senha    := LEmpresa.CertPassword;

      LNFe.Configuracoes.Certificados.ArquivoPFX := '';
      LNFe.Configuracoes.Certificados.NumeroSerie := '';

      LNFe.Configuracoes.WebServices.UF       := LEmpresa.Uf;
      LNFe.Configuracoes.WebServices.TimeOut  := 15000;

      if LEmpresa.Environment = 0 then
        LNFe.Configuracoes.WebServices.Ambiente := taProducao
      else
        LNFe.Configuracoes.WebServices.Ambiente := taHomologacao;


      Result := LNFe;
    end;
  finally
    LEmpresa.Free;
  end;
end;

class function TLacFactoryAcbr.New: ILacFactoryAcbr;
begin
   Result := Self.Create;
end;

end.
