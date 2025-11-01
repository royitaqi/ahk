#include KeyboardAndMouse.ahk


; Stash slots
; X   Y   res = 1068 x 600
; 10c 10r
; 245 160
; 506 421

; Stash buttons
; X   Y   Button
; 390 465 next

StashX(col)
{
    return 245 + 29 * col
}

StashY(row)
{
    return 160 + 29 * row
}

ClickStash(row, col, button := "", delay := 100)
{
    ClickOrMove StashX(col), StashY(row), button, delay
}

ClickStashNext(button := "", delay := 100)
{
    ClickOrMove 390, 465, button, delay
}
