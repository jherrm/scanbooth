; AutoHotkey stuff
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ScanBooth Stuff

; Start ReconstructMe command line application
Run "C:\ReconstructMe\Start ReconstructMe Record OpenNI.bat"

; Wait until ReconstructMe starts
WinWait C:\Windows\system32\cmd.exe
Sleep 500

; Agree to the terms of service
Send y{Enter}

; Wait until the window closes
; NOTE: since ReconstructMe runs under cmd.exe, this
; script will wait until ALL cmd.exe windows are closed
WinWaitClose

; Wait a sec until things actually close
Sleep 1000

; Go to the next step - move the
Run C:\ScanBooth\automation\move_scans.bat
