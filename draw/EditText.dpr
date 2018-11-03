library EditText;

uses
  drawShare, kol, Windows;

var 
  Initialized: boolean = false;
  
  // Индексы свойств (чтобы не искать при каждой перерисовке)
  PropWidth,
  PropHeight,
  PropText,
  PropHint: integer;


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
  PropText := SearchIndex('Text');
  PropHint := SearchIndex('Hint');

  Initialized := true;
end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    R: TRect;
    Width, Height: integer;
    Text, Hint : string;
begin
  
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  Text := string(PRec[PropText].Value^);
  Hint := string(PRec[PropHint].Value^);
  
  C := NewCanvas(dc);
  SetRect(R, 4, 2, Width - 8, Height - 4);
  with C^ do
  begin
    Pen.Color := $2894ff;
    Pen.PenWidth := 2;
    Brush.Color := clWhite;
    RoundRect (0, 0, Width, Height, 6, 6);
    
    Brush.BrushStyle := bsClear;
    Font.FontName := 'Tahoma';
    Font.FontHeight := 20;
    Font.FontQuality := fqAntialiased;
    //Font.FontStyle := [fsBold];
    if Text <> '' then 
    begin
      Font.Color := clBlack;
      StrReplace(Text, '\r\n', #13#10);
      DrawText(Text, R, {DT_EDITCONTROL}DT_WORDBREAK + DT_NOPREFIX);
    end
    else if Hint <> '' then
    begin
      Font.Color := clSilver;
      StrReplace(Hint, '\r\n', #13#10);
      DrawText(Hint, R, {DT_EDITCONTROL}DT_WORDBREAK + DT_NOPREFIX);
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
 