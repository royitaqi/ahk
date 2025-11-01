LK_DetectWaypointAndRecover(bitmap := 0, recover := 1)
{
    global

    ; Only get the bitmap once for the whole detection and search of the waypoint position
    if (!bitmap) {
        bitmap := GetD2BitMap()
    }

    ; Check if the character is on the waypoint
    confidence := LK_DetectOnWaypoint(bitmap)
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
            if (!DetectPixelColorInRect(bitmap,
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
            if (!DetectPixelColorInRect(bitmap,
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
            confidence := LK_DetectOnWaypoint()
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

LK_DetectOnWaypoint(bitmap := 0)
{
    if (!bitmap) {
        bitmap := GetD2BitMap()
    }

    confidence := 0.0
    ; Detect left blue flame
    if (DetectPixelColorInRect(bitmap,
            s_LK_Left_Blue_Flame_X1,
            s_LK_Left_Blue_Flame_Y1,
            s_LK_Left_Blue_Flame_X1 + s_LK_Blue_Flame_Size,
            s_LK_Left_Blue_Flame_Y1 + s_LK_Blue_Flame_Size,
            0x669AD4, 0x20)) {
        confidence := confidence + 1.0
    }
    ; Detect right blue flame
    if (DetectPixelColorInRect(bitmap,
            s_LK_Right_Blue_Flame_X1,
            s_LK_Right_Blue_Flame_Y1,
            s_LK_Right_Blue_Flame_X1 + s_LK_Blue_Flame_Size,
            s_LK_Right_Blue_Flame_Y1 + s_LK_Blue_Flame_Size,
            0x76A9DE, 0x20)) {
        confidence := confidence + 1.0
    }
    ; Detect bottom left yellow flame
    if (DetectPixelColorInRect(bitmap,
            s_LK_Yellow_Flame_X1,
            s_LK_Yellow_Flame_Y1,
            s_LK_Yellow_Flame_X2,
            s_LK_Yellow_Flame_Y2,
            0xFFC54D, 0x40, 0x8B3000, 0x40)) {
        confidence := confidence + 1.0
    }

    return confidence / 3.0
}
