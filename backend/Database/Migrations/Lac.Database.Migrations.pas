unit Lac.Database.Migrations;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, Lac.Infra.Connection;

type
  TDatabaseMigrations = class
    private
      class procedure CriarTabelaBusiness(AQuery : TFDQuery);
      class procedure TB_USER_BUSINESS(AQuery: TFDQuery);
      class procedure TB_NOTAS_DESTINADAS(AQuery: TFDQuery);
      class procedure TB_NOTAS_DESTINADAS_XML(AQuery: TFDQuery);
    public
      class procedure Run;
  end;

implementation

{ TDatabaseMigrations }

class procedure TDatabaseMigrations.CriarTabelaBusiness(AQuery: TFDQuery);
begin
    AQuery.SQL.Text :=
      'IF OBJECT_ID(''dbo.TB_BUSINESS'', ''U'') IS NULL ' +
      'BEGIN ' +
      '  CREATE TABLE dbo.TB_BUSINESS ( ' +
      '    BUSINESS_ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (NEWID()), ' +
      '    CORPORATE_NAME NVARCHAR(200) NOT NULL, ' +
      '    FANTASY_NAME NVARCHAR(200), ' +
      '    CNPJ VARCHAR(14) NOT NULL UNIQUE, ' +
      '    IE VARCHAR(20), ' +
      '    UF CHAR(2) NOT NULL, ' +
      '    ENVIRONMENT INT DEFAULT 1, ' +
      '    LAST_NSU VARCHAR(20) DEFAULT (''0''), ' +
      '    CERT_BASE64 VARCHAR(MAX), ' +
      '    CERT_PASSWORD VARCHAR(100), ' +
      '    CERT_EXPIRATION DATETIME, ' +
      '    CREATED_AT DATETIME DEFAULT (GETDATE()), ' +
      '    UPDATED_AT DATETIME ' +
      '  ); ' +
      'END;';

      AQuery.ExecSQL;
end;

class procedure TDatabaseMigrations.Run;
var
  LConexao: IControllerConnection;
  LQry: TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LConexao.Connect;
    LQry.Connection := LConexao.GetConnection;

    LQry.ResourceOptions.PreprocessCmdText := False;

    try
      CriarTabelaBusiness(LQry);
      TB_USER_BUSINESS(LQry);
      TB_NOTAS_DESTINADAS(LQry);
      TB_NOTAS_DESTINADAS_XML(LQry);
    except
      on E:Exception do

    end;
  finally
    LQry.Free;
  end;

end;

class procedure TDatabaseMigrations.TB_NOTAS_DESTINADAS(AQuery: TFDQuery);
begin
  AQuery.SQL.Text :=
  'IF OBJECT_ID(''dbo.TAB_NOTAS_DESTINADAS'', ''U'') IS NULL' +
  '  BEGIN' +
  ' CREATE TABLE dbo.TB_NOTAS_DESTINADAS (' +
  '  ID UNIQUEIDENTIFIER DEFAULT (NEWSEQUENTIALID()) PRIMARY KEY,' +
  '  BUSINESS_ID UNIQUEIDENTIFIER NOT NULL,' +
  '  CHAVE_ACESSO VARCHAR(45) NOT NULL,' +
  '  NSU VARCHAR(20) NOT NULL,' +
  '  CNPJ_EMITENTE VARCHAR(16) NOT NULL,' +
  '  NOME_EMITENTE VARCHAR(150) NOT NULL,' +
  '  DATA_EMISSAO DATETIME NOT NULL,' +
  '  VALOR_TOTAL DECIMAL(18,2) NOT NULL,' +
  '  SITUACAO_SEFAZ INT NOT NULL, -- Ex: 1 = Autorizada, 2 = Cancelada, 3 = Denegada' +
  '  SITUACAO_SEFAZ INT NOT NULL, -- Ex: 1 = Autorizada, 2 = Cancelada, 3 = Denegada' +
  '  STATUS_MANIFESTACAO INT DEFAULT 0, -- Ex: 0 = Sem Manifestação, 1 = Ciência, 2 = Confirmação, 3 = Desconhecimento' +
  '  DATA_DOWNLOAD DATETIME DEFAULT (GETDATE()),' +
  '  PROCESSADA_ENTRADA BIT DEFAULT 0 -- 0 = Só baixou, 1 = Já gerou estoque/financeiro nas tabelas oficiais' +
  '  );' +
  '  CREATE NONCLUSTERED INDEX IX_NOTAS_DESTINADAS_BUSINESS ON TB_NOTAS_DESTINADAS(BUSINESS_ID);' +
  '  CREATE NONCLUSTERED INDEX IX_NOTAS_DESTINADAS_CHAVE ON TB_NOTAS_DESTINADAS(CHAVE_ACESSO);' +
  '  END;' ;
  AQuery.ExecSQL;
end;

class procedure TDatabaseMigrations.TB_NOTAS_DESTINADAS_XML(AQuery: TFDQuery);
begin
   AQuery.SQL.Text :=
   ' IF OBJECT_ID(''dbo.TB_NOTAS_DESTINADAS_XML'', ''U'') IS NULL'+
   ' CREATE TABLE TB_NOTAS_DESTINADAS_XML ('+
   ' DESTINADA_ID UNIQUEIDENTIFIER PRIMARY KEY,'+
   ' XML_CONTEUDO VARCHAR(MAX) NOT NULL, '+

   ' CONSTRAINT FK_DESTINADA_XML FOREIGN KEY (DESTINADA_ID)'+
   ' REFERENCES TB_NOTAS_DESTINADAS(ID)'+
   ' ON DELETE CASCADE'+
   ' );'+
   'END;';

   AQuery.ExecSQL;
end;

class procedure TDatabaseMigrations.TB_USER_BUSINESS(AQuery: TFDQuery);
begin
  AQuery.SQL.Text :=
    'IF OBJECT_ID(''dbo.TB_USER_BUSINESS'', ''U'') IS NULL ' +
    ' BEGIN '+
    '	CREATE TABLE dbo.TB_USER_BUSINESS ('+
	  ' USERID UNIQUEIDENTIFIER NOT NULL,'+
    '	BUSINESS_ID UNIQUEIDENTIFIER NOT NULL,'+
    '	ROLE_NAME VARCHAR(50) NOT NULL,'+
    '	CREATED_AT DATETIME NOT NULL DEFAULT GETDATE(),'+

    '	PRIMARY KEY (USERID, BUSINESS_ID),'+

    '	CONSTRAINT FK_UB_USER FOREIGN KEY (USERID) REFERENCES dbo.TB_USERS(USERID) ON DELETE CASCADE,'+
    '	CONSTRAINT FK_UB_BUSINESS FOREIGN KEY (BUSINESS_ID) REFERENCES dbo.TB_BUSINESS(BUSINESS_ID) ON DELETE CASCADE'+
    '	); '+
    ' END;';

    AQuery.ExecSQL;
end;

end.
