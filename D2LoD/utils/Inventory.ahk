#include DebugTools.ahk
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

OpenInventory() {
    if (IsInventoryOpen(, true)) {
        return
    }

    Press(s_Inventory_Hotkey)

    Assert(IsInventoryOpen(, true), "Inventory should have been opened")
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
        bitmap := GetD2Bitmap()
    }

    x := InventoryX(col)
    y := InventoryY(row)
    slot_color := GetPixelColorInRGB(bitmap, x, y)
    ARGB2RGB(slot_color, &r, &g, &b)

    if (r = g && g = b && RGBAreClose(r, g, b, 0x08, 0x08, 0x08, 0x10)) {
        Log("row=" row " col=" col " x=" x " y=" y " r=" r " g=" g " b=" b)
        return true
    } else {
        return false
    }
}

ForEachInventorySlot(callback) {
    Assert(callback, "Callback shouldn't be empty")

    row := 0
    loop s_Inventory_Rows {
        col := 0
        loop s_Inventory_Cols {
            x := InventoryX(col)
            y := InventoryY(row)
            callback.Call(row, col, x, y)
            col := col + 1
        }
        row := row + 1
    }
}