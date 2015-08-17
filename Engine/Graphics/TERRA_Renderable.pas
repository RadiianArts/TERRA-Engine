Unit TERRA_Renderable;

{$I terra.inc}

Interface
Uses TERRA_Object, TERRA_String, TERRA_Utils, TERRA_Vector3D, TERRA_BoundingBox, TERRA_Renderer,
  TERRA_Viewport, TERRA_Collections, TERRA_List;

Const
  renderFlagsSkipFrustum  = 1;
  renderFlagsSkipSorting  = 2;
  renderFlagsSkipReflections  = 4;

  renderBucket_Opaque       = 1;
  renderBucket_Translucent  = 2;
  renderBucket_Sky          = 4;
  renderBucket_Reflections  = 8;
  renderBucket_Occluder     = 16;

Type
  RenderableManager = Class;

  TERRARenderable = Class(TERRAObject)
    Protected
      _Manager:RenderableManager;
      _RenderFlags:Cardinal;

      _LastUpdate:Cardinal;

      _Distance:Single;
      //_WasVisible:Boolean;

//      _IsReflection:Boolean;
    Public
{      ReflectionPoint:Vector3D;
      ReflectionNormal:Vector3D;}

      Procedure Release; Override;

      Function SortID:Integer; Override;

      Procedure Update(View:TERRAViewport); Virtual;

      Function GetName():TERRAString; Virtual;

      Function GetRenderBucket:Cardinal; Virtual;

      Function GetBoundingBox:BoundingBox; Virtual; Abstract;
      Procedure Render(View:TERRAViewport; Const Bucket:Cardinal); Virtual; Abstract;

      Procedure RenderLights(View:TERRAViewport); Virtual;

      //Property WasVisible:Boolean Read _WasVisible;

      Property RenderFlags:Cardinal Read _RenderFlags;
  End;

  RenderableManager = Class(TERRAObject)
    Protected
      _BucketSky:List;
      _BucketOpaque:List;
      _BucketAlpha:List;
      {$IFDEF REFLECTIONS_WITH_STENCIL}
      _BucketReflection:List;
      {$ENDIF}

      Procedure RenderList(View:TERRAViewport; RenderList:List; Const Bucket:Cardinal);

    Public
      Constructor Create();
      Procedure Release(); Override;

      Procedure Render(View:TERRAViewport);
      Procedure Clear();

      Function AddRenderable(View:TERRAViewport; Renderable:TERRARenderable):Boolean;
      Procedure DeleteRenderable(MyRenderable:TERRARenderable);
  End;


Implementation
Uses TERRA_GraphicsManager, TERRA_Decals, TERRA_Billboards;

{ TERRARenderable }
Procedure TERRARenderable.Release;
Begin
  If Assigned(_Manager) Then
    _Manager.DeleteRenderable(Self);
End;

Function TERRARenderable.GetName:TERRAString;
Begin
  Result := Self.ClassName + '_'+HexStr(Cardinal(Self));
End;

Procedure TERRARenderable.RenderLights;
Begin
  // do nothing
End;

Procedure TERRARenderable.Update(View:TERRAViewport);
Begin
  // do nothing
End;

Function TERRARenderable.GetRenderBucket:Cardinal;
Begin
  Result := 0;
End;

Function TERRARenderable.SortID:Integer;
Begin
  Result := Trunc(Self._Distance);
End;

{ RenderableManager }
Constructor RenderableManager.Create();
Begin
  _BucketSky := List.Create(collection_Sorted_Descending);
  _BucketOpaque := List.Create(collection_Sorted_Ascending);
  _BucketAlpha :=  List.Create(collection_Sorted_Descending);

  {$IFDEF REFLECTIONS_WITH_STENCIL}
  _BucketReflection := List.Create(coAppend);
  {$ENDIF}
End;


Procedure RenderableManager.RenderList(View:TERRAViewport; RenderList:List; Const Bucket:Cardinal);
Var
  P:TERRACollectionObject;
  Renderable:TERRARenderable;
Begin
  {$IFDEF DEBUG_GRAPHICS}Log(logDebug, 'GraphicsManager', 'Rendering bucket'); {$ENDIF}

  P := RenderList.First;
  While (Assigned(P)) Do
  Begin
    {$IFDEF DEBUG_GRAPHICS}Log(logDebug, 'GraphicsManager', 'Fetching next...');{$ENDIF}
    {$IFDEF DEBUG_GRAPHICS}Log(logDebug, 'GraphicsManager', P.ToString());{$ENDIF}

    Renderable := TERRARenderable(P.Item);
    If (Assigned(Renderable)) Then
    Begin
      If (Not GraphicsManager.Instance.ReflectionActive) Or (Renderable.RenderFlags And renderFlagsSkipReflections=0) Then
        Renderable.Render(View, Bucket);
    End;

    P := P.Next;
  End;
End;

Procedure RenderableManager.Render(View:TERRAViewport);
Begin
  RenderList(View, _BucketSky, renderBucket_Sky);

  {$IFNDEF DEBUG_REFLECTIONS}

{$IFDEF ADVANCED_ALPHA_BLEND}
  If Pass = captureTargetAlpha Then
  Begin
    RenderList(_BucketOpaque, False);
    RenderList(_BucketAlpha, True)
  End Else
  Begin
    RenderList(_BucketOpaque, False);

    If (_RenderStage <> renderStageNormal) Then
    Begin
      {$IFDEF DEBUG_GRAPHICS}Log(logDebug, 'GraphicsManager', 'Scene.RenderDecals');{$ENDIF}
      DecalManager.Instance.Render();

      {$IFDEF DEBUG_GRAPHICS}Log(logDebug, 'GraphicsManager', 'Scene.RenderBillboards');{$ENDIF}
      BillboardManager.Instance.Render();
    End;
  End;
{$ELSE}
    RenderList(View, _BucketOpaque, renderBucket_Opaque);

    If (GraphicsManager.Instance.RenderStage <> renderStageNormal) Then
    Begin
      {$IFDEF DEBUG_GRAPHICS}Log(logDebug, 'GraphicsManager', 'Scene.RenderDecals');{$ENDIF}
      DecalManager.Instance.Render(View);

      {$IFDEF DEBUG_GRAPHICS}Log(logDebug, 'GraphicsManager', 'Scene.RenderBillboards');{$ENDIF}
      BillboardManager.Instance.Render(View);
    End;

    {$IFDEF DEBUG_GRAPHICS}Log(logDebug, 'GraphicsManager', 'Scene.RenderAlphaBucket');{$ENDIF}
    RenderList(View, _BucketAlpha, renderBucket_Opaque);
    {$ENDIF}
{$ENDIF}
End;

Procedure RenderableManager.DeleteRenderable(MyRenderable:TERRARenderable);
Begin
  _BucketSky.Remove(MyRenderable);
  _BucketOpaque.Remove(MyRenderable);
  _BucketAlpha.Remove(MyRenderable);
  {$IFDEF REFLECTIONS_WITH_STENCIL}
  _BucketReflection.Remove(MyRenderable);
  {$ENDIF}
End;

Procedure RenderableManager.Clear;
Begin
  _BucketSky.Clear();
  _BucketOpaque.Clear();
  _BucketAlpha.Clear();
End;


Function RenderableManager.AddRenderable(View:TERRAViewport; Renderable:TERRARenderable):Boolean;
Const
  LODS:Array[0..MaxLODLevel] Of Single = (0.0, 0.4, 0.8, 1.0);
Var
  Box:BoundingBox;
  Pos:Vector3D;
  I:Integer;
  FarDist:Single;
  Unsorted:Boolean;
  Graphics:GraphicsManager;
  Bucket:Cardinal;
Begin
  If Not Assigned(Renderable) Then
  Begin
    Result := False;
    Exit;
  End;

  Unsorted := (Renderable.RenderFlags And renderFlagsSkipSorting<>0);
  Bucket := Renderable.GetRenderBucket();

  Renderable._Manager := Self;

  {$IFDEF REFLECTIONS_WITH_STENCIL}
  If (_RenderStage = renderStageReflection) Then
  Begin
    _BucketReflection.Add(Renderable);
    Exit;
  End;
  {$ENDIF}

  Graphics := GraphicsManager.Instance;

  If (Graphics.RenderStage <> renderStageDiffuse) Then
  Begin
    DebugBreak;
    //MyTERRARenderable.Render(View, Bucket);
    Result := True;
    Exit;
  End;

//Log(logDebug, 'GraphicsManager', 'Rendering lights...');
//Log(logDebug, 'GraphicsManager', 'Class: '+MyTERRARenderable.ClassName);

  If (Graphics.Renderer.Settings.DynamicLights.Enabled) Then
    Renderable.RenderLights(View);

  If (Renderable._LastUpdate <> Graphics.FrameID) Then
  Begin
    Renderable._LastUpdate := Graphics.FrameID;
    Renderable.Update(View);
  End;

  If (Bucket And renderBucket_Sky = 0)  Then
  Begin
    // frustum test
    Box := Renderable.GetBoundingBox;
    If (Renderable.RenderFlags And renderFlagsSkipFrustum=0) And (Not Graphics.IsBoxVisible(View, Box)) Then
    Begin
      //MyTERRARenderable._WasVisible := False;
      Result := False;
      Exit;
    End;

    //MyTERRARenderable._WasVisible := True;

    Pos := VectorAdd(Box.Center , VectorScale(View.Camera.View, -Box.Radius));
    Renderable._Distance := Pos.Distance(View.Camera.Position);

    FarDist := View.Camera.FarDistance;

    (*For I:=1 To MaxLODLevel Do
    If (MyTERRARenderable._Distance < LODS[I]*FarDist) Then
    Begin
      MyTERRARenderable._LOD := Pred(I) + ((MyTERRARenderable._Distance - (LODS[Pred(I)]*FarDist)) / ((LODS[I] - LODS[Pred(I)])*FarDist));
      Break;
    End Else
    If (I >= MaxLODLevel) Then
      MyTERRARenderable._LOD := MaxLODLevel;*)
  End;

  Graphics.Renderer.InternalStat(statRenderables);

  If (Bucket And renderBucket_Translucent<>0) Then
    _BucketAlpha.Add(Renderable);

  If (Bucket And renderBucket_Opaque<>0) Then
    _BucketOpaque.Add(Renderable);

  If (Bucket And renderBucket_Sky<>0) Then
    _BucketSky.Add(Renderable);

  Result := True;
End;

procedure RenderableManager.Release;
begin
  ReleaseObject(_BucketSky);
  ReleaseObject(_BucketOpaque);
  ReleaseObject(_BucketAlpha);
  {$IFDEF REFLECTIONS_WITH_STENCIL}
  ReleaseObject(_BucketReflection);
  {$ENDIF}
End;


End.
