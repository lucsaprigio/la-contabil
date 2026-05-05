unit Model.Entity.Usuario;

interface

uses
  System.StrUtils, System.SysUtils;

type
  TUser = class
  private
    FUserId: String;
    FUsername: String;
    FEmail: String;
    FPassword: String;
    procedure SetUserId(const Value: String);
  public

    property UserId: String read FUserId write SetUserId;
    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
    property Email: String read FEmail write FEmail;
  end;

implementation

{ TUser }

procedure TUser.SetUserId(const Value: String);
begin
  if Value.Trim = '' then begin
    FUserId := '';
    Exit;
  end;

  FUserId := Value.Replace('{', '').Replace('}', '');
end;

end.
