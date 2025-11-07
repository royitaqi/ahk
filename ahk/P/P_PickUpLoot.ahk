P_PickUpLoot() {
    global s_P_Loot

    c_Max_Loot_Level := 2

    ; Sleep for a bit to allow loot to fall on the ground and be detected.
    Sleep(1000)
    loot_level := DetectLootInMinimap(c_Max_Loot_Level)
    if (loot_level = 0) {
        Log("No loot is detected")
        return
    }
    Log("Loot detected (level=" loot_level ")")

    ; Blink towards where loot may be
    Press "C"
    ClickOrMove2 800, 150, "Right", , s_Blink_Delay

    ; Try to pick it up by Alt + Click for 3 times.
    loop 3 {
        Log("Attempting to pick up loot")
        detected := PickUpLootOnGround(c_Max_Loot_Level, 500)
        Log("Was loot detected by holding Alt: " detected)

        remaining_loot_level := DetectLootInMinimap(c_Max_Loot_Level)
        looted := (remaining_loot_level = 0)
        if (looted) {
            break
        }
    }

    ; Transfer loot from inventory to cube.
    ; NOTE: This has to be done no matter the loot was collected or not, because other items could have been accidentally picked up.
    OpenInventory()
    loot_count := P_TransferLootToCube()
    CloseInventory()
    Log(loot_count " loot has been transfered to cube")

    ; Check if the loot has been picked up (by see what's remaining on the ground)
    remaining_loot_level := DetectLootInMinimap(c_Max_Loot_Level)
    looted := (remaining_loot_level = 0)
    if (looted) {
        Log("Successfully picked up loot (level " loot_level ")")
        s_P_Loot.Looted := s_P_Loot.Looted + 1
    } else {
        LogWarning("Failed to pick up loot (level " loot_level ")")
        s_P_Loot.Failed := s_P_Loot.Failed + 1

        ; Take a picture of the scene before moving on
        now := FormatTime(A_Now, "HHmmss")
        Press("{Alt down}", 200)
        GetD2Bitmap("tmp/" now "_Screenshot_P_failed_loot_run_" s_P_Run_ID "_level_" loot_level ".jpg")
        Press("{Alt up}", 0)

        if (loot_level = 1) {
            ; Play sound and wait so that a human can have the chance to interfere before moving on
            SoundPlay("sounds/Notification.aac", 1)
            Sleep(1000)
            SoundPlay("sounds/Notification.aac", 1)
        }
    }

    ; Have to restart anyways
    s_P_Tasks.Clear()
    s_P_Tasks.Append(P_SaveLoadAnnounce)
}

/*
    Returns the number of transfered items.
*/
P_TransferLootToCube() {
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
