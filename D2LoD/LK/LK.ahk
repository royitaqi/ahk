#Requires AutoHotkey v2.0.0

#include "../../data_structure/Queue.ahk"
#include "../utils/SaveAndLoad.ahk"

#include "LK_Route.ahk"
#include "LK_WaypointDetectionAndRecovery.ahk"


s_LK_Tasks := Queue()
s_LK_Run_ID := 0

LK_Main() {
    global s_LK_Tasks

    StopScriptWhenD2BecomeInactive()

    LK_Clear()
    s_LK_Tasks.Append(LK_BackToAct4AndRestart)
    LK_Loop()
}

LK_Clear() {
    global s_LK_Tasks
    s_LK_Tasks.Clear()
}

LK_Loop() {
    global s_LK_Tasks
    loop {
        task := s_LK_Tasks.Pop()
        task.Call()
    }
}

LK_BackToAct4AndRestart() {
    ClickOrMove 536, 278, "", s_LK_Run_Premove_Delay
    ClickOrMove 536, 278, "Left", 500
    ClickOrMove 431, 78, "Left", 100
    ClickOrMove 427, 142, "Left", 1000

    s_LK_Tasks.Append(LK_SaveLoadAnnounce)
    s_LK_Tasks.Append(LK_FromAct4SpawnToLK)
}

LK_RestartInAct3() {
    s_LK_Tasks.Append(LK_SaveLoadAnnounce)
    s_LK_Tasks.Append(LK_FromAct3SpawnToLK)
}

LK_SaveLoadAnnounce() {
    SaveAndQuit(true)
    SinglePlayerChar1Hell(true)
    ; Immediately announce run ID after loading into the game
    LK_AnnounceRunID()
}

LK_AnnounceRunID() {
    global s_LK_Run_ID
    s_LK_Run_ID := s_LK_Run_ID + 1
    Log("LK run " s_LK_Run_ID)
}

LK_FromAct4SpawnToLK() {
    ClickOrMove 835, 70, "", 100
    ClickOrMove 835, 70, "Left", 1750
    ClickOrMove 371, 80, "Left", 100
    ClickOrMove 408, 280, "Left", 500

    s_LK_Tasks.Append(LK_StartRun)
}

LK_FromAct3SpawnToLK() {
    ClickOrMove 995, 310, "Left", 1100 ; 1250
    ClickOrMove 1050, 25, "Left", 1800 ; 2000
    ClickOrMove 1000, 60, "Left", 1650 ; 2000
    ClickOrMove 1060, 300, "Left", 1050 ; 2000
    ClickOrMove 1067, 110, "", s_LK_Run_Premove_Delay
    ClickOrMove 1067, 110, "Left", 2000
    ClickOrMove 408, 280, "Left", 500

    s_LK_Tasks.Append(LK_StartRun)
}

LK_StartRun() {
    ; Get ready: open map, turn on ice shield
    Send "B"
    Send "E"
    Click "Right"
    Sleep 500

    s_LK_Tasks.Append(LK_Run1stHut)
    s_LK_Tasks.Append(LK_DetectLoot)
    s_LK_Tasks.Append(LK_Run2ndHut)
    s_LK_Tasks.Append(LK_DetectLoot)
    s_LK_Tasks.Append(LK_Run3rdHut)
    s_LK_Tasks.Append(LK_DetectLoot)
    s_LK_Tasks.Append(LK_Run4thHut)
    s_LK_Tasks.Append(LK_DetectLoot)
    s_LK_Tasks.Append(LK_RunReturn)
    s_LK_Tasks.Append(LK_WaypointRecoveryIfNeeded)
    s_LK_Tasks.Append(LK_BackToAct4AndRestart)
}

LK_DetectLoot() {
    bitmap := GetD2BitMap("")
    if (LK_DetectOrangeText(bitmap)) {
        StopScript("Loot detected")
    }
}

LK_WaypointRecoveryIfNeeded() {
    confidence := LK_DetectWaypointAndRecover()
    if (confidence < 0.5) {
        ; Failed to recover
        Log("Failed to recover to waypoint. Restarting in Act 3.")
        s_LK_Tasks.Clear()
        s_LK_Tasks.Append(LK_RestartInAct3)
    }
}

LK_DetectOrangeText(bitmap := 0)
{
    if (!bitmap) {
        ;bitmap := GetD2BitMap("temp/Screenshot_LK_Detect_Orange_Text.jpg")
        bitmap := GetD2BitMap()
    }
    confidence := DetectColoredText(bitmap, 5, 0xC48100, 0x20)
    return confidence
}
