unit Infra.HorseServer;

interface

uses
  System.SysUtils, Lac.Router.Auth, Lac.Router.Empresa,
  Lac.Router.UsuarioEmpresa, Sync.Interfaces, Sync.Sincronismo, Lac.Router.NotasSaidas, Lac.Router.Clientes;

type
  TLogCallBack = reference to procedure(const AMsg : string);

 TServerHorse = class
 private
  class var FSincronismo : ISincronizador;
 public
   class procedure Start(APort: Integer; const AOnLog: TLogCallback = nil);
   class procedure Stop;
 end;

implementation

uses
  Horse,
  Horse.Jhonson,
  Lac.Router.Usuario,
  Sync.SincronizacaoDfe;

{ TServerHorse }

class procedure TServerHorse.Start(APort: Integer; const AOnLog: TLogCallback);
begin
  THorse.Use(Jhonson);

  Lac.Router.Auth.Registry;

  Lac.Router.Empresa.Registry;
  Lac.Router.Usuario.Registry;
  Lac.Router.UsuarioEmpresa.Registry;
  Lac.Router.NotasSaidas.Registry;
  Lac.Router.Clientes.Registry;

  FSincronismo := TSincronizador.New;

  FSincronismo.GerarRotinas;

  THorse.Listen(APort,
    procedure
    begin
      if Assigned(AOnLog) then
        AOnLog(FormatDateTime('[hh:nn:ss] ', Now) + 'Servidor Online na porta ' + APort.ToString);
    end);
end;

class procedure TServerHorse.Stop;
begin
    if THorse.IsRunning then begin
     if Assigned(FSincronismo) then
     begin
        FSincronismo.PararRotinas;

        FSincronismo := nil;
     end;
      THorse.StopListen;
    end;
end;

end.
