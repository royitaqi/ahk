#include KeyboardAndMouse.ahk


InventoryX(col)
{
    return 560 + 30 * col
}

InventoryY(row)
{
    return 330 + 30 * row
}

ClickInventory(row, col, button := "")
{
    ClickOrMove InventoryX(col), InventoryY(row), button
}
