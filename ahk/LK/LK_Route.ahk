LK_Run1stHut() {
    global
    ; Blink to hut
    Press "C", s_Press_Delay
    ClickOrMove 864, 445, "", s_Premove_Delay
    ClickOrMove 864, 445, "Right", s_Blink_Delay
    ClickOrMove 864, 445, "Right", s_Blink_Delay
    ClickOrMove 864, 445, "Right", s_Blink_Delay
    ClickOrMove 864, 445, "Right", s_Blink_Delay
    ; Open 1st chest
    Press "R", s_Press_Delay
    ClickOrMove 498, 280, "", s_Premove_Delay
    ClickOrMove 498, 280, "Right", s_Pick_Delay
    ; Open 2nd chest
    Press "R", s_Press_Delay
    ClickOrMove 856, 375, "", s_Premove_Delay
    ClickOrMove 856, 375, "Right", s_Pick_Delay
}

LK_Gather1stHutLoot() {
    ClickOrMove 417, 312, "", s_Premove_Delay
    ClickOrMove 417, 312, "Left", 500
    ClickOrMove 934, 327, "", s_Premove_Delay
    ClickOrMove 934, 327, "Left", 1000
    ClickOrMove 613, 344, "", s_Premove_Delay
    ClickOrMove 613, 344, "Left", 500
}

LK_Run2ndHut() {
    ; Blink to hut
    Press "C", s_Press_Delay
    ClickOrMove 940, 300, "", s_Premove_Delay
    ClickOrMove 940, 300, "Right", s_Blink_Delay
    ClickOrMove 940, 300, "Right", s_Blink_Delay
    ClickOrMove 940, 300, "Right", s_Blink_Delay
    ClickOrMove 940, 300, "Right", s_Blink_Delay
    ; Open chest
    Press "R", s_Press_Delay
    ClickOrMove 575, 290, "", s_Premove_Delay
    ClickOrMove 575, 290, "Right", s_Pick_Delay
}

LK_Gather2ndHutLoot() {
    ClickOrMove 617, 363, "Left", 1000
}

LK_Run3rdHut() {
    ; Blink to hut
    Press "C", s_Press_Delay
    ClickOrMove 510, 20, "", s_Premove_Delay
    ClickOrMove 510, 20, "Right", s_Blink_Delay
    ClickOrMove 510, 20, "Right", s_Blink_Delay
    ClickOrMove 510, 20, "Right", s_Blink_Delay
    ClickOrMove 510, 20, "Right", s_Blink_Delay
    ClickOrMove 510, 20, "Right", s_Blink_Delay
    ; Open chest in potential position 1
    Press "R", s_Press_Delay
    ClickOrMove 688, 328, "", s_Premove_Delay
    ClickOrMove 688, 328, "Right", s_Pick_Delay
    ; Open chest in potential position 2
    Press "R", s_Press_Delay
    ClickOrMove 658, 328, "", s_Premove_Delay
    ClickOrMove 658, 328, "Right", s_Pick_Delay
}

LK_Gather3rdHutLoot() {
    ; Walk to the chest
    ClickOrMove 744, 375, "", s_Premove_Delay
    ClickOrMove 744, 375, "Left", 1200
    ; Walk around 
    ClickOrMove 432, 305, "", s_Premove_Delay
    ClickOrMove 432, 305, "Left", 500
}

LK_Run4thHut() {
    ; Blink to hut
    Press "C", s_Press_Delay
    ClickOrMove 80, 325, "", s_Premove_Delay
    ClickOrMove 80, 325, "Right", s_Blink_Delay
    ClickOrMove 80, 325, "Right", s_Blink_Delay
    ClickOrMove 80, 325, "Right", s_Blink_Delay
    ; Open 1st chest
    Press "R", s_Press_Delay
    ClickOrMove 725, 290, "", s_Premove_Delay
    ClickOrMove 725, 290, "Right", s_Pick_Delay
    ; Open 2nd chest
    Press "R", s_Press_Delay
    ClickOrMove 390, 210, "", s_Premove_Delay
    ClickOrMove 390, 210, "Right", s_Pick_Delay
}

LK_Gather4thHutLoot() {
    ; Blink to one chest
    Press "C", s_Press_Delay
    ClickOrMove 329, 217, "", s_Premove_Delay
    ClickOrMove 329, 217, "Right", s_Blink_Delay
    ; Pick up around the chest
    ClickOrMove 639, 244, "", s_Premove_Delay
    ClickOrMove 639, 244, "Left", 500

    ; Blink to the second chest
    Press "C", s_Press_Delay
    ClickOrMove 795, 367, "", s_Premove_Delay
    ClickOrMove 795, 367, "Right", s_Blink_Delay
    ; Pick up around the chest
    ClickOrMove 632, 355, "", s_Premove_Delay
    ClickOrMove 632, 355, "Left", 500
}

LK_RunReturn()
{
    ; Blink to waypoint
    Press "C", s_Press_Delay
    ClickOrMove 155, 434, "", s_Premove_Delay
    ClickOrMove 155, 434, "Right", s_Blink_Delay
    ClickOrMove 155, 434, "Right", s_Blink_Delay
    ClickOrMove 155, 434, "Right", s_Blink_Delay
    ClickOrMove 155, 434, "Right", s_Blink_Delay
}
