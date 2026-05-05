unit Lac.Router.UsuarioEmpresa;

interface

uses
  Horse, Lac.Controller.UsuarioEmpresa;

procedure Registry;

implementation

procedure Registry;
begin
  THorse.Get('/api/user_business/:id', TLacControllerUsuarioEmpresa.GetBuscarUsuarioEmpresa);
  THorse.Post('/api/user_business', TLacControllerUsuarioEmpresa.PostNovoUsuarioEmpresa);
  THorse.Delete('/api/user_business/:userId/:businessId', TLacControllerUsuarioEmpresa.DeleteUsuarioEmpresa);
end;

end.
