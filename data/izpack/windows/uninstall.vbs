Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c uninstall.bat"
oShell.Run strArgs, 0, false