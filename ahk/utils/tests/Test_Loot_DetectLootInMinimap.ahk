#Requires AutoHotkey v2.0.0

#include ../Loot.ahk
#include ../ReadScreen.ahk
#include ../Script.ahk
#include ../UnitTest.ahk


Test_Loot_DetectLootInMinimap_1() {
    MockD2Bitmaps(
        "Test_Loot_PickUpLootOnGround_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_HoldAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_HoldAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_HoldAlt.bmp",
    )
    Assert(DetectLootInMinimap(, 1) = 0, "Should not detect loot")
    Assert(DetectLootInMinimap(, 1) = 0, "Should not detect loot")
    Assert(DetectLootInMinimap(, 1) = 1, "Should detect purple loot")
    Assert(DetectLootInMinimap(, 1) = 1, "Should detect purple loot")
    Assert(DetectLootInMinimap(, 2) = 1, "Should detect purple loot")
    Assert(DetectLootInMinimap(, 2) = 1, "Should detect purple loot")
}
RunTest(Test_Loot_DetectLootInMinimap_1)

ReportPass("Test_Loot_DetectLootInMinimap.ahk")
