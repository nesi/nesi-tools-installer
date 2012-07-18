@ECHO OFF

set dir=%APPDATA%\NeSI\Grisu

if NOT EXIST "%dir%" (
	MD "%dir%"
)

if NOT EXIST "%dir%\grid-client.jar" (
	COPY ..\resources\grid-client.jar "%dir%\grid-client.jar"
)

if NOT EXIST "%dir%\grid-client-dependencies.jar" (
	COPY ..\resources\grid-client-dependencies.jar "%dir%\grid-client-dependencies.jar"
)


if NOT EXIST "%dir%\getdown.txt" (
	COPY ..\resources\getdown.txt "%dir%\getdown.txt"
)

if NOT EXIST "%dir%\grisu.png" (
	COPY ..\resources\grisu.png "%dir%\grisu.png"
)




setlocal EnableDelayedExpansion
FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment" /v CurrentVersion') DO set CurVer=%%B

REM echo version "!CurVer!"

FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment\!CurVer!" /v JavaHome') DO set JAVA_HOME=%%B

set JAVA_EXE=!JAVA_HOME!\bin\java.exe

REM @echo Using Java: !JAVA_EXE!
if NOT EXIST "!JAVA_EXE!" (

	ECHO WScript.Echo( "Can't find Java executable." ^& vbCrLf ^& vbCrLf ^& "Please contact support:" ^& vbCrLf ^& vbCrLf ^& "m.binsteiner@auckland.ac.nz" ^)  > %TMP%\usermessage.vbs
	WSCRIPT.EXE %TMP%\usermessage.vbs
	DEL %TMP%\usermessage.vbs
) ELSE (

	set X509_USER_PROXY=%USERPROFILE%\.grid\grid.proxy

	@echo Using proxy path: "!X509_USER_PROXY!"

    "!JAVA_EXE!" -jar "..\resources\getdown-client.jar" "%dir%" setup

)