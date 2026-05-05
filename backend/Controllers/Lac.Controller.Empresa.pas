unit Lac.Controller.Empresa;

interface

uses
  Horse, System.JSON, Model.Entity.Empresa, Lac.Model.DAO.Empresa,
  System.SysUtils, System.DateUtils, Lac.Utils, REST.JSON, Lac.Utils.Certificados,
  Lac.Services.NotasDestinadas, Lac.Services.ExportacaoXML, Lac.Services.Email;

type
  TControllerEmpresa = class
    class procedure GetBusinessByCnpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PostNewBusiness(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PutAtualizaCertificado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PutAtualizarEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure DeleteExcluirEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetNotasDestinadas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PostEnviarEmailXML(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

uses
  Lac.Utils.Configuracao;

{ TControllerEmpresa }

class procedure TControllerEmpresa.DeleteExcluirEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LEmpresa: TEmpresa;
  LID: String;
begin
  LID := Req.Params.Field('id').AsString;

  if not TLacUtils.IsValidID(LID) then
  begin
    Res.Status(400).Send('O ID informado na URL n�o � um formato v�lido (GUID).');
    Exit;
  end;

  LEmpresa := TDAOEmpresa.BuscarEmpresaPorid(LID);

  try
    if Assigned(LEmpresa) then
    begin
      TDAOEmpresa.ExcluirEmpresa(LID);
      Res.Status(200).Send('Empresa exclu�da com sucesso')
    end
    else
    begin
      Res.Status(404).Send('Empresa n�o encontrada.')
    end;
  finally
    LEmpresa.Free;
  end;
end;

class procedure TControllerEmpresa.GetBusinessByCnpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LCnpj: String;
  LEmpresa: TEmpresa;
begin
  LCnpj := Req.Params.Field('id').AsString;

  LEmpresa := TDAOEmpresa.BuscarEmpresaPorCnpj(LCnpj);

  if Assigned(LEmpresa) then
    Res.Send<TJSONObject>(TJson.ObjectToJsonObject(LEmpresa))
  else
    Res.Status(400).Send('Empresa n�o encontrada.')
end;

class procedure TControllerEmpresa.PostNewBusiness(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LBusiness: TEmpresa;
begin
  LBody := Req.Body<TJSONObject>;

  if not Assigned(LBody) then
  begin
    Res.Status(400).Send('Corpo da Requisi��o Inv�lido');
    Exit;
  end;

  LBusiness := TEmpresa.New;
  try
    try
      LBusiness.CorporateName := LBody.GetValue<string>('corporateName');
      LBusiness.FantasyName := LBody.GetValue<string>('fantasyName');
      LBusiness.Cnpj := LBody.GetValue<string>('cnpj');
      LBusiness.Ie := LBody.GetValue<string>('ie');
      LBusiness.Uf := LBody.GetValue<string>('uf');
      LBusiness.Environment := LBody.GetValue<integer>('env');
      LBusiness.LastNSU := LBody.GetValue<string>('lastNsu', '');
      LBusiness.CertBase64 := LBody.GetValue<string>('cert', '');
      LBusiness.CertPassword := LBody.GetValue<string>('certPass', '');

      TDAOEmpresa.CriarEmpresa(LBusiness);

      Res.Status(200).Send('Empresa criada com sucesso!');
    except
      on E: Exception do
        Res.Status(400).Send('Ocorreu um erro ao criar Empresa ' + E.Message);
    end;
  finally
    LBusiness.Free;
  end;
end;

class procedure TControllerEmpresa.PutAtualizaCertificado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LBusiness: TEmpresa;
  LCnpj: String;
begin
  LBody := Req.Body<TJSONObject>;
  LCnpj := Req.Params.Field('id').AsString;

  LBusiness := TDAOEmpresa.BuscarEmpresaPorCnpj(LCnpj);

  if not Assigned(LBusiness) then
  begin
    Res.Status(404).Send('Empresa n�o encontrada');
    Exit;
  end;

  try
    if Assigned(LBody) then
    begin
      LBusiness.CertBase64 := LBody.GetValue<String>('certificate');
      LBusiness.CertPassword := LBody.GetValue<String>('certPass');

      LBusiness.CertExpiration := TLacUtilsCertificado.ValidarCertificado(LBusiness.CertBase64, LBusiness.CertPassword);

      TDAOEmpresa.AtualizarCertificado(LCnpj, LBusiness);

      Res.Status(200).Send('Certificado validado e importado com sucesso V�lido at� ' +
        DateToStr(LBusiness.CertExpiration));
    end;
  except
    on E: Exception do
    begin
      Res.Status(400).Send('Ocorreu um erro ao importar ' + E.Message);
    end;
  end;
end;

class procedure TControllerEmpresa.PutAtualizarEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LID, LTempName, LTempCnpj: String;
  LBody: TJSONObject;
  LBusinessExist, LCheckCnpj: TEmpresa;
begin
  LID := Req.Params.Field('id').AsString;

  if not TLacUtils.IsValidID(LID) then
  begin
    Res.Status(400).Send('O ID informado na URL n�o � um formato v�lido (GUID).');
    Exit;
  end;

  LBusinessExist := TDAOEmpresa.BuscarEmpresaPorid(LID);

  if not Assigned(LBusinessExist) then
  begin
    Res.Status(404).Send('Empresa n�o encontrada.');
    Exit;
  end;

  try
    LBody := Req.Body<TJSONObject>;

    if Assigned(LBody) then
    begin

      if Assigned(LBody.GetValue('cnpj')) then
      begin
        LTempCnpj := LBody.GetValue<string>('cnpj');
        if LTempCnpj <> LBusinessExist.Cnpj then
        begin
          LCheckCnpj := TDAOEmpresa.BuscarEmpresaPorCnpj(LTempCnpj);
          if Assigned(LCheckCnpj) then
          begin
            LCheckCnpj.Free;
            Res.Status(409).Send('J� existe este CNPJ no Cadastro de Empresa');
            Exit;
          end;
        end;

        LBusinessExist.Cnpj := LTempCnpj;
      end;

      if Assigned(LBody.GetValue('corporateName')) then
      begin
        LBusinessExist.CorporateName := LBody.GetValue<string>('corporateName');
      end;

      if Assigned(LBody.GetValue('fantasyName')) then
      begin
        LBusinessExist.FantasyName := LBody.GetValue<string>('fantasyName');
      end;

      if Assigned(LBody.GetValue('ie')) then
      begin
        LBusinessExist.Ie := LBody.GetValue<string>('ie');
      end;

      if Assigned(LBody.GetValue('uf')) then
      begin
        LBusinessExist.Uf := LBody.GetValue<string>('uf');
      end;

      if Assigned(LBody.GetValue('env')) then
      begin
        LBusinessExist.Environment := LBody.GetValue<integer>('env');
      end;

      if Assigned(LBody.GetValue('lastNsu')) then
      begin
        LBusinessExist.LastNSU := LBody.GetValue<string>('lastNsu');
      end;

      TDAOEmpresa.AtualizarEmpresa(LBusinessExist);

      Res.Status(200).Send('Empresa atualizada com sucesso.');
    end
    else
    begin
      Res.Status(400).Send('Nenhum dado enviado para atualiza��o.');
    end;
  finally
    LBusinessExist.Free;
  end;
end;

class procedure TControllerEmpresa.GetNotasDestinadas(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lCnpjParam, lBusinessIdParam : String;
  lServiceNotasDestinadas : TServiceNotasDestinadas;
begin
  lBusinessIdParam := Req.Params.Field('businessId').AsString;
  lCnpjParam       := Req.Params.Field('cnpj').AsString;

  if not TLacUtils.IsValidID(lBusinessIdParam) then
  begin
    Res.Status(400).Send('O ID informado na URL n�o � um formato válido (GUID).');
    Exit;
  end;

    lServiceNotasDestinadas := TServiceNotasDestinadas.Create;
  try
    try
      lServiceNotasDestinadas.SincronizarSefaz(lBusinessIdParam, lCnpjParam);
       Res.Status(200).Send('Notas Consultadas');
    except on E:Exception do
      begin
       Res.Status(400).Send('Ocorreu um erro ' + E.Message);
      end;
    end;
  finally
    lServiceNotasDestinadas.Free;
  end;
end;
class procedure TControllerEmpresa.PostEnviarEmailXML(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lBody         : TJSONObject;
  lBusinessId   : string;
  lDataInicio   : TDateTime;
  lDataFim      : TDateTime;
  lDestinatario : string;
  lAssunto      : string;
  lCorpo        : string;
  lBase64       : string;
begin
  lBusinessId := Req.Params.Field('businessId').AsString;

  if not TLacUtils.IsValidID(lBusinessId) then
  begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (GUID).');
    Exit;
  end;

  lBody := Req.Body<TJSONObject>;

  if not Assigned(lBody) then
  begin
    Res.Status(400).Send('Corpo da requisição inválido.');
    Exit;
  end;

  if (TAppConfig.Email = '') or (TAppConfig.MailPassword = '') then
  begin
       Res.Status(500).Send('OCorreu um erro na Configuração do Email. Por favor tente mais tarde.');
       Exit;
  end;

  lAssunto  := 'Segue em anexo os arquivos XML do mês vigente';
  lCorpo    := 'Arquivos XML em Anexo';

  try
    lDataInicio   := ISO8601ToDate(lBody.GetValue<string>('dataInicio'));
    lDataFim      := ISO8601ToDate(lBody.GetValue<string>('dataFim'));
    lDestinatario := lBody.GetValue<string>('destinatario');
  except
    Res.Status(400).Send('Parametros inválidos. Verifique dataInicio, dataFim e demais campos obrigatórios.');
    Exit;
  end;

  try
    lBase64 := TServiceExportacao.New.GerarLoteXML(lBusinessId, lDataInicio, lDataFim);

    if lBase64.IsEmpty then
    begin
      Res.Status(404).Send('Nenhum XML encontrado para o período informado.');
      Exit;
    end;

    TServiceEmail.NewGmail(TAppConfig.Email, TAppConfig.MailPassword)
      .EnviarXMLPorEmail(lBusinessId, lDataInicio, lDataFim,
                         lDestinatario, lAssunto, lBase64, lCorpo);

    Res.Status(200).Send('E-mail enviado com sucesso.');
  except
    on E: Exception do
      Res.Status(500).Send('Erro ao enviar e-mail: ' + E.Message);
  end;
end;

end.
