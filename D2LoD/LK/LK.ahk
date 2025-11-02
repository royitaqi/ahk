#Requires AutoHotkey v2.0.0

#include "../../data_structure/Queue.ahk"
#include "../utils/Logs.ahk"
#include "../utils/ReadScreen.ahk"
#include "../utils/SaveAndLoad.ahk"

#include "LK_Route.ahk"
#include "LK_WaypointDetectionAndRecovery.ahk"


s_LK_Tasks := Queue()
s_LK_Run_ID := -1
EmptyLootData() {
    return { Detected: 0, Looted: 0, LootCount: 0, Failed: 0 }
}
s_LK_Loot := [
    [EmptyLootData(), EmptyLootData()],
    [EmptyLootData(), EmptyLootData()],
    [EmptyLootData(), EmptyLootData()],
    [EmptyLootData(), EmptyLootData()]
]

LK_Main() {
    global s_LK_Tasks

    ;StopScriptWhenD2BecomeInactive()
    ClearLogFile()
    SetPlayers(7)
    
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
        Log("Running task: " task.Name)
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
    LK_CheckHealth()
    LK_Announce()
}

LK_Announce() {
    global s_LK_Run_ID, s_LK_Loot
    s_LK_Run_ID := s_LK_Run_ID + 1
    Log("Runs: " Format("{:3d}", s_LK_Run_ID) " | Purple Loot: "
        s_LK_Loot[1][1].Detected "=>" s_LK_Loot[1][1].Looted "(" s_LK_Loot[1][1].LootCount ")-" s_LK_Loot[1][1].Failed " | "
        s_LK_Loot[2][1].Detected "=>" s_LK_Loot[2][1].Looted "(" s_LK_Loot[2][1].LootCount ")-" s_LK_Loot[2][1].Failed " | "
        s_LK_Loot[3][1].Detected "=>" s_LK_Loot[3][1].Looted "(" s_LK_Loot[3][1].LootCount ")-" s_LK_Loot[3][1].Failed " | "
        s_LK_Loot[4][1].Detected "=>" s_LK_Loot[4][1].Looted "(" s_LK_Loot[4][1].LootCount ")-" s_LK_Loot[4][1].Failed)
    Log("            Orange Loot: "
        s_LK_Loot[1][2].Detected "=>" s_LK_Loot[1][2].Looted "(" s_LK_Loot[1][2].LootCount ")-" s_LK_Loot[1][2].Failed " | "
        s_LK_Loot[2][2].Detected "=>" s_LK_Loot[2][2].Looted "(" s_LK_Loot[2][2].LootCount ")-" s_LK_Loot[2][2].Failed " | "
        s_LK_Loot[3][2].Detected "=>" s_LK_Loot[3][2].Looted "(" s_LK_Loot[3][2].LootCount ")-" s_LK_Loot[3][2].Failed " | "
        s_LK_Loot[4][2].Detected "=>" s_LK_Loot[4][2].Looted "(" s_LK_Loot[4][2].LootCount ")-" s_LK_Loot[4][2].Failed)
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
    s_LK_Tasks.Append((*) => LK_DetectLoot(1, LK_Gather1stHutLoot))
    s_LK_Tasks.Append(LK_Run2ndHut)
    s_LK_Tasks.Append((*) => LK_DetectLoot(2, LK_Gather2ndHutLoot))
    s_LK_Tasks.Append(LK_Run3rdHut)
    s_LK_Tasks.Append((*) => LK_DetectLoot(3, LK_Gather3rdHutLoot))
    s_LK_Tasks.Append(LK_Run4thHut)
    s_LK_Tasks.Append((*) => LK_DetectLoot(4, LK_Gather4thHutLoot))
    s_LK_Tasks.Append(LK_RunReturn)
    s_LK_Tasks.Append(LK_WaypointRecoveryIfNeeded)
    s_LK_Tasks.Append(LK_BackToAct4AndRestart)
}

LK_DetectLoot(hut_name, gather_loot_func) {
    global s_LK_Loot

    ; Sleep for a bit to allow loot to fall on the ground and be detected.
    Sleep(300)
    loot_level := LK_DetectLootInMinimap()
    if (loot_level = 0) {
        return
    }

    ; Loot detected. Try to pick it up.
    Log("Loot level " loot_level " detected in hut " hut_name)
    s_LK_Loot[hut_name][loot_level].Detected := s_LK_Loot[hut_name][loot_level].Detected + 1
    gather_loot_func.Call()

    ; If failed to pick up the loot, stop the script and pause the game
    OpenInventory()
    loot_count := LK_TransferLootToCube()
    CloseInventory()
    s_LK_Loot[hut_name][loot_level].LootCount := s_LK_Loot[hut_name][loot_level].LootCount + loot_count
    Log(loot_count " loot has been transfered to cube")

    ; Check if the loot has been picked up (by see what's remaining on the ground)
    remaining_loot_level := LK_DetectLootInMinimap()
    if (remaining_loot_level != loot_level) {
        Log("Successfully picked loot (level " loot_level ")")
        s_LK_Loot[hut_name][loot_level].Looted := s_LK_Loot[hut_name][loot_level].Looted + 1

        ; Notify by sound
        SoundPlay("sounds/Notification.aac")
    } else {
        LogWarning("Failed to pick up loot (level " loot_level ")")
        s_LK_Loot[hut_name][loot_level].Failed := s_LK_Loot[hut_name][loot_level].Failed + 1

        ; Take a picture of the scene before moving on
        Send "{Alt down}"
        Sleep 200
        GetD2Bitmap("tmp/Screenshot_LK_failed_loot_run_" s_LK_Run_ID "_hut_" hut_name "_level_" loot_level ".jpg")
        Send "{Alt up}"
    }

    ; Have to restart anyways
    s_LK_Tasks.Clear()
    s_LK_Tasks.Append(LK_RestartInAct3)
}

/*
    Returns the number of transfered items.
*/
LK_TransferLootToCube() {
    cube_inventory_row := 1
    cube_inventory_col := 8

    transfered_items := 0
    callback(row, col, x, y) {
        if (!IsInventorySlotEmpty(, row, col)) {
            ClickOrMoveToInventorySlot(row, col, "Left")
            ClickOrMoveToInventorySlot(cube_inventory_row, cube_inventory_col, "Left")
            transfered_items := transfered_items + 1
        }
    }
    ForEachInventorySlot(callback, 2, 8, 4, 2)

    return transfered_items
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

LK_DetectOrangeText(bitmap := 0) {
    if (!bitmap) {
        bitmap := GetD2Bitmap()
    }
    confidence := DetectColoredText(bitmap, 10, 0xC48100, 0x20)
    return confidence
}

/*
    Returns 1 if there is purple loot on the ground, 2 if orange loot, 0 if nothing.
*/
LK_DetectLootInMinimap(bitmap := 0) {
    if (!bitmap) {
        bitmap := GetD2Bitmap("tmp/Screenshot_LK_DetectLootInMinimap.jpg")
    }

    /*
        Orange loot.
        > The color at X=899 Y=174 is 0xE07020

        Purple loot.
        > The color at X=899 Y=174 is 0xA420FC

        Minimap area.
        > The cursor is at X=791 Y=126
        > The cursor is at X=1004 Y=244
        Rounded to:
        - 800, 125
        - 1000, 245

        Character is at:
        > The cursor is at X=900 Y=172
        Rounded to:
        - 900, 172~173

        Finally adjust the minimap area to:
        - 800, 125
        - 1000, 220
    */
    return DetectPixelColorInRect(bitmap, 800, 125, 1000, 220, 0xA420FC, 0, 0xE07020, 0)
}

LK_CheckHealth() {
    bitmap := GetD2Bitmap()

    /*
        Use a health potion if current hp is below 60%.
        > X=63 Y=534 is 0x5C0000
    */
     if (GetPixelColorInRGB(bitmap, 63, 534) != 0x5C0000) {
        Press("1")
        Log("Health potion used")
    }
}
