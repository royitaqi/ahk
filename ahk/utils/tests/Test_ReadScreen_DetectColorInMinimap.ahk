#Requires AutoHotkey v2.0.0

#include ../Loot.ahk
#include ../ReadScreen.ahk
#include ../Script.ahk
#include ../UnitTest.ahk


Test_ReadScreen_DetectColorInMinimap_1() {
    MockD2Bitmaps(
        "Test_Loot_PickUpLootOnGround_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_HoldAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_HoldAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_HoldAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_HoldAlt.bmp",
    )
    Assert(DetectColorInMinimap(, s_Purple_Minimap, 0) = 0, "Should not detect loot")
    Assert(DetectColorInMinimap(, s_Purple_Minimap, 0) = 0, "Should not detect loot")
    Assert(DetectColorInMinimap(, s_Purple_Minimap, 0) = 1, "Should detect purple loot")
    Assert(DetectColorInMinimap(, s_Purple_Minimap, 0) = 1, "Should detect purple loot")
    Assert(DetectColorInMinimap(, s_Purple_Minimap, 0, s_Orange_Minimap, 0) = 1, "Should detect purple loot")
    Assert(DetectColorInMinimap(, s_Purple_Minimap, 0, s_Orange_Minimap, 0) = 1, "Should detect purple loot")
    Assert(DetectColorInMinimap(, s_Orange_Minimap, 0) = 0, "Should not detect orange loot")
    Assert(DetectColorInMinimap(, s_Orange_Minimap, 0) = 0, "Should not detect orange loot")
}
RunTest(Test_ReadScreen_DetectColorInMinimap_1)

ReportPass("Test_ReadScreen_DetectColorInMinimap.ahk")
