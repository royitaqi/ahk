#Requires AutoHotkey v2.0.0


try
{
    obj := ComObject("ScriptControl")
    obj.ExecuteStatement('MsgBox "This is embedded VBScript"')  ; This line produces an Error.
    obj.InvalidMethod()  ; This line would produce a MethodError.
}
catch MemberError  ; Covers MethodError and PropertyError.
{
    MsgBox "We tried to invoke a member that doesn't exist."
}
catch as e
{
    ; For more detail about the object that e contains, see Error Object.
    MsgBox("Exception thrown: " e.what ": " e.message "`n`n" e.stack) 
}
