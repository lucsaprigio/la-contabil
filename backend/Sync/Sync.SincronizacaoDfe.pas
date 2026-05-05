unit Sync.SincronizacaoDfe;

interface

uses
  System.Classes, Sync.Interfaces, System.SysUtils, Model.Entity.Empresa, Lac.Model.DAO.Empresa,
  Winapi.ActiveX;

type
  TWorkerSincronizacaoDFe = class(TInterfacedObject, ISyncJob)
    private
      class var FThread: TThread;
      class procedure ProcessarEmpresas;
    public
       procedure Iniciar;
       procedure Parar;
  end;


implementation

uses
  Lac.Services.NotasDestinadas;

{ TWorkerSincronizacaoDFe }

procedure TWorkerSincronizacaoDFe.Iniciar;
begin
    if Assigned(FThread) then Exit;

    FThread := TThread.CreateAnonymousThread(
      procedure
      begin

        CoInitialize(nil);
        try
        while not TThread.CheckTerminated do
        begin
          try
             ProcessarEmpresas;
          except on E: Exception do
            raise Exception.Create('Ocorreu um Erro!' + E.Message);
          end;

          {$IFDEF RELEASE}
            TThread.Sleep(10 * 60 * 1000); // 10 Minutos
          {$ELSE}
            TThread.Sleep(5000); // 5 segundos
          {$ENDIF}

        end;
        finally
         CoUninitialize;
        end;
      end
    );

    FThread.FreeOnTerminate := False;
    FThread.Start;

  {$IFDEF CONSOLE}
    Writeln('Sincronização de DFe Iniciado.');
  {$ENDIF}
end;

procedure TWorkerSincronizacaoDFe.Parar;
begin
   if Assigned(FThread) then
   begin
      FThread.Terminate;
      FThread.WaitFor;
      FreeAndNil(FThread);
      {$IFDEF CONSOLE}
      Writeln('Worker de Sincronizacao DFe Parado.');
      {$ENDIF}
   end;
end;

class procedure TWorkerSincronizacaoDFe.ProcessarEmpresas;
var
  lEmpresas : TArray<TEmpresa>;
  lEmpresa : TEmpresa;
  lService : TServiceNotasDestinadas;
begin
  lEmpresas := TDAOEmpresa.BuscarEmpresasPendentesDFe;

  if Length(lEmpresas) = 0 then Exit;

  lService := TServiceNotasDestinadas.Create;

  try
    for lEmpresa in lEmpresas do
    begin
      try
        try
          lService.SincronizarSefaz(lEmpresa.BusinessId, lEmpresa.Cnpj, lEmpresa.LastNSU);
        except on E: Exception do
        begin
          // Colocar um LOG depois
        end;
        end;
      finally
        // Precisa dar o Free aqui pois lá no DAO eu crio ele e precisa ser liberado.
        TDAOEmpresa.AtualizarDataConsulta(lEmpresa.BusinessId);
        lEmpresa.Free;
      end;
    end;

  finally
     lService.Free;
  end;
end;

end.
