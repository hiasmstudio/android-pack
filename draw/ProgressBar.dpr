library ProgressBar;

uses
  drawShare, kol, Windows;

var 
  Initialized: boolean = false;
  
  // Индексы свойств (чтобы не искать при каждой перерисовке)
  PropWidth,
  PropHeight,
  PropDefault,
  PropMax: integer;


procedure Init(PRec:PParamRec; var ed:pointer; DTools:PDrawTools); cdecl;
  function SearchIndex(const name:string):integer;
  begin
    result := 0;
    while lowercase(PRec^[result].name) <> lowercase(name) do
      inc(result);
  end;
begin
  if Initialized then exit;
  
  PropWidth := SearchIndex('Width');
  PropHeight := SearchIndex('Height');
  PropDefault := SearchIndex('Default');
  PropMax := SearchIndex('Max');

  Initialized := true;
end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    w: integer;
    Width, Height: integer;
    PMax, PDef : integer;
begin
  
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  PMax := integer(PRec[PropMax].Value^);
  PDef := integer(PRec[PropDefault].Value^);
  
  C := NewCanvas(dc);

  with C^ do
  begin
    Pen.Color := $6b716b; // Gray
    Brush.Color := $6b716b;
    RoundRect (0, 0, Width, Height, 10, 10);
    if PMax > 0 then 
    begin
      w := Trunc(PDef * Width / PMax);
      if w < 10 then w := 10;
      Brush.Color := $00beff; // Orange
      RoundRect (0, 0, w, Height, 10, 10);
    end;
  end;
  
  C.Free;
end;

procedure Close(PRec:PParamRec; ed:pointer); cdecl;
begin

end;

procedure Change(PRec:PParamRec; ed:pointer; Index:integer); cdecl;
begin

end;



exports
    Init,
    //Close,
    //Change,
    Draw;


   
begin
  


end.
 