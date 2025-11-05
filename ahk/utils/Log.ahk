#include D2.ahk
#include SaveAndLoad.ahk

/*
    On Windows, tail the log file in VS Code's terminal window by running the following:
    > Get-Content 'D2LoD/log.txt' -Wait -Tail 10
*/


s_Log_File := "log.txt"
s_Log_Level := 0 ; -3=Error, -2=Warning, -1=Important, 0=Normal, 1=Debug, 2=Verbose

Say(text, delay := 100) {
    Send "{Enter}"
    Sleep 50
    Send text
    Sleep 50
    Send "{Enter}"
    Sleep delay
}

LogToFile(text) {
    now := FormatTime(A_Now, "HH:mm")
    FileAppend(now " - " text "`n", s_Log_File)
}

Log(text, level := 0) {
    if (level > s_Log_Level) {
        return
    }

    if (level = -3) {
        text := "ERROR: " text
    }
    if (level = -2) {
        text := "WARNING: " text
    }
    if (level = -1) {
        text := "IMPORTANT: " text
    }
    if (level = 1) {
        text := "DEBUG: " text
    }
    if (level = 2) {
        text := "VERBOSE: " text
    }

    LogToFile(text)

    if (IsD2Active() && IsGameLoaded() && !IsGamePaused()) {
        Say(text)
    }
}

LogError(text) {
    Log(text, -3)
}

LogWarning(text) {
    Log(text, -2)
}

LogImportant(text) {
    Log(text, -1)
}

LogDebug(text) {
    Log(text, 1)
}

LogVerbose(text) {
    Log(text, 2)
}

ClearLogFile() {
    FileOpen(s_Log_File, "w").Close()
}

IsLogLevelDebug() {
    return s_Log_Level >= 1
}

LogLevelDebug() {
    global s_Log_Level
    s_Log_Level := 1
}

IsLogLevelVerbose() {
    return s_Log_Level >= 2
}

LogLevelVerbose() {
    global s_Log_Level
    s_Log_Level := 2
}
