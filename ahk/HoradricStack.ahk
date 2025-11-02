I::HoradricStack()
O::HoradricUnstack()

HoradricStack()
{
    MouseGetPos &xpos, &ypos
    Send "{Ctrl Down}"
    ClickOrMove(xpos, ypos, "Left", 0)
    Send "{Ctrl Up}"
    ClickCubeButton("Left", 0)
    ClickOrMove(xpos, ypos, "", 0)
}

HoradricUnstack()
{
    MouseGetPos &xpos, &ypos
    ClickCubeButton("Left", 50)
    ClickCube(7, 9, "Left", 0)
    ClickOrMove(xpos, ypos, "", 0)
}
