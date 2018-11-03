library ToggleButton;

{$R *.res}

uses
  drawShare, kol, Windows;


var 
  InitCounter: integer = 0;
  BmpChecked, BmpUnchecked, BmpBG: KOL.PBitmap;
  
  // Индексы свойств (чтобы не искать при каждой перерисовке)
  PropWidth,
  PropHeight,
  PropChecked,
  PropTextOn,
  PropTextOff: integer;


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
    PropTextOn := SearchIndex('TextOn');
    PropTextOff := SearchIndex('TextOff');
    
    BmpChecked := NewBitmap(0,0);
    BmpChecked.LoadFromResourceName(HInstance, PChar('CHECKED'));
    BmpUnchecked := NewBitmap(0,0);
    BmpUnchecked.LoadFromResourceName(HInstance, PChar('UNCHECKED'));
    BmpBG := NewBitmap(0,0);
    BmpBG.LoadFromResourceName(HInstance, PChar('BG'));
  end
  else Inc(InitCounter);

end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    R: TRect;
    Width, Height, Checked: integer;
    X, Y: integer;
    Caption: string;
    Bmp: KOL.PBitmap;
begin
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  Checked := ord(boolean(PRec[PropChecked].Value^));
  
  if Checked = 0 then 
  begin
    Bmp := BmpUnchecked;
    Caption := string(PRec[PropTextOff].Value^);
  end
  else
  begin
    Bmp := BmpChecked;
    Caption := string(PRec[PropTextOn].Value^);
  end;
  
  // Фон кнопки
  //SetStretchBltMode(dc, HALFTONE);
  SetRect(R, 0, 0, Width, Height);
  BmpBG.StretchDraw(dc, R);
  
  // Изображение-метка
  X := (Width - Bmp.Width) div 2;
  Y := Height - Bmp.Height - 2;
  Bmp.DrawTransparent(dc, X, Y, clWhite);
  
  
  // Надпись
  if Caption <> '' then 
  begin
    SetTextAlign(dc, TA_CENTER or TA_BOTTOM);
    C := NewCanvas(dc);
    with C^ do
    begin
      Font.FontName := 'Tahoma';
      Font.FontHeight := 16;
      Font.FontQuality := fqAntialiased;
      Font.Color := clBlack;
      Brush.BrushStyle := bsClear;
      TextOut(Width div 2, Y, Caption);
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
    BmpBG.Free;
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
 