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
    while (DetectBossInMinimap()) {
        ; Glacial Spike
        Press "F"
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay

        ; Blizzard
        Press "W"
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay

        Sleep(1000)
    }

    ; Switch back to normal gear
    Press "``"
}
