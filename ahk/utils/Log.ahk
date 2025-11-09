#include D2.ahk
#include SaveAndLoad.ahk


/*
    On Windows, tail the log file in VS Code's terminal window by running the following:
    > Get-Content 'D2LoD/log.txt' -Wait -Tail 10
*/
s_Log_File := "log.txt"

/*
    -3 = Error
    -2 = Warning
    -1 = Important
     0 = Info
     1 = Verbose    - Often used by business level scripts (e.g. LK, P)
     2 = Debug      - Often used by util scripts
     3 = Tedious    - Often used by util scripts for extreme details
*/
s_Log_Level := 0

Say(text, delay := 100) {
    Send "{Enter}"
    Sleep 50
    Send text
    Sleep 50
    Send "{Enter}"
    Sleep delay
}

s_Log_To_File_Buffer := ""
LogToFile(text) {
    global s_Log_To_File_Buffer
    line := s_Log_To_File_Buffer "" FormatTime(A_Now, "HH:mm:ss") " - " text "`n"
    try {
        FileAppend(line, s_Log_File)
        s_Log_To_File_Buffer := ""
    }
    catch Error {
        s_Log_To_File_Buffer := line
    }
}

ClearLogFile() {
    FileOpen(s_Log_File, "w").Close()
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
        text := "VERBOSE: " text
    }
    if (level = 2) {
        text := "DEBUG: " text
    }
    if (level = 3) {
        text := "TEDIOUS: " text
    }

    LogToFile(text)

    ; Only log to screen if it's at or above INFO level, and message can be typed into the game.
    if (level <= 0 && IsD2Active() && IsGameLoaded() && !IsGamePaused()) {
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
LogVerbose(text) {
    Log(text, 1)
}
LogDebug(text) {
    Log(text, 2)
}
LogTedious(text) {
    Log(text, 3)
}


IsLogLevelVerbose() {
    return s_Log_Level >= 1
}
IsLogLevelDebug() {
    return s_Log_Level >= 2
}
IsLogLevelTedious() {
    return s_Log_Level >= 3
}

LogLevelVerbose() {
    global s_Log_Level
    s_Log_Level := 1
}
LogLevelDebug() {
    global s_Log_Level
    s_Log_Level := 2
}
LogLevelTedious() {
    global s_Log_Level
    s_Log_Level := 3
}
