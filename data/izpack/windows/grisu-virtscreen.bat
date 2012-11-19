@ECHO OFF

set dir=%APPDATA%\NeSI\Grisu
set installdir=%~dp0


if NOT EXIST "%dir%" (
	MD "%dir%"
)


if NOT EXIST "%USERPROFILE%\.grid" (
	MD "%USERPROFILE%\.grid"
)
if NOT EXIST "%USERPROFILE%\.grisu" (
	MD "%USERPROFILE%\.grisu"
)

if NOT EXIST "%dir%\version.txt" (
	COPY "%installdir%\..\resources\version.txt" "%dir%\version.txt"
)

if NOT EXIST "%dir%\getdown.txt" (
	COPY "%installdir%\..\resources\getdown.txt" "%dir%\getdown.txt"
)

if NOT EXIST "%dir%\nesi.png" (
	COPY "%installdir%\..\resources\nesi.png" "%dir%\nesi.png"
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

    "!JAVA_EXE!" -jar "%installdir%\..\resources\getdown-client.jar" "%dir%" virtscreen

)