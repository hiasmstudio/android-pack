type
  lng_indexer = (
    lng_BlockToUtf8,
    lng_ColorForCode,
    lng_ColorForXML,
    lng_CreateDir,
    lng_FileCopy,
    lng_GetSrcDir,
    lng_ImportClass,
    lng_PrintBlockArray,
    lng_PropToFile,
    lng_SaveStreamArray,
    lng_StrLen,
    lng_StrToJava,
    lng_StrToUtf8,
    lng_StrToXML,
    lng_last // Обязательно должен быть последним в списке
  );

var UT_Boolean,
    UT_Byte,
    UT_Short,
    UT_Long,
    UT_Float,
    UT_Char: byte;
  
procedure _tostr_proc(var s:string);
begin
  //MessageBox(0, PChar(s), PChar(''), 1);
  //replace(s, '"', '\"');
end;

function ins_func2(const l_func:string; data:PScData; const r_func:string; sub:integer):PScData;
begin
  Result := MakeData(l_func + data.toCode + r_func, true);
  Result.SetSubType(sub);
end;

function ins_func(const func:string; data:PScData; sub:integer):PScData;
begin
  Result := MakeData(func + '(' + data.toCode + ')', true);
  Result.SetSubType(sub);
end;

function make_cast(const CastTo:string; data:PScData; sub:integer):PScData;
begin
  Result := MakeData('((' + CastTo + ') ' + data.toCode +')', true);
  Result.SetSubType(sub);
end;

procedure PrintArrayRecursive(parser: TParser; val: PScData);
var i:integer; arr: PScArray;
  procedure PrintBlock (blk:string);
  begin
    parser.codeb.CopyTo(blk, parser.codeb.CurBlockName);
    parser.codeb.Delete(blk);
    //parser.cgt._debug(PChar(blk), clRed);
  end;
begin
  case val.GetType of
    data_code, data_str:
    begin
      PrintBlock(val.toStr);
    end;  
    
    data_array:
    begin
      arr := val.toArray;
      for i := 0 to arr.Count-1 do
      begin
        PrintArrayRecursive(parser, arr.Items[i]);
      end;    
    end;
  end;    
end;


function _toCode(data:PScData; toType:byte):PScData;
begin
   Result := data;

  case toType of
  
    data_int:
      case data.GetType of
        data_int: ;
        data_str, data_real: Result := MakeData(data.toInt);
        data_code, data_array:
          case data.GetSubType of
            data_int: ;
            data_str: Result := ins_func('Integer.parseInt', data, toType);
            data_real: Result := make_cast('int', data, toType); 
            data_object: Result := ins_func2('', data, '.readInt()', toType);
          else
            if data.GetSubType = UT_Boolean then Result := ins_func2 ('(', data, '?1:0)', toType)
            else if data.GetSubType = UT_Byte then Result := make_cast('int', data, toType)
            else if data.GetSubType = UT_Short then Result := make_cast('int', data, toType)
            else if data.GetSubType = UT_Long then Result := make_cast('int', data, toType)
            else if data.GetSubType = UT_Float then Result := make_cast('int', data, toType)
            else if data.GetSubType = UT_Char then Result := make_cast('int', data, toType)
            else
              Result.SetValue(0);
          end;
      else
        Result.SetValue(0);
      end;
      
    data_str:
      case data.GetType of
        data_int, data_real: 
          begin
            Result := MakeData(data.toStr);
            Result.SetType(data_str);
          end;
        data_str: ; 
        data_code, data_array:
          case data.GetSubType of
            data_int, data_real: Result := ins_func('String.valueOf', data, toType);
            data_str:;
            data_object: Result := ins_func2('', data, '.readString()', toType);
          else 
            if data.GetSubType = UT_Boolean then Result := ins_func2 ('(', data, '?"1":"0")', toType)
            else if (data.GetSubType = UT_Byte) or
                    (data.GetSubType = UT_Short) or
                    (data.GetSubType = UT_Long) or
                    (data.GetSubType = UT_Float) or
                    (data.GetSubType = UT_Char)
            then Result := ins_func('String.valueOf', data, toType)
            else
            begin
              Result.SetValue('', toType);
              Result.SetSubType(0);
            end;
          end;
      else
        Result.SetValue('', toType);
      end;
      
    data_real:
      case data.GetType of
        data_real: ;
        data_str, data_int: Result := MakeData(data.toReal);
        data_code, data_array:
          case data.GetSubType of
            data_int: Result := make_cast('double', data, toType);
            data_str: Result := ins_func('Double.parseDouble', data, toType);
            data_real: ;
            data_object: Result := ins_func2('', data, '.readDouble()', toType);
          else
            if data.GetSubType = UT_Boolean then Result := ins_func2 ('(', data, '?1.0:0.0)', toType)
            else if data.GetSubType = UT_Byte then Result := make_cast('double', data, toType)
            else if data.GetSubType = UT_Short then Result := make_cast('double', data, toType)
            else if data.GetSubType = UT_Long then Result := make_cast('double', data, toType)
            else if data.GetSubType = UT_Float then Result := make_cast('double', data, toType)
            else if data.GetSubType = UT_Char then Result := make_cast('double', data, toType)
            else
              Result.SetValue('0.0', toType);
          end;
      else
        Result.SetValue('0.0', toType);
      end;
      
    else
    begin
      if toType = UT_Boolean then      
        case data.GetType of
          data_int: if (data.toInt = 0) then Result := MakeData('false', true) else Result := MakeData('true', true); 
          data_real: if (data.toReal = 0) then Result := MakeData('false', true) else Result := MakeData('true', true);
          data_str: if (data.toStr = '') or (data.toStr = '0') then Result := MakeData('false', true) else Result := MakeData('true', true);
          data_code, data_array:
            case data.GetSubType of
              data_int, data_real: Result := ins_func2 ('(', data, ' != 0)', toType);
              data_str: Result := ins_func2 ('(', data, '.compareTo("0") == 1)', toType);
              data_object: Result := ins_func2('', data, '.readBool()', toType);
            else
              if (data.GetSubType = UT_Byte) or
                 (data.GetSubType = UT_Short) or
                 (data.GetSubType = UT_Long) or
                 (data.GetSubType = UT_Float) or
                 (data.GetSubType = UT_Char)
              then Result := ins_func2 ('(', data, ' != 0)', toType)
              else if data.GetSubType <> UT_Boolean then
                begin
                  Result.SetValue('false', data_code);
                  Result.SetSubType(toType);
                  Exit;
                end;
            end;
        else 
          Result.SetValue('false', data_code);
          Result.SetSubType(toType);
          Exit;
        end;
        
      if toType = UT_Byte then      
        case data.GetType of
          data_int, data_str, data_real: Result := MakeData(byte(data.toInt));
          data_code, data_array:
            case data.GetSubType of
              data_int: Result := make_cast('byte', data, toType);
              data_str: Result := ins_func('Byte.parseByte', data, toType);
              data_real: Result := make_cast('byte', data, toType);
              data_object: Result := ins_func2('', data, '.readByte()', toType);
            else
              if data.GetSubType = UT_Boolean then Result := ins_func2 ('(', data, '?1:0)', toType)
              else if data.GetSubType = UT_Short then Result := make_cast('byte', data, toType)
              else if data.GetSubType = UT_Long then Result := make_cast('byte', data, toType)
              else if data.GetSubType = UT_Float then Result := make_cast('byte', data, toType)
              else if data.GetSubType = UT_Char then Result := make_cast('byte', data, toType)
              else if data.GetSubType <> UT_Byte then
                begin
                  Result.SetValue('((byte) 0)', data_code);
                  Result.SetSubType(toType);
                  Exit;
                end;
            end;
        else
          Result.SetValue('((byte) 0)', data_code);
          Result.SetSubType(toType);
          Exit;
        end;
        
      if toType = UT_Short then      
        case data.GetType of
          data_int, data_str, data_real: Result := MakeData(data.toInt);
          data_code, data_array:
            case data.GetSubType of
              data_int: Result := make_cast('short', data, toType);
              data_str: Result := ins_func('Short.parseShort', data, toType);
              data_real: Result := make_cast('short', data, toType);
              data_object: Result := ins_func2('', data, '.readShort()', toType);
            else
              if data.GetSubType = UT_Boolean then Result := ins_func2 ('(short)(', data, '?1:0)', toType)
              else if data.GetSubType = UT_Byte then Result := make_cast('short', data, toType)
              else if data.GetSubType = UT_Long then Result := make_cast('short', data, toType)
              else if data.GetSubType = UT_Float then Result := make_cast('short', data, toType)
              else if data.GetSubType = UT_Char then Result := make_cast('short', data, toType)
              else if data.GetSubType <> UT_Short then
                begin
                  Result.SetValue('((short) 0)', data_code);
                  Result.SetSubType(toType);
                  Exit;
                end;
            end;
        else
          Result.SetValue('((short) 0)', data_code);
          Result.SetSubType(toType);
          Exit;
        end;
        
      if toType = UT_Long then      
        case data.GetType of
          data_int: ;
          data_str, data_real: Result := MakeData(data.toInt);
          data_code, data_array:
            case data.GetSubType of
              data_int: Result := make_cast('long', data, toType);
              data_str: Result := ins_func('Long.parseLong', data, toType);
              data_real: Result := make_cast('long', data, toType);
              data_object: Result := ins_func2('', data, '.readLong()', toType);
            else
              if data.GetSubType = UT_Boolean then Result := ins_func2 ('(', data, '?1L:0L)', toType)
              else if data.GetSubType = UT_Byte then Result := make_cast('long', data, toType)
              else if data.GetSubType = UT_Short then Result := make_cast('long', data, toType)
              else if data.GetSubType = UT_Float then Result := make_cast('long', data, toType)
              else if data.GetSubType = UT_Char then Result := make_cast('long', data, toType)
              else if data.GetSubType <> UT_Long then
                begin
                  Result.SetValue('0L', data_code);
                  Result.SetSubType(toType);
                  Exit;
                end;
            end;
        else
          Result.SetValue('0L', data_code);
          Result.SetSubType(toType);
          Exit;
        end;
      
      if toType = UT_Float then      
        case data.GetType of
          data_int: Result := make_cast('float', data, toType);
          data_str, data_real: Result := make_cast('float', MakeData(data.toReal), toType);
          data_code, data_array:
            case data.GetSubType of
              data_int: Result := make_cast('float', data, toType);
              data_str: Result := ins_func('Float.parseFloat', data, toType);
              data_real: Result := make_cast('float', data, toType);
              data_object: Result := ins_func2('', data, '.readFloat()', toType);
            else
              if data.GetSubType = UT_Boolean then Result := ins_func2 ('(', data, '?1F:0F)', toType)
              else if data.GetSubType = UT_Byte then Result := make_cast('float', data, toType)
              else if data.GetSubType = UT_Short then Result := make_cast('float', data, toType)
              else if data.GetSubType = UT_Char then Result := make_cast('float', data, toType)
              else if data.GetSubType <> UT_Float then
                begin
                  Result.SetValue('0F', data_code);
                  Result.SetSubType(toType);
                  Exit;
                end;
            end;
        else
          Result.SetValue('0F', data_code);
          Result.SetSubType(toType);
          Exit;
        end;
        
      if toType = UT_Char then      
        case data.GetType of
          data_int: Result := make_cast('char', data, toType); 
          data_str: Result := MakeData(''''+data.toStr+'''', true);
          data_real: Result := make_cast('char', data, toType);
          data_code, data_array:
            case data.GetSubType of
              data_int: Result := make_cast('char', data, toType);
              data_str: Result := ins_func2('', data, '.charAt(0)', toType);
              data_real: Result := make_cast('char', data, toType);
              data_object: Result := ins_func2('', data, '.readChar()', toType);
            else
              if data.GetSubType = UT_Boolean then Result := ins_func2 ('(', data, '?''1'':''0'')', toType)
              else if data.GetSubType = UT_Byte then Result := make_cast('char', data, toType)
              else if data.GetSubType = UT_Short then Result := make_cast('char', data, toType)
              else if data.GetSubType = UT_Long then Result := make_cast('char', data, toType)
              else if data.GetSubType = UT_Float then Result := make_cast('char', data, toType)
              else if data.GetSubType <> UT_Char then
                begin
                  Result.SetValue('((char) 0)', data_code);
                  Result.SetSubType(toType);
                  Exit;
                end;
            end;
        else
          Result.SetValue('((char) 0)', data_code);
          Result.SetSubType(toType);
          Exit;
        end;
    end;        
  end;
end;

function AnsiToUtf8Ex(const S: string; const cp : integer): string;
var
  wlen, ulen : integer;
  wbuf : PWideChar;
begin
  if cp = CP_UTF8 then 
  begin
    Result := S;
    exit;
  end;
  
  Result := '';
  wlen := MultiByteToWideChar(cp, 0, PChar(S), length(S), NIL, 0); // wlen is the number of UCS2 without NULL terminater.
  if wlen = 0 then exit;
  wbuf := GetMemory(wlen * sizeof(wchar)); 
  try
    MultiByteToWideChar(cp, 0, PChar(S), length(S), wbuf, wlen);

    ulen := WideCharToMultiByte(CP_UTF8, 0, wbuf, wlen, NIL, 0, NIL, NIL);
    setlength(Result, ulen);
    WideCharToMultiByte(CP_UTF8, 0, wbuf, wlen, PChar(Result), ulen, NIL, NIL);
  finally
    FreeMemory(WBuf);
  end;
end;



procedure StringForJava(var s:string); // Подготавливает строковой литерал для вставки в файлы *.java
begin
  Replace(s, '\\', #14); // Двойные слеши заменяем на служебный символ (чтобы не разорвать при следующей замене)
  Replace(s, '\r\n', '\n'); // Стандартный перевод строки HiAsm заменяем на требуемый в Java
  
  // Восстанавливаем двойный слеш (TODO: восстанавливать одинарный, заставляя 
  // пользователя всегда дублировать. Иначе будет неправильно работать слеш в конце строки: 'ABC\\r\nDEF')
  Replace(s, #14, '\\');
  Replace(s, '"', '\"'); // Экранируем кавычки
  s := AnsiToUtf8Ex(s, 1251);
end;

function StringForXML(s:string):string; // Подготавливает строку для вставки в атрибуты файлов *.xml
begin
  Replace(s, '&', '&amp;');
  Replace(s, '<', '&lt;');
  Replace(s, '>', '&gt;');
  //Replace(s, '''', '&apos;');
  Replace(s, '"', '&quot;'); 
  //result := AnsiToUtf8Ex(s, 1251); // В UTF-8 нужно преобразовывать вручную
  result := s;
end;

procedure ReplaceChar (var s: string; src, dst: char);
var i: integer;
begin
  for i := 1 to Length(s) do
  begin
    if s[i] = src then s[i] := dst;
  end;
end;

function IsValidProjectName (const s: string): boolean;
var 
  i: integer;
const 
  AllowedChars: set of Char = ['A'..'Z', 'a'..'z', '0'..'9', '_', '.'];
begin
  if (Length(s) = 0) or (s[1] = '.') or (s[Length(s)] = '.') then
  begin 
    Result := False;
    Exit;
  end;
  
  Result := True;
  
  for i := 1 to Length(s) do
  begin
    if not (s[i] in AllowedChars) then
    begin
      Result := False;
      break;
    end; 
  end;
end;

function ForceRelativeDirs (Dir: string): string;
var
   Lst: PStrList;
   i: integer;
begin
  Result := '';
  ReplaceChar(Dir, '\', #13);
  
  Lst := NewStrList;
  Lst.Text := Dir;
  for i := 0 to Lst.Count - 1 do
  begin
    if Length(Result) = 0 then 
      Result := Lst.Items[i]
    else
      Result := Result + '\' + Lst.Items[i]; 
    if not DirectoryExists(Result) then CreateDir(Result);
  end;
  Lst.Free;
end;

function SaveStreamArray(cgt: PCodeGenTools; Prop: integer; Prefix, Ext: string): integer;
var 
  i, c, len: Integer;
  Arr: id_array;
  s: PChar;
  fn: string;
begin
  Result := 0;
  
  Arr := id_array(cgt.propGetValue(Prop));
  if (cgt.arrType(Arr) <> data_stream) or
     (Length(Prefix) = 0)
  then exit;

  c := cgt.arrCount(Arr);

  for i := 0 to c - 1 do
  begin
    s := cgt.resAddStream(cgt.arrGetItem(Arr, i));
    if s <> nil then // = nil, если файл не загружен, но элемент в массиве добавлен
    begin
      //cgt._Debug(s, clBlue);
      len := StrLen(s);
      SetLength(fn, len);
      StrCopy(@fn[1], s);
      fn := fn + '.dat';
      CopyFile(PChar('compiler\' + fn), PChar(Prefix + Int2Str(Result) + Ext), false);
      Inc(Result)
    end;
  end;
end;


function lng_proc(parser:TParser; obj:pointer; index:integer; args:TArgs):TScData;
var utf_str, old_blk, s, s2, s3: string; i, k: integer;
    lst: PStrList;
begin
  case lng_indexer(index) of
  
    lng_BlockToUtf8:
    begin  
      old_blk := parser.codeb.Select(args.Values[0].toStr);
        for i := 0 to parser.codeb.Current.Count-1 do
        begin
          utf_str := AnsiToUtf8Ex(PScData(parser.codeb.Current.Items[i]).toCode, 1251);
          //if i = 0 then utf_str := 'п»ї' + utf_str; // Метка кодировки в начале файла
          PScData(parser.codeb.Current.Items[i]).SetValue(utf_str, data_code); 
        end;
      parser.codeb.Select(old_blk);     
    end;
    
    lng_ColorForCode:
    begin
      result.value.sdata :='0xFF' + Int2Hex(Integer(Color2RGBQuad(args.Values[0].toInt)), 6);
      result.SetType(data_code);
      Result.SetSubType(data_int);
    end;

    lng_ColorForXML:
    begin
      result.value.sdata := '#' + Int2Hex(Integer(Color2RGBQuad(args.Values[0].toInt)), 6);
      result.SetType(data_code);
    end;
    
    lng_CreateDir:
    begin
      ForceRelativeDirs(PChar(args.Values[0].toStr));
    end;
    
    lng_FileCopy:
    begin
      CopyFile(PChar(args.Values[0].toStr), PChar(args.Values[1].toStr), false);
    end;
    
    lng_GetSrcDir:
    begin
      s := args.Values[0].toStr; // Имя проекта
      if not IsValidProjectName(s) then s := 'hiasm.hiasmproject';
      ReplaceChar(s, '.', '\');
      result.SetValue(ForceRelativeDirs ('Elements\Android\code\result\src\' + s) + '\');
    end;
    
    lng_ImportClass:
    begin
      s := args.Values[0].toStr; // Исходный файл
      s2 := args.Values[1].toStr; // Конечный файл
      s3 := args.Values[2].toStr; // Package
      if (FileExists(s)) and (not FileExists(s2)) then // Если файл существует - замены не будет (в целях оптимизации)
      begin
        lst := NewStrList;
        lst.LoadFromFile(s);
          for i := 0 to lst.Count - 1 do
          begin
            if StrIsStartingFrom(lst.ItemPtrs[i], 'package ') then
            begin
              lst.Items[i] := 'package ' + s3 + ';';
              break;
            end;            
          end;
        lst.SaveToFile(s2);
        lst.Free;
      end;
    end;
    
    lng_PrintBlockArray:
    begin
      PrintArrayRecursive(parser, args.Values[0]);
    end; 
    
    lng_PropToFile:
    begin
      i := args.Values[0].toInt; // ID свойства
      s := args.Values[1].toStr; // Имя файла
      result.SetValue(-1);
      if (parser.cgt.propGetType(i) in [data_stream, data_wave, data_bitmap, data_jpeg])
        and (s <> '') then
      begin
        k := parser.findProperty(parser.cgt.propGetName(i)); // Индекс свойства в INI
        if (k <> -1) and (not parser.cgt.elIsDefProp(parser.el, k)) then
        begin
          result.SetValue(parser.cgt.propSaveToFile(i, PChar(s)));
        end;       
      end;
    end;
    
    lng_SaveStreamArray:
    begin
      i := args.Values[0].toInt; // ID свойства
      result.SetValue(0);
      if parser.cgt.propGetType(i) = data_array then
      begin
        k := parser.findProperty(parser.cgt.propGetName(i)); // Индекс свойства в INI
        if (k <> -1) and (not parser.cgt.elIsDefProp(parser.el, k)) then
        begin
          result.SetValue(SaveStreamArray(parser.cgt, i,
                                          args.Values[1].toStr,  // Префикс имен
                                          args.Values[2].toStr) // Расширение
                          );
        end;       
      end;
    end;
    
    lng_StrLen:
    begin
      result.SetValue(Length(args.Values[0].toStr));
    end;
    
    lng_StrToJava:
    begin  
      s := args.Values[0].toStr;
      StringForJava(s);
      result.SetValue(s, data_str);
    end; 
    
    lng_StrToUtf8:
    begin  
      result.SetValue(AnsiToUtf8Ex(args.Values[0].toStr, 1251), data_str);
    end; 
    
    lng_StrToXML:
    begin
      result.SetValue(StringForXML(args.Values[0].toStr), data_str);
    end;

  end;
end;

procedure _readCustomProperty(Return:PScData; e:id_element; cgt:PCodeGenTools; prop:id_prop);
begin
  //cgt._Debug(PChar('abcdef'), clBlue);
  
  case cgt.propGetType(prop) of
    data_str:
    begin
      StringForJava(Return.value.sdata);
    end;
    
    data_data:
    begin
      if Return.GetType = data_str then StringForJava(Return.value.sdata);
    end;
    
    data_stream, data_wave, data_bitmap, data_jpeg:
      Return.setValue(prop); // Возвращает ID свойства
    
    data_array:
    begin
      // Для свойства-массива с типом элементов "10" (data_stream) 
      // возвращает ID свойства
      if cgt.arrType(id_array(cgt.propGetValue(prop))) = 10 then
        Return.setValue(prop);
    end;    
  end;

end;



procedure fill_lng_object(var methods:TAObjMethod; var count:integer);
begin
  UT_Boolean := RegisterUserType('Boolean');
  UT_Byte := RegisterUserType('Byte');
  UT_Short := RegisterUserType('Short');
  UT_Long := RegisterUserType('Long');
  UT_Float := RegisterUserType('Float');
  UT_Char := RegisterUserType('Char');
  
  readCustomProperty := _readCustomProperty;

  count := integer(lng_last); 
  setlength(methods, count);
  
  // Преобразовывает содержимое блока в UTF-8
  methods[integer(lng_BlockToUtf8)] := MakeMethod('blocktoutf8', 1, 'BlockName');
  // Возвращает цвет в формате 0x00RRGGBB
  methods[integer(lng_ColorForCode)] := MakeMethod('colorforcode', 1, 'Color');
  // Возвращает цвет в формате #RRGGBB
  methods[integer(lng_ColorForXML)] := MakeMethod('colorforxml', 1, 'Color');
  // Создать каталог
  methods[integer(lng_CreateDir)] := MakeMethod('createdir', 1, 'Path');
  // Копирует файлы
  methods[integer(lng_FileCopy)] := MakeMethod('filecopy', 2, 'SourceFile, DestFile');
  // Формирует каталог исходного кода в папке result\src по заданному имени проекта и возвращает его 
  methods[integer(lng_GetSrcDir)] := MakeMethod('getsrcdir', 1, 'PkgName');
  // Копирует файл исходного кода SrcFile в DstFile, заменяя в нём "package XXXX;" на Package
  methods[integer(lng_ImportClass)] := MakeMethod('importclass', 3, 'SrcFile, DstFile, Package');
  // Выводит в текущий блок все блоки из многомерного массива имен
  methods[integer(lng_PrintBlockArray)] := MakeMethod('printblockarray', 1, 'ArrayOfBlocks'); 
  // Сохраняет содержимое свойства типа Stream в файл
  methods[integer(lng_PropToFile)] := MakeMethod('proptofile', 2, 'Property, FileName');
  // Сохраняет содержимое свойства типа "массив стримов" в указанную папку
  // Prefix - префикс имен файлов вместе с путем вида "папка\папка\файл"; Ext - расширение файлов (с точкой)
  // Результат: "папка\папка\файлХХХext", где ХХХ от 0 до Count-1. Возвращает количество элементов массива
  methods[integer(lng_SaveStreamArray)] := MakeMethod('savestreamarray', 3, 'Property, Prefix, Ext'); 
  // Возвращает длину строки
  methods[integer(lng_StrLen)] := MakeMethod('strlen', 1, 'String');
  // Переводит строку в UTF-8 и экранирует спецсимволы
  methods[integer(lng_StrToJava)] := MakeMethod('strtojava', 1, 'String');
  // Переводит строку в UTF-8
  methods[integer(lng_StrToUtf8)] := MakeMethod('strtoutf8', 1, 'String');
  // Переводит строку в формат XML (экранированы спец. символы)
  methods[integer(lng_StrToXML)] := MakeMethod('strtoxml', 1, 'String');
end;

const
  lng_count = 1;
  lngs:array[0..lng_count-1] of TLangRec = (
     (entry:'MainActivity'; name:'java';  str_del_o: '"'; str_del_c: '"'; op_del: ' + ';   var_mask:'%n%i'; tostr_proc:_tostr_proc)
  );
