P_TeleportToPindleAndKill() {
    ; Blink into temple
    Press "C", s_Press_Delay
    ClickOrMove 830, 50, "", s_Premove_Delay
    ClickOrMove 830, 50, "Right", s_Blink_Delay
    ClickOrMove 830, 50, "Right", s_Blink_Delay
    ClickOrMove 830, 50, "Right", s_Blink_Delay

    ; Switch to MF gear
    Press "``", s_Press_Delay

    c_Cast_X := 771
    c_Cast_Y := 181

    ; Glacial spike
    Press "F", s_Press_Delay
    ClickOrMove c_Cast_X, c_Cast_Y, "", s_Premove_Delay
    ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay

    loop {
        ; Blizzard
        Press "W", s_Press_Delay
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay

        ; Glacial spikes
        Press "F", s_Press_Delay
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay
        ClickOrMove c_Cast_X, c_Cast_Y, "Right", s_Cast_Delay

        ; Detect bloody marble on ground
    }

    ; Repeated cast spells to kill
    throw "Done"
}
