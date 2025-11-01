﻿#Requires AutoHotkey v2.0.0

#HotIf WinActive("Diablo II")

SetTitleMatchMode(1)
SetDefaultMouseSpeed(0)
CoordMode("Mouse", "Client")
CoordMode("Pixel", "Client")

#include gdip/Gdip_Toolbox.ahk
pToken := Gdip_Startup()

#include lk.ahk
#include tests/test_lk.ahk

;;------------------------------------------------------------
;; Quick cast
;;------------------------------------------------------------

Q::QuickCast("Q")
W::QuickCast("W")
E::QuickCast("E")
R::QuickCast("R")
T::QuickCast("T")
F::QuickCast("F")
G::QuickCast("G")
Z::QuickCast("Z")
X::QuickCast("X")
C::QuickCast("C")
V::QuickCast("V")

QuickCast(c)
{
    Send c
    Sleep 50
    Send "{Click Right}"
}

;;------------------------------------------------------------
;; Horadric Stack
;;------------------------------------------------------------
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

;;------------------------------------------------------------
;; Set players
;;------------------------------------------------------------

F1::SetPlayers(1)
F2::SetPlayers(2)
F3::SetPlayers(3)
F4::SetPlayers(4)
F5::SetPlayers(5)
F6::SetPlayers(6)
F7::SetPlayers(7)
F8::SetPlayers(8)

SetPlayers(n)
{
    Say("/players " n)
}

s_CurrentStage := 0
ResetStage()
{
    global
    s_CurrentStage := 0
    SetPlayers(1)
}

NextStageDiablo()
{
    global
    s_CurrentStage := Mod(s_CurrentStage + 1, 2)
    switch s_CurrentStage
    {
        case 0: Say("Sanctum")              SetPlayers(1)
        case 1: Say("Diablo")               SetPlayers(7)
    }
}

NextStageBaal()
{
    global
    s_CurrentStage := Mod(s_CurrentStage + 1, 7)
    switch s_CurrentStage
    {
        case 0: Say("Chamber")              SetPlayers(1)
        case 1: Say("Stage 1: Sharman")     SetPlayers(8)
        case 2: Say("Stage 2: Skeleton")    SetPlayers(1)
        case 3: Say("Stage 3: Council")     SetPlayers(5)
        case 4: Say("Stage 4: Lord")        SetPlayers(8)
        case 5: Say("Stage 5: Dinosaur")    SetPlayers(5)
        case 6: Say("Baal")                 SetPlayers(1)
    }
}


;;------------------------------------------------------------
;; QoL
;;------------------------------------------------------------

ScrollLock::
{
    Say("Locking mouse")
    Sleep 50
    Say("/lock")
}


;;------------------------------------------------------------
;; Utils
;;------------------------------------------------------------

Assert(expr, msg)
{
    if (!expr) {
        Throw Error("msg", -1)
    }
}

Say(text, delay := 100)
{
    Send "{Enter}"
    Sleep 50
    Send text
    Sleep 50
    Send "{Enter}"
    Sleep delay
}

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

InventoryX(col)
{
    return 560 + 30 * col
}

InventoryY(row)
{
    return 330 + 30 * row
}

ClickInventory(row, col, button := "")
{
    ClickOrMove InventoryX(col), InventoryY(row), button
}

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

IsD2Active()
{
    title := WinGetTitle("A")
    return SubStr(title, 1, StrLen("Diablo II")) == "Diablo II"
}
IsD2Windowed()
{
    color := PixelGetColor(533, 287, "Slow")
    return color != 0x000000
}
GetD2BitMap(save_to_file := "")
{
    ; Get the active game window's handle
    hwnd := WinGetID("A")

    ; Capture a screenshot of the window
    bitmap := Gdip_BitmapFromHWND(hwnd, 1)

    ; Save bitmap to a file
    if (save_to_file) {
        Gdip_SaveBitmapToFile(bitmap, save_to_file)
    }

    return bitmap
}
ARGB2RGB(argb, &r, &g, &b)
{
    r := Gdip_RFromARGB(argb)
    g := Gdip_GFromARGB(argb)
    b := Gdip_BFromARGB(argb)
}
RGB2Hex(r, g, b)
{
    return Format("{:02X}{:02X}{:02X}", r, g, b)
}
GetD2PixelColorInRGB(bitmap, x, y)
{
    argb := Gdip_GetPixel(bitmap, x, y)
    return argb & 0xffffff
}
GetD2PixelColorInHex(bitmap, x, y)
{
    ; Get the color of the pixel at the coordinates
    rgb := GetD2PixelColorInRGB(bitmap, x, y)

    ; Convert the ARGB color to a hex value
    ARGB2RGB(rgb, &r, &g, &b)
    return RGB2Hex(r, g, b)
}
DetectD2PixelColorInRect(bitmap, x1, y1, x2, y2, color1, variation1 := 0, color2 := 0, variation2 := 0, &match_x := 0, &match_y := 0)
{
    Assert(bitmap, "bitmap should have value")

    ARGB2RGB(color1, &r1, &g1, &b1)
    if (color2) {
        ARGB2RGB(color2, &r2, &g2, &b2)
    }

    loop x2 - x1 + 1
    {
        loop y2 - y1 + 1
        {
            ; Get the color of the pixel at the coordinates
            argb := Gdip_GetPixel(bitmap, x1, y1)
            ARGB2RGB(argb, &r, &g, &b)

            ; Check if the color of the pixel is within range of any input colors
            if (r >= r1 - variation1 && r <= r1 + variation1 && g >= g1 - variation1 && g <= g1 + variation1 && b >= b1 - variation1 && b <= b1 + variation1) {
                match_x := x1
                match_y := y1
                return 1
            }
            if (color2 && r >= r2 - variation2 && r <= r2 + variation2 && g >= g2 - variation2 && g <= g2 + variation2 && b >= b2 - variation2 && b <= b2 + variation2) {
                match_x := x1
                match_y := y1
                return 2
            }

            y1 := y1 + 1
        }
        x1 := x1 + 1
    }
    return 0
}
DetectColoredText(bitmap, lines, color1, variation1 := 0, color2 := 0, variation2 := 0)
{
    x1 := 16
    y1 := 84
    ; Magic number. The width to look for.
    x2 := x1 + 8
    ; Each line is 9 pixels tall. Gap between two lines is 6 pixels tall.
    y2 := y1 + 9 + 15 * (lines - 1)

    return DetectD2PixelColorInRect(bitmap, x1, y1, x2, y2, color1, variation1, color2, variation2)
}


;;------------------------------------------------------------
;; Advanced Mode
;;------------------------------------------------------------

s_CurrentMode := 0
Numpad0::SetAdvancedMode(0)
Numpad1::SetAdvancedMode(1)
Numpad2::SetAdvancedMode(2)
Numpad3::SetAdvancedMode(3)
Numpad4::SetAdvancedMode(4)
Numpad5::SetAdvancedMode(5)
SetAdvancedMode(mode)
{
    global
    s_CurrentMode := mode
    AnnounceMode()
}
NumLock::
{
    AnnounceMode()
}
AnnounceMode()
{
    switch s_CurrentMode
    {
    case 0: Say "Advanced Mode = 0/OFF"
    case 1: Say "Advanced Mode = 1/Utility"
    case 2: Say "Advanced Mode = 2/Gamble"
    case 3: Say "Advanced Mode = 3/LK"
    case 4: Say "Advanced Mode = 4/Reroll"
    }
}
F12::
{
    if (s_CurrentMode != 0)
    {
        TestMousePosition()
        return
    }
    Send "{F12}"
}
F11::
{
    if (s_CurrentMode != 0)
    {
        TestPixelColor()
        return
    }
    Send "{F11}"
}
Delete::
{
    if (s_CurrentMode != 0)
    {
        StopScript("Stopping script", 0, 0)
        return
    }
    Send "{Delete}"
}
; Temporary tests
F10::
{
    switch s_CurrentMode
    {
    case 1:
        SendMode("Input")
        loop {
            ClickOrMove 555, 297, "Left", 1000
            ClickOrMove 510, 280, "Left", 1000
        }
        return
    }
    Send "{F10}"
}
; Unit tests
F9::
{
    switch s_CurrentMode
    {
    case 1:
        Test_LK()
        return
    }
    Send "{F9}"
}
N::
{
    switch s_CurrentMode
    {
    case 2:
        N_2Gamble()
        return
    case 4:
        N_4Reroll()
        return
    }
    Send "N"
}
M::
{
    switch s_CurrentMode
    {
    case 2:
        M_2Gamble()
        return
    case 4:
        N_4Reroll()
        return
    }
    Send "N"
}
J::
{
    switch s_CurrentMode
    {
    case 0:
        Char1Hell()
        return
    case 1:
        Char1Hell()
        return
    case 3:
        Char1Hell()
        return
    case 4:
        J_4Reroll()
        return
    }
    Send "J"
}
K::
{
    switch s_CurrentMode
    {
    case 3:
        K_3LK()
        return
    case 4:
        K_4Reroll()
        return
    }
    Send "K"
}
L::
{
    switch s_CurrentMode
    {
    case 3:
        L_3LK()
        return
    }
    Send "L"
}


;;------------------------------------------------------------
;; Advanced Mode: 1/Utility
;;------------------------------------------------------------

/* Character & level selection */
Char1Hell()
{
    ClickOrMove(475, 315, "Left", 100)
    ClickOrMove(200, 150, "Left", 0)
    ClickOrMove(200, 150, "Left", 100)
    ClickOrMove(475, 375, "Left", 100)
}


/* Test mouse position */
TestMousePosition()
{
    MouseGetPos &xpos, &ypos
    Say("The cursor is at X" xpos " Y" ypos)
}

/* Test pixel color at current mouse position + (-10,-10) */
TestPixelColor()
{
    MouseGetPos &xpos, &ypos

    Say("Will test pixel in ...")
    countdown := 3
    loop 3
    {
        Say(countdown)
        Sleep(1000)
        countdown := countdown - 1
    }

    ; color := PixelGetColor(xpos, ypos, "Alt")
    ; color := GetPixelColorBuffered(xpos, ypos)

    bitmap := GetD2BitMap("Screenshot_Test.jpg")
    color := GetD2PixelColorInHex(bitmap, xpos, ypos)

    Say("The color at X" xpos " Y" ypos " is " color)
}

/* Test if orange text */
TestOrangeAndPurpleText()
{
    bitmap := GetD2BitMap("D:/Downloads/a.jpg")
    ret := DetectColoredText(bitmap, 3, 0xC48100, 0x20)
    if (ret) {
        Say("Text detected: " ret)
    } else {
        Say("No text detected")
    }
}

/* Stop execution of script */
StopScript(say_reason := 0, take_action := 0, play_sound := 0)
{
    if (say_reason) {
        Say(say_reason)
    }
    if (take_action) {
        take_action.Call()
    }
    ; Sound is downloaded from https://www.youtube.com/watch?v=ii8zdA_teQE
    if (play_sound) {
        SoundPlay("sounds/Notification.aac", 1)
    }
    Reload
}

/* Delete pages which has items (PlugY's /dp can only delete empty pages) */
TooglePages()
{
    start_page := 244
    end_page := 260

    i := start_page
    n := end_page - start_page + 1

    loop n
    {
        Say("/tp " i, 100)
        ClickStashNext("Left", 100)
        i := i + 1

        if (!IsD2Active()) {
            return
        }
    }
}


;;------------------------------------------------------------
;; Advanced Mode: 2/Gamble
;;------------------------------------------------------------

N_2Gamble()
{
    NextGamblePage("Horker")
}
M_2Gamble()
{
    loop 10
    {
        NextGamblePage("Sorc")
        GambleAmulet()
    }
}
NextGamblePage(who)
{
    MouseGetPos &xpos, &ypos
    Send "{Escape}"
    Sleep 100
    MouseMove 535, 191
    Sleep 100
    Click 535, 191, "Left"
    Sleep 100

    if (who == "Sorc") {
        y := 128
    }
    if (who == "Horker") {
        y := 114
    }

    MouseMove 535, y
    Sleep 100
    Click 535, y, "Left"
    Sleep 100
    MouseMove xpos, ypos
}
GambleAmulet()
{
    MouseMove 504, 172
    Sleep 100
    Click 504, 172, "Right"
    Sleep 100
}


;;------------------------------------------------------------
;; Advanced Mode: 4/Reroll
;;------------------------------------------------------------

N_4Reroll()
{
    NextReroll()
}
J_4Reroll()
{
    FillInventory(0, 0, 4, 10)
}
K_4Reroll()
{
    FillInventory(4, 0, 4, 10)
}

s_CurrentColumn := 0
NextReroll()
{
    global

    Send "{Shift Down}"
    ClickCube(3, 2, "Right")
    ClickInventory(0, s_CurrentColumn, "Right")
    ClickInventory(1, s_CurrentColumn, "Right")
    ClickInventory(2, s_CurrentColumn, "Right")
    ClickInventory(3, s_CurrentColumn, "Right")
    ClickCubeButton("Left")
    ClickCube(3, 2)
    Send "{Shift Up}"

    s_CurrentColumn := Mod(s_CurrentColumn + 1, 10)
}

FillInventory(row_start, col_start, row_count, col_count)
{
    Send "{Shift Down}"
    c := col_start
    Loop col_count / 2 {
        r := row_start
        Loop row_count {
            ClickStash(r, c, "Right")
            ClickStash(r, c + 1, "Right")
            r := r + 1
        }
        c := c + 2
    }
    Send "{Shift Up}"

    Click 490, 400, "Right"
}



/* Caster Reroll
N::NextReroll()

s_CurrentColumn := 0
NextReroll()
{
    global
    x := 560 + 30 * s_CurrentColumn

    Send "{Shift Down}"
    y := 330
    Click x, y, "Right"
    Sleep 100
    Click x, y + 30, "Right"
    Sleep 100
    Click x, y + 60, "Right"
    Sleep 100
    Send "{Shift Up}"

    Click 375, 335, "Left"

    MouseMove 345, 240

    s_CurrentColumn := Mod(s_CurrentColumn + 1, 10)
}

FillInventory(x, cs, rs)
{
    Send "{Shift Down}"
    Loop cs {
        y := 160
        Loop rs {
            Click x, y, "Right"
            Sleep 100

            y := y + 30
        }
        x := x + 30
    }
    Send "{Shift Up}"

    Click 490, 400, "Right"
}
*/
