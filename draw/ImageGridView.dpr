library ImageGridView;

{$R *.res}

uses
  drawShare, kol, Windows;

var 
  Initialized: boolean = false;
  Bmp: KOL.PBitmap;
  
  // Индексы свойств (чтобы не искать при каждой перерисовке)
  PropWidth,
  PropHeight,
  PropNumColumns: integer;
  //PropCaption: integer;


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
  PropNumColumns := SearchIndex('NumColumns');
  //PropCaption := SearchIndex('Caption');
  
  Bmp := NewBitmap(0,0);
  Bmp.LoadFromResourceName(HInstance, PChar('IMG'));

  Initialized := true;
end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    R, R2: TRect;
    Width, Height, Cols: integer;
    //Caption: string;
    W, H, i, k, Hsp, Vsp: integer;
begin
  
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  Cols := integer(PRec[PropNumColumns].Value^);
  //Caption := string(PRec[PropCaption].Value^);
  
  C := NewCanvas(dc);

  with C^ do
  begin
    SetRect(R, 0, 0, Width, Height);
    Brush.Color := $00646464;
    FillRect (R);
    
    Hsp := 10;
    W := (Width - Hsp) div Cols;
    Dec(W, Hsp);
    
    Vsp := 10;
    H := (Height - Vsp) div Cols;
    Dec(H, Vsp);
    
    Brush.Color := clWhite;
    SetRect(R, 0, Vsp, W, H + Vsp);
    for i := 0 to Cols - 1 do
    begin
      R.Left := Hsp;
      R.Right := R.Left + W;
      for k := 0 to Cols - 1 do
      begin
        C.FillRect(R);
        SetRect(R2, R.Left + 2, R.Top + 2, R.Right - 2, R.Bottom - 2);
        Bmp.StretchDraw(dc, R2);
        OffsetRect(R, W + Hsp, 0);
      end;
      OffsetRect(R, 0, H + Vsp);
    end;

    {if Caption <> '' then 
    begin
      Font.FontName := 'Tahoma';
      Font.FontHeight := 16;
      Font.FontQuality := fqAntialiased;
      Font.Color := clBlack;
      StrReplace(Caption, '\r\n', #13#10);
      SetRect(R, 0, 0, Width, Height);
      DrawText(Caption, R, DT_NOPREFIX + DT_CENTER + DT_VCENTER + DT_SINGLELINE);
    end;}
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
 