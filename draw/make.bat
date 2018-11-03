@echo off
echo "Making custom draw DLLs for Android pack"
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi Button.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi CalendarView.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi CheckBox.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi DatePicker.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi EditText.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi ImageGridView.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi ProgressBar.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi RadioButton.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi SeekBar.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi TextView.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi TimePicker.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi ToggleButton.dpr
pause