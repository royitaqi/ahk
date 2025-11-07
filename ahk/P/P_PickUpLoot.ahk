P_PickUpLoot() {
}

/*
P_PickUpLoot() {
    global s_LK_Loot

    ; Sleep for a bit to allow loot to fall on the ground and be detected.
    Sleep(200)
    loot_level := DetectLootInMinimap()
    if (loot_level = 0) {
        return
    }
    ; Loot detected
    Log("Loot level " loot_level " detected in hut " hut_name)
    s_LK_Loot[hut_name][loot_level].Detected := s_LK_Loot[hut_name][loot_level].Detected + 1

    ; Try to pick it up by the planned route.
    gather_loot_func.Call()
    remaining_loot_level := DetectLootInMinimap()
    looted := (remaining_loot_level = 0)
    if (looted) {
        ; Looted by planned route
        s_LK_Loot[hut_name][loot_level].LootedPlanned := s_LK_Loot[hut_name][loot_level].LootedPlanned + 1
    }

    ; Try to pick it up by Alt + Click for 3 times.
    if (!looted) {
        loop 3 {
            Log("Attempting to pick up loot by Alt + Click")
            detected := PickUpLootOnGround()
            Log("Was loot detected by holding Alt: " detected)

            remaining_loot_level := DetectLootInMinimap()
            looted := (remaining_loot_level = 0)
            if (looted) {
                s_LK_Loot[hut_name][loot_level].LootedAltClick := s_LK_Loot[hut_name][loot_level].LootedAltClick + 1
                break
            }
        }
    }

    ; Transfer loot from inventory to cube.
    ; NOTE: This has to be done no matter the loot was collected or not, because other items could have been accidentally picked up.
    OpenInventory()
    loot_count := LK_TransferLootToCube()
    CloseInventory()
    Log(loot_count " loot has been transfered to cube")

    ; Check if the loot has been picked up (by see what's remaining on the ground)
    remaining_loot_level := DetectLootInMinimap()
    looted := (remaining_loot_level = 0)
    if (looted) {
        Log("Successfully picked up loot (level " loot_level ")")
    } else {
        LogWarning("Failed to pick up loot (level " loot_level ")")
        s_LK_Loot[hut_name][loot_level].Failed := s_LK_Loot[hut_name][loot_level].Failed + 1

        ; Take a picture of the scene before moving on
        now := FormatTime(A_Now, "HHmm")
        Press("{Alt down}", 200)
        GetD2Bitmap("tmp/" now "_Screenshot_LK_failed_loot_run_" s_LK_Run_ID "_hut_" hut_name "_level_" loot_level ".jpg")
        Press("{Alt up}", 0)

        if (loot_level = 1) {
            ; Play sound and wait so that a human can have the chance to interfere before moving on
            SoundPlay("sounds/Notification.aac", 1)
            Sleep(1000)
            SoundPlay("sounds/Notification.aac", 1)
        }
    }

    ; Have to restart anyways
    s_LK_Tasks.Clear()
    s_LK_Tasks.Append(LK_RestartInAct3)
}
*/

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
