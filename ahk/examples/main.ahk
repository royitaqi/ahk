#Requires AutoHotkey v2.0.0

#include main/lib.ahk


MsgBox "main.ahk:`nA_ScriptFullPath=" A_ScriptFullPath "`nA_ScriptDir=" A_ScriptDir "`nA_ScriptName=" A_ScriptName

If (A_ScriptFullPath = A_ScriptDir '\main.ahk') {
    MsgBox "main.ahk: This is the main script."
} Else {
    MsgBox "main.ahk: This is a library or included script."
}
