library TextView;

uses
  drawShare, kol, Windows;

var 
  Initialized: boolean = false;
  
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
  if Initialized then exit;
  
  PropWidth := SearchIndex('Width');
  PropHeight := SearchIndex('Height');
  PropCaption := SearchIndex('Caption');

  Initialized := true;
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
  
  C := NewCanvas(dc);

  with C^ do
  begin
    Brush.Color := clBtnFace;
    
    FillRect (R);

    if Caption <> '' then 
    begin
      Font.FontName := 'Tahoma';
      Font.FontHeight := 16;
      Font.FontQuality := fqAntialiased;
      Font.Color := clBlack;
      repeat until not StrReplace(Caption, '\r\n', #13#10);
      DrawText(Caption, R, {DT_EDITCONTROL}DT_WORDBREAK + DT_NOPREFIX);
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
 