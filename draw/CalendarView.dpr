library CalendarView;

uses
  drawShare, kol, Windows;

const
  Days : array [0..6] of string[2] = ('Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс');


var 
  Initialized: boolean = false;
  
  // Индексы свойств (чтобы не искать при каждой перерисовке)
  PropWidth,
  PropHeight,
  PropShowWeekNum,
  PropWeekCount,
  PropCFocMonth,
  PropCUnFocMonth,
  PropCWeekNum,
  PropCWeekSep,
  PropCWeekBG : integer;

  
  DtNow : TDateTime;
  DayOfWeek, // 0-based
  Day, Month, Year : word;  
  Week: byte; // Номер первой недели месяца
  CurMonthStart: byte; // Номер дня недели первого числа текущего месяца
  DaysInCurMonth: byte; // Количество дней текущего месяца
  
  CalendarTitle: string;
  DayNumbers: array [0..41] of string[2];
  WeekNumbers: array [0..5] of string[2];

  NeededWeeks: byte = 6;

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
  PropShowWeekNum := SearchIndex('ShowWeekNumbers');
  PropWeekCount := SearchIndex('WeekCount');
  PropCFocMonth := SearchIndex('FocusedMonth');
  PropCUnFocMonth := SearchIndex('UnfocusedMonth');
  PropCWeekNum := SearchIndex('WeekNumber');
  PropCWeekSep := SearchIndex('WeekSeparator');
  PropCWeekBG := SearchIndex('SelectedWeekBG');

  Initialized := true;
end;

procedure Draw(PRec:PParamRec; ed:pointer; dc:HDC); cdecl;
var C: PCanvas;
    i, k, n, v_step, h_step: integer;
    R0: TRect;
    Sz:TSize;

    Width, Height: integer;
    ShowWeekNum, WeekCount : integer;
    CFocMonth,
    CUnFocMonth,
    CWeekNum,
    CWeekSep,
    CWeekBG : TColor;
begin
  
  Width := integer(PRec[PropWidth].Value^);
  Height := integer(PRec[PropHeight].Value^);
  ShowWeekNum := ord(boolean(PRec[PropShowWeekNum].Value^));
  WeekCount := integer(PRec[PropWeekCount].Value^);
  CFocMonth := TColor(PRec[PropCFocMonth].Value^);
  CUnFocMonth := TColor(PRec[PropCUnFocMonth].Value^);
  CWeekNum := TColor(PRec[PropCWeekNum].Value^);
  CWeekSep := TColor(PRec[PropCWeekSep].Value^);
  CWeekBG := TColor(PRec[PropCWeekBG].Value^);
  
  if (WeekCount < 1) or (WeekCount > NeededWeeks) then WeekCount := NeededWeeks;
  
  
  v_step := Height div (WeekCount + 2);
  if v_step < 10 then v_step := 10;
  
  //SetBkMode(dc, TRANSPARENT);
  C := NewCanvas(dc);

  with C^ do
  begin
    Brush.Color := clBlack;
    Pen.Color := CWeekSep;
    Font.Color := clWhite;
    Font.FontHeight := v_step - 4;
    Font.FontName := 'Arial';
  end;
  
  // Заливка фона
  SetRect(R0, 0, 0, Width, Height);
  C.FillRect(R0);
  
  // Заливка фона текущей недели
  C.Brush.Color := CWeekBG;
  k := ((CurMonthStart + Day ) div 7) * v_step + v_step*2;
  SetRect(R0, 0, k, Width, k + v_step);
  C.FillRect(R0);
  C.Brush.Color := clBlack;
  
  
  GetTextExtentPoint32(dc, PChar('98'), 2, Sz);
  //Sz := C.TextExtent('98');
  
  h_step := (Width - 5) div (7 + ShowWeekNum); // div 7 or div 8
  Inc(Sz.cx, 6);
  if h_step < Sz.cx then h_step := Sz.cx;

  C.Brush.BrushStyle := bsClear;
  SetTextAlign(dc, GetTextAlign(dc) or TA_CENTER);
  
  // Заголовок
  C.TextOut((h_step*ShowWeekNum + Width) div 2, 2, CalendarTitle);

  // Номера недель
  C.Font.Color := CWeekNum;
  if (ShowWeekNum <> 0) then
  begin
    k := h_step div 2 + 2;
    for i := 0 to WeekCount - 1 do
    begin
      C.TextOut(k, i*v_step + (v_step * 2) + 2, WeekNumbers[i]);
    end;
  end;
  
  // Названия дней
  C.Font.Color := clSilver;
  for i := 0 to 6 do
  begin
    C.TextOut(i*h_step + (h_step*ShowWeekNum) + (h_step div 2), v_step, Days[i]);
  end;
  
  // Числа
  //C.Font.Color := CFocMonth;
  for i := 0 to WeekCount - 1 do
  begin
    for k := 0 to 6 do
    begin
      n := i * 7 + k; // Позиция в массиве чисел
      
      if (n < CurMonthStart) or (n > (CurMonthStart + DaysInCurMonth - 1)) 
      then C.Font.Color := CUnFocMonth 
      else C.Font.Color := CFocMonth;
      
      C.TextOut(k*h_step + (h_step*ShowWeekNum) + (h_step div 2), i*v_step + (v_step * 2) + 2, DayNumbers[n]);
    end;
  end; 

  // Линии между неделями  
  i := v_step * 3;
  while i < Height do
  begin
    C.MoveTo(0, i);
    C.LineTo(Width, i);    
    Inc(i, v_step);
  end;
  
  // Линии сегодняшнего числа
  C.Pen.Color := clRed;
  C.Pen.PenWidth := 2;
  i := (DayOfWeek + ShowWeekNum) * h_step;
  k := (((CurMonthStart + Day - 1) div 7) + 2) * v_step;
  
  C.MoveTo(i + 3, k + 2);
  C.LineTo(i + 3, k + v_step - 2); 
  C.MoveTo(i + h_step - 3, k + 2);
  C.LineTo(i + h_step - 3, k + v_step - 2); 

  C.Free;
end;

procedure Close(PRec:PParamRec; ed:pointer); cdecl;
begin

end;

procedure Change(PRec:PParamRec; ed:pointer; Index:integer); cdecl;
begin

end;


procedure CalendarInit;
var TmpDT, DTStartOfMonth : TDateTime; 
    i, k:integer; 
    DaysInPrevMonth: byte; 
begin
  Week := 0;
  DtNow := Date;  // Сегодняшняя дата
  DecodeDateFully(DtNow, Year, Month, Day, DayOfWeek); // Год, месяц, день, день недели
  Dec(DayOfWeek);
  CalendarTitle := Date2StrFmt('MMMM yyyy', DtNow); // Заголовок календаря
  
  
  EncodeDate(Year, 1, 1, TmpDT); // 01.01 текущего года
  EncodeDate(Year, Month, 1, DTStartOfMonth); // 1-е текущего месяца ...
  CurMonthStart := KOL.DayOfWeek(DTStartOfMonth) - 1; // ... на какой день оно приходится
  Week := Trunc(DTStartOfMonth - TmpDT) div 7 + 1;  // ... на какую неделю оно приходится

  DaysInCurMonth := MonthDays[IsLeapYear(Year), Month]; // Количество дней в текущем месяце ...
  if Month = 1 then DaysInPrevMonth := 31 else DaysInPrevMonth := MonthDays[IsLeapYear(Year), Month - 1]; // ... в предыдущем

  
  // Prev month days
  if CurMonthStart > 0 then // Если текущий месяц не начинается в понедельник
  begin
    k := DaysInPrevMonth;
    for i := CurMonthStart - 1 downto 0 do
    begin
      DayNumbers[i] := Int2Str(k);
      Dec(k);
    end;
  end;

  // Cur month days
  k := 1;
  for i := CurMonthStart to CurMonthStart + DaysInCurMonth - 1 do 
  begin
    DayNumbers[i] := Int2Str(k);
    Inc(k);
  end;
  
  // Next month days
  k := 1;
  for i := CurMonthStart + DaysInCurMonth to 42 do
  begin
    DayNumbers[i] := Int2Str(k);
    Inc(k);
  end;
  
  k := CurMonthStart + DaysInCurMonth + 1;
  NeededWeeks := k div 7;
  if k mod 7 > 0 then Inc(NeededWeeks);
  
  // Week numbers
  for i := 0 to NeededWeeks - 1 do 
  begin
    WeekNumbers[i] := Int2Str(Week + i);
  end;

end;


exports
    Init,
    //Close,
    //Change,
    Draw;


   
begin
  
  CalendarInit;

end.
 