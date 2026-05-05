unit Lac.Router.NotasSaidas;

interface

uses
  Horse, Lac.Controller.Empresa, Lac.Controller.NFSaida;

procedure Registry;

implementation

procedure Registry;
begin
    THorse.Get('/api/nfe/saida/:businessId/buscar', TLacControllerNFSaida.GetBuscarNFSaida);
    THorse.Get('/api/nfe/saida/:businessId/listar', TLacControllerNFSaida.GetListarNFSaida);
    THorse.Post('/api/nfe/saida', TLacControllerNFSaida.PostSalvarNFSaida);
end;

end.
