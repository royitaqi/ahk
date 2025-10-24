#Requires AutoHotkey v2.0.0

#HotIf WinActive("Diablo II")

SetTitleMatchMode(1)
SetDefaultMouseSpeed(0)
CoordMode("Mouse", "Client")
CoordMode("Pixel", "Client")

#include Gdip_Toolbox.ahk
pToken := Gdip_Startup()

;;------------------------------------------------------------
;; Quick cast
;;------------------------------------------------------------

W::QuickCast("W")
E::QuickCast("E")
R::QuickCast("R")
T::QuickCast("T")
F::QuickCast("F")
G::QuickCast("G")
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
Q::HoradricStack()
Z::HoradricUnstack()

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
DetectD2PixelColorInRect(bitmap, x1, y1, x2, y2, color1, variation1 := 0, color2 := "", variation2 := 0, &match_x := 0, &match_y := 0)
{
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
DetectColoredText(bitmap, lines, color1, variation1 := 0, color2 := "", variation2 := 0)
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
        StopScript("Stopping script")
        return
    }
    Send "{Delete}"
}
F10::
{
    switch s_CurrentMode
    {
    case 1:
        TestOrangeAndPurpleText()
        return
    }
    Send "{F10}"
}
F9::
{
    switch s_CurrentMode
    {
    case 1:
        Test_LK_Waypoint()
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
    ret := DetectColoredText(bitmap, 3, 0xCD862E, 0x20)
    if (ret) {
        Say("Text detected: " ret)
    } else {
        Say("No text detected")
    }
}

/* Stop execution of script */
StopScript(say_reason := "", take_action := "")
{
    if (say_reason) {
        Say(say_reason)
    }
    if (take_action) {
        take_action.Call()
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
    if (LK_Detect_Orange_Text()) {
        StopScript("Loot detected", () => Send("{Escape}"))
    }
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_2nd_Hut()
    if (LK_Detect_Orange_Text()) {
        StopScript("Loot detected", () => Send("{Escape}"))
    }
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_3rd_Hut()
    if (LK_Detect_Orange_Text()) {
        StopScript("Loot detected", () => Send("{Escape}"))
    }
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_4th_Hut()
    if (LK_Detect_Orange_Text()) {
        StopScript("Loot detected", () => Send("{Escape}"))
    }
    if (!IsD2Active()) {
        StopScript()
    }

    LK_Run_Return()
    loop 3 ; 3 attempts to return to waypoint
    {
        confidence := LK_Detect_Waypoint_And_Recover()
        if (confidence >= 0.5) {
            break
        }
    }
    if (confidence < 0.5) {
        ; All recovery attempts have failed. Give up.
        StopScript("Failed waypoint detection (confidence = " confidence ")", () => Send("{Escape}"))
    }
    if (!IsD2Active()) {
        StopScript()
    }

    Sleep 500
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
    ; Move mouse to waypoint
    ClickOrMove 536, 278, "", s_LK_Run_Premove_Delay
}
LK_Detect_Orange_Text()
{
    bitmap := GetD2BitMap()
    return DetectColoredText(bitmap, 3, 0xCD862E, 0x20)
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
    blue_flame_boxes := 5 ; must be an odd number
    x := 0
    while x <= s_X_Max
    {
        y := 0
        while y <= s_Y_Max
        {
            ; Check if the left blue flame is this 10x10 area
            if (!DetectD2PixelColorInRect(bitmap,
                    x,
                    y,
                    x + search_box_size - 1,
                    y + search_box_size - 1,
                    0x669AD4, 0x20, , , &left_x, &left_y)) {
                y := y + search_box_size
                continue
            }

            Say(left_x " " left_y)

            ; Check if the right blue flame is in a corresponding 30x30 area
            relative_x := s_LK_Right_Blue_Flame_X1 - s_LK_Left_Blue_Flame_X1
            relative_y := s_LK_Right_Blue_Flame_Y1 - s_LK_Left_Blue_Flame_Y1
            if (!DetectD2PixelColorInRect(bitmap,
                    x + relative_x - search_box_size * (blue_flame_boxes / 2),
                    y + relative_y - search_box_size * (blue_flame_boxes / 2),
                    x + relative_x + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    y + relative_y + search_box_size * (blue_flame_boxes / 2 + 1) - 1,
                    0x76A9DE, 0x20, , , &right_x, &right_y)) {
                y := y + search_box_size
                continue
            }

            ; Confirmed that the waypoint is likely there.
            Say(left_x " " left_y "    " right_x " " right_y)
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
Test_LK_Waypoint()
{
    Test(file)
    {
        bitmap := Gdip_CreateBitmapFromFile(file)
        confidence := LK_Detect_Waypoint_And_Recover(bitmap, recover := 0)
        Say(file ": " confidence)
    }

    Test("Test_LK_WayPoint_RightAbove_Day.jpg")
    Test("Test_LK_WayPoint_RightBelow_Day.jpg")
    Test("Test_LK_WayPoint_MediumBottomLeft_Day.jpg")
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
