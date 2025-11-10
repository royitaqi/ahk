#Requires AutoHotkey v2.0.0

#include ../Loot.ahk
#include ../ReadScreen.ahk
#include ../Script.ahk
#include ../UnitTest.ahk


Test_Loot_IsMouseHoldingLoot_HoldingLoot() {
    MockD2Bitmaps(
        "Test_MouseHoldingLoot.bmp",
    )
    Assert(IsMouseHoldingLoot(768, 410), "Should detect that the mouse is holding loot")
}
RunTest(Test_Loot_IsMouseHoldingLoot_HoldingLoot)

Test_Loot_IsMouseHoldingLoot_NotHoldingLoot() {
    MockD2Bitmaps(
        "Test_MouseOnLoot.bmp",
    )
    Assert(!IsMouseHoldingLoot(768, 410), "Should detect that the mouse is not holding loot")
}
RunTest(Test_Loot_IsMouseHoldingLoot_NotHoldingLoot)

ReportPass("Test_Loot_IsMouseHoldingLoot.ahk")
