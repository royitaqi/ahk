#Requires AutoHotkey v2.0.0

#include "../data_structure/Queue.ahk"
#include "../utils/Health.ahk"
#include "../utils/Log.ahk"
#include "../utils/Loot.ahk"
#include "../utils/ReadScreen.ahk"
#include "../utils/SaveAndLoad.ahk"

#include "P_HealAndEnterRedPortal.ahk"
#include "P_TeleportToPindleAndKill.ahk"
#include "P_PickUpLoot.ahk"


s_P_Tasks := Queue()
s_P_Run_ID := -1
s_P_Loot := { Detected: 0, LootedPlanned: 0, LootedAltClick: 0, Failed: 0 }
s_Potions_Used := 0

P_Main() {
    global s_P_Tasks

    ClearLogFile()
    SetPlayers(1)
    
    s_P_Tasks.Append(P_SaveLoadAnnounce)
    P_Loop()
}


P_Loop() {
    global s_P_Tasks
    loop {
        task := s_P_Tasks.Pop()
        LogDebug("Running task: " task.Name)
        task.Call()
    }
}

P_SaveLoadAnnounce() {
    SaveAndQuit(true)
    SinglePlayerChar1Hell(true)
    P_Announce()

    s_P_Tasks.Append(P_RunOnce)
}

P_RunOnce() {
    P_HealAndEnterRedPortal()
    P_TeleportToPindleAndKill()
    P_PickUpLoot()

    s_P_Tasks.Append(P_SaveLoadAnnounce)
}

P_Announce() {
    global s_P_Run_ID, s_P_Loot

    s_P_Run_ID := s_P_Run_ID + 1

    Log("Runs: " s_P_Run_ID
        "   |   P: " s_P_Loot.Detected "=>" s_P_Loot.LootedPlanned "/" s_P_Loot.LootedAltClick "-" s_P_Loot.Failed
            "   HP: " s_Potions_Used
    )
}
