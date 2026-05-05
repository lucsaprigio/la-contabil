unit Lac.Model.DAO.Usuario;

interface

uses
  System.JSON, FIREDAC.Comp.Client, System.SysUtils,
  lac.Infra.Connection, DataSet.Serialize, Model.Entity.Usuario, Data.DB;

type
  TModelUsuario = class
    class function  ListarPorEmpresa(aCodEmpresa: String): TJSONArray;
    class function  BuscarPorID(aID: String): TUser;
    class function  BuscarPorEmail(aEmail: string): TUser;
    class procedure CriarUsuario(aUser: TUser);
    class procedure ExcluirUsuario(aID: String);
    class procedure AtualizarUsuario(aUser: TUser);
  end;

implementation

{ TModelUsuario }

class procedure TModelUsuario.AtualizarUsuario(aUser: TUser);
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry := TFDQuery.Create(nil);

  try
    lConexao.Connect;
    lQry.Connection := lConexao.GetConnection;

    lQry.SQL.Text :=
      'UPDATE TB_USERS SET ' +
      '  USERNAME = :USERNAME, ' +
      '  EMAIL = :EMAIL, ' +
      '  UPDATED_AT = GETDATE() ' +
      'WHERE USERID = :USERID';

    lQry.ParamByName('USERID').DataType   := ftGuid;
    lQry.ParamByName('USERID').AsString   := aUser.UserId;

    lQry.ParamByName('USERNAME').AsString := aUser.Username;
    lQry.ParamByName('EMAIL').AsString    := aUser.Email;

    lQry.ExecSQL;
  finally
    lQry.Free;
  end;
end;

class function TModelUsuario.BuscarPorEmail(aEmail: string): TUser;
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
   lConexao := TControllerConection.New;
   lQry := TFDQuery.Create(nil);

   try
      with lQry do begin
      Connection := lConexao.GetConnection;

      SQL.Add('SELECT USERID, USERNAME, EMAIL, PASSWORD FROM TB_USERS WHERE EMAIL = :EMAIL');
      ParamByName('EMAIL').AsString := aEmail;

      Open;
    end;

    if not lQry.IsEmpty then begin
      Result := TUser.Create;

      Result.Email    := lQry.FieldByName('EMAIL').AsString;
      Result.Password := lQry.FieldByName('PASSWORD').AsString;
      Result.UserId := lQry.FieldByName('USERID').AsString;
      Result.Username := lQry.FieldByName('USERNAME').AsString;
    end;
   finally
      lQry.Free;
   end;
end;

class function TModelUsuario.BuscarPorID(aID: String): TUser;
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
  Result := nil;
  lConexao := TControllerConection.New;
  lQry := TFDQuery.Create(nil);

  try
    lConexao.Connect;

    lQry.Connection := lConexao.GetConnection;
    lQry.SQL.Add
      (' SELECT USERID, USERNAME, EMAIL, PASSWORD FROM TB_USERS WHERE USERID = :USERID');

    lQry.ParamByName('USERID').DataType := ftGuid;
    lQry.ParamByName('USERID').AsString := aID;

    lQry.Open;

    if not lQry.IsEmpty then begin
      Result := TUser.Create;

      Result.UserId   := lQry.FieldByName('USERID').AsString;
      Result.Username := lQry.FieldByName('USERNAME').AsString;
      Result.Password := lQry.FieldByName('PASSWORD').AsString;
      Result.Email    := lQry.FieldByName('EMAIL').AsString;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Ocorreu um erro ao executar a Query: ' +
        E.Message);
    end;
  end;
  lQry.Free;
  lConexao.Disconnect;
end;

class procedure TModelUsuario.CriarUsuario(aUser: TUser);
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry := TFDQuery.Create(nil);

  lQry.Connection := lConexao.GetConnection;
  try
    lQry.SQL.Add('INSERT INTO TB_USERS (USERNAME, EMAIL, PASSWORD)');
    lQry.SQL.Add('              VALUES (:USERNAME, :EMAIL, :PASSWORD)');

    lQry.ParamByName('USERNAME').AsString := aUser.Username;
    lQry.ParamByName('EMAIL').AsString    := aUser.Email;
    lQry.ParamByName('PASSWORD').AsString := aUser.Password;

    lQry.ExecSQL;
  finally
    lQry.Free;
  end;

end;

class procedure TModelUsuario.ExcluirUsuario(aID: String);
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry := TFDQuery.Create(nil);

  lQry.Connection := lConexao.GetConnection;
  try
    lQry.SQL.Add('DELETE FROM TB_USERS WHERE USERID = :USERID');

    lQry.ParamByName('USERID').AsString := aID;

    lQry.ExecSQL;
  finally
    lQry.Free;
  end;
end;

class function TModelUsuario.ListarPorEmpresa(aCodEmpresa: String): TJSONArray;
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry := TFDQuery.Create(nil);

  try
    lQry.Connection := lConexao.GetConnection;
    lQry.SQL.Add
      (' SELECT CD_CLIENTE, CNPJ_EMPRESA, RAZAO_EMPRESA, CNPJ_MATRIZ, ITEN, EMP_CONCENTRADORA');
    lQry.SQL.Add
      (' FROM DB_CLIENTE_PAGINA_EMPRESA WHERE CD_CLIENTE = :pEmpresa');
    lQry.ParamByName('pEmpresa').AsString := aCodEmpresa;

    lQry.Open;

    Result := lQry.ToJSONArray;
  finally
    lQry.Free;
  end;
end;

end.
