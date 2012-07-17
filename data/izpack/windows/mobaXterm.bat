@ECHO OFF

set dir=%APPDATA%\NeSI\MobaXTerm
set grisu_dir=%APPDATA%\NeSI\Grisu

if NOT EXIST "%dir%" (
	MD "%dir%"
)

echo DIR %dir%

if NOT EXIST "%dir%\mobaxterm.exe" (
	COPY ..\bin\mobaxterm.exe "%dir%\mobaxterm.exe"
)

if NOT EXIST "%dir%\MobaXterm.ini.auto" (

	if NOT EXIST "%grisu_dir%" (
		MD "%grisu_dir%"
	)

	if NOT EXIST "%grisu_dir%\combinedClient-binary.jar" (
		COPY ..\resources\combinedClient-binary.jar "%grisu_dir%\combinedClient-binary.jar"
	)

	if NOT EXIST "%grisu_dir%\getdown.txt" (
		COPY ..\resources\getdown.txt "%grisu_dir%\getdown.txt"
	)

	if NOT EXIST "%grisu_dir%\grisu.png" (
		COPY ..\resources\grisu.png "%grisu_dir%\grisu.png"
	)
	

	setlocal EnableDelayedExpansion
	FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment" /v CurrentVersion') DO set CurVer=%%B

	echo version "!CurVer!"
	
	FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment\!CurVer!" /v JavaHome') DO set JAVA_HOME=%%B

	set JAVA_EXE=!JAVA_HOME!\bin\java.exe

	@echo Using Java: !JAVA_EXE!
	if NOT EXIST "!JAVA_EXE!" (

		ECHO WScript.Echo( "Can't find Java executable." ^& vbCrLf ^& vbCrLf ^& "Please contact support:" ^& vbCrLf ^& vbCrLf ^& "m.binsteiner@auckland.ac.nz" ^)  > usermessage.vbs
		WSCRIPT.EXE usermessage.vbs
		DEL usermessage.vbs
	)

	"!JAVA_EXE!" -cp "%grisu_dir%\combinedClient-binary.jar" "grisu.frontend.view.swing.utils.ssh.SshKeyCopyFrame" "..\resources\MobaXterm.ini" "%dir%"

)

%dir%\mobaxterm.exe"


