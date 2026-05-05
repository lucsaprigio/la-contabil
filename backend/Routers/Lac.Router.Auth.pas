unit Lac.Router.Auth;

interface

uses
  Horse, Lac.Controller.Auth;

  procedure Registry;

implementation

procedure Registry;
begin
  THorse.Post('/api/login', TControllerAuth.Login);
end;

end.
