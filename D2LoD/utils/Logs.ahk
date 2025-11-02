#include D2.ahk
#include SaveAndLoad.ahk

/*
    On Windows, tail the log file in VS Code's terminal window by running the following:
    > Get-Content 'D2LoD/log.txt' -Wait -Tail 10
*/


s_Log_File := "log.txt"

Say(text, delay := 100) {
    Send "{Enter}"
    Sleep 50
    Send text
    Sleep 50
    Send "{Enter}"
    Sleep delay
}

LogToFile(text) {
    FileAppend(text "`n", s_Log_File)
}

Log(text) {
    LogToFile(text)

    if (IsD2Active() && IsGameLoaded() && !IsGamePaused()) {
        Say(text)
    }
}

ClearLogFile() {
    FileOpen(s_Log_File, "w").Close()
}
