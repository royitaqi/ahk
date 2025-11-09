#Requires AutoHotkey v2.0.0


MsgBox "lib.ahk: A_ScriptFullPath=" A_ScriptFullPath "`nA_ScriptDir=" A_ScriptDir "`nA_ScriptName=" A_ScriptName

If (A_ScriptFullPath = A_ScriptDir '\lib.ahk') {
    MsgBox "lib.ahk: This is the main script."
} Else {
    MsgBox "lib.ahk: This is a library or included script."
}
