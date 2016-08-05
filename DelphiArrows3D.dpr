program DelphiArrows3D;

uses
  System.StartUpCopy,
  FMX.Forms,
  FormSimpleCameraUnit in 'FormSimpleCameraUnit.pas' {FormSimpleCamera};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormSimpleCamera, FormSimpleCamera);
  Application.Run;
end.
