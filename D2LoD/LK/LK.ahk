#Requires AutoHotkey v2.0.0

#include "../../data_structure/Queue.ahk"
#include "../utils/SaveAndLoad.ahk"

#include "LK_Route.ahk"
#include "LK_WaypointDetectionAndRecovery.ahk"


s_LK_Tasks := Queue()
s_LK_Run_ID := 0

LK_MainLoop() {
    global

    StopScriptWhenD2BecomeInactive()

    ; Assume we are standing on the LK waypoint and just finished a run
    s_LK_Tasks.Clear()
    s_LK_Tasks.Append(LK_BackToAct4AndRestart)

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
    s_LK_Tasks.Append(LK_AnnounceRunID)
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
    Assert(false, "Not implemented")

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
