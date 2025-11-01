#Requires AutoHotkey v2.0.0

;;------------------------------------------------------------
;; Advanced Mode: 3/LK
;;------------------------------------------------------------
s_LK_Run_ID := 0
K_3LK()
{
    global s_LK_Run_ID
    s_LK_Run_ID := s_LK_Run_ID + 1
    Say("LK run " s_LK_Run_ID)

    ClickOrMove 835, 70, "", 100
    ClickOrMove 835, 70, "Left", 1750
    ClickOrMove 371, 80, "Left", 100
    ClickOrMove 408, 280, "Left", 500

    Send "B"
    Send "E"
    Click "Right"
    Sleep 500
    Send "C"
    ClickOrMove 864, 445, "", 0
}
L_3LK()
{
    MouseGetPos &xpos, &ypos
    ClickOrMove xpos, ypos, "Left", 500
    ClickOrMove 431, 78, "Left", 100
    ClickOrMove 427, 142, "Left", 1000
    Send "{Escape}"
    ClickOrMove 500, 265, "Left", 1500

    Char1Hell()
    if (!IsD2Active()) {
        StopScript()
    }
    Sleep 2500

    K_3LK()
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_1st_Hut()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_1.jpg")
    bitmap := GetD2BitMap("")
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected", () => Send("{Escape}"), 1)
    }
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_2nd_Hut()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_2.jpg")
    bitmap := GetD2BitMap()
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected", () => Send("{Escape}"), 1)
    }
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_3rd_Hut()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_3.jpg")
    bitmap := GetD2BitMap()
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected", () => Send("{Escape}"), 1)
    }
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_4th_Hut()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_4.jpg")
    bitmap := GetD2BitMap()
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected", () => Send("{Escape}"), 1)
    }
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_Return()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_R.jpg")
    bitmap := GetD2BitMap()
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected", () => Send("{Escape}"), 1)
    }
    if (!IsD2Active()) {
        StopScript()
    }

    loop 1 ; 1 attempt to verify that we are on waypoint, and recover if necessary
    {
        confidence := LK_Detect_Waypoint_And_Recover()
        if (confidence >= 0.5) {
            break
        }
    }
    if (confidence < 0.5) {
        ; All recovery attempts have failed. Give up.
        StopScript("Failed waypoint detection after " s_LK_Run_ID " runs (confidence = " confidence ")", () => Send("{Escape}"), 1)
    }
    if (!IsD2Active()) {
        StopScript()
    }

    ; Move mouse to waypoint
    ClickOrMove 536, 278, "", s_LK_Run_Premove_Delay
    ; Give human a chance to stop the script before leaving LK
    Sleep 500
    ; Leave LK and do the next run
    L_3LK()
}
s_LK_Run_Press_Delay := 100
s_LK_Run_Premove_Delay := 200
s_LK_Run_Blink_Delay := 400
s_LK_Run_Pick_Delay := 200
LK_Run_1st_Hut()
{
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
LK_Run_2nd_Hut()
{
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
LK_Run_3rd_Hut()
{
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
LK_Run_4th_Hut()
{
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
LK_Run_Return()
{
    ; Blink to waypoint
    Press "C", s_LK_Run_Press_Delay
    ClickOrMove 155, 434, "", s_LK_Run_Premove_Delay
    ClickOrMove 155, 434, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 155, 434, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 155, 434, "Right", s_LK_Run_Blink_Delay
    ClickOrMove 155, 434, "Right", s_LK_Run_Blink_Delay
}
LK_Detect_Orange_Text(bitmap := 0)
{
    if (!bitmap) {
        bitmap := GetD2BitMap("Screenshot_LK_Detect_Orange_Text.jpg")
    }
    confidence := DetectColoredText(bitmap, 5, 0xC48100, 0x20)
    return confidence
}
LK_Detect_Waypoint_And_Recover(bitmap := 0, recover := 1)
{
    global

    ; Only get the bitmap once for the whole detection and search of the waypoint position
    if (!bitmap) {
        bitmap := GetD2BitMap()
    }

    ; Check if the character is on the waypoint
    confidence := LK_Detect_On_Waypoint(bitmap)
    if (confidence >= 0.5) {
        return confidence
    }

    ; The character isn't on the waypoint. Try to find the waypoint by scanning the whole screen.
    search_box_size := 10
    blue_flame_boxes := 3 ; must be an odd number
    x := 0
    while x <= s_X_Max
    {
        y := 0
        while y <= s_Y_Max
        {
            ; Check if the left blue flame is this 10x10 area
            if (!DetectD2PixelColorInRect(bitmap,
                    x - search_box_size * (blue_flame_boxes / 2),
                    y - search_box_size * (blue_flame_boxes / 2),
                    x + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    y + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    0x669AD4, 0x20, 0x7290FF, 0x20, &left_x, &left_y)) {
                y := y + search_box_size
                continue
            }

            ;Say(left_x " " left_y)

            ; Check if the right blue flame is in a corresponding 30x30 area
            relative_x := s_LK_Right_Blue_Flame_X1 - s_LK_Left_Blue_Flame_X1
            relative_y := s_LK_Right_Blue_Flame_Y1 - s_LK_Left_Blue_Flame_Y1
            if (!DetectD2PixelColorInRect(bitmap,
                    x + relative_x - search_box_size * (blue_flame_boxes / 2),
                    y + relative_y - search_box_size * (blue_flame_boxes / 2),
                    x + relative_x + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    y + relative_y + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    0x76A9DE, 0x20, 0x6988F4, 0x20, &right_x, &right_y)) {
                y := y + search_box_size
                continue
            }

            ; Confirmed that the waypoint is likely there.
            ;Say(left_x " " left_y "    " right_x " " right_y)
            x := (left_x + right_x) / 2
            y := (left_y + right_y) / 2

            if (!recover)
            {
                ; We think we have found the waypoint
                return 1.0
            }

            ; Blink there
            Press "C", s_LK_Run_Press_Delay
            ClickOrMove x, y, "", s_LK_Run_Premove_Delay
            ClickOrMove x, y, "Right", s_LK_Run_Blink_Delay

            ; Return the detected confidence
            confidence := LK_Detect_On_Waypoint()
            return confidence
        }
        x := x + search_box_size
    }
    ; Cannot find any potential waypoint positions
    return 0.0
}
LK_Detect_Waypoint_And_Recover_Old(bitmap := 0, recover := 1)
{
    global

    ; Only get the bitmap once for the whole detection and search of the waypoint position
    if (!bitmap) {
        bitmap := GetD2BitMap()
    }

    ; Check if the character is on the waypoint
    confidence := LK_Detect_On_Waypoint(bitmap)
    if (confidence >= 0.5) {
        return confidence
    }

    ; The character isn't on the waypoint. Try to find the waypoint by scanning the whole screen.
    search_box_size := 10
    blue_flame_boxes := 3 ; must be an odd number
    x := 0
    while x <= s_X_Max
    {
        y := 0
        while y <= s_Y_Max
        {
            score := 0
            ; Check if the yellow flame is in this 10x10 area
            if (DetectD2PixelColorInRect(bitmap, x, y, x + search_box_size - 1, y + search_box_size - 1, 0xFFC54D, 0x40, 0x8B3000, 0x40)) {
                score := score + 1
            }

            ; Check if the right blue flame is in a 30x30 area to the top right of the waypoint fire
            relative_x_r := s_LK_Right_Blue_Flame_X1 - s_LK_Yellow_Flame_X1
            relative_y_r := s_LK_Right_Blue_Flame_Y1 - s_LK_Yellow_Flame_Y1
            if (DetectD2PixelColorInRect(bitmap,
                    x + relative_x_r - search_box_size * (blue_flame_boxes / 2),
                    y + relative_y_r - search_box_size * (blue_flame_boxes / 2),
                    x + relative_x_r + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    y + relative_y_r + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    0x76A9DE, 0x20, , , &right_x, &right_y)) {
                score := score + 1
                ;Say("DEBUG left flame " x + relative_x_r - search_box_size * (blue_flame_boxes / 2) " " y + relative_y_r - search_box_size * (blue_flame_boxes / 2) " " x + relative_x_r + search_box_size * (blue_flame_boxes / 2 + 1) - 1 " " y + relative_y_r + search_box_size * (blue_flame_boxes / 2 + 1) - 1)
            }

            ; Check if the left blue flame is in a 30x30 area in its corresponding position
            relative_x_l := s_LK_Left_Blue_Flame_X1 - s_LK_Yellow_Flame_X1
            relative_y_l := s_LK_Left_Blue_Flame_Y1 - s_LK_Yellow_Flame_Y1
            if (DetectD2PixelColorInRect(bitmap,
                    x + relative_x_l - search_box_size * (blue_flame_boxes / 2),
                    y + relative_y_l - search_box_size * (blue_flame_boxes / 2),
                    x + relative_x_l + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    y + relative_y_l + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    0x669AD4, 0x20, , , &left_x, &left_y)) {
                score := score + 1
                ;Say("DEBUG right flame " x + relative_x_l - search_box_size * (blue_flame_boxes / 2) " " y + relative_y_l - search_box_size * (blue_flame_boxes / 2) " " x + relative_x_l + search_box_size * (blue_flame_boxes / 2 + 1) - 1 " " y + relative_y_l + search_box_size * (blue_flame_boxes / 2 + 1) - 1)
            }

            ; If not detected, search next position
            if (score < 2) {
                y := y + search_box_size
                continue
            }

            ; Confirmed that the waypoint is likely there.
            ;Say(score "   " left_x " " left_y "    " right_x " " right_y)
            ;x := x + (relative_x_l + relative_x_r) / 2 + search_box_size / 2
            ;y := y + (relative_y_l + relative_y_r) / 2 + search_box_size / 2
            x := (left_x + right_x) / 2
            y := (left_y + right_y) / 2

            if (!recover)
            {
                return 1.0
            }

            ; Blink there
            Press "C", s_LK_Run_Press_Delay
            ClickOrMove x, y, "", s_LK_Run_Premove_Delay
            ClickOrMove x, y, "Right", s_LK_Run_Blink_Delay

            ; Return the detected confidence
            confidence := LK_Detect_On_Waypoint()
            return confidence
        }
        x := x + search_box_size
    }
    ; Cannot find any potential waypoint positions
    return 0.0
}
s_LK_Left_Blue_Flame_X1 := 470
s_LK_Left_Blue_Flame_Y1 := 256
s_LK_Right_Blue_Flame_X1 := 579
s_LK_Right_Blue_Flame_Y1 := 256
s_LK_Blue_Flame_Size := 12
s_LK_Yellow_Flame_X1 := 155
s_LK_Yellow_Flame_Y1 := 412
s_LK_Yellow_Flame_X2 := 177
s_LK_Yellow_Flame_Y2 := 424
LK_Detect_On_Waypoint(bitmap := 0)
{
    if (!bitmap) {
        bitmap := GetD2BitMap()
    }

    confidence := 0.0
    ; Detect left blue flame
    if (DetectD2PixelColorInRect(bitmap,
            s_LK_Left_Blue_Flame_X1,
            s_LK_Left_Blue_Flame_Y1,
            s_LK_Left_Blue_Flame_X1 + s_LK_Blue_Flame_Size,
            s_LK_Left_Blue_Flame_Y1 + s_LK_Blue_Flame_Size,
            0x669AD4, 0x20)) {
        confidence := confidence + 1.0
    }
    ; Detect right blue flame
    if (DetectD2PixelColorInRect(bitmap,
            s_LK_Right_Blue_Flame_X1,
            s_LK_Right_Blue_Flame_Y1,
            s_LK_Right_Blue_Flame_X1 + s_LK_Blue_Flame_Size,
            s_LK_Right_Blue_Flame_Y1 + s_LK_Blue_Flame_Size,
            0x76A9DE, 0x20)) {
        confidence := confidence + 1.0
    }
    ; Detect bottom left yellow flame
    if (DetectD2PixelColorInRect(bitmap,
            s_LK_Yellow_Flame_X1,
            s_LK_Yellow_Flame_Y1,
            s_LK_Yellow_Flame_X2,
            s_LK_Yellow_Flame_Y2,
            0xFFC54D, 0x40, 0x8B3000, 0x40)) {
        confidence := confidence + 1.0
    }

    return confidence / 3.0
}
