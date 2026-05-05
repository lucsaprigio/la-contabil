unit Model.Entity.UsuarioEmpresa;

interface

uses Lac.Utils, System.StrUtils, System.SysUtils;

type
  TUsuarioEmpresa = class
  private
    FUserId: String;
    FBusinessId: String;
    FRoleName: String;

    constructor Create;
    procedure SetBusinessId(const Value: String);
    procedure SetUserId(const Value: String);

    public
    class function New: TUsuarioEmpresa;

    property UserId: String read FUserId write SetUserId;
    property BusinessId: String read FBusinessId write SetBusinessId;
    property RoleName: String read FRoleName write FRoleName;
  end;

implementation

{ TUsuarioEmpresa }

constructor TUsuarioEmpresa.Create;
begin
 inherited Create;
end;

class function TUsuarioEmpresa.New: TUsuarioEmpresa;
begin
  Result := TUsuarioEmpresa.Create;
end;

procedure TUsuarioEmpresa.SetBusinessId(const Value: String);
begin
  if Trim(Value) = '' then begin
     FBusinessId := '';
     Exit;
  end;

  FBusinessId := TLacUtils.CleanID(Value);
end;

procedure TUsuarioEmpresa.SetUserId(const Value: String);
begin
  if Trim(Value) = '' then begin
    FUserId := '';
    Exit;
  end;

  FUserId := TLacUtils.CleanID(Value);
end;

end.
