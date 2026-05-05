unit Lac.Model.DAO.Empresa;

interface

uses
  Lac.Infra.Connection, FireDAC.Comp.Client, Model.Entity.Empresa;

type
  TDAOEmpresa = class
    class procedure CriarEmpresa(aEmpresa: TEmpresa);
    class function BuscarEmpresaPorCnpj(aCnpj: String): TEmpresa;
    class function BuscarEmpresaPorID(aID: String): TEmpresa;
    class procedure AtualizarCertificado(aCnpj: String; aBusiness: TEmpresa);
    class procedure AtualizarEmpresa(aBusiness: TEmpresa);
    class procedure ExcluirEmpresa(aID: String);
    class function BuscarUltimoNSU(aCnpj: String) : String;
    class procedure AtualizarUltimoNSU(aID, aUltNSU, aCnpj : String);
    class function BuscarEmpresasPendentesDFe: TArray<TEmpresa>;
    class procedure AtualizarDataConsulta(const ABusinessId: string);
  end;

implementation

{ TDAOEmpresa }

class procedure TDAOEmpresa.AtualizarCertificado(aCnpj: String; aBusiness: TEmpresa);
var
  LConexao: iControllerConnection;
  LQry: TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := 'UPDATE TB_BUSINESS SET CERT_BASE64 = :CERT_BASE64, CERT_PASSWORD = :CERT_PASSWORD, ' +
      ' CERT_EXPIRATION = :CERT_EXPIRATION, UPDATED_AT = GETDATE() WHERE CNPJ = :CNPJ';

    LQry.ParamByName('CNPJ').AsString := aCnpj;

    LQry.ParamByName('CERT_BASE64').AsString := aBusiness.CertBase64;
    LQry.ParamByName('CERT_PASSWORD').AsString := aBusiness.CertPassword;
    LQry.ParamByName('CERT_EXPIRATION').AsDate := aBusiness.CertExpiration;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

class procedure TDAOEmpresa.AtualizarEmpresa(aBusiness: TEmpresa);
var
  LConexao: iControllerConnection;
  LQry: TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := 'UPDATE TB_BUSINESS SET ' + ' CORPORATE_NAME = :CORPORATE_NAME, ' +
      ' FANTASY_NAME = :FANTASY_NAME, ' + ' CNPJ = :CNPJ, ' + ' IE = :IE, ' + ' UF = :UF, ' +
      ' ENVIRONMENT = :ENVIRONMENT, ' + ' LAST_NSU = :LAST_NSU, UPDATED_AT = GETDATE() ' +
      ' WHERE BUSINESS_ID = :BUSINESS_ID ';

    LQry.ParamByName('BUSINESS_ID').AsString := aBusiness.BusinessId;

    LQry.ParamByName('CORPORATE_NAME').AsString := aBusiness.CorporateName;
    LQry.ParamByName('FANTASY_NAME').AsString := aBusiness.FantasyName;
    LQry.ParamByName('CNPJ').AsString := aBusiness.Cnpj;
    LQry.ParamByName('IE').AsString := aBusiness.Ie;
    LQry.ParamByName('UF').AsString := aBusiness.Uf;
    LQry.ParamByName('ENVIRONMENT').AsInteger := aBusiness.Environment;
    LQry.ParamByName('LAST_NSU').AsString := aBusiness.LastNSU;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

class procedure TDAOEmpresa.AtualizarUltimoNSU(aID, aUltNSU, aCnpj: String);
var
  LConexao: iControllerConnection;
  LQry: TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

    try
    LQry.Connection := LConexao.GetConnection;


    LQry.SQL.Text :=
     ' UPDATE TB_BUSINESS'+
     ' SET LAST_NSU = :LAST_NSU' +
     ' WHERE BUSINESS_ID = :BUSINESS_ID' +
     ' AND CNPJ = :CNPJ' ;

    LQry.ParamByName('LAST_NSU').AsString        := aUltNSU;
    LQry.ParamByName('BUSINESS_ID').AsString     := aID;
    LQry.ParamByName('CNPJ').AsString            := aCnpj;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

class function TDAOEmpresa.BuscarEmpresaPorCnpj(aCnpj: String): TEmpresa;
var
  LConexao: iControllerConnection;
  LQry: TFDQuery;
begin
  Result := nil;

  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := ' SELECT BUSINESS_ID ,CORPORATE_NAME ,FANTASY_NAME ,CNPJ ' +
      ' ,IE ,UF ,ENVIRONMENT ,LAST_NSU ,CERT_BASE64 ,CERT_PASSWORD ,CERT_EXPIRATION FROM TB_BUSINESS ' +
      ' WHERE CNPJ = :CNPJ';

    LQry.ParamByName('CNPJ').AsString := aCnpj;

    LQry.Open;
    if not LQry.IsEmpty then
    begin
      Result := TEmpresa.Create;

      Result.BusinessId := LQry.FieldByName('BUSINESS_ID').AsString;
      Result.CorporateName := LQry.FieldByName('CORPORATE_NAME').AsString;
      Result.FantasyName := LQry.FieldByName('FANTASY_NAME').AsString;
      Result.Cnpj := LQry.FieldByName('CNPJ').AsString;
      Result.Ie := LQry.FieldByName('IE').AsString;
      Result.Uf := LQry.FieldByName('UF').AsString;
      Result.LastNSU := LQry.FieldByName('LAST_NSU').AsString;
      Result.CertBase64 := LQry.FieldByName('CERT_BASE64').AsString;
      Result.CertPassword := LQry.FieldByName('CERT_PASSWORD').AsString;
      Result.CertExpiration := LQry.FieldByName('CERT_EXPIRATION').AsDateTime;
    end;
  finally
    LQry.Free;
  end;
end;

class function TDAOEmpresa.BuscarEmpresaPorID(aID: String): TEmpresa;
var
  LConexao: iControllerConnection;
  LQry: TFDQuery;
begin
  Result := nil;

  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := ' SELECT BUSINESS_ID ,CORPORATE_NAME ,FANTASY_NAME ,CNPJ ' +
      ' ,IE ,UF ,ENVIRONMENT ,LAST_NSU ,CERT_BASE64 ,CERT_PASSWORD ,CERT_EXPIRATION FROM TB_BUSINESS ' +
      ' WHERE BUSINESS_ID = :ID';

    LQry.ParamByName('ID').AsString := aID;

    LQry.Open;
    if not LQry.IsEmpty then
    begin
      Result := TEmpresa.Create;

      Result.BusinessId := LQry.FieldByName('BUSINESS_ID').AsString;
      Result.CorporateName := LQry.FieldByName('CORPORATE_NAME').AsString;
      Result.FantasyName := LQry.FieldByName('FANTASY_NAME').AsString;
      Result.Cnpj := LQry.FieldByName('CNPJ').AsString;
      Result.Ie := LQry.FieldByName('IE').AsString;
      Result.Uf := LQry.FieldByName('UF').AsString;
      Result.LastNSU := LQry.FieldByName('LAST_NSU').AsString;
      Result.CertBase64 := LQry.FieldByName('CERT_BASE64').AsString;
      Result.CertPassword := LQry.FieldByName('CERT_PASSWORD').AsString;
      Result.CertExpiration := LQry.FieldByName('CERT_EXPIRATION').AsDateTime;
    end;
  finally
    LQry.Free;
  end;
end;

class function TDAOEmpresa.BuscarEmpresasPendentesDFe: TArray<TEmpresa>;
var
  LConexao: iControllerConnection;
  LQry: TFDQuery;
  LEmpresa : TEmpresa;
begin
  Result := nil;

  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := ' SELECT BUSINESS_ID, CNPJ, LAST_NSU' +
                     ' FROM TB_BUSINESS' +
                     ' WHERE DATA_ULTIMA_CONSULTA IS NULL' +
                     ' OR DATEDIFF(MINUTE, DATA_ULTIMA_CONSULTA, GETDATE()) >= 60';


    LQry.Open;

    while not LQry.Eof do
    begin
      LEmpresa := TEmpresa.Create;
      LEmpresa.BusinessId := LQry.FieldByName('BUSINESS_ID').AsString;
      LEmpresa.Cnpj       := LQry.FieldByName('CNPJ').AsString;
      LEmpresa.LastNSU    := LQry.FieldByName('LAST_NSU').AsString;

      // Incrementando sempre o Array
      SetLength(Result, Length(Result) + 1);

      Result[High(Result)] := LEmpresa;

      LQry.Next;
    end;
  finally
    LQry.Free;
  end;
end;

class procedure TDAOEmpresa.AtualizarDataConsulta(const ABusinessId: string);
var
  LConexao: IControllerConnection;
  LQry: TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := ' UPDATE TB_BUSINESS' +
                     ' SET DATA_ULTIMA_CONSULTA = GETDATE()' +
                     ' WHERE BUSINESS_ID = :BUSINESS_ID';

    LQry.ParamByName('BUSINESS_ID').AsString := ABusinessId;

    LQry.ExecSQL;

  finally
    LQry.Free;
  end;
end;

class function TDAOEmpresa.BuscarUltimoNSU(aCnpj: String): String;
var
  LConexao: iControllerConnection;
  LQry: TFDQuery;
begin
  Result := '0';
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := 'SELECT TOP 1 LAST_NSU FROM TB_BUSINESS WHERE CNPJ = :CNPJ';

    LQry.ParamByName('CNPJ').AsString := aCnpj;

    LQry.Open;

    if not LQry.IsEmpty then begin
      Result := LQry.FieldByName('LAST_NSU').AsString;
    end;

  finally
    LQry.Free;
  end;
end;

class procedure TDAOEmpresa.CriarEmpresa(aEmpresa: TEmpresa);
var
  LConexao: iControllerConnection;
  LQry: TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text := 'INSERT INTO TB_BUSINESS ' +
      '(BUSINESS_ID, CORPORATE_NAME, FANTASY_NAME, CNPJ, IE, UF, ENVIRONMENT, LAST_NSU, CERT_BASE64, CERT_PASSWORD, CERT_EXPIRATION) '
      + 'VALUES ' +
      '(:BUSINESS_ID, :CORPORATE_NAME, :FANTASY_NAME, :CNPJ, :IE, :UF, :ENVIRONMENT, :LAST_NSU, :CERT_BASE64, :CERT_PASSWORD, :CERT_EXPIRATION) ';

    LQry.ParamByName('BUSINESS_ID').AsString := aEmpresa.BusinessId;
    LQry.ParamByName('CORPORATE_NAME').AsString := aEmpresa.CorporateName;
    LQry.ParamByName('FANTASY_NAME').AsString := aEmpresa.FantasyName;
    LQry.ParamByName('CNPJ').AsString := aEmpresa.Cnpj;
    LQry.ParamByName('IE').AsString := aEmpresa.Ie;
    LQry.ParamByName('UF').AsString := aEmpresa.Uf;
    LQry.ParamByName('ENVIRONMENT').AsInteger := aEmpresa.Environment;
    LQry.ParamByName('LAST_NSU').AsString := aEmpresa.LastNSU;
    LQry.ParamByName('CERT_BASE64').AsString := aEmpresa.CertBase64;
    LQry.ParamByName('CERT_PASSWORD').AsString := aEmpresa.CertPassword;
    LQry.ParamByName('CERT_EXPIRATION').AsDateTime := aEmpresa.CertExpiration;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

class procedure TDAOEmpresa.ExcluirEmpresa(aID: String);
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry := TFDQuery.Create(nil);

  lQry.Connection := lConexao.GetConnection;
  try
    lQry.SQL.Add('DELETE FROM TB_BUSINESS WHERE BUSINESS_ID = :ID');

    lQry.ParamByName('ID').AsString := aID;

    lQry.ExecSQL;
  finally
    lQry.Free;
  end;
end;

end.
