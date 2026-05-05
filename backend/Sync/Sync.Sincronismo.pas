unit Sync.Sincronismo;

interface

uses
  Sync.SincronizacaoDfe, Sync.Interfaces;

type
  ISincronizador = interface
    ['{D1AA5698-4AA4-4AE7-B723-7FB284AC1EAD}']
    procedure GerarRotinas;
    procedure PararRotinas;
  end;

  TSincronizador = class(TInterfacedObject, ISincronizador)
  private
    FSincronizadorDFe : ISyncJob;
  public
    constructor Create;
    destructor Destroy; override;

    class function New: ISincronizador;

    procedure GerarRotinas;
    procedure PararRotinas;
  end;

implementation

{ TSincronizador }

{ TSincronizador }

constructor TSincronizador.Create;
begin
   FSincronizadorDFe := TWorkerSincronizacaoDFe.Create;
end;

destructor TSincronizador.Destroy;
begin

  inherited;
end;

class function TSincronizador.New: ISincronizador;
begin
   Result := Self.Create;
end;

procedure TSincronizador.GerarRotinas;
begin
    FSincronizadorDFe.Iniciar;
end;


procedure TSincronizador.PararRotinas;
begin
   FSincronizadorDFe.Parar;
end;

end.
