@ECHO OFF

set dir=%APPDATA%\NeSI\Grisu

if NOT EXIST "%dir%" (
	MD "%dir%"
)
if NOT EXIST "%dir%\combinedClient-binary.jar" (
	COPY ..\resources\combinedClient-binary.jar "%dir%\combinedClient-binary.jar"
)

if NOT EXIST "%dir%\getdown.txt" (
	COPY ..\resources\getdown.txt "%dir%\getdown.txt"
)

if NOT EXIST "%dir%\grisu.png" (
	COPY ..\resources\grisu.png "%dir%\grisu.png"
)



setlocal EnableDelayedExpansion
FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment" /v CurrentVersion') DO set CurVer=%%B

FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment\!CurVer!" /v JavaHome') DO set JAVA_HOME=%%B

set JAVA_EXE=!JAVA_HOME!\bin\java.exe

REM @echo Using Java: !JAVA_EXE!
if NOT EXIST "!JAVA_EXE!" (

	@echo Can't find Java executable. Please contact support: m.binsteiner@auckland.ac.nz

	
) ELSE (

	@echo Checking for updates. This might take a while...
	"!JAVA_EXE!" -Dsilent -jar "..\resources\getdown-client.jar" "%dir%"

	set X509_USER_PROXY=%USERPROFILE%\.grid\grid.proxy

	@echo Using proxy path: "!X509_USER_PROXY!"

	"!JAVA_EXE!" -cp "%dir%\combinedClient-binary.jar" grisu.gricli.Gricli "%*"
)
