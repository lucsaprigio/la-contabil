unit Lac.Controller.UsuarioEmpresa;

interface

uses
  Horse, System.JSON, Lac.Model.DAO.UsuarioEmpresa, REST.Json,
  Model.Entity.UsuarioEmpresa, System.SysUtils, Lac.Exceptions;

type
  TLacControllerUsuarioEmpresa = class
    class procedure GetBuscarUsuarioEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PostNovoUsuarioEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure DeleteUsuarioEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TLacControllerUsuarioEmpresa }

uses DTO.UsuarioEmpresa.Response, Lac.Utils;

class procedure TLacControllerUsuarioEmpresa.DeleteUsuarioEmpresa(
  Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LUserId, LBusinessId: String;
begin
  LUserId     := Req.Params.Field('userId').AsString;
  LBusinessId := Req.Params.Field('businessId').AsString;

  if (not TLacUtils.IsValidID(LUserId)) or (not TLacUtils.IsValidID(LBusinessId)) then begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (GUID).');
    Exit;
  end;

  if not TDAOUsuarioEmpresa.BuscaUsuarioVinculado(LUserId, LBusinessId) then begin
     raise EUsuarioEmpresaExistente.Create('Usuário vinculado não encontrado');
  end;

  TDAOUsuarioEmpresa.ExcluirUsuarioEmpresa(LUserId, LBusinessId);

  Res.Status(200).Send('Empresa excluída com sucesso');
end;

class procedure TLacControllerUsuarioEmpresa.GetBuscarUsuarioEmpresa(
  Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDTOEmpresaResponse : TDTOUsuarioEmpresaResponse;
  LID                 : String;
begin
  LID := Req.Params.Field('id').AsString;

  if not TLacUtils.IsValidID(LID) then begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (GUID).');
    Exit;
  end;

  LDTOEmpresaResponse := TDAOUsuarioEmpresa.BuscarUsuarioEmpresa(LID);

  try
   Res.Status(200).Send<TJSONObject>(TJson.ObjectToJsonObject(LDTOEmpresaResponse));
  finally
   LDTOEmpresaResponse.Free;
  end;
end;

class procedure TLacControllerUsuarioEmpresa.PostNovoUsuarioEmpresa(
  Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LUsuarioEmpresa : TUsuarioEmpresa;
  LBodyRoleName, LTempRoleName : String;
begin
  LBody := Req.Body<TJSONObject>;

  if not Assigned(LBody) then
  begin
    Res.Status(400).Send('Corpo da Requisição Inválido');
    Exit;
  end;

  LUsuarioEmpresa := TUsuarioEmpresa.New;

  try
    try
       LUsuarioEmpresa.UserId     := LBody.GetValue<String>('userId');
       LUsuarioEmpresa.BusinessId := LBody.GetValue<String>('businessId');

       if TDAOUsuarioEmpresa.BuscaUsuarioVinculado(LUsuarioEmpresa.UserId, LUsuarioEmpresa.BusinessId) then begin
         raise EUsuarioJaVinculado.Create('Usuário já vinculado a esta empresa');
       end;


       LBodyRoleName := 'USER';

       if LBody.TryGetValue<String>('roleName', LTempRoleName) and (LTempRoleName.Trim <> '') then begin
          LBodyRoleName := LTempRoleName.Trim;
       end;

       LUsuarioEmpresa.RoleName   := LBodyRoleName;

       TDAOUsuarioEmpresa.CriarUsuarioAEmpresa(LUsuarioEmpresa);

       Res.Status(200).Send('Usuário vinculado a Empresa!');
    except on E: Exception do begin
       Res.Status(400).Send('Ocorreu um erro ao Vincular o Usuário ' + E.Message);
     end;
    end;
  finally
   LUsuarioEmpresa.Free;
  end;

end;

end.
