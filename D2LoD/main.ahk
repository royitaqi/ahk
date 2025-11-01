#Requires AutoHotkey v2.0.0

#HotIf WinActive("Diablo II")

SetTitleMatchMode(1)
SetDefaultMouseSpeed(0)
CoordMode("Mouse", "Client")
CoordMode("Pixel", "Client")

#include gdip/Gdip_Toolbox.ahk
pToken := Gdip_Startup()

#include utils/Cube.ahk
#include utils/DebugTools.ahk
#include utils/Inventory.ahk
#include utils/KeyboardAndMouse.ahk
#include utils/Logs.ahk
#include utils/ReadScreen.ahk
#include utils/SaveAndLoad.ahk
#include utils/Stash.ahk

#include LK/lk.ahk
#include LK/tests/test_lk.ahk

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
Delete::
{
    if (s_CurrentMode != 0)
    {
        StopScript("Stopping script", 0, 0)
        return
    }
    Send "{Delete}"
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
; Temporary tests
F10::
{
    switch s_CurrentMode
    {
    case 1:
        ret := GetGameState()
        Log("GetGameState() = " ret)
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
        SinglePlayerChar1Hell()
        return
    case 1:
        SinglePlayerChar1Hell()
        return
    case 3:
        SinglePlayerChar1Hell()
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
