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

Press(key, delay := 100)
{
    Send key
    if (delay != 0) {
        Sleep delay
    }
}

ClearMouse() {
    ClickOrMove(s_Max_X - 1, s_Max_Y - 1, "", 0)
}
