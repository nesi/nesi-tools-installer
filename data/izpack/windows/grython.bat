@ECHO OFF

set dir=%APPDATA%\NeSI\Grisu

if NOT EXIST "%dir%" (
	MD "%dir%"
)
if NOT EXIST "%dir%\grid-client-core.jar" (
	COPY ..\resources\grid-client-core.jar "%dir%\grid-client-core.jar"
)

if NOT EXIST "%dir%\grid-client-dependencies.jar" (
	COPY ..\resources\grid-client-dependencies.jar "%dir%\grid-client-dependencies.jar"
)


if NOT EXIST "%dir%\getdown.txt" (
	COPY ..\resources\getdown.txt "%dir%\getdown.txt"
)

if NOT EXIST "%dir%\nesi.png" (
	COPY ..\resources\nesi.png "%dir%\nesi.png"
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
	
	if EXIST "%dir%\java_vm\bin\java.exe" (

		set JAVA_EXE=%dir%\java_vm\bin\java.exe

	)
	
	cd %HOMEDRIVE%%HOMEPATH%

	REM @echo Using java: "!JAVA_EXE!"
	REM "!JAVA_EXE!" -cp "%dir%\grid-client-core.jar;%dir%\grid-client-dependencies.jar" grisu.gricli.Gricli "%*"
	"!JAVA_EXE!" -cp "%dir%\grid-client-core.jar;%dir%\grid-client-dependencies.jar" grisu.Grython -b bestgrid
)
