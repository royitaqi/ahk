#include D2.ahk
#include SaveAndLoad.ahk

/*
    On Windows, tail the log file in VS Code's terminal window by running the following:
    > Get-Content 'D2LoD/log.txt' -Wait -Tail 10
*/


s_Log_File := "log.txt"
s_Log_Level := 0 ; 0 = Normal, 1 = Debug

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

Log(text, level := 0) {
    if (level > s_Log_Level) {
        return
    }

    if (level = 1) {
        text := "[D] " text
    }

    LogToFile(text)

    if (IsD2Active() && IsGameLoaded() && !IsGamePaused()) {
        Say(text)
    }
}

ClearLogFile() {
    FileOpen(s_Log_File, "w").Close()
}

IsLogLevelDebug() {
    return s_Log_Level >= 1
}

SetLogLevel(level := 0) {
    global s_Log_Level
    s_Log_Level := level
}