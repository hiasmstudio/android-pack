library RadioButton;

uses
  drawShare, kol, Windows;


var 
  Initialized: boolean = false;
  
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
  if Initialized then exit;

  PropWidth := SearchIndex('Width');
  PropHeight := SearchIndex('Height');
  PropChecked := SearchIndex('Checked');
  PropCaption := SearchIndex('Caption');

  Initialized := true;
end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    X1, Y1, D1, X2, Y2, D2: integer;
    
    Width, Height, Checked: integer;
    Caption: string;
begin
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  Caption := string(PRec[PropCaption].Value^);
  Checked := ord(boolean(PRec[PropChecked].Value^));
  

  D1 := 33;
  X1 := 0;
  Y1 := (Height - D1) div 2;
  D2 := 13;
  X2 := (D1 - D2) div 2;
  Y2 := (Height - D2) div 2;
  
  C := NewCanvas(dc);

  with C^ do
  begin
    Brush.Color := clWhite;
    Pen.Color := clGray;
    Pen.PenWidth := 2;
    
    Ellipse(X1, Y1, X1+D1, Y1+D1);
    if Checked = 0 then Brush.Color := clSilver else Brush.Color := clLime;//$37dd00;
    //Pen.PenWidth := 1;    
    //Pen.Color := clLime;
    Ellipse(X2, Y2, X2+D2, Y2+D2);

    if Caption <> '' then 
    begin
      Font.FontName := 'Tahoma';
      Font.FontHeight := 16;
      Font.FontQuality := fqAntialiased;
      Font.Color := clBlack;
      Brush.BrushStyle := bsClear;
      TextOut(X1 + D1 + 4, (Height - 16) div 2, Caption);
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
 