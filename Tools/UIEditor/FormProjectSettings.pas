unit FormProjectSettings;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TProjectSettingsForm = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProjectSettingsForm: TProjectSettingsForm;

implementation

{$R *.dfm}

procedure TProjectSettingsForm.Button1Click(Sender: TObject);
begin
  Self.Close;
end;

end.
