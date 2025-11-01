#include D2.ahk
#include Logs.ahk


StopScript(msg := "", try_to_pause_and_notify := true)
{
    ; Print/log the message is possible
    if (msg) {
        Log(msg)
    }

    ; Try to pause the game and play notification sound
    if (try_to_pause_and_notify) {
        PauseGameIfPossible()
        SoundPlay("sounds/Notification.aac", 1)
    }

    ; Actually stop the script
    Reload
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
