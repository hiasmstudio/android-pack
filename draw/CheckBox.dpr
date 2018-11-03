library CheckBox;

{$R *.res}

uses
  drawShare, kol, Windows;


var 
  InitCounter: integer = 0;
  BmpChecked, BmpUnchecked: KOL.PBitmap;
  
  // Индексы свойств (чтобы не искать при каждой перерисовке)
  PropWidth,
  PropHeight,
  PropChecked,
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
    PropChecked := SearchIndex('Checked');
    PropCaption := SearchIndex('Caption');
    
    BmpChecked := NewBitmap(0,0);
    BmpChecked.LoadFromResourceName(HInstance, PChar('CHECKED'));
    BmpUnchecked := NewBitmap(0,0);
    BmpUnchecked.LoadFromResourceName(HInstance, PChar('UNCHECKED'));
  end
  else Inc(InitCounter);

end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    Width, Height, Checked: integer;
    Caption: string;
    Bmp: KOL.PBitmap;
begin
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  Caption := string(PRec[PropCaption].Value^);
  Checked := ord(boolean(PRec[PropChecked].Value^));
  
  if Checked = 0 then Bmp := BmpUnchecked else Bmp := BmpChecked;
  
  //SetStretchBltMode(dc, HALFTONE);
  Bmp.Draw(dc, 0, (Height - Bmp.Height) div 2);
  
  if Caption <> '' then 
  begin
    C := NewCanvas(dc);
    with C^ do
    begin
      Font.FontName := 'Tahoma';
      Font.FontHeight := 16;
      Font.FontQuality := fqAntialiased;
      Font.Color := clBlack;
      Brush.BrushStyle := bsClear;
      TextOut(Bmp.Width + 4, (Height - 16) div 2, Caption);
    end;
    C.Free;
  end;
  
end;

procedure Close(PRec:PParamRec; ed:pointer); cdecl;
begin
  Dec(InitCounter);
  if InitCounter = 0 then 
  begin
    BmpChecked.Free;
    BmpUnchecked.Free;
  end;
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
 