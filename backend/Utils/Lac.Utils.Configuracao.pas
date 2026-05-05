unit Lac.Utils.Configuracao;

interface

uses
  System.IOUtils,
  System.SysUtils,
  System.IniFiles;

type
  TAppConfig = class
  private
    class var FServer: String;
    class var FPort: String;
    class var FDatabase: String;
    class var FDBXml: String;
    class var FDBUser: String;
    class var FDBPassword: String;

    class var FServerXml: String;
    class var FPortXml: String;
    class var FDBUserXml: String;
    class var FDBPasswordXml: String;
    class var FDriverID: string;
    class var FJWT_SECRET: String;
    class var FCaminhoSchemas: String;
    class var FEmail: string;
    class var FMailPassword: string;

  public
    class procedure CarregarIni;

    // Informações do Banco Spdc (Login e Usuário; Informações das Notas Fiscais)
    class property DriverID: string read FDriverID write FDriverID;
    class property Server: string read FServer write FServer;
    class property Port: string read FPort write FPort;
    class property Database: string read FDatabase write FDatabase;
    class property DBUser: string read FDBUser write FDBUser;
    class property DBPassword: string read FDBPassword write FDBPassword;

    // Banco onde está os Xml salvos das empresas.
    class property DBXml: string read FDBXml;
    class property ServerXml: String read FServerXml write FServerXml;
    class property PortXml: String read FPortXml write FPortXml;
    class property DBUserXml: String read FDBUserXml write FDBUserXml;
    class property DBPasswordXml: String read FDBPasswordXml write FDBPasswordXml;

    class property CaminhoSchemas: String read FCaminhoSchemas write FCaminhoSchemas;

    class property Email: String read FEmail write FEmail;
    class property MailPassword: String read FMailPassword write FMailPassword;

    class property JWT_SECRET: String read FJWT_SECRET write FJWT_SECRET;
  end;

implementation

{ TAppConfig }

class procedure TAppConfig.CarregarIni;
var
  LArquivoINI : TIniFile;
  LCaminhoINI, LCaminhoSchemas : String;

  function LerEGarantir(const aSessao, aChave, aValorPadrao: string): string;
  begin
    if not LArquivoINI.ValueExists(aSessao, aChave) then
      LArquivoINI.WriteString(aSessao, aChave, aValorPadrao);

    Result := LArquivoINI.ReadString(aSessao, aChave, aValorPadrao);
  end;

begin
  // C:\MeuApp\config.Ini -> Facilitanto caso for para um Linux.
  LCaminhoINI     := TPath.Combine(ExtractFilePath(ParamStr(0)), 'config.ini');
  LCaminhoSchemas := TPath.Combine(ExtractFilePath(ParamStr(0)), 'Schemas');


  LArquivoINI := TIniFile.Create(LCaminhoINI);

  try
    FDriverID        := LerEGarantir('BancoConfig', 'DriverID', '');
    FServer          := LerEGarantir('BancoConfig', 'Server', '127.0.0.1');
    FPort            := LerEGarantir('BancoConfig', 'Port', '');
    FDatabase        := LerEGarantir('BancoConfig', 'Database', '');
    FDBUser          := LerEGarantir('BancoConfig', 'User', '');
    FDBPassword      := LerEGarantir('BancoConfig', 'Password', '');

    FServerXml       := LerEGarantir('BancoXml', 'ServerXml', '127.0.0.1');
    FDBXml           := LerEGarantir('BancoXml', 'DatabaseXml', '');
    FPortXml         := LerEGarantir('BancoXml', 'PortXml', '');
    FDBUserXml       := LerEGarantir('BancoXml', 'UserXml', '');
    FDBPasswordXml   := LerEGarantir('BancoXml', 'PasswordXml', '');

    FJWT_SECRET      := LerEGarantir('Auth', 'JWT_SECRET', '');

    FCaminhoSchemas  := LerEGarantir('Caminhos', 'Schemas', LCaminhoSchemas);

    FEmail           := LerEGarantir('SMTP', 'Email', '');
    FMailPassword    := LerEGarantir('SMTP', 'Password', '');

  finally
    LArquivoINI.Free;
  end;

end;


end.
