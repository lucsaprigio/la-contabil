unit Lac.Utils.Certificados;

interface

uses
  System.SysUtils, System.Classes, System.NetEncoding, ACBrNFe, ACBrDFeSSL;

type
  TLacUtilsCertificado = class
  public
    // Configurando o certificado e Retornando o Vencimento
    class function ValidarCertificado(const aBase64, aSenha: String): TDateTime;
  end;

implementation

{ TLacUtilsCertificado }

class function TLacUtilsCertificado.ValidarCertificado(const aBase64,
  aSenha: String): TDateTime;
var
  LStream: TStringStream;
  LBytes: TBytes;
  LDadosAnsi: AnsiString;
  LAcbrNfFe: TACBrNFe;
begin
  LAcbrNfFe := TACBrNFe.Create(nil);
  try
    // Convertendo a String do Front para Bytes
    LBytes := TNetEncoding.Base64.DecodeStringToBytes(aBase64);

    // ACBr ainda pega o certificado Via AnsiString, então vou converter para Ansi.
    SetString(LDadosAnsi, PAnsiChar(LBytes), Length(LBytes));

    LAcbrNfFe.Configuracoes.Geral.SSLLib := libOpenSSL;
    LAcbrNfFe.Configuracoes.Certificados.Senha := aSenha;

    LAcbrNfFe.Configuracoes.Certificados.DadosPFX := LDadosAnsi;

    try
      LAcbrNfFe.SSL.CarregarCertificado;

      Result := LAcbrNfFe.SSL.CertDataVenc;
    except
      on E: Exception do
      begin
        raise Exception.Create('Falha ao ler o certificado. Verifique a senha' +
          E.Message);
      end;
    end;
  finally
    LAcbrNfFe.Free;
  end;
end;

end.
