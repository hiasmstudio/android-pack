library TimePicker;

{$R *.res}

uses
  drawShare, kol, Windows;


var 
  InitCounter: integer = 0;
  BmpBG, BmpAM, BmpPM: KOL.PBitmap;
  
  // Индексы свойств (чтобы не искать при каждой перерисовке)
  //PropWidth,
  //PropHeight,
  PropHour,
  PropMinute,
  PropHour24Format: integer;


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
    //PropWidth := SearchIndex('Width');
    //PropHeight := SearchIndex('Height');
    PropHour := SearchIndex('Hour');
    PropMinute := SearchIndex('Minute');
    PropHour24Format := SearchIndex('Hour24Format');
    
    BmpBG := NewBitmap(0,0);
    BmpBG.LoadFromResourceName(HInstance, PChar('BG'));
    BmpAM := NewBitmap(0,0);
    BmpAM.LoadFromResourceName(HInstance, PChar('AM'));
    BmpPM := NewBitmap(0,0);
    BmpPM.LoadFromResourceName(HInstance, PChar('PM'));

  end
  else Inc(InitCounter);

end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    W, X, Y: integer;
    //Width, Height,
    Hour, Minute, Hour24Format: integer;
    Time: TDateTime;
    ST: TSystemTime;
    BmpAMPM: KOL.PBitmap;
begin
  //Width := integer(PRec[PropWidth].Value^);
  //Height := integer(PRec[PropHeight].Value^);
  Hour := integer(PRec[PropHour].Value^);
  Minute := integer(PRec[PropMinute].Value^);
  Hour24Format := ord(boolean(PRec[PropHour24Format].Value^));
  
  
  Time := Now;

  FillChar(ST, Sizeof(ST), 0);
  DateTime2SystemTime(Time, ST);
  
  if Hour = -1 then Hour := ST.wHour;
  if Minute = -1 then Minute := ST.wMinute;
  
  if Hour24Format = 0 then
  begin
    if Hour > 11 then 
    begin
      Hour := Hour - 12;
      BmpAMPM := BmpPM;
    end
    else BmpAMPM := BmpAM;
    
    if Hour = 0 then Hour := 12;
  end;   
  

  BmpBG.Draw(dc, 0, 0);
  if Hour24Format = 0 then
  begin
    BmpAMPM.Draw(dc, BmpBG.Width + 5, (BmpBG.Height - BmpAM.Height) div 2);
  end;
  
  SetTextAlign(dc, TA_CENTER);
  C := NewCanvas(dc);
  with C^ do
  begin   
    Brush.BrushStyle := bsClear;
    Font.Color := clBlack;
    Font.FontHeight := (BmpBG.Height div 3) - 6;
    Font.FontName := 'Arial';
    
    W := BmpBG.Width div 2;
    Y := BmpBG.Height div 3 + 5;
    X := BmpBG.Width div 4 - 8;
    TextOut(X, Y, Int2Str(Hour));
    X := BmpBG.Width div 4 + W;
    TextOut(X, Y, Int2Str(Minute));
  end;
  C.Free;
end;

procedure Close(PRec:PParamRec; ed:pointer); cdecl;
begin
  Dec(InitCounter);
  if InitCounter = 0 then 
  begin
    BmpAM.Free;
    BmpPM.Free;
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
 