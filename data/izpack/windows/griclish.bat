@ECHO OFF

set dir="%APPDATA%\Grid\Grisu"

if NOT EXIST "%dir%" (
	MD "%dir%"
)
if NOT EXIST "%dir%\combinedClient-binary.jar" (
	COPY ..\resources\getdown.txt "%dir%\getdown.txt"
	COPY ..\resources\combinedClient-binary.jar "%dir%\combinedClient-binary.jar"
)



FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment" /v CurrentVersion') DO set CurVer=%%B

FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment\%CurVer%" /v JavaHome') DO set JAVA_HOME=%%B

REM @echo JAVA_HOME = %JAVA_HOME%
set JAVA_EXE=%JAVA_HOME%\bin\java.exe


if NOT EXIST "%JAVA_EXE%" (

	REM ECHO WScript.Echo( "Can't find Java executable." ^& vbCrLf ^& vbCrLf ^& "Please contact support:" ^& vbCrLf ^& vbCrLf ^& "m.binsteiner@auckland.ac.nz" ^)  > usermessage.vbs
	REM WSCRIPT.EXE usermessage.vbs
	REM DEL usermessage.vbs
	
	echo Can't find java executable. Exiting...

) ELSE (

	ECHO Checking for updates. This might take a while...
	"%JAVA_EXE%" -Dsilent -jar "..\resources\getdown-client.jar" "%dir%"

	set X509_USER_PROXY=%USERPROFILE%\.grid\grid.proxy

	echo Using proxy path: "%X509_USER_PROXY%"

	"%JAVA_EXE%" -cp "%dir%\combinedClient-binary.jar" grisu.gricli.Gricli -b nesi "%*"
)
