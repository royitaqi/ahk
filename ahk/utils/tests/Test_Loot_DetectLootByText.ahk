#Requires AutoHotkey v2.0.0

#include ../Loot.ahk
#include ../ReadScreen.ahk
#include ../Script.ahk
#include ../UnitTest.ahk


Test_Loot_DetectLootByText_1() {
    MockD2Bitmaps(
        "Test_Loot_DetectLootByText_Line6PurpleOrange.bmp",
        "Test_Loot_DetectLootByText_Line6PurpleOrange.bmp",
        "Test_Loot_DetectLootByText_Line6PurpleOrange.bmp",
        "Test_Loot_DetectLootByText_Line6PurpleOrange.bmp",
        "Test_Loot_DetectLootByText_Line6PurpleOrange.bmp",
        "Test_Loot_DetectLootByText_Line6PurpleOrange.bmp",
    )
    Assert(DetectLootByText(, 5, 1, 1) = 0, "Should not detect loot")
    Assert(DetectLootByText(, 6, 1, 1) = 0, "Should not detect loot")
    Assert(DetectLootByText(, 6, 12, 1) = 1, "Should detect purple loot")
    Assert(DetectLootByText(, 5, 1, 2) = 0, "Should not detect loot")
    Assert(DetectLootByText(, 6, 1, 2) = 2, "Should detect orange loot")
    Assert(DetectLootByText(, 6, 12, 2) = 2, "Should detect orange loot")
}
RunTest(Test_Loot_DetectLootByText_1)

ReportPass("Test_Loot_DetectLootByText.ahk")
