unit Lac.UserAuth.Response;

interface

uses
  REST.Json.Types;

type
  TDTOUserAuthResponse = class
     private
      [JSONName('userId')]
      FUserId: String;
      [JSONName('token')]
      FToken: String;
      [JSONName('username')]
      FUsername: String;
     published
      property UserId: String read FUserId write FUserId;
      property Token: String read FToken write FToken;
      property Username: String read FUsername write FUsername;
  end;

implementation

end.
