set ANDROID_HOME=%~dp0..\..\..\..\compiler\android

java.exe -classpath ..\..\..\..\compiler\Android\Java\ant\lib\ant-launcher.jar -Dant.home=..\..\..\..\compiler\Android\Java\ant org.apache.tools.ant.launch.Launcher -cp .;..\..\..\..\compiler\Android\Java\lib\tools.jar -f build.xml debug
pause
