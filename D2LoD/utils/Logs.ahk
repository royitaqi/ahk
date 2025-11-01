#include SaveAndLoad.ahk


Say(text, delay := 100) {
    Send "{Enter}"
    Sleep 50
    Send text
    Sleep 50
    Send "{Enter}"
    Sleep delay
}

LogToFile(text) {
    FileAppend(text "`n", "log.txt")
}

Log(text) {
    LogToFile(text)

    if (IsGameLoaded() && !IsGamePaused()) {
        Say(text)
    }
}
