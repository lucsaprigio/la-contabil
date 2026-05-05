unit Lac.Router.Clientes;

interface

uses
  Horse, Lac.Controller.Clientes;

procedure Registry;

implementation

procedure Registry;
begin
  THorse.Get('/api/clientes/:businessId', TLacControllerClientes.GetListarClientes);
  THorse.Get('/api/clientes/:businessId/:id/buscar', TLacControllerClientes.GetBuscarCliente);

  THorse.Post('/api/clientes', TLacControllerClientes.PostSalvarCliente);
  THorse.Put('/api/clientes/:businessId/:id', TLacControllerClientes.PutAtualizarCliente);
end;

end.
