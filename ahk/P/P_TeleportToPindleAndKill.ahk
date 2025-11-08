#include ../utils/Monster.ahk

P_TeleportToPindleAndKill() {
    ; Blink into temple
    Press "C"
    ClickOrMove 830, 50, "", s_Premove_Delay
    ClickOrMove 830, 50, "Right", s_Blink_Delay
    ClickOrMove 830, 50, "Right", s_Blink_Delay
    ClickOrMove 830, 50, "Right", s_Blink_Delay

    ; Switch to MF gear
    Press "``"

    ; Cycle through Glacial Spike and Blizzard until Pindle is dead
    c_Cast_X := 771
    c_Cast_Y := 181
    ClickOrMove c_Cast_X, c_Cast_Y, "", s_Premove_Delay

    c_Kill_Timeout_Seconds := 12
    start_tick := A_TickCount
    timeout_tick := start_tick + c_Kill_Timeout_Seconds * 1000
    while (is_boss_alive := DetectBossInMinimap() && A_TickCount < timeout_tick) {
        ; Glacial Spike
        Press "F"
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay

        ; Blizzard
        Press "W"
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay

        Sleep(1000)

        CheckHealth([[40, P_EmergencyRestart]])
    }

    if (is_boss_alive) {
        LogWarning("Couldn't kill Pindle in 10 seconds")
    } else {
        dur := A_TickCount - start_tick
        LogVerbose("Killed Pindle in " (dur // 1000) "." Format("{:03u}", Mod(dur, 1000)) " seconds")
    }

    ; Switch back to normal gear
    Press "``"
}
