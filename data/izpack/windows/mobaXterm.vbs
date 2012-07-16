Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c mobaXterm.bat"
oShell.Run strArgs, 0, false