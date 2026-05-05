unit Lac.Infra.Connection;

interface

uses
  FireDAC.UI.Intf, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, Data.DB, FireDAC.Comp.Client, FireDAC.DApt,
  System.SysUtils, FireDAC.VCLUI.Wait;

type
  IControllerConnection = interface
    ['{8D970CDA-4C32-4198-9866-C21B1EE28B6F}']
    function GetConnection: TFDConnection;
    function Connect: IControllerConnection;
    function Disconnect: IControllerConnection;
  end;

  TControllerConection = class(TInterfacedObject, IControllerConnection)
  private
    FConnection: TFDConnection;
    FDatabasePath : String;
    procedure ConfigurarConexao;
  public
    constructor Create(const ADatabasePath : String = ''); // Vou usar 2 bancos, então vou colocar um parâmetro opcional
    destructor destroy; override;

    class function New(const ADatabasePath : String = ''): IControllerConnection; // Preciso colocar no new pois é onde eu faço instancio a classe.

    function GetConnection: TFDConnection;
    function Connect: IControllerConnection;
    function Disconnect: IControllerConnection;
  end;

implementation

{ TControllerConection }

uses Lac.Utils.Configuracao;

constructor TControllerConection.Create(const ADatabasePath : String = '');
begin
  // No Constructor é onde vamos fazer a criação de conexão neste caso de Banco.
  FConnection   := TFDConnection.Create(nil);
  FDatabasePath := ADatabasePath;
  ConfigurarConexao;
end;

destructor TControllerConection.destroy;
begin
  FConnection.Free;
  inherited;
end;

class function TControllerConection.New(const ADatabasePath : String = ''): IControllerConnection;
begin
  Result := Self.Create(ADatabasePath);
end;

procedure TControllerConection.ConfigurarConexao;
begin
  // Colocar no INI
  with FConnection do
  begin
    Connected := False;
    Params.Clear;

    Params.DriverID           := TAppConfig.DriverID;
    Params.Values['Protocol'] := 'TCPIP';
    Params.Values['Port']     := TAppConfig.Port;
    Params.Values['Server']   := TAppConfig.Server;

    if TAppConfig.DriverID = 'MSSQL' then begin
      Params.Values['OSAuthent']               := 'No'; // Define que usa Usuario e Senha, não o Windows.

      Params.Values['ODBCAdvanced'] := 'Encrypt=yes;TrustServerCertificate=yes;';
    end;

    if Trim(FDatabasePath) = '' then
      Params.Database           := TAppConfig.Database
    else
      Params.Database           := FDatabasePath;

    Params.UserName           := TAppConfig.DBUser;
    Params.Password           := TAppConfig.DBPassword;

    // Configurações importantes para performance
    LoginPrompt                := False;
    ResourceOptions.SilentMode := True;

    ResourceOptions.AutoConnect := True; // Para o TTask
  end;
end;

function TControllerConection.Connect: IControllerConnection;
begin
  Result := Self;

  try
    if not FConnection.Connected then
    begin
      FConnection.Connected := True;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro fatal ao conectar no banco de dados: ' +
        E.Message);
    end;
  end;
end;

function TControllerConection.Disconnect: IControllerConnection;
begin
  Result := Self;
  FConnection.Connected := False;
end;

function TControllerConection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
