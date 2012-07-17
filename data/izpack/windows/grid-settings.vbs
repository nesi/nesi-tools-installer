Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c grid-settings.bat"
oShell.Run strArgs, 0, false