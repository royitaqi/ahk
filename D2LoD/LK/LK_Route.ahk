s_LK_Run_Press_Delay := 100
s_LK_Run_Premove_Delay := 200
s_LK_Run_Blink_Delay := 400
s_LK_Run_Pick_Delay := 50

LK_Run1stHut() {
    global
    ; Blink to hut
    Press "C", s_LK_Run_Press_Delay
    ClickOrMove 864, 445, "", s_LK_Run_Premove_Delay
    ClickOrMove 864, 445, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 864, 445, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 864, 445, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 864, 445, "Right", s_LK_Run_Blink_Delay
    ; Open 1st chest
    Press "R", s_LK_Run_Press_Delay
    ClickOrMove 498, 280, "", s_LK_Run_Premove_Delay
    ClickOrMove 498, 280, "Right", s_LK_Run_Pick_Delay
    ; Open 2nd chest
    Press "R", s_LK_Run_Press_Delay
    ClickOrMove 856, 375, "", s_LK_Run_Premove_Delay
    ClickOrMove 856, 375, "Right", s_LK_Run_Pick_Delay
}

LK_Gather1stHutLoot() {
    ClickOrMove 876, 424, "Left", 2000
}

LK_Run2ndHut() {
    ; Blink to hut
    Press "C", s_LK_Run_Press_Delay
    ClickOrMove 940, 300, "", s_LK_Run_Premove_Delay
    ClickOrMove 940, 300, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 940, 300, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 940, 300, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 940, 300, "Right", s_LK_Run_Blink_Delay
    ; Open chest
    Press "R", s_LK_Run_Press_Delay
    ClickOrMove 575, 290, "", s_LK_Run_Premove_Delay
    ClickOrMove 575, 290, "Right", s_LK_Run_Pick_Delay
}

LK_Gather2ndHutLoot() {
    ClickOrMove 617, 363, "Left", 1000
}

LK_Run3rdHut() {
    ; Blink to hut
    Press "C", s_LK_Run_Press_Delay
    ClickOrMove 510, 20, "", s_LK_Run_Premove_Delay
    ClickOrMove 510, 20, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 510, 20, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 510, 20, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 510, 20, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 510, 20, "Right", s_LK_Run_Blink_Delay
    ; Open chest in potential position 1
    Press "R", s_LK_Run_Press_Delay
    ClickOrMove 688, 328, "", s_LK_Run_Premove_Delay
    ClickOrMove 688, 328, "Right", s_LK_Run_Pick_Delay
    ; Open chest in potential position 2
    Press "R", s_LK_Run_Press_Delay
    ClickOrMove 658, 328, "", s_LK_Run_Premove_Delay
    ClickOrMove 658, 328, "Right", s_LK_Run_Pick_Delay
}

LK_Gather3rdHutLoot() {
    ClickOrMove 744, 375, "Left", 1500
}

LK_Run4thHut() {
    ; Blink to hut
    Press "C", s_LK_Run_Press_Delay
    ClickOrMove 80, 325, "", s_LK_Run_Premove_Delay
    ClickOrMove 80, 325, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 80, 325, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 80, 325, "Right", s_LK_Run_Blink_Delay
    ; Open 1st chest
    Press "R", s_LK_Run_Press_Delay
    ClickOrMove 725, 290, "", s_LK_Run_Premove_Delay
    ClickOrMove 725, 290, "Right", s_LK_Run_Pick_Delay
    ; Open 2nd chest
    Press "R", s_LK_Run_Press_Delay
    ClickOrMove 390, 210, "", s_LK_Run_Premove_Delay
    ClickOrMove 390, 210, "Right", s_LK_Run_Pick_Delay
}

LK_Gather4thHutLoot() {
    ; Blink to one chest
    Press "C", s_LK_Run_Press_Delay
    ClickOrMove 329, 217, "", s_LK_Run_Premove_Delay
    ClickOrMove 329, 217, "Right", s_LK_Run_Blink_Delay
    ; Run towards the other chest
    ClickOrMove 947, 367, "Left", 1500
}

LK_RunReturn()
{
    ; Blink to waypoint
    Press "C", s_LK_Run_Press_Delay
    ClickOrMove 155, 434, "", s_LK_Run_Premove_Delay
    ClickOrMove 155, 434, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 155, 434, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 155, 434, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 155, 434, "Right", s_LK_Run_Blink_Delay
}
