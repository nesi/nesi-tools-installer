@ECHO OFF

set dir=%APPDATA%\NeSI\MobaXTerm
set grisu_dir=%APPDATA%\NeSI\Grisu
set installdir=%~dp0


if NOT EXIST "%dir%" (
	MD "%dir%"
)

echo DIR %dir%

if NOT EXIST "%dir%\mobaxterm.exe" (
	COPY "%installdir%\..\bin\mobaxterm.exe" "%dir%\mobaxterm.exe"
)

if NOT EXIST "%dir%\MobaXterm.ini.auto" (

	if NOT EXIST "%grisu_dir%" (
		MD "%grisu_dir%"
	)

	if NOT EXIST "%grisu_dir%\version.txt" (
		COPY "%installdir%\..\resources\version.txt" "%grisu_dir%\version.txt"
	)

	if NOT EXIST "%grisu_dir%\getdown.txt" (
		COPY "%installdir%\..\resources\getdown.txt" "%grisu_dir%\getdown.txt"
	)

	if NOT EXIST "%grisu_dir%\nesi.png" (
		COPY "%installdir%\..\resources\nesi.png" "%grisu_dir%\nesi.png"
	)
	

	setlocal EnableDelayedExpansion
	FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment" /v CurrentVersion') DO set CurVer=%%B

	echo version "!CurVer!"
	
	FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment\!CurVer!" /v JavaHome') DO set JAVA_HOME=%%B

	set JAVA_EXE=!JAVA_HOME!\bin\java.exe

	@echo Using Java: !JAVA_EXE!
	if NOT EXIST "!JAVA_EXE!" (

		ECHO WScript.Echo( "Can't find Java executable so can't setup ssh access automatically." ^& vbCrLf ^& vbCrLf ^& "Please contact support:" ^& vbCrLf ^& vbCrLf ^& "m.binsteiner@auckland.ac.nz" ^)  > %TMP%\usermessage.vbs
		WSCRIPT.EXE %TMP%\usermessage.vbs
		DEL %TMP%\usermessage.vbs
	) else (
	
		set X509_USER_PROXY=%USERPROFILE%\.grid\grid.proxy
		@echo Checking for updates. This might take a while...
		"!JAVA_EXE!" -jar "%installdir%\..\resources\getdown-client.jar" "%grisu_dir%" update
		
		if EXIST "%grisu_dir%\java_vm\bin\java.exe" (

			set JAVA_EXE=%grisu_dir%\java_vm\bin\java.exe

		)
	
		"!JAVA_EXE!" -cp "%grisu_dir%\grid-client-core.jar;%grisu_dir%\grid-client-dependencies.jar" "grisu.frontend.view.swing.utils.ssh.SshKeyCopyFrame" "..\resources\MobaXterm.ini" "%dir%" "bestgrid"
	)

)

"%dir%\mobaxterm.exe"


