#Requires AutoHotkey v2.0.0

#include ../Loot.ahk
#include ../ReadScreen.ahk
#include ../Script.ahk
#include ../UnitTest.ahk


Test_Loot_TransferLootFromInventoryIntoCube_CubeNotFull() {
    MockD2Bitmaps(
        ; TransferLootFromInventoryIntoCube() -> OpenInventory() -> 1st IsInventoryOpen() to check if it's already opened. Mocking it here that it's already opened.
        "Test_RedPortal_InventoryNonEmpty.bmp",
        ; TransferLootFromInventoryIntoCube() -> IsInventorySlotEmpty() to decide if want to transfer
        "Test_RedPortal_InventoryNonEmpty.bmp",
        ; TransferLootFromInventoryIntoCube() -> IsMouseHoldingLoot() after transfer attempt
        "Test_ClearedMouse_NotHoldingLoot.bmp",
        ; TransferLootFromInventoryIntoCube() -> CloseInventory() -> 1st IsInventoryOpen() to check if inventory is already closed
        "Test_Loot_PickUpLootOnGround_NoAlt.bmp",
    )
    AssertEqual(TransferLootFromInventoryIntoCube(2, 8, 1, 1, 1, 8), 1, "Should transfer 1 loot")
}
RunTest(Test_Loot_TransferLootFromInventoryIntoCube_CubeNotFull)

Test_Loot_TransferLootFromInventoryIntoCube_CubeFull() {
    MockD2Bitmaps(
        ; TransferLootFromInventoryIntoCube() -> OpenInventory() -> 1st IsInventoryOpen() to check if it's already opened. Mocking it here that it's already opened.
        "Test_RedPortal_InventoryNonEmpty.bmp",
        ; TransferLootFromInventoryIntoCube() -> 1st IsInventorySlotEmpty() to decide if want to transfer
        "Test_RedPortal_InventoryNonEmpty.bmp",
        ; TransferLootFromInventoryIntoCube() -> IsMouseHoldingLoot() after transfer attempt
        "Test_ClearedMouse_HoldingLoot.bmp",
        ; TransferLootFromInventoryIntoCube() -> CloseInventory() -> 1st IsInventoryOpen() to check if inventory is already closed
        "Test_Loot_PickUpLootOnGround_NoAlt.bmp",
    )
    AssertEqual(TransferLootFromInventoryIntoCube(2, 8, 1, 1, 1, 8), -1, "Should detect cube full")
}
RunTest(Test_Loot_TransferLootFromInventoryIntoCube_CubeFull)

ReportPass("Test_Loot_TransferLootFromInventoryIntoCube.ahk")
