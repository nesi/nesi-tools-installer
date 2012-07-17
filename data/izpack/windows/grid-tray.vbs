Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c grid-tray.bat"
oShell.Run strArgs, 0, false