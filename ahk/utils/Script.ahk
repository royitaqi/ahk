#include D2.ahk
#include Log.ahk


StopScript(msg := "", try_to_pause_and_notify := true)
{
    ; Print/log the message is possible
    if (msg) {
        Log(msg)
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


StopScriptWhenD2BecomeInactive()
{
    Impl() {
        if (!IsD2Active()) {
            StopScript("Stopping script because D2 became inactive", false)
        }
    }
    SetTimer(Impl, 1000)
}
