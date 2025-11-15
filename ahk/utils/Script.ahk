#include D2.ahk
#include Log.ahk


StopScript(msg := "", try_to_pause_and_notify := true) {
    ; Print/log the message is possible
    if (msg) {
        LogError(msg)
    }

    ; Try to pause the game and play notification sound
    if (try_to_pause_and_notify) {
        LogDebug("Trying to pause the game and play notification sound")
        PauseGameIfPossible()
        SoundPlay("sounds/Notification.aac", 1)
    }

    ; Actually stop the script
    Reload
    Sleep 1000
    throw "Should have reloaded"
}

StopScriptWhenD2BecomeInactive() {
    Impl() {
        if (!IsD2Active()) {
            StopScript("Stopping script because D2 became inactive", false)
        }
    }
    SetTimer(Impl, 1000)
}

IsMainScript(scriptname) {
    return A_ScriptName = scriptname
}

RunForever(func) {
    loop {
        try {
            LogImportant("Running " func.Name)
            func.Call()
        } catch Error as err {
            LogError("Exception was thrown. " err.what ": " err.message "`n`n" err.stack)

            ; Make sure D2 window is activated
            hwnd := WinGetID("Diablo II")
            WinActivate { Hwnd: hwnd } ; https://www.autohotkey.com/docs/v2/misc/WinTitle.htm
            
            ; Play alarm sound, but don't wait for it because it's too long
            SoundPlay("sounds/WarSiren.aac", 0)
            
            ; Reload the game
            ReloadFromAnywhere()
        }
    }
}
