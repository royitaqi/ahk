s_Premove_Delay := 200
s_Click_Delay := 100
s_Press_Delay := 100
s_Cast_Delay := 400
s_Blink_Delay := 400
s_Pick_Delay := 50


ClickOrMove(x, y, button := "", delay := 100)
{
    if (button != "") {
        Click x, y, button
    } else {
        MouseMove x, y
    }
    if (delay != 0) {
        Sleep delay
    }
}

Press(key, delay := s_Press_Delay)
{
    Send key
    if (delay != 0) {
        Sleep delay
    }
}

ClearMouse() {
    ClickOrMove(s_Max_X - 1, s_Max_Y - 1, "", 0)
}

ClickOrMove2(x, y, button := "", premove_delay := s_Premove_Delay, click_delay := s_Click_Delay) {
    MouseMove(x, y)
    if (premove_delay) {
        Sleep(premove_delay)
    }
    if (button) {
        Click(x, y, button)
        if (click_delay) {
            Sleep(click_delay)
        }
    }
}
