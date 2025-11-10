#include ../data_structure/Types.ahk

#include Debug.ahk
#include KeyboardAndMouse.ahk
#include SaveAndLoad.ahk


s_Inventory_Hotkey := "D"
s_Inventory_TopLeftSlot_X := 570
s_Inventory_TopLeftSlot_Y := 290
s_Inventory_Slot_Width := 29
s_Inventory_Slot_Height := 29
s_Inventory_Cols := 10
s_Inventory_Rows := 6

InventoryX(col)
{
    return s_Inventory_TopLeftSlot_X + s_Inventory_Slot_Width * col
}

InventoryY(row)
{
    return s_Inventory_TopLeftSlot_Y + s_Inventory_Slot_Height * row
}

ClickOrMoveToInventorySlot(row, col, button := "")
{
    ClickOrMove InventoryX(col), InventoryY(row), button
}

OpenInventory(timeout := 1000) {
    if (IsInventoryOpen(, true)) {
        return
    }

    Press(s_Inventory_Hotkey)

    waited := 0
    while (!IsInventoryOpen(, true)) {
        Assert(timeout = 0 || waited < timeout, "Timed out while trying to open inventory")
        Sleep(100)
        waited := waited + 100
    }
}

CloseInventory(timeout := 1000) {
    if (!IsInventoryOpen(, true)) {
        return
    }

    Press("{Escape}")

    waited := 0
    while (IsInventoryOpen(, true)) {
        Assert(timeout = 0 || waited < timeout, "Timed out while trying to close inventory")
        Sleep(100)
        waited := waited + 100
    }
}

IsInventoryOpen(bitmap := 0, clear_mouse := false) {
    if (clear_mouse) {
        ClearMouse()
    }
    if (!bitmap) {
        bitmap := GetD2Bitmap()
    }

    Assert(IsGameLoaded(bitmap, clear_mouse), "The game should be loaded in order to open inventory")

    /*
        The gold icon should be yellow.
        > The color at X=629 Y=463 is 0x849848
    */
    if (GetPixelColorInRGB(bitmap, 629, 463) != 0x849848) {
        return false
    }

    /*
        The Close button should have dark gray color.
        > The color at X=568 Y=462 is 0x50483C
    */
    if (GetPixelColorInRGB(bitmap, 568, 462) != 0x50483C) {
        return false
    }

    /*
        There should be golden decoration to the right of the inventory area.
        > The color at X=861 Y=278 is 0xAC9C64
    */
    if (GetPixelColorInRGB(bitmap, 861, 278) != 0xAC9C64) {
        return false
    }

    return true
}

IsInventorySlotEmpty(bitmap := 0, row := -1, col := -1) {
    Assert(row >= 0, "Row should be non-negative")
    Assert(col >= 0, "Row should be non-negative")

    if (!bitmap) {
        ; Move mouse away so that it's not on that slot
        ClearMouse(100)
        bitmap := GetD2Bitmap()
    }

    x := InventoryX(col)
    y := InventoryY(row)
    slot_color := GetPixelColorInRGB(bitmap, x, y)
    ARGB2RGB(slot_color, &r, &g, &b)

    if (r = g && g = b && RGBAreClose(r, g, b, 0x08, 0x08, 0x08, 0x10)) {
        return true
    } else {
        return false
    }
}

/*
    Go through each inventory slot in the specified area and invoke the callback.
    Stops if the callback returns a value that evaluates to "true".
    Returns that value in that case. Otherwise return nil.
*/
ForEachInventorySlot(callback, start_row := 0, start_col := 0, row_count := s_Inventory_Rows, col_count := s_Inventory_Cols) {
    Assert(callback, "Callback shouldn't be empty")
    row := start_row
    loop row_count {
        col := start_col
        loop col_count {
            x := InventoryX(col)
            y := InventoryY(row)
            ret := callback.Call(row, col, x, y)
            if (ret) {
                return ret
            }
            col := col + 1
        }
        row := row + 1
    }
    return nil
}
