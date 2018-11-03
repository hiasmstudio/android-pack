@echo off
echo The Android pack will be deleted from 'hiasm.db'.
echo Press any key to continue.
pause
@echo on
..\..\Plug\sqlite3.exe ..\..\Int\hiasm.db <del_pack.sql