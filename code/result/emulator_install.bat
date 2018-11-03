..\..\..\..\compiler\Android\platform-tools\adb.exe -s emulator-5554 uninstall hiasm.hiasmproject
..\..\..\..\compiler\Android\platform-tools\adb.exe -s emulator-5554 install bin\HiAsmMain-debug.apk
:pause
..\..\..\..\compiler\Android\platform-tools\adb.exe kill-server
