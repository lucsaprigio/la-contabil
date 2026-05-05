unit Lac.Model.DAO.UsuarioEmpresa;

interface

uses Model.Entity.UsuarioEmpresa, FireDAC.Comp.Client, Lac.Infra.Connection,
  DTO.UsuarioEmpresa.Response, System.Generics.Collections, System.JSON;

type
  TDAOUsuarioEmpresa = class
    class procedure CriarUsuarioAEmpresa(aUsuarioEmpresa : TUsuarioEmpresa);
    class function  BuscarUsuarioEmpresa(aUserId: string) : TDTOUsuarioEmpresaResponse;
    class function  BuscaUsuarioVinculado(aUserId, aBusinessId: string): Boolean;
    class procedure ExcluirUsuarioEmpresa(aUserId, aBusinessId: string);
    class procedure AtualizarUsuarioEmpresa(aUsuarioEmpresa : TUsuarioEmpresa);
  end;

implementation

{ TDAOUsuarioEmpresa }

class procedure TDAOUsuarioEmpresa.AtualizarUsuarioEmpresa(
  aUsuarioEmpresa: TUsuarioEmpresa);
var
  LConexao : IControllerConnection;
  LQry     : TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LConexao.Connect;
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := ' UPDATE TB_USER_BUSINESS ' +
   '    SET  ' +
   '    BUSINESS_ID = :BUSINESS_ID' +
   '    ,ROLE_NAME = :ROLE_NAME' +
   '    WHERE USERID = :USERID' +
   '    AND BUSINESS_ID = : BUSINESS_ID ';

   LQry.ParamByName('BUSINESS_ID').ASString := aUsuarioEmpresa.BusinessId;
   LQry.ParamByName('ROLE_NAME').AsString   := aUsuarioEmpresa.RoleName;

   LQry.ExecSQL;

  finally
    LQry.Free;
  end;
end;

class function TDAOUsuarioEmpresa.BuscarUsuarioEmpresa(
  aUserId: string): TDTOUsuarioEmpresaResponse;
var
  LConexao : IControllerConnection;
  LQry     : TFDQuery;
  LEmpresa : TDTOEmpresa;
begin
  Result := TDTOUsuarioEmpresaResponse.New;

  Result.UserId := aUserId;

  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
  LConexao.Connect;
  LQry.Connection := LConexao.GetConnection;

  LQry.SQL.TExt :=
  'SELECT A.USERID '+
  '   ,A.BUSINESS_ID '+
  '   ,A.ROLE_NAME '+
  '   ,B.CNPJ '+
  '   ,B.CORPORATE_NAME '+
  '   ,B.FANTASY_NAME '+
  'FROM TB_USER_BUSINESS A '+
  'JOIN TB_BUSINESS B ON B.BUSINESS_ID = A.BUSINESS_ID '+
  'WHERE A.USERID = :USERID ';

  LQry.ParamByName('USERID').AsString := aUserId;

  LQry.Open;

  while not LQry.Eof do begin
    LEmpresa := TDTOEmpresa.New;

    LEmpresa.BusinessId   := LQry.FieldByName('BUSINESS_ID').AsString;
    LEmpresa.RoleName     := LQry.FieldByName('ROLE_NAME').AsString;
    LEmpresa.Cnpj         := LQry.FieldByName('CNPJ').AsString;
    LEmpresa.CorporateName:= LQry.FieldByName('CORPORATE_NAME').AsString;
    LEmpresa.FantasyName  := LQry.FieldByName('FANTASY_NAME').AsString;

    Result.AddEmpresa(LEmpresa);

    LQry.Next;
  end;

  finally
    LQry.Free;
  end;
end;

class function TDAOUsuarioEmpresa.BuscaUsuarioVinculado(aUserId,
  aBusinessId: string): Boolean;
var
  LConexao : IControllerConnection;
  LQry     : TFDQuery;
begin
  Result := True;
  LConexao := TControllerConection.New;
  LQry     := TFDQuery.Create(nil);

  try
  LConexao.Connect;
  LQry.Connection := LConexao.GetConnection;

  LQry.SQL.Text := 'SELECT TOP(1) USERID, BUSINESS_ID FROM TB_USER_BUSINESS WHERE USERID = :USERID AND BUSINESS_ID = :BUSINESS_ID';

  LQry.ParamByName('USERID').AsString      := aUserId;
  LQry.ParamByName('BUSINESS_ID').AsString := aBusinessId;  

  LQry.Open;

  Result := not LQry.IsEmpty;
  finally
    LQry.Free;
  end;
end;

class procedure TDAOUsuarioEmpresa.CriarUsuarioAEmpresa(
  aUsuarioEmpresa: TUsuarioEmpresa);
var
  LConexao : IControllerConnection;
  LQry : TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LConexao.Connect;
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text :=
    'INSERT INTO TB_USER_BUSINESS '+
    '       (USERID '+
    '       ,BUSINESS_ID'+
    '       ,ROLE_NAME'+
    '       )'+
    'VALUES ' +
    '       (:USERID'+
    '        ,:BUSINESS_ID' +
    '        ,:ROLE_NAME)';

    LQry.ParamByName('USERID').AsString      := aUsuarioEmpresa.UserId;
    LQry.ParamByName('BUSINESS_ID').AsString := aUsuarioEmpresa.BusinessId;
    LQry.ParamByName('ROLE_NAME').AsString   := aUsuarioEmpresa.RoleName;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

class procedure TDAOUsuarioEmpresa.ExcluirUsuarioEmpresa(aUserId,
  aBusinessId: string);
var
  LConexao : IControllerConnection;
  LQry : TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LConexao.Connect;
    LQry.Connection := LConexao.GetConnection;

     LQry.SQL.Text := 'DELETE FROM TB_USER_BUSINESS WHERE USERID = :USERID AND BUSINESS_ID = :BUSINESS_ID';

     LQry.ParamByName('USERID').AsString := aUserId;
     LQry.ParamByName('BUSINESS_ID').AsString := aBusinessId;

     LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

end.
