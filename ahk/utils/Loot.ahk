s_Purple_Minimap := 0xA420FC
s_Orange_Minimap := 0xE07020

; > The color at X=105 Y=89 is 0x8600C4
s_Purple_Text := 0x8600C4
; > The color at X=19 Y=90 is 0xC48100
s_Orange_Text :=0xC48100

s_Press_Delay := 100
s_Premove_Delay := 200
s_Blink_Delay := 400
s_Pick_Delay := 50

/*
    1 = purple only
    2 = purple and orange
*/
DetectLootInMinimap(max_loot_level := 2) {
    if (max_loot_level = 1) {
        return DetectColorInMinimap(, s_Purple_Minimap, 0)
    } else {
        return DetectColorInMinimap(, s_Purple_Minimap, 0, s_Orange_Minimap, 0)
    }
    
}

/*
    1 = purple only
    2 = purple and orange
*/
PickUpLootOnGround(max_loot_level := 2, walk_delay := 2000) {
    c_Max_X := 787
    c_Min_X := s_Max_X - c_Max_X

    c_Min_Y := 60
    c_Max_Y := s_Max_Y - 60

    if (max_loot_level = 1) {
        color2 := 0
    } else {
        color2 := s_Orange_Text
    }

    /*
        The purple text "==HIGH== (26)" is 90 pixel wide
        > The cursor is at X=599 Y=300
        > The cursor is at X=509 Y=299
        
        and 10 pixel tall.
        > The cursor is at X=593 Y=290
        > The cursor is at X=543 Y=301

        Let's take 20 stride in X. That's at least 4 lines in <100 pixels.
    */
    c_X_Stride := 5

    Press("{Alt down}", 200)
    bitmap := GetD2Bitmap()

    ; Find the top-left most pixel that has a loot color
    x := c_Min_X
    while (x <= c_Max_X) {
        LogDebug("Detecting vertical line X=" x)
        match := DetectPixelColorInVerticalLine(bitmap, x, c_Min_Y, c_Max_Y, s_Purple_Text, 0, color2, 0, &match_x, &match_y)
        if (match) {
            break
        }
        x += c_X_Stride
    }

    if (!match) {
        Press("{Alt up}", 200)
        return false
    }

    LogDebug("Loot detected on round: X=" match_x ", Y=" match_y ", match=" match)

    ClickOrMove(match_x, match_y, "", s_Premove_Delay)
    ClickOrMove(match_x, match_y, "Left", walk_delay)
    Press("{Alt up}", 200)

    return true
}