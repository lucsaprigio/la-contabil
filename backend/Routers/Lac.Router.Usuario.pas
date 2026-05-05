unit Lac.Router.Usuario;

interface

uses
  Horse, Horse.JWT,
  Lac.Controller.Usuario, Lac.Utils.Configuracao;

procedure Registry;

implementation

procedure Registry;
begin
  THorse.Use(HorseJWT(TAppConfig.JWT_SECRET, THorseJWTConfig.New.SkipRoutes(['/api/login', '/api/user'])));

  THorse.Get('/api/user/:id', TControllerUsuario.GetUsuarioPorID);
  THorse.Post('/api/user', TControllerUsuario.PostNewUser);
  THorse.Put('/api/user/:id', TControllerUsuario.PutUpdateUser);
  THorse.Delete('/api/user/:id', TControllerUsuario.DeleteUser);
end;

end.
