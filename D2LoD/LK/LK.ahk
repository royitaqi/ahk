#Requires AutoHotkey v2.0.0

#include "../utils/SaveAndLoad.ahk"

#include "LK_Route.ahk"
#include "LK_WaypointDetectionAndRecovery.ahk"


;;------------------------------------------------------------
;; Hot Keys
;;------------------------------------------------------------




;;------------------------------------------------------------
;; Logic
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
    StopScriptWhenD2BecomeInactive()

    MouseGetPos &xpos, &ypos
    ClickOrMove xpos, ypos, "Left", 500
    ClickOrMove 431, 78, "Left", 100
    ClickOrMove 427, 142, "Left", 1000

    SaveAndQuit(true)
    SinglePlayerChar1Hell(true)

    K_3LK()

    LK_Run1stHut()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_1.jpg")
    bitmap := GetD2BitMap("")
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected")
    }

    LK_Run2ndHut()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_2.jpg")
    bitmap := GetD2BitMap()
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected")
    }

    LK_Run3rdHut()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_3.jpg")
    bitmap := GetD2BitMap()
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected")
    }

    LK_Run4thHut()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_4.jpg")
    bitmap := GetD2BitMap()
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected")
    }

    LK_RunReturn()
    ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text_R.jpg")
    bitmap := GetD2BitMap()
    if (LK_Detect_Orange_Text(bitmap)) {
        StopScript("Loot detected")
    }

    loop 1 ; 1 attempt to verify that we are on waypoint, and recover if necessary
    {
        confidence := LK_DetectWaypointAndRecover()
        if (confidence >= 0.5) {
            break
        }
    }
    if (confidence < 0.5) {
        ; All recovery attempts have failed. Give up.
        StopScript("Failed waypoint detection after " s_LK_Run_ID " runs (confidence = " confidence ")")
    }

    ; Move mouse to waypoint
    ClickOrMove 536, 278, "", s_LK_Run_Premove_Delay
    ; Give human a chance to stop the script before leaving LK
    Sleep 500
    ; Leave LK and do the next run
    L_3LK()
}

LK_Detect_Orange_Text(bitmap := 0)
{
    if (!bitmap) {
        ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text.jpg")
        bitmap := GetD2BitMap()
    }
    confidence := DetectColoredText(bitmap, 5, 0xC48100, 0x20)
    return confidence
}
