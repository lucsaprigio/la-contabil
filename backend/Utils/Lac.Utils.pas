unit Lac.Utils;

interface

uses
 System.SysUtils, System.IOUtils, System.DateUtils;

type
  TLacUtils = class
    class function IsValidID(const AValue: string): Boolean;
    class function NewIDString: string;
    class function CleanID(const AValue: string): string;
    class procedure GeraLog(aLog: String);
  end;

implementation

{ TLacUtils }

class function TLacUtils.CleanID(const AValue: string): string;
begin
  Result := AValue.Replace('{', '').Replace('}', '');
end;

class procedure TLacUtils.GeraLog(aLog: String);
var
  LogPath : string;
  LogFolder : string;
  MsgFormatada : String;
begin
  LogFolder := TPath.Combine(ExtractFilePath(ParamStr(0)), 'logs');
  LogPath   := TPath.Combine(LogFolder, 'log.txt');

  if not TDirectory.Exists(LogFolder) then
     TDirectory.CreateDirectory(LogFolder);


  MsgFormatada := Format('[%s] %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), aLog]);
  TFile.AppendAllText(LogPath, MsgFormatada + sLineBreak, TEncoding.UTF8);
end;

class function TLacUtils.IsValidID(const AValue: string): Boolean;
var
  LCleanID        : string;
  LGUIDValidation : TGUID;
begin
  LCleanID := CleanID(AValue);
   try
     LGUIDValidation := StringToGUID('{' + LCleanID + '}');
     Result := True;
   except
     Result := False;
   end;
end;

class function TLacUtils.NewIDString: string;
var
  LGUID: TGUID;
begin
  CreateGUID(LGUID);
  Result := CleanID(GUIDToString(LGUID));
end;

end.
