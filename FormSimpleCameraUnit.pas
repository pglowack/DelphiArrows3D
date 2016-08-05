unit FormSimpleCameraUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Viewport3D,
  System.Math.Vectors, FMX.Types3D, FMX.Controls3D, FMX.Objects3D,
  FMX.MaterialSources, FMX.Gestures;

type
  TFormSimpleCamera = class(TForm)
    Viewport3DMain: TViewport3D;
    DummyScene: TDummy;
    DummyXY: TDummy;
    CameraZ: TCamera;
    LightCamera: TLight;
    GestureManager1: TGestureManager;
    MaterialSourceY: TLightMaterialSource;
    MaterialSourceZ: TLightMaterialSource;
    MaterialSourceX: TLightMaterialSource;
    CylX: TCylinder;
    ConeX: TCone;
    CylY: TCylinder;
    ConeY: TCone;
    CylZ: TCylinder;
    ConeZ: TCone;
    procedure Viewport3DMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Viewport3DMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure Viewport3DMainMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure FormGesture(Sender: TObject;
      const [Ref] EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    FDown: TPointF;
    FLastDistance: integer;
    procedure DoZoom(aIn: boolean);
  public
    { Public declarations }
  end;

var
  FormSimpleCamera: TFormSimpleCamera;

implementation

{$R *.fmx}

const
  ROTATION_STEP = 0.3;
  ZOOM_STEP = 2;
  CAMERA_MAX_Z = -2;
  CAMERA_MIN_Z = -102;

procedure TFormSimpleCamera.DoZoom(aIn: boolean);
var newZ: single;
begin
  if aIn then
    newZ := CameraZ.Position.Z + ZOOM_STEP
  else
    newZ := CameraZ.Position.Z - ZOOM_STEP;

  if (newZ < CAMERA_MAX_Z) and (newZ > CAMERA_MIN_Z) then
    CameraZ.Position.Z := newZ;
end;

procedure TFormSimpleCamera.FormGesture(Sender: TObject;
  const [Ref] EventInfo: TGestureEventInfo; var Handled: Boolean);
var delta: integer;
begin
  if EventInfo.GestureID = igiZoom then
  begin
    if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
    begin
      delta := EventInfo.Distance - FLastDistance;
      DoZoom(delta > 0);
    end;
    FLastDistance := EventInfo.Distance;
  end;
end;

procedure TFormSimpleCamera.Viewport3DMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  FDown := PointF(X, Y);
end;

procedure TFormSimpleCamera.Viewport3DMainMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  if (ssLeft in Shift) then
  begin
    DummyXY.RotationAngle.X := DummyXY.RotationAngle.X - ((Y - FDown.Y) * ROTATION_STEP);
    DummyXY.RotationAngle.Y := DummyXY.RotationAngle.Y + ((X - FDown.X) * ROTATION_STEP);
    FDown := PointF(X, Y);
  end;
end;

procedure TFormSimpleCamera.Viewport3DMainMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  DoZoom(WheelDelta > 0);
end;

end.
