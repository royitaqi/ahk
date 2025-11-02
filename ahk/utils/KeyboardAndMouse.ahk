s_X_Max := 1068
s_Y_Max := 600

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
    ClickOrMove(1067, 599, "", 0)
}
