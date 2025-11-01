#include KeyboardAndMouse.ahk


; X   Y   res = 1068 x 600
; 10c 8r
; 245  92
; 508 295

CubeX(col)
{
    return 245 + 29 * col
}

CubeY(row)
{
    return 92 + 29 * row
}

ClickCube(row, col, button := "", delay := 100)
{
    ClickOrMove CubeX(col), CubeY(row), button, delay
}

ClickCubeButton(button := "", delay := 100)
{
    ClickOrMove 375, 335, button, delay
}
