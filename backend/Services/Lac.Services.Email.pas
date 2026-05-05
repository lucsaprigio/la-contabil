unit Lac.Services.Email;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Zip,
  IdSMTP,
  IdMessage,
  IdText,
  IdAttachmentMemory,
  IdSSLOpenSSL,
  Lac.Model.DAO.NotasSaida,
  Model.DAO.Interfaces,
  DTO.NFExportacaoXML,
  Lac.Utils,
  IdExplicitTLSClientServerBase, System.NetEncoding;

type

  iServiceEmail = interface
    ['{A3F82C1D-5B74-4E91-B3F0-8D9E6C2A1F47}']
    function EnviarXMLPorEmail(const aBusinessId: string;
      aDataInicio, aDataFim: TDateTime;
      const aDestinatario, aAssunto, aAnexo, aCorpo: string): Boolean;
  end;

  TServiceEmail = class(TInterfacedObject, iServiceEmail)
  private
    FSMTPHost  : string;
    FSMTPPort  : Integer;
    FUsuario   : string;
    FSenha     : string;
    FRemetente : string;
    FSSL       : Boolean;

    constructor Create(const aSMTPHost: string; aSMTPPort: Integer;
      const aUsuario, aSenha, aRemetente: string; aSSL: Boolean = True);

  public
    class function New(const aSMTPHost: string; aSMTPPort: Integer;
      const aUsuario, aSenha, aRemetente: string; aSSL: Boolean = True): iServiceEmail;

    class function NewGmail(const aUsuario, aSenha: string): iServiceEmail;

    function EnviarXMLPorEmail(const aBusinessId: string;
      aDataInicio, aDataFim: TDateTime;
      const aDestinatario, aAssunto, aAnexo, aCorpo: string): Boolean;
  end;

implementation

uses
  Lac.Infra.Connection, Lac.Services.ExportacaoXML;

{ TServiceEmail }

constructor TServiceEmail.Create(const aSMTPHost: string; aSMTPPort: Integer;
  const aUsuario, aSenha, aRemetente: string; aSSL: Boolean);
begin
  inherited Create;
  FSMTPHost  := aSMTPHost;
  FSMTPPort  := aSMTPPort;
  FUsuario   := aUsuario;
  FSenha     := aSenha;
  FRemetente := aRemetente;
  FSSL       := aSSL;
end;

class function TServiceEmail.New(const aSMTPHost: string; aSMTPPort: Integer;
  const aUsuario, aSenha, aRemetente: string; aSSL: Boolean): iServiceEmail;
begin
  Result := Self.Create(aSMTPHost, aSMTPPort, aUsuario, aSenha, aRemetente, aSSL);
end;

class function TServiceEmail.NewGmail(const aUsuario, aSenha: string): iServiceEmail;
begin
  // Gmail: SMTP smtp.gmail.com, porta 587 (STARTTLS)
  // Requer senha de app: https://myaccount.google.com/apppasswords
  Result := Self.Create('smtp.gmail.com', 587, aUsuario, aSenha, aUsuario, True);
end;

function TServiceEmail.EnviarXMLPorEmail(const aBusinessId: string;
  aDataInicio, aDataFim: TDateTime;
  const aDestinatario, aAssunto, aAnexo, aCorpo: string): Boolean;
var
  lSMTP       : TIdSMTP;
  lSSLHandler : TIdSSLIOHandlerSocketOpenSSL;
  lMensagem   : TIdMessage;
  lAnexo      : TIdAttachmentMemory;
  lZipStream  : TBytesStream;
  lBytes      : TBytes;
  lNomeAnexo  : string;
begin
  Result := False;

  lBytes := TNetEncoding.Base64.DecodeStringToBytes(aAnexo);
  lZipStream := TBytesStream.Create(lBytes);

  lNomeAnexo := Format('XMLs_%s_%s_%s.zip', [
    aBusinessId,
    FormatDateTime('yyyymmdd', aDataInicio),
    FormatDateTime('yyyymmdd', aDataFim)
  ]);

  lSMTP       := TIdSMTP.Create(nil);
  lSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  lMensagem   := TIdMessage.Create(nil);
  try
    // Configuracao SSL/TLS para Gmail (STARTTLS na porta 587)
    lSSLHandler.SSLOptions.Method  := sslvTLSv1_2;
    lSSLHandler.SSLOptions.Mode    := sslmClient;

    lSMTP.IOHandler        := lSSLHandler;
    lSMTP.UseTLS           := utUseRequireTLS;
    lSMTP.Host             := FSMTPHost;
    lSMTP.Port             := FSMTPPort;
    lSMTP.Username         := FUsuario;
    lSMTP.Password         := FSenha;
    lSMTP.AuthType         := satDefault;

    // Monta a mensagem
    lMensagem.From.Address := FRemetente;
    lMensagem.Recipients.EMailAddresses := aDestinatario;
    lMensagem.Subject      := aAssunto;
    lMensagem.ContentType  := 'multipart/mixed';

    // Corpo do e-mail
    with TIdText.Create(lMensagem.MessageParts, nil) do
    begin
      ContentType := 'text/plain; charset=UTF-8';
      Body.Text   := aCorpo;
    end;

    // Anexo ZIP em memoria em Base64 que foi feito lá em cima
    lAnexo := TIdAttachmentMemory.Create(lMensagem.MessageParts, lZipStream);
    lAnexo.FileName    := lNomeAnexo;
    lAnexo.ContentType := 'application/zip';

    // Envia
    lSMTP.Connect;
    try
      lSMTP.Send(lMensagem);
      Result := True;
      TLacUtils.GeraLog(Format('EnviarXMLPorEmail: e-mail enviado com sucesso para %s.', [aDestinatario]));
    finally
      lSMTP.Disconnect;
    end;

  except
    on E: Exception do
    begin
      TLacUtils.GeraLog(Format('EnviarXMLPorEmail: erro ao enviar e-mail - %s', [E.Message]));
      raise;
    end;
  end;

  lMensagem.Free;
  lSSLHandler.Free;
  lSMTP.Free;
  lZipStream.Free;
end;

end.
