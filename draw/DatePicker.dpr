library DatePicker;

{$R *.res}

uses
  drawShare, kol, Windows;


var 
  InitCounter: integer = 0;
  Bmp: KOL.PBitmap;
  
  // »ндексы свойств (чтобы не искать при каждой перерисовке)
  PropWidth,
  PropHeight: integer;

  
  DtNow : TDateTime;
  Day, Month, Year : word;  
  sD, sM, sY :string;
  
  Months: array [0..11] of string[3] = 
  (
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  );
  
procedure DrawTextOnBmp;
var W1, W2, W3, Bl: integer;
    Width, Height: integer;
begin
  Width := Bmp.Width;
  Height := Bmp.Height;
  
  W1 := Width div 3;
  W2 := W1;
  //W3 := Width - 2*W1;  
  Bl := Height div 3 + 5;
  
  with Bmp.Canvas^ do
  begin
    Brush.BrushStyle := bsClear;
    Font.Color := clBlack;
    Font.FontHeight := (Height div 3) - 6;
    Font.FontName := 'Arial';
    
    TextOut(5, Bl, sM);
    TextOut((W1 + 15), Bl, sD);
    TextOut((W1 + 10) + (W2 - 4), Bl, sY);
  end;

end;

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
    
    Bmp := NewBitmap(0,0);
    Bmp.LoadFromResourceName(HInstance, PChar('BG'));
    DrawTextOnBmp;
  end
  else Inc(InitCounter);

end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var R0: TRect;
    Width, Height: integer;
begin
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  SetRect(R0, 0, 0, Width, Height);
  SetStretchBltMode(dc, HALFTONE);
  Bmp.StretchDraw(dc, R0);
end;

procedure Close(PRec:PParamRec; ed:pointer); cdecl;
begin
  Dec(InitCounter);
  if InitCounter = 0 then Bmp.Free;
end;

procedure Change(PRec:PParamRec; ed:pointer; Index:integer); cdecl;
begin

end;


procedure MainInit;
begin
  DtNow := Date;  // —егодн€шн€€ дата
  DecodeDate(DtNow, Year, Month, Day); // √од, мес€ц, день, день недели
  sD := Int2Str(Day);
  sM := Months[Month - 1];
  sY := Int2Str(Year);
end;


exports
    Init,
    Close,
    //Change,
    Draw;


   
begin
  
  MainInit;

end.
 