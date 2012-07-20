Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c grisu-virtscreen.bat"
oShell.Run strArgs, 0, false