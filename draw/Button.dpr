library Button;

{$R *.res}

uses
  drawShare, kol, Windows;

var 
  InitCounter: integer = 0;
  Bmp: KOL.PBitmap;
  
  // Индексы свойств (чтобы не искать при каждой перерисовке)
  PropWidth,
  PropHeight,
  PropCaption: integer;


procedure Init(PRec:PParamRec; var ed:pointer; DTools:PDrawTools); cdecl;
  function SearchIndex(const name:string):integer;
  begin
    result := 0;
    while lowercase(PRec^[result].name) <> lowercase(name) do
      inc(result);
  end;
begin
  if InitCounter = 0 then
  begin
    PropWidth := SearchIndex('Width');
    PropHeight := SearchIndex('Height');
    PropCaption := SearchIndex('Caption');
    
    Bmp := NewBitmap(0,0);
    Bmp.LoadFromResourceName(HInstance, PChar('BG'));
  end
  else Inc(InitCounter);
end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    R: TRect;
    Width, Height: integer;
    Caption: string;
begin
  
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  Caption := string(PRec[PropCaption].Value^);
  
  SetRect(R, 0, 0, Width, Height);
  
  Bmp.StretchDraw(dc, R);

  if Caption = '' then Exit;
 
  C := NewCanvas(dc);
  with C^ do
  begin
    //SetTextAlign(dc, GetTextAlign(dc) or TA_CENTER);
    C.Brush.BrushStyle := bsClear;
    Font.FontName := 'Tahoma';
    Font.FontHeight := 16;
    Font.FontQuality := fqAntialiased;
    Font.Color := clBlack;
    StrReplace(Caption, '\r\n', #13#10);
    DrawText(Caption, R, {DT_WORDBREAK +} DT_NOPREFIX + DT_CENTER + DT_VCENTER + DT_SINGLELINE);
  end;
  C.Free;
end;

procedure Close(PRec:PParamRec; ed:pointer); cdecl;
begin
  Dec(InitCounter);
  if InitCounter = 0 then Bmp.Free;
end;

procedure Change(PRec:PParamRec; ed:pointer; Index:integer); cdecl;
begin

end;



exports
    Init,
    Close,
    //Change,
    Draw;


   
begin
  


end.
 