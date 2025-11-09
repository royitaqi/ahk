#Requires AutoHotkey v2.0.0

; Include all actual implementations first, so that the following mock happens last, so that they always override the function handles.
#include KeyboardAndMouse.ahk
#include ReadScreen.ahk


s_Unit_Testing := false
s_Mocked_D2Bitmaps := []

ClickOrMove := Noop
Press := Noop
ClearMouse := Noop
ClickOrMove2 := Noop

GetD2Bitmap := MockedGetD2Bitmap

Noop(args*) {
}

MockedGetD2Bitmap(args*) {
    global s_Mocked_D2Bitmaps
    Assert(s_Mocked_D2Bitmaps.Length >= 1, "Not enough mocked bitmaps")
    return s_Mocked_D2Bitmaps.RemoveAt(1)
}

ReportPass() {
    if (IsMainScript()) {
        MsgBox "All tests passed."
    }
}
