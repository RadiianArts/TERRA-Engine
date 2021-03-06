Unit TERRA_GLCustomRenderer;

{$I terra.inc}

{$IFDEF WINDOWS}
{-$DEFINE DEBUG_GL}
{$DEFINE DEBUG_SHADERS}
{$ENDIF}

(*Procedure MeshGroup.SetCombineWithColor(C:Color);
Var
  CC:Array[0..3] Of Single;
Begin
  {$IFDEF PC}
  glActiveTexture(GL_TEXTURE0);
  glEnable(GL_TEXTURE_2D);
  glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE );

  glTexEnvi( GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PRIMARY_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE0);
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR );
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);

  glTexEnvi( GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PRIMARY_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE0);
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);

  TextureManager.Instance.WhiteTexture.Bind(1);
  glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE );

  CC[0] := C.R/255;
  CC[1] := C.G/255;
  CC[2] := C.B/255;
  CC[3] := C.A/255;
  glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, @CC);

  glTexEnvi( GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PREVIOUS);
  glTexEnvi( GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_CONSTANT );
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_CONSTANT);

  glTexEnvi( GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PREVIOUS);
  glTexEnvi( GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_CONSTANT );
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_CONSTANT);

   {$ENDIF}
End;

Procedure SpriteBatch.SetupSaturationCombiners(Var Slot:Integer);
Var
  Values:Array[0..3] Of Single;
Begin
  Slot := 0;
{$IFDEF PC}
  Values[0] := 0.30;
  Values[1] := 0.59;
  Values[2] := 0.11;
  Values[3] := 1.0;

  glActiveTexture(GL_TEXTURE0);
  glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE );
  glTexEnvi( GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PRIMARY_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE);
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR );
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);

  glTexEnvi( GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PRIMARY_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE);
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
  glTexEnvi( GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);

  Inc(Slot);
  TextureManager.Instance.WhiteTexture.Bind(Slot);
  glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE );
  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_DOT3_RGB);
  glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB, GL_PREVIOUS);
  glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB, GL_CONSTANT);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_ONE_MINUS_SRC_COLOR);
  glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, @Values);

  If (_Saturation<=0) Then
    Exit;

  If (GraphicsManager.Instance.Renderer.Features.MaxTextureUnits>3) Then
  Begin
    Values[0] := 0.5;
    Values[1] := Values[0];
    Values[2] := Values[0];
    Values[3] := Values[0];
    Inc(Slot);
    TextureManager.Instance.WhiteTexture.Bind(Slot);
    glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE );
    glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_ADD);
    glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB, GL_PREVIOUS);
    glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB, GL_CONSTANT);
    glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
    glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, @Values);
  End;

  If (GraphicsManager.Instance.Renderer.Features.MaxTextureUnits>2) Then
  Begin
    Values[0] := _Saturation;
    Values[1] := Values[0];
    Values[2] := Values[0];
    Values[3] := Values[0];

    Inc(Slot);
    TextureManager.Instance.WhiteTexture.Bind(Slot);
    glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, @Values);
    glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE );
    glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_INTERPOLATE);
    glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB, GL_TEXTURE0);
    glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB, GL_PREVIOUS);
    glTexEnvi(GL_TEXTURE_ENV, GL_SRC2_RGB, GL_CONSTANT);
    glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
    glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
    glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND2_RGB, GL_SRC_COLOR);
  End;
{$ENDIF}
End;

*)

Interface
Uses
  TERRA_Object, TERRA_String, TERRA_Utils, TERRA_Stream, TERRA_Renderer, TERRA_VertexFormat,
  {$IFDEF DEBUG_GL}TERRA_DebugGL{$ELSE}TERRA_OpenGL{$ENDIF},
  TERRA_Color, TERRA_Image, TERRA_Vector2D, TERRA_Vector3D, TERRA_Vector4D,
  TERRA_Matrix3x3, TERRA_Matrix4x4,
  TERRA_OpenGLCommon;

Type
  OpenGLFeatures = Class(RendererFeatures)
    Public
      Constructor Create(Owner:GraphicsRenderer);
  End;

  OpenGLTexture = Class(TextureInterface)
    Protected
      _Handle:Cardinal;
      _ShouldGenMips:Boolean;

    Public
      Function Generate(Pixels:Pointer; Width, Height:Integer; SourceFormat, TargetFormat:TextureColorFormat; ByteFormat:PixelSizeType):Boolean; Override;
      Procedure Release(); Override;

      Function Bind(Slot:Integer):Boolean; Override;

      Procedure SetFilter(Value:TextureFilterMode); Override;
      Procedure SetWrapMode(Value:TextureWrapMode); Override;
      Procedure SetMipMapping(Value:Boolean); Override;

      Function Update(Pixels:Pointer; X,Y, Width, Height:Integer):Boolean; Override;

      Function GetImage():TERRAImage; Override;

      Procedure Invalidate(); Override;
  End;

  OpenGLCubeMap = Class(CubeMapInterface)
    Protected
      _Handle:Cardinal;
      _ShouldGenMips:Boolean;

    Public
      Procedure Release(); Override;

      Function Bind(Slot:Integer):Boolean; Override;

      Procedure SetFilter(Value:TextureFilterMode); Override;
      Procedure SetWrapMode(Value:TextureWrapMode); Override;
      Procedure SetMipMapping(Value:Boolean); Override;

      Function Generate(Width, Height:Integer; SourceFormat, TargetFormat:TextureColorFormat; ByteFormat:PixelSizeType):Boolean; Override;

      Function UpdateFace(FaceID:Integer; Pixels:Pointer; X,Y, Width, Height:Integer):Boolean; Override;

      Procedure Invalidate(); Override;
  End;

  OpenGLFBO = Class(RenderTargetInterface)
    Protected
	    _Handle:Cardinal;
	    _mfb:Cardinal;
	    _color_rb:Cardinal;
	    _depth_rb:Cardinal;
      _stencil_rb:Cardinal;
  	  _targets:Array Of Cardinal;
      _targetCount:Integer;
	    _internalformat:Cardinal;
	    _multisample:Boolean;
      _drawBuffers:Array Of Cardinal;
      _hasDepthBuffer:Boolean;
      _hasStencilBuffer:Boolean;
      _Shared:Boolean;

	    _type:PixelSizeType;

      _Complete:Boolean;

  	  // Create a render texture
	    Function Init():Boolean;

      Function GetErrorString(Code:Cardinal):TERRAString;

      Function GetOrigin: SurfaceOrigin; Override;

    Public
      Function Generate(Width, Height:Integer; MultiSample:Boolean; PixelSize:PixelSizeType; TargetCount:Integer; DepthBuffer, StencilBuffer:Boolean):Boolean; Override;

  	  // Free OpenGL memory
	    Procedure Release(); Override;

      Function Bind(Slot:Integer):Boolean; Override;

      Procedure SetFilter(Value:TextureFilterMode); Override;
      Procedure SetWrapMode(Value:TextureWrapMode); Override;
      Procedure SetMipMapping(Value:Boolean); Override;

	    // Render to this target
	    Procedure BeginCapture(Flags:Cardinal = clearAll); Override;
	    Procedure EndCapture; Override;

      Procedure Resize(NewWidth, NewHeight:Integer); Override;

      Function GetImage():TERRAImage; Override;
      Function GetPixel(X,Y:Integer):ColorRGBA; Override;

      Procedure Invalidate(); Override;

      Property Handle:Cardinal Read _Handle;
  End;

  CustomOpenGLRenderer = Class(GraphicsRenderer)
    Protected
      _HasContext:Boolean;

      _ClearColor:ColorRGBA;

      _UsedTextures:Array[0..Pred(MaxTextureHandles)] Of Boolean;
      _UsedFrameBuffers:Array[0..Pred(MaxFrameBufferHandles)] Of Boolean;
      _UsedRenderBuffers:Array[0..Pred(MaxFrameBufferHandles)] Of Boolean;

      Function GenerateTexture():Cardinal;
      Function GenerateFrameBuffer():Cardinal;
      Function GenerateRenderBuffer():Cardinal;

      Procedure DeleteTexture(Var Handle:Cardinal);
      Procedure DeleteFrameBuffer(Var Handle:Cardinal);
      Procedure DeleteRenderBuffer(Var Handle:Cardinal);

      Function Initialize():Boolean; Override;

      Procedure ApplyTextureFilter(Handle, TextureKind:Integer; MipMapped, ShouldGenMips:Boolean; Filter:TextureFilterMode);
      Procedure ApplyTextureWrap(Handle, TextureKind:Integer; WrapMode:TextureWrapMode);

    Public
      Procedure ResetState(); Override;
      Procedure BeginFrame(); Override;

      Function GetScreenshot():TERRAImage; Override;

      Function CreateTexture():TextureInterface; Override;
      Function CreateCubeMap():CubeMapInterface; Override;
      Function CreateVertexBuffer():VertexBufferInterface; Override;
      Function CreateShader():ShaderInterface; Override;
      Function CreateRenderTarget():RenderTargetInterface; Override;

      Procedure ClearBuffer(Color, Depth, Stencil:Boolean); Override;
      Procedure SetClearColor(Const ClearColor:ColorRGBA); Override;

      Procedure SetStencilTest(Enable:Boolean); Override;
      Procedure SetStencilFunction(Mode:CompareMode; StencilID:Cardinal; Mask:Cardinal = $FFFFFFFF); Override;
      Procedure SetStencilOp(fail, zfail, zpass:StencilOperation); Override;

      Procedure SetColorMask(Red, Green, Blue, Alpha:Boolean); Override;

      Procedure SetDepthMask(WriteZ:Boolean); Override;
      Procedure SetDepthTest(Enable:Boolean); Override;
      Procedure SetDepthFunction(Mode:CompareMode); Override;

      Procedure SetCullMode(Mode:CullMode); Override;

      Procedure SetBlendMode(BlendMode:Integer); Override;

      Procedure SetProjectionMatrix(Const Mat:Matrix4x4); Override;
      Procedure SetModelMatrix(Const Mat:Matrix4x4);  Override;
      Procedure SetTextureMatrix(Const Mat:Matrix4x4); Override;

      Procedure SetScissorState(Enabled:Boolean); Override;
      Procedure SetScissorArea(X,Y, Width, Height:Integer); Override;

      Procedure SetViewport(X,Y, Width, Height:Integer); Override;

      Procedure SetAttributeSource(Const Name:TERRAString; AttributeKind:Cardinal; ElementType:DataFormat; AttributeSource:Pointer); Override;

      Procedure SetDiffuseColor(Const C:ColorRGBA); Override;

      Procedure DrawSource(Primitive:RenderPrimitive; Count:Integer); Override;
      Procedure DrawIndexedSource(Primitive:RenderPrimitive; Count:Integer; Indices:System.PWord); Override;

    Public

  End;

Implementation
Uses SysUtils, TERRA_Engine, TERRA_Log, TERRA_Application, TERRA_GraphicsManager, TERRA_Error, TERRA_OS, TERRA_Texture, TERRA_RendererStats;

{ OpenGLFeatures }
Constructor OpenGLFeatures.Create(Owner:GraphicsRenderer);
Var
  HasShaders:Boolean;
  S:AnsiString;
Begin
  Inherited Create(Owner);

  glGetIntegerv(GL_MAX_TEXTURE_UNITS, @_MaxTextureUnits);

  glGetIntegerv(GL_MAX_TEXTURE_SIZE, @_MaxTextureSize);

  glGetIntegerv(GL_MAX_COLOR_ATTACHMENTS, @_maxRenderTargets);

{$IFDEF PC}
  If (glExtensionSupported('GL_EXT_texture_filter_anisotropic')) Then
  Begin
    glGetIntegerv(GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT, @_maxAnisotrophy);
  End Else
{$ENDIF}
    _maxAnisotrophy := 0;

  If (glExtensionSupported('GL_ARB_multisample')) Then
    _multiSampleCount := 4
  Else
    _multiSampleCount := 0;

  _VertexCacheSize := 32;

(*  _Vendor := UpStr(_Vendor);
  If Pos('INTEL', _Vendor)>0 Then
    _Vendor := 'INTEL'
  Else
  If Pos('NVIDIA', _Vendor)>0 Then
    _Vendor := 'NVIDIA'
  Else
  If (Pos('ATI', _Vendor)>0) Or (Pos('AMD', _Vendor)>0) Then
    _Vendor := 'ATI';*)

  {$IFDEF PC}
	TextureCompression.Avaliable :=  glExtensionSupported('GL_EXT_texture_compression_s3tc');
  {$ELSE}
  TextureCompression.Avaliable :=  False;
  {$ENDIF}

  {$IFDEF PC}
	HasShaders := (glExtensionSupported('GL_ARB_vertex_shader')) And (glExtensionSupported('GL_ARB_fragment_shader'));
//  HasShaders := HasShaders And (Pos('MESA', _Vendor)<=0);
  {$ELSE}

{$IFDEF IPHONE}
  HasShaders := shadersAvailable();
{$ELSE}
  HasShaders := True;
{$ENDIF}
  {$ENDIF}

  {$IFDEF DISABLESHADERS}
  HasShaders := False;
  {$ENDIF}

  Shaders.Avaliable := HasShaders;

  VertexBufferObject.Avaliable := glExtensionSupported('GL_ARB_vertex_buffer_object');

  {$IFDEF FRAMEBUFFEROBJECTS}
  FrameBufferObject.Avaliable := glExtensionSupported('GL_ARB_framebuffer_object') Or glExtensionSupported('GL_EXT_framebuffer_object');
  {$ELSE}
  FrameBufferObject.Avaliable := False;
  {$ENDIF}


  {$IFDEF POSTPROCESSING}
  PostProcessing.Avaliable := (FrameBufferObject.Avaliable) And (MaxRenderTargets>=4);
  {$ELSE}
  PostProcessing.Avaliable := False;
  {$ENDIF}

  CubeMapTexture.Avaliable := glExtensionSupported('GL_ARB_texture_cube_map');
  SeparateBlends.Avaliable := glExtensionSupported('GL_EXT_draw_buffers2');
  SeamlessCubeMap.Avaliable := glExtensionSupported('GL_ARB_seamless_cube_map') Or glExtensionSupported('GL_AMD_seamless_cubemap_per_texture');

  NPOT.Avaliable := glExtensionSupported('GL_ARB_texture_non_power_of_two');//OES_texture_npot

  PackedStencil.Avaliable := True;

  (*glGetIntegerv(GL_MAX_VERTEX_UNIFORM_COMPONENTS, @_MaxUniformVectors);
  If (_MaxUniformVectors<128) Then
    VertexBufferObject.Avaliable := False;     *)

  TextureArray.Avaliable := glExtensionSupported('GL_EXT_texture_array');

  FloatTexture.Avaliable := glExtensionSupported('GL_ARB_color_buffer_float') Or
                            glExtensionSupported('GL_ATI_pixel_format_float') Or
                            glExtensionSupported('GL_NV_float_buffer');

  DeferredLighting.Avaliable := (MaxRenderTargets>=4) And (FrameBufferObject.Avaliable);

  StencilBuffer.Avaliable := True;

(*  {$IFDEF IPHONE}
  DynamicShadows.Avaliable := glExtensionSupported('GL_OES_packed_depth_stencil') Or glExtensionSupported('GL_OES_stencil8');
  {$ELSE}
  DynamicShadows.Avaliable := True;
  {$ENDIF}

  _Settings.DeferredLighting._Enabled := _Settings.DeferredLighting._Avaliable;
  _Settings.DeferredFog._Enabled := True;
  _Settings.DeferredShadows._Enabled := True;
  _Settings.FogMode := 0;

  _Settings.DynamicShadows._Enabled := False;

  _Settings.DynamicShadows._Quality := qualityMedium;
  _Settings.Textures._Quality := qualityMedium;

  _Settings.DepthOfField._Avaliable := True;
  _Settings.DepthOfField._Enabled := True;

  _Settings.NormalMapping._Avaliable := True;
  _Settings.NormalMapping._Enabled := False;

  _Settings.LightMapping._Avaliable := True;
  _Settings.LightMapping._Enabled := True;

  _Settings.DynamicLights._Avaliable := True;
  _Settings.DynamicLights._Enabled := True;

  _Settings.ToonShading._Avaliable := True;
  _Settings.ToonShading._Enabled := True;

  _Settings.AlphaTesting._Avaliable := True;
  {$IFDEF MOBILE}
  _Settings.AlphaTesting._Enabled := False;
  {$ELSE}
  _Settings.AlphaTesting._Enabled := True;
  {$ENDIF}

  _Settings.Specular._Avaliable := True;
  _Settings.Specular._Enabled := False;

  _Settings.Fur._Avaliable := True;
  _Settings.Fur._Enabled := True;

  {$IFDEF HAS_REFLECTIONS}
  _Settings.Reflections._Avaliable := True;
  {$ELSE}
  _Settings.Reflections._Avaliable := False;
  {$ENDIF}
  _Settings.Reflections._Enabled := False;

  _Settings.Sky._Avaliable := True;
  _Settings.Sky._Enabled := True;

  _Settings.SelfShadows._Avaliable := True;
  _Settings.SelfShadows._Enabled := False;

  _Settings.SSAO._Avaliable := _Settings.PostProcessing._Avaliable;
  _Settings.SSAO._Enabled := False;

  _Settings.ShadowSplitCount := 3;
  _Settings.ShadowSplitWeight := 0.75;
  _Settings.ShadowMapSize := 1024;
  _Settings.ShadowBias := 2.0;

  
  *)
  
  S := glGetExtensionString();
  Engine.Log.Write(logDebug, 'Renderer', 'Extensions: '+ S);
End;


Function StencilOpToGL(Op:StencilOperation):Integer;
Begin
  Case Op Of
  stencilReplace:   Result := GL_REPLACE;
  stencilIncrement: Result := GL_INCR;
  stencilDecrement: Result := GL_DECR;
  stencilInvert:    Result := GL_INVERT;
  stencilIncrementWithWrap: Result := GL_INCR_WRAP;
  stencilDecrementWithWrap: Result := GL_DECR_WRAP;
  Else
    //stencilKeep
    Result := GL_KEEP;
  End;
End;

Function PrimitiveToGL(Primitive:RenderPrimitive):Integer;
Begin
  Case Primitive Of
  renderPoints:     Result := GL_POINTS;
  renderLines:      Result := GL_LINES;
  renderLineStrip:  Result := GL_LINE_STRIP;
  renderTriangleStrip: Result := GL_TRIANGLE_STRIP;
  Else
      //renderTriangles
      Result := GL_TRIANGLES;
  End;
End;

Function TextureColorFormatToGL(Format:TextureColorFormat):Integer;
Begin
  Case Format Of
  textureFormat_RGB:   Result := GL_RGB;
  textureFormat_BGR:   Result := GL_BGR;
  textureFormat_BGRA:   Result := GL_BGRA;
  textureFormat_Alpha: Result := GL_ALPHA; //GL_LUMINANCE;
  Else
      //textureFormat_RGBA
      Result := GL_RGBA;
  End;
End;

Function DataFormatToGL(Format:DataFormat):Integer;
Begin
  Case Format Of
  typeColor:  Result := GL_UNSIGNED_BYTE;
  typeByte:   Result := GL_UNSIGNED_BYTE;
  typeFloat:    Result:= GL_FLOAT;
  typeVector2D: Result:= GL_FLOAT;
  typeVector3D: Result := GL_FLOAT;
  typeVector4D: Result := GL_FLOAT;
    Else
      Result := 0;
  End;
End;

Function ByteFormatToGL(ByteFormat:PixelSizeType):Integer;
Begin
  Case ByteFormat Of
  pixelSizeByte: Result := GL_UNSIGNED_BYTE;
(*  //pixelSizeFloat:
  ,
                    GL_UNSIGNED_SHORT_5_6_5,
                    GL_UNSIGNED_SHORT_4_4_4_4, and
                    GL_UNSIGNED_SHORT_5_5_5_1.*)
    Else
      Result := 0;
  End;
End;

{ OpenGLCubeMap }
Function OpenGLCubeMap.Bind(Slot: Integer):Boolean;
Begin
  glActiveTexture(GL_TEXTURE0 + Slot);

  Result := (_Handle>0) And (Self.IsValid());
  If Not Result Then
  Begin
    glBindTexture(GL_TEXTURE_CUBE_MAP, 0);
    Exit;
  End;

  {$IFDEF PC}
  glEnable(GL_TEXTURE_CUBE_MAP);
  {$ENDIF}
  glBindTexture(GL_TEXTURE_CUBE_MAP, _Handle);

  Result := True;
End;

Function OpenGLCubeMap.Generate(Width, Height:Integer; SourceFormat, TargetFormat:TextureColorFormat; ByteFormat:PixelSizeType): Boolean;
Begin
  _Width := Width;
  _Height := Height;

  _Handle := CustomOpenGLRenderer(_Owner).GenerateTexture();
  glBindTexture(GL_TEXTURE_CUBE_MAP, _Handle);

  glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, TextureColorFormatToGL(TargetFormat),	_Width, _Height, 0,	TextureColorFormatToGL(SourceFormat), GL_UNSIGNED_BYTE, Nil);
  glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, TextureColorFormatToGL(TargetFormat),	_Width, _Height, 0,	TextureColorFormatToGL(SourceFormat), GL_UNSIGNED_BYTE, Nil);
  glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, TextureColorFormatToGL(TargetFormat),	_Width, _Height, 0,	TextureColorFormatToGL(SourceFormat), GL_UNSIGNED_BYTE, Nil);
  glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, TextureColorFormatToGL(TargetFormat),	_Width, _Height, 0,	TextureColorFormatToGL(SourceFormat), GL_UNSIGNED_BYTE, Nil);
  glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, TextureColorFormatToGL(TargetFormat),	_Width, _Height, 0,	TextureColorFormatToGL(SourceFormat), GL_UNSIGNED_BYTE, Nil);
  glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, TextureColorFormatToGL(TargetFormat), _Width, _Height, 0,	TextureColorFormatToGL(SourceFormat), GL_UNSIGNED_BYTE, Nil);

  _ShouldGenMips := True;

  Self.SetWrapMode(wrapNothing);
  Self.MipMapped := False;
  Self.SetFilter(filterBilinear);

  Result := True;
End;

Function OpenGLCubeMap.UpdateFace(FaceID: Integer; Pixels: Pointer; X, Y, Width, Height: Integer):Boolean;
Var
  N:Integer;
Begin
  Case FaceID Of
  cubemap_PositiveX: N := GL_TEXTURE_CUBE_MAP_POSITIVE_X;
  cubemap_NegativeX: N := GL_TEXTURE_CUBE_MAP_NEGATIVE_X;

  cubemap_PositiveY: N := GL_TEXTURE_CUBE_MAP_POSITIVE_Y;
  cubemap_NegativeY: N := GL_TEXTURE_CUBE_MAP_NEGATIVE_Y;

  cubemap_PositiveZ: N := GL_TEXTURE_CUBE_MAP_POSITIVE_Z;
  Else
  //  cubemap_NegativeZ
    N := GL_TEXTURE_CUBE_MAP_NEGATIVE_Z;
  End;

  glBindTexture(GL_TEXTURE_CUBE_MAP, _Handle);
  glTexImage2D(N, 0, GL_RGBA8,	_Width, _Height, 0,	GL_RGBA, GL_UNSIGNED_BYTE, Pixels);

  Result := True;
End;

Procedure OpenGLCubeMap.Invalidate;
Begin
  _Handle := 0;
End;

Procedure OpenGLCubeMap.Release();
Begin
  If (Self.IsValid()) Then
    CustomOpenGLRenderer(_Owner).DeleteTexture(_Handle);
End;

Procedure OpenGLCubeMap.SetFilter(Value: TextureFilterMode);
Begin
  Self._Filter := Value;
  CustomOpenGLRenderer(_Owner).ApplyTextureFilter(_Handle, GL_TEXTURE_CUBE_MAP, MipMapped, _ShouldGenMips, Filter);
  _ShouldGenMips := False;
End;

procedure OpenGLCubeMap.SetMipMapping(Value: Boolean);
Begin
  Self._MipMapped := Value;
End;

procedure OpenGLCubeMap.SetWrapMode(Value: TextureWrapMode);
Begin
  Self._WrapMode := Value;
  CustomOpenGLRenderer(_Owner).ApplyTextureWrap(_Handle, GL_TEXTURE_CUBE_MAP, WrapMode);
End;

{ OpenGLFBO }
Function OpenGLFBO.Generate(Width, Height:Integer; MultiSample:Boolean; PixelSize:PixelSizeType; TargetCount:Integer; DepthBuffer,StencilBuffer:Boolean):Boolean;
Var
  I:Integer;
Begin
  Self._SizeInBytes := Width * Height * 4 * 2;

  _BackgroundColor := ColorCreate(Byte(0), Byte(0), Byte(0), Byte(0));

  _PixelSize := PixelSize;

	_Handle := 0;
	_color_rb := 0;
	_depth_rb := 0;

//  _ContextID := Application.Instance.ContextID;

  If (Multisample) And (_Owner.Features.MultiSampleCount<=0) Then
    Multisample := False;

  _TargetCount := TargetCount;
  SetLength(_Targets, _TargetCount);
  SetLength(_DrawBuffers, _TargetCount);
  For I:=0 To Pred(_TargetCount) Do
  Begin
    _targets[I] := 0;
    _DrawBuffers[I] := GL_COLOR_ATTACHMENT0 + I;
  End;

  _Shared := False;

	_Width := Width;
	_Height := Height;
	_type := PixelSize;
	_multisample := multisample;
  _hasDepthBuffer := DepthBuffer;
  _HasStencilBuffer := StencilBuffer;

  Engine.Log.Write(logDebug,'Framebuffer', 'Creating Framebuffer with size: '+ IntegerProperty.Stringify(_Width)+' x '+ IntegerProperty.Stringify(_Height));

  {$IFDEF PC}
	If (_type = pixelSizeFloat) Then
		_internalformat := GL_RGBA16F
	Else
  {$ENDIF}
		_internalformat := GL_RGBA8;

  Result := Self.Init();
End;


Function OpenGLFBO.GetErrorString(Code: Cardinal): TERRAString;
Begin
	Case Code Of
		GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
        Result := 'Framebuffer incomplete: Attachment is NOT complete.';

		GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
        Result := 'Framebuffer incomplete: No image is attached to FBO.';

		GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
        Result := 'Framebuffer incomplete: Attached images have different dimensions.';

		GL_FRAMEBUFFER_INCOMPLETE_FORMATS:
        Result := 'Framebuffer incomplete: Color attached images have different internal formats.';

		GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER:
        Result := 'Framebuffer incomplete: Draw buffer.';

		GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER:
        Result := 'Framebuffer incomplete: Read buffer.';

		GL_FRAMEBUFFER_UNSUPPORTED:
        Result := 'Unsupported by FBO implementation.';
		Else
        Result := 'Unknow FBO error code '+CardinalToString(Code);
    End;
End;

Function OpenGLFBO.Init():Boolean;
Var
  I, Status:Integer;
  R:CustomOpenGLRenderer;
Begin
  Engine.Log.Write(logDebug, 'Framebuffer','Initializing framebuffer: '{+ Self.Name});

  R := CustomOpenGLRenderer(_Owner);

	glBindFramebuffer(GL_FRAMEBUFFER, 0);
  glBindRenderbuffer(GL_RENDERBUFFER, 0);

	If (_multisample) Then
	Begin
    _Handle := R.GenerateFrameBuffer();
		glBindFramebuffer(GL_FRAMEBUFFER, _Handle);

		_Targets[0] := R.GenerateTexture();
		glBindTexture(GL_TEXTURE_2D, _Targets[0]);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

		// initialize color texture
    {$IFDEF PC}
    If (_type = pixelSizeFloat) Then
    Begin
      _internalformat := GL_RGBA16F;
      glTexImage2D(GL_TEXTURE_2D, 0, _internalformat, _Width, _Height, 0, GL_RGBA, GL_HALF_FLOAT, Nil);      
    End Else
    {$ENDIF}
    Begin
      _internalformat := GL_RGBA8;
      glTexImage2D(GL_TEXTURE_2D, 0, _internalformat, _Width, _Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Nil);    
		End;
		glBindTexture(GL_TEXTURE_2D, 0);      

    _color_rb := R.GenerateRenderBuffer();
		glBindRenderbuffer(GL_RENDERBUFFER, _color_rb);
		glRenderbufferStorageMultisample(GL_RENDERBUFFER, _Owner.Features.MultiSampleCount , _internalformat, _Width, _Height);
		glBindRenderbuffer(GL_RENDERBUFFER, 0);    

    If (_HasDepthBuffer) Then
    Begin
  		_depth_rb := R.GenerateRenderBuffer();
	  	glBindRenderbuffer(GL_RENDERBUFFER, _depth_rb);      
  		glRenderbufferStorageMultisample(GL_RENDERBUFFER, _Owner.Features.MultiSampleCount, {$IFDEF IPHONE}GL_DEPTH24_STENCIL8_OES{$ELSE}GL_DEPTH24_STENCIL8{$ENDIF}, _Width, _Height);      
	  	glBindRenderbuffer(GL_RENDERBUFFER, 0);
    End;

    _MFB := R.GenerateFrameBuffer();
		glBindFramebuffer(GL_FRAMEBUFFER, _mfb);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _color_rb);

    If (_HasDepthBuffer) Then
    Begin
  	  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depth_rb);      
      glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, _depth_rb);
    End;

    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    _Handle := R.GenerateFrameBuffer();
		glBindFramebuffer(GL_FRAMEBUFFER, _Handle);    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _Targets[0], 0);    
	End Else
	Begin
		// initalize FrameBufferObject
    _Handle := R.GenerateFrameBuffer();
		glBindFramebuffer(GL_FRAMEBUFFER, _Handle);
    Engine.Log.Write(logDebug,'Framebuffer', 'Created framebuffer with handle: '+ IntegerProperty.Stringify(_Handle));

		// initialize color texture
    For I:=0 To Pred(_TargetCount) Do
    Begin
      _Targets[I] := R.GenerateTexture();
	  	glBindTexture(GL_TEXTURE_2D, _Targets[I]);
  		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	  	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

      If (_type = pixelSizeFloat) Then
		  Begin
			  glTexImage2D(GL_TEXTURE_2D, 0, _internalformat, _Width, _Height, 0, GL_RGBA, GL_HALF_FLOAT, Nil);
      End Else
  		Begin
	  	  glTexImage2D(GL_TEXTURE_2D, 0, _internalformat, _Width, _Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Nil);
      End;
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0 + I, GL_TEXTURE_2D, _Targets[I], 0);

      Engine.Log.Write(logDebug,'Framebuffer', 'Binding texture to framebuffer with handle: '+ IntegerProperty.Stringify(_Targets[I]));
    End;

		If (_HasDepthBuffer) Then
		Begin
			// initialize depth renderbuffer
			_depth_rb := R.GenerateRenderBuffer();
			glBindRenderbuffer(GL_RENDERBUFFER, _depth_rb);
			glRenderbufferStorage(GL_RENDERBUFFER, {$IFDEF IPHONE}GL_DEPTH24_STENCIL8_OES{$ELSE}GL_DEPTH24_STENCIL8{$ENDIF}, _Width, _Height);

			glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depth_rb);
      glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, _depth_rb);
		End;
	End;

	// check for errors
	Status := glCheckFramebufferStatus(GL_FRAMEBUFFER);
  _Complete := (Status = GL_FRAMEBUFFER_COMPLETE);

  If _Complete Then
  Begin
    Self.SetWrapMode(wrapNothing);
    Self.MipMapped := False;
    Self.SetFilter(filterBilinear);
  End Else
    Engine.Log.Write(logError, 'Framebuffer', GetErrorString(Status));

  // set default framebuffer
	glBindFramebuffer(GL_FRAMEBUFFER, 0);

  Result := _Complete;
End;

Procedure OpenGLFBO.Invalidate;
Var
  I:Integer;
Begin
  _Handle := 0;
	_color_rb := 0;
  _depth_rb := 0;
  _stencil_rb := 0;

  For I:=0 To Pred(_TargetCount) Do
    _Targets[I] := 0;
End;

Var
  CurrentFBO:OpenGLFBO;

Procedure OpenGLFBO.BeginCapture(Flags: Cardinal);
Var
  I:Integer;
  ClearFlags:Cardinal;
Begin
  If (CurrentFBO<>Nil) Then
  Begin
     IntegerProperty.Stringify(2);
     Exit;
  End;

  If (_Handle = 0) Then
    Self.Init();

  CurrentFBO := Self;

  {$IFDEF DEBUG_GRAPHICS}Engine.Log.Write(logDebug, 'Framebuffer','Begin framebuffer capture: W:'+ IntegerProperty.Stringify(_Width)+' H:'+ IntegerProperty.Stringify(_Height));{$ENDIF}


	If (_multisample) Then
  Begin
		glBindFramebuffer(GL_FRAMEBUFFER, _mfb);
	End Else
  Begin
		glBindFramebuffer(GL_FRAMEBUFFER, _Handle);
  End;

  {$IFDEF PC}
  //glDrawBuffers(_TargetCount, @_DrawBuffers[0]);
  {$ENDIF}

  If (Flags<>0) Then
  Begin
    ClearFlags := 0;

    If ((Flags And clearColor)<>0) Then
      ClearFlags := ClearFlags Or GL_COLOR_BUFFER_BIT;

    If ((Flags And clearDepth)<>0) Then
      ClearFlags := ClearFlags Or GL_DEPTH_BUFFER_BIT;

    If ((Flags And clearStencil)<>0) Then
      ClearFlags := ClearFlags Or GL_STENCIL_BUFFER_BIT;

    glClearStencil(0);
    glClearColor(_BackgroundColor.R/255.0, _BackgroundColor.G/255.0, _BackgroundColor.B/255.0, _BackgroundColor.A/255.0);
    glClear(ClearFlags);
  End;
End;

Procedure OpenGLFBO.EndCapture;
Var
  I:Integer;
Begin
  If CurrentFBO <> Self Then
  Begin
     IntegerProperty.Stringify(2);
     Exit;
  End;

  CurrentFBO  := Nil;

  {$IFDEF DEBUG_GRAPHICS}Engine.Log.Write(logDebug, 'Framebuffer','End framebuffer capture');{$ENDIF}

  {$IFDEF PC}
	If (_multisample) Then
	Begin
		glBindFramebuffer(GL_READ_FRAMEBUFFER, _mfb);
		glReadBuffer(GL_COLOR_ATTACHMENT0);
		glBindFramebuffer(GL_DRAW_FRAMEBUFFER, _Handle);
		glDrawBuffer(GL_COLOR_ATTACHMENT0);
		glBlitFramebuffer(0, 0, _Width, _Height, 0, 0, _Width, _Height, GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT, GL_NEAREST);
	End;
  {$ENDIF}

  glBindFramebuffer(GL_FRAMEBUFFER, 0);
End;

Procedure OpenGLFBO.Resize(NewWidth, NewHeight:Integer);
Begin
	Self.Release();
  _Width := NewWidth;
  _Height := NewHeight;
	Self.Init();
End;

Function OpenGLFBO.Bind(Slot: Integer):Boolean;
Begin
  If CurrentFBO = Self Then
     IntegerProperty.Stringify(2);

  Result := (_Handle>0) And (Self.IsValid()) And (_Complete);
  If Not Result Then
  Begin
    glBindTexture(GL_TEXTURE_2D, 0);
    Result := False;
    Exit;
  End;

	glActiveTexture(GL_TEXTURE0 + Slot);
  {$IFDEF PC}
	glEnable(GL_TEXTURE_2D);
  {$ENDIF}

	glBindTexture(GL_TEXTURE_2D, _Targets[0]);


  Result := True;
End;

Procedure OpenGLFBO.Release();
Var
  I:Integer;
  R:CustomOpenGLRenderer;
Begin
{  If (_ContextID <> Application.Instance.ContextID) Then
  Begin
  Self.Invalidate();
    Exit;
  End;}

  R := CustomOpenGLRenderer(_Owner);

  If (Self.IsValid()) Then
  Begin
    R.DeleteRenderBuffer(_color_rb);

  	If (Not _Shared) Then
    Begin
  		R.DeleteRenderBuffer(_depth_rb);
      R.DeleteRenderBuffer(_stencil_rb);
    End;

    For I:=0 To Pred(_TargetCount) Do
		  R.DeleteTexture(_Targets[I]);

    R.DeleteFrameBuffer(_Handle);
  End;
End;

Function OpenGLFBO.GetImage():TERRAImage;
Begin
  Result := TERRAImage.Create(_Width, _Height);

	glBindFramebuffer(GL_FRAMEBUFFER, _Handle);
  {$IFDEF PC}
	glReadBuffer(GL_COLOR_ATTACHMENT0 + 0);
  {$ENDIF}

	glReadPixels(0,0, _Width, _Height, GL_RGBA, GL_UNSIGNED_BYTE, Result.RawPixels);
	glBindFramebuffer(GL_FRAMEBUFFER, 0);

	Result.FlipVertical();
End;

Function OpenGLFBO.GetPixel(X,Y:Integer):ColorRGBA;
Var
  P:ColorRGBA;
Begin
  Y := _Height - Y;
  {$IFDEF PC}
	glBindFramebuffer(GL_FRAMEBUFFER, _Handle);
	glReadBuffer(GL_COLOR_ATTACHMENT0);
	glReadPixels(X,Y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, @P);
	glBindFramebuffer(GL_FRAMEBUFFER, 0);
  {$ELSE}
  P := ColorNull;
  {$ENDIF}
  Result := P;
End;

Procedure OpenGLFBO.SetFilter(Value: TextureFilterMode);
Begin
  _Filter := Value;
  CustomOpenGLRenderer(_Owner).ApplyTextureFilter(_Handle, GL_TEXTURE_2D, False, False, Filter);
End;

procedure OpenGLFBO.SetMipMapping(Value: Boolean);
Begin
  _MipMapped := Value;
  CustomOpenGLRenderer(_Owner).ApplyTextureFilter(_Handle, GL_TEXTURE_2D, False, False, Filter);
End;

procedure OpenGLFBO.SetWrapMode(Value: TextureWrapMode);
Begin
  _WrapMode := Value;
  CustomOpenGLRenderer(_Owner).ApplyTextureWrap(_Handle, GL_TEXTURE_2D, WrapMode);
End;

Function OpenGLFBO.GetOrigin: SurfaceOrigin;
Begin
  Result := surfaceBottomRight;
End;

{ OpenGLTexture }
Function OpenGLTexture.Bind(Slot: Integer): Boolean;
Begin
  glActiveTexture(GL_TEXTURE0 + Slot);

  Result := (_Handle>0) And (Self.IsValid());
  If Not Result Then
  Begin
    glBindTexture(GL_TEXTURE_2D, 0);
    Result := False;
    Exit;
  End;

  {$IFDEF PC}
  glEnable(GL_TEXTURE_2D);
  {$ENDIF}

  glBindTexture(GL_TEXTURE_2D, _Handle);
  Result := True;
End;

Function OpenGLTexture.Generate(Pixels: Pointer; Width, Height:Integer; SourceFormat, TargetFormat:TextureColorFormat; ByteFormat:PixelSizeType): Boolean;
Var
  Mult:Single;
Begin
  _Handle := CustomOpenGLRenderer(_Owner).GenerateTexture();
  _Width := Width;
  _Height := Height;

  glActiveTexture(GL_TEXTURE0);
  {$IFDEF PC}
  glEnable(GL_TEXTURE_2D);
  {$ENDIF}
  glBindTexture(GL_TEXTURE_2D, _Handle);

//  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

  {$IFDEF DEBUG_GRAPHICS}Engine.Log.Write(logDebug, 'Texture', 'Uploading texture frame...');{$ENDIF}
  glTexImage2D(GL_TEXTURE_2D, 0, TextureColorFormatToGL(TargetFormat), Width, Height, 0, TextureColorFormatToGL(SourceFormat), ByteFormatToGL(ByteFormat), Pixels);

  //_Source.Save('debug\temp\pp'+ IntegerProperty.Stringify(I)+'.png');

(*  If (_Format = GL_COMPRESSED_RGBA) Then
  Begin
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_INTERNAL_FORMAT, @_Format);
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_COMPRESSED_IMAGE_SIZE, @_Size);
  End;
*)

  Case ByteFormatToGL(ByteFormat) Of
  GL_UNSIGNED_SHORT_4_4_4_4,
  GL_UNSIGNED_SHORT_5_5_5_1,
  GL_UNSIGNED_SHORT_5_6_5:
    Begin
      Mult := 2;
    End;

  Else
    Mult := 4.0;
  End;

  _SizeInBytes := Trunc(Mult * _Width * _Height);

  {$IFDEF PC}
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @_Width);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @_Height);
  {$ENDIF}

  _ShouldGenMips := True;

  Self.SetWrapMode(wrapAll);
  Self.MipMapped := True;
  Self.SetFilter(filterBilinear);

  Result := True;
End;

Function OpenGLTexture.GetImage:TERRAImage;
Begin
  Engine.Log.Write(logDebug, 'Texture', 'Getting image from texture '{+Self.Name});

  Result := TERRAImage.Create(_Width, _Height);

  {$IFDEF PC}
  glActiveTexture(GL_TEXTURE0);
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, _Handle);

  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @_Width);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @_Height);

  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, Result.RawPixels);

  Result.FlipVertical();
  {$ENDIF}
End;

Procedure OpenGLTexture.Invalidate;
Begin
  _Handle := 0;
End;

Function OpenGLTexture.Update(Pixels: Pointer; X, Y, Width, Height: Integer):Boolean;
Begin
	glBindTexture(GL_TEXTURE_2D, _Handle);

(*  If (X=0) And (Y=0) And (Width = Self._Width) And (Height = Self._Height) Then
    glTexImage2D(GL_TEXTURE_2D, 0, X, Y, Width, Height, GL_RGBA, GL_UNSIGNED_BYTE, Pixels)
  Else
	//glTexSubImage2D(GL_TEXTURE_2D, 0, X, Y, Source.Width, Source.Height, _TargetFormat, _ByteFormat, Pixels);*)
    glTexSubImage2D(GL_TEXTURE_2D, 0, X, Y, Width, Height, GL_RGBA, GL_UNSIGNED_BYTE, Pixels);

  _ShouldGenMips := Self.MipMapped;

  Result := True;
End;

Procedure OpenGLTexture.Release;
Begin
  If (Self.IsValid()) Then
    CustomOpenGLRenderer(_Owner).DeleteTexture(_Handle);
End;

Procedure OpenGLTexture.SetFilter(Value: TextureFilterMode);
Begin
  Self._Filter := Value;
  CustomOpenGLRenderer(_Owner).ApplyTextureFilter(_Handle, GL_TEXTURE_2D, MipMapped, _ShouldGenMips, Filter);

  _ShouldGenMips := False;
End;

Procedure OpenGLTexture.SetMipMapping(Value: Boolean);
Begin
  Self._MipMapped := Value;
End;

Procedure OpenGLTexture.SetWrapMode(Value: TextureWrapMode);
Begin
  Self._WrapMode := Value;
  CustomOpenGLRenderer(_Owner).ApplyTextureWrap(_Handle, GL_TEXTURE_2D, Value);
End;

{ OpenGLRenderer }
Procedure CustomOpenGLRenderer.ClearBuffer(Color, Depth, Stencil:Boolean);
Var
  Flags:Cardinal;
Begin
  Flags := 0;

  If (Color) Then
    Flags := Flags Or GL_COLOR_BUFFER_BIT;

  If (Depth) Then
    Flags := Flags Or GL_DEPTH_BUFFER_BIT;

  If (Stencil) Then
    Flags := Flags Or GL_STENCIL_BUFFER_BIT;

  If (Flags<>0) Then
  Begin
    glClearColor(_ClearColor.R/255, _ClearColor.G/255, _ClearColor.B/255, _ClearColor.A/255);
    glClear(Flags);
  End;
End;

Procedure CustomOpenGLRenderer.SetClearColor(const ClearColor: ColorRGBA);
Begin
  Self._ClearColor := ClearColor;
End;

Function CustomOpenGLRenderer.Initialize():Boolean;
Var
  I:Integer;
  S:AnsiString;
Begin
  _ClearColor := ColorNull;

  _Features := OpenGLFeatures.Create(Self);

  _DeviceName := glGetString(GL_RENDERER);
  _DeviceVendor := glGetString(GL_VENDOR);

  _DeviceVersion := StringToVersion('0.0.0');

  If (Features.Shaders.Avaliable) Then
  Begin
    S := glGetString(GL_SHADING_LANGUAGE_VERSION);
    If (S<>'') Then
    Begin
      Engine.Log.Write(logDebug, 'GraphicsManager', 'Version: '+ S);

      I := Pos(' ', S);
      If (I>0) Then
        S := Copy(S, 1, Pred(I));
      _DeviceVersion := StringToVersion(S);
    End;

    Engine.Log.Write(logDebug,'GraphicsManager','GLSL version:'+VersionToString(_DeviceVersion));
  End;

  Result := True;
End;

Procedure CustomOpenGLRenderer.SetColorMask(Red, Green, Blue, Alpha: Boolean);
Begin
  glColorMask(Red, Green, Blue, Alpha);
End;

Procedure CustomOpenGLRenderer.SetDepthMask(WriteZ: Boolean);
Begin
  glDepthMask(WriteZ);
End;

Procedure CustomOpenGLRenderer.SetDepthFunction(Mode: CompareMode);
Begin
  glDepthFunc(CompareToGL(Mode));
End;

Procedure CustomOpenGLRenderer.SetStencilTest(Enable: Boolean);
Begin
  If Enable Then
    glEnable(GL_STENCIL_TEST)
  Else
    glDisable(GL_STENCIL_TEST);
End;

Procedure CustomOpenGLRenderer.SetStencilFunction(Mode: CompareMode; StencilID, Mask: Cardinal);
Begin
  glStencilFunc(CompareToGL(Mode), StencilID, $FFFFFFFF);
End;

Procedure CustomOpenGLRenderer.SetStencilOp(fail, zfail, zpass: StencilOperation);
Begin
  glStencilOp(StencilOpToGL(Fail), StencilOpToGL(ZFail), StencilOpToGL(ZPass));
End;


Procedure CustomOpenGLRenderer.SetCullMode(Mode: CullMode);
Begin
  If (Mode = cullNone) Then
  Begin
    glDisable(GL_CULL_FACE);
  End Else
  Begin
    glEnable(GL_CULL_FACE);
    If (Mode = cullFront) Then
      glCullFace(GL_FRONT)
    Else
      glCullFace(GL_BACK);
  End;
End;

Procedure CustomOpenGLRenderer.SetDepthTest(Enable: Boolean);
Begin
  If Enable Then
    glEnable(GL_DEPTH_TEST)
  Else
    glDisable(GL_DEPTH_TEST);
End;

Procedure CustomOpenGLRenderer.SetBlendMode(BlendMode: Integer);
Var
  NeedsAlpha:Boolean;
  A,B:Integer;
Begin
{glEnable(GL_BLEND);
glBlendFunc(GL_ONE, GL_ONE);
exit;}

{  If (BlendMode = _CurrentBlendMode) Then
    Exit;}

  NeedsAlpha := BlendMode>0;

  (*If (Settings.SeparateBlends.Avaliable) And (Settings.PostProcessing.Avaliable)
  And (Shader.ActiveShader<>Nil) And (Shader.ActiveShader.MRT) Then
  Begin
    If NeedsAlpha Then
      glEnableIndexedEXT(GL_BLEND, 0)
    Else
      glDisableIndexedEXT(GL_BLEND, 0);

  End Else*)
  Begin
    If NeedsAlpha Then
    Begin
      glEnable(GL_BLEND);
    End Else
    Begin
      glDisable(GL_BLEND);
    End;

  End;


  If (NeedsAlpha) Then
  Case BlendMode Of
  blendBlend:
    Begin
      A := GL_SRC_ALPHA;
      B := GL_ONE_MINUS_SRC_ALPHA;
    End;

  blendAdd:
    Begin
      A := GL_SRC_ALPHA;
      B := GL_ONE;
    End;

  blendFilter:
    Begin
      A := GL_ONE;
      B := GL_ONE_MINUS_SRC_ALPHA;
    End;

  blendModulate:
    Begin
      A := GL_SRC_COLOR;
      B := GL_ONE;
  End;

  blendJoin:
    Begin
      A := GL_ONE;
      B := GL_ONE;
    End;

  blendZero:
    Begin
      A := GL_ZERO;
      B := GL_ZERO;
    End;

  blendOne:
    Begin
      A := GL_ONE;
      B := GL_ZERO;
    End;

  blendColor:
    Begin
      A := GL_SRC_COLOR;
      B := GL_ONE_MINUS_SRC_COLOR;
    End;

  blendColorAdd:
    Begin
      A := GL_SRC_COLOR;
      B := GL_ONE;
    End;

  blendReflection:
    Begin
      A := GL_DST_ALPHA;
      B := GL_ONE_MINUS_DST_ALPHA;
    End;
  End;

  glBlendFuncSeparate(A, B, GL_ONE, GL_ONE);
  //glBlendFunc(A, B);

 //_CurrentBlendMode := BlendMode;
End;

Procedure CustomOpenGLRenderer.SetModelMatrix(Const Mat: Matrix4x4);
Begin
  _ModelMatrix := Mat;

  If (Features.Shaders.Avaliable) Then
  Begin
    If Assigned(Self.ActiveShader) Then
    Begin
      Self.ActiveShader.SetMat4Uniform('modelMatrix', Mat);

      If Self.Settings.SurfaceProjection<>surfacePlanar Then
        Self.ActiveShader.SetMat4Uniform('modelMatrixInverse', Matrix4x4_Inverse(Mat));
      Exit;
    End;
  End;

  glMatrixMode(GL_MODELVIEW);
  glLoadMatrixf(@Mat);
End;

Procedure CustomOpenGLRenderer.SetProjectionMatrix(Const Mat:Matrix4x4);
Begin
  _ProjectionMatrix := Mat;

  If (Features.Shaders.Avaliable) Then
  Begin
    If Assigned(Self.ActiveShader) Then
    Begin
      Self.ActiveShader.SetMat4Uniform('projectionMatrix', Mat);
      Exit;
    End;
  End;

  glMatrixMode(GL_PROJECTION);
  glLoadMatrixf(@Mat);
End;

Procedure CustomOpenGLRenderer.SetTextureMatrix(Const Mat: Matrix4x4);
Begin
  _TextureMatrix := Mat;

  If (Features.Shaders.Avaliable) Then
  Begin
    If Assigned(Self.ActiveShader) Then
    Begin
      Self.ActiveShader.SetMat4Uniform('textureMatrix', Mat);
      Exit;
    End;
  End;

  glActiveTexture(GL_TEXTURE0);
  glMatrixMode(GL_TEXTURE);
  glLoadMatrixf(@Mat);
End;

Procedure CustomOpenGLRenderer.SetDiffuseColor(Const C: ColorRGBA);
Begin
  _DiffuseColor := C;

  If (Features.Shaders.Avaliable) Then
  Begin
    If Assigned(Self.ActiveShader) Then
    Begin
      Self.ActiveShader.SetColorUniform('diffuse', C);
      Exit;
    End;
  End;

  glColor4f(C.R/255, C.G/255, C.B/255, C.A/255);
End;

Procedure CustomOpenGLRenderer.SetAttributeSource(Const Name:TERRAString; AttributeKind:Cardinal; ElementType:DataFormat; AttributeSource:Pointer);
Var
  Count, Format:Integer;
  Norm:Boolean;
  Handle:Integer;
Begin
  Format := DataFormatToGL(ElementType);
  Case ElementType Of
  typeColor:
    Begin
      Count := 4;
      Norm := True;
    End;

  typeByte:
    Begin
      Count := 1;
      Norm := True;
    End;

  typeFloat:
    Begin
      Count := 1;
      Norm := False;
    End;

  typeVector2D:
    Begin
      Count := 2;
      Norm := False;
    End;

  typeVector3D:
    Begin
      Count := 3;
      Norm := False;
    End;

  typeVector4D:
    Begin
      Count := 4;
      Norm := False;
    End;

    Else
      Exit;
  End;

  If _CurrentSource = Nil Then
  Begin
    Engine.RaiseError('Please call Renderer.SetVertexSize() before drawing anything!');
    Exit;
  End;

  If (Not Features.Shaders.Avaliable) {Or (Self.ActiveShader = Nil) }Then
  Begin
    If (AttributeKind = vertexPosition) Then
    Begin
      glEnableClientState(GL_VERTEX_ARRAY);
      glVertexPointer(Count, Format, _CurrentSource.Size, AttributeSource);
    End Else
    If (AttributeKind = vertexNormal) Then
    Begin
      glEnableClientState(GL_NORMAL_ARRAY);
      glNormalPointer(Format, _CurrentSource.Size, AttributeSource);
    End Else
    If (AttributeKind = vertexColor) Then
    Begin
      glEnableClientState(GL_COLOR_ARRAY);
      glColorPointer(Count, Format, _CurrentSource.Size, AttributeSource);
    End Else
    If (AttributeKind = vertexUV0) Then
    Begin
      glClientActiveTexture(GL_TEXTURE0);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);
      glTexCoordPointer(Count, Format, _CurrentSource.Size, AttributeSource);
    End Else
    If (AttributeKind = vertexUV1) Then
    Begin
      glClientActiveTexture(GL_TEXTURE1);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);
      glTexCoordPointer(Count, Format, _CurrentSource.Size, AttributeSource);
    End Else
    If (AttributeKind = vertexUV2) Then
    Begin
      glClientActiveTexture(GL_TEXTURE2);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);
      glTexCoordPointer(Count, Format, _CurrentSource.Size, AttributeSource);
    End Else
    If (AttributeKind = vertexUV3) Then
    Begin
      glClientActiveTexture(GL_TEXTURE3);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);
      glTexCoordPointer(Count, Format, _CurrentSource.Size, AttributeSource);
    End Else
    Begin
      Engine.RaiseError('Unknown attribute: '+Name);
    End;

    Exit;
  End;

  If Self.ActiveShader = Nil Then
    Exit;

  Handle := Self.ActiveShader.GetAttributeHandle(Name);

  If (Handle<0) Then
    Exit;

  glVertexAttribPointer(Handle, Count, Format, Norm, _CurrentSource.Size, AttributeSource);
End;

Procedure CustomOpenGLRenderer.DrawSource(Primitive: RenderPrimitive; Count: Integer);
Begin
  If (Count<0) Then
    Exit;

  If Assigned(_CurrentSource) Then
  Begin
    If Not _CurrentSource.Bind(True) Then
      Exit;
  End Else
    Engine.RaiseError('Cannot draw null buffer!');

  {$IFDEF DEBUG_GRAPHICS}
  Engine.Log.Write(logDebug, 'Renderer', 'glDrawArrays: '+IntToString(Count));
  {$ENDIF}

  If Count > 0 Then
  Begin
    glDrawArrays(PrimitiveToGL(Primitive), 0, Count);
    _Stats.Update(RendererStat_Triangles, Count Div 3);
  End;

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);

  _CurrentSource := Nil;
End;

Procedure CustomOpenGLRenderer.DrawIndexedSource(Primitive:RenderPrimitive; Count:Integer; Indices:System.PWord);
Begin
  If (Count<0) Then
    Exit;

  If Assigned(_CurrentSource) Then
    _CurrentSource.Bind(True)
  Else
    Engine.RaiseError('Cannot draw null buffer!');

  {$IFDEF DEBUG_GRAPHICS}
  Engine.Log.Write(logDebug, 'Renderer', 'glDrawElements: '+IntToString(Count));
  {$ENDIF}

  glDrawElements(PrimitiveToGL(Primitive), Count, GL_UNSIGNED_SHORT, Indices);

  _Stats.Update(RendererStat_Triangles, Count Div 3);

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
End;

Procedure CustomOpenGLRenderer.SetViewport(X, Y, Width, Height:Integer);
Begin
  glViewport(X,Y, Width, Height);
End;


Procedure CustomOpenGLRenderer.SetScissorArea(X,Y, Width, Height:Integer);
Begin
  glScissor(X, Y, Width, Height);
End;

Procedure CustomOpenGLRenderer.SetScissorState(Enabled: Boolean);
Begin
  If Enabled Then
    glEnable(GL_SCISSOR_TEST)
  Else
    glDisable(GL_SCISSOR_TEST);
End;

Procedure CustomOpenGLRenderer.ResetState();
Begin
	glEnable(GL_CULL_FACE);

  {$IFDEF PC}
	glEnable(GL_TEXTURE_2D);
  {$ENDIF}

  glEnable(GL_DEPTH_TEST);
	//glDisable(GL_FOG);
	//glEnable(GL_LIGHTING);

  //glDisable(GL_ALPHA_TEST);
  //glDisable(GL_LINE_SMOOTH);
  //glClearDepth(1.0);
  glClearStencil(0);
  glStencilMask($FFFFFFF);
  glDepthFunc(GL_LEQUAL);
End;


Function CustomOpenGLRenderer.GenerateFrameBuffer: Cardinal;
Begin
  Engine.Log.Write(logDebug, 'GraphicsManager', 'Generating a new frame buffer...');
  Repeat
    glGenFramebuffers(1, @Result);
    Engine.Log.Write(logDebug, 'GraphicsManager', 'Got handle: '+ IntegerProperty.Stringify(Result));
  Until (Result>=MaxFrameBufferHandles) Or (Not _UsedFrameBuffers[Result]);

  If (Result<MaxFrameBufferHandles) Then
    _UsedFrameBuffers[Result] := True;
End;

Function CustomOpenGLRenderer.GenerateRenderBuffer: Cardinal;
Begin
  Engine.Log.Write(logDebug, 'GraphicsManager', 'Generating a new render buffer...');
  Repeat
    glGenRenderbuffers(1, @Result);
    Engine.Log.Write(logDebug, 'GraphicsManager', 'Got handle: '+ IntegerProperty.Stringify(Result));
  Until (Result>=MaxFrameBufferHandles) Or (Not _UsedRenderBuffers[Result]);

  If (Result<MaxFrameBufferHandles) Then
    _UsedRenderBuffers[Result] := True;
End;

Function CustomOpenGLRenderer.GenerateTexture: Cardinal;
Begin
  Engine.Log.Write(logDebug, 'GraphicsManager', 'Generating a new texture...');
  Repeat
    glGenTextures(1, @Result);
    Engine.Log.Write(logDebug, 'GraphicsManager', 'Got handle: '+ IntegerProperty.Stringify(Result));
  Until (Result>=MaxTextureHandles) Or (Not _UsedTextures[Result]);

  If (Result<MaxTextureHandles) Then
    _UsedTextures[Result] := True;
End;

Procedure CustomOpenGLRenderer.DeleteFrameBuffer(Var Handle: Cardinal);
Begin
  If (Handle<=0) Then
    Exit;

  glDeleteFramebuffers(1, @Handle);
  If (Handle < MaxFrameBufferHandles) Then
    _UsedFrameBuffers[Handle] := False;

  Handle := 0;
End;

Procedure CustomOpenGLRenderer.DeleteRenderBuffer(Var Handle: Cardinal);
Begin
  If (Handle<=0) Then
    Exit;

  glDeleteRenderbuffers(1, @Handle);
  If (Handle < MaxFrameBufferHandles) Then
    _UsedRenderBuffers[Handle] := False;

  Handle := 0;
End;

Procedure CustomOpenGLRenderer.DeleteTexture(Var Handle: Cardinal);
Begin
  If (Handle<=0) Then
    Exit;

  glDeleteTextures(1, @Handle);
  If (Handle < MaxTextureHandles) Then
    _UsedTextures[Handle] := False;

  Handle := 0;
End;

Procedure CustomOpenGLRenderer.ApplyTextureFilter(Handle, TextureKind:Integer; MipMapped, ShouldGenMips:Boolean; Filter:TextureFilterMode);
Begin
  If Handle = 0 Then
    Exit;

  {$IFDEF PC}
    {$IFNDEF WINDOWS}
    MipMapped := False; {FIXME}
    {$ENDIF}
  {$ENDIF}

  If (Not Features.Shaders.Avaliable) Then
    MipMapped := False;

  {$IFDEF DEBUG_GRAPHICS}Engine.Log.Write(logDebug, 'Texture', 'Setting texture filtering');{$ENDIF}

  If (Filter = filterBilinear) Then
  Begin
    If (MipMapped) Then
      glTexParameteri(TextureKind, GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR)
    Else
      glTexParameteri(TextureKind, GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(TextureKind, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  End Else
  Begin
    If (MipMapped) Then
      glTexParameteri(TextureKind, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST)
    Else
      glTexParameteri(TextureKind, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(TextureKind, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  End;

  {$IFDEF DEBUG_GRAPHICS}Engine.Log.Write(logDebug, 'Texture', 'Generating mipmap');{$ENDIF}
  If (MipMapped) And (ShouldGenMips) Then
  Begin
    glGenerateMipmap(TextureKind);
  End;
End;

Procedure CustomOpenGLRenderer.ApplyTextureWrap(Handle, TextureKind:Integer; WrapMode:TextureWrapMode);
Begin
  If Handle = 0 Then
    Exit;

  {$IFDEF DEBUG_GRAPHICS}Engine.Log.Write(logDebug, 'Texture', 'Setting wrap mode');{$ENDIF}

  If ((Cardinal(WrapMode) And Cardinal(wrapHorizontal))<>0) Then
    glTexParameteri(TextureKind, GL_TEXTURE_WRAP_S, GL_REPEAT)
  Else
    glTexParameteri(TextureKind, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);

  If ((Cardinal(WrapMode) And Cardinal(wrapVertical))<>0) Then
    glTexParameteri(TextureKind, GL_TEXTURE_WRAP_T, GL_REPEAT)
  Else
    glTexParameteri(TextureKind, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

{	If (_Owner.Settings.Textures.Quality>=QualityHigh) And (_Onwer.Settings.MaxAnisotrophy > 1) Then
  Begin
	  glTexParameteri(TextureKind, GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT, GraphicsManager.Instance.Settings.MaxAnisotrophy);
  End; BIBI}
End;

Function CustomOpenGLRenderer.CreateCubeMap: CubeMapInterface;
Begin
  Result := OpenGLCubeMap.Create(Self);
End;

Function CustomOpenGLRenderer.CreateRenderTarget: RenderTargetInterface;
Begin
  Result := OpenGLFBO.Create(Self);
End;

Function CustomOpenGLRenderer.CreateTexture: TextureInterface;
Begin
  Result := OpenGLTexture.Create(Self);
End;

Function CustomOpenGLRenderer.CreateVertexBuffer: VertexBufferInterface;
Begin
  Result := OpenGLVBO.Create(Self);
End;

Function CustomOpenGLRenderer.CreateShader: ShaderInterface;
Begin
  Result := OpenGLShader.Create(Self);
End;

Procedure CustomOpenGLRenderer.BeginFrame;
Begin
  Inherited;

  //glClearColor(_BackgroundColor.R/255, _BackgroundColor.G/255, _BackgroundColor.B/255, 0{_BackgroundColor.A/255});
End;

Function CustomOpenGLRenderer.GetScreenshot:TERRAImage;
Var
  W,H:Integer;
Begin
  W := Application.Instance.Window.Width;
  H := Application.Instance.Window.Height;
  Result := TERRAImage.Create(W, H);
  glReadPixels(0, 0, W, H, GL_RGBA, GL_UNSIGNED_BYTE, Result.RawPixels);
  Result.FlipVertical();
End;

End.
