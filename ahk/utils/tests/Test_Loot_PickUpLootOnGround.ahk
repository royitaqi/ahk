#Requires AutoHotkey v2.0.0

#include ../Loot.ahk
#include ../Script.ahk
#include ../UnitTest.ahk


; Test 1
{
    MockD2Bitmaps(
        "Test_Loot_PickUpLootOnGround_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_HoldAlt.bmp",
    )
    Assert(PickUpLootOnGround() = true, "Should be able to detect orange loot")
}

; Test 2
{
    MockD2Bitmaps(
        "Test_Loot_PickUpLootOnGround_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_HoldAlt.bmp",
    )
    Assert(PickUpLootOnGround(1) = true, "Should be able to detect purple loot")
}

; Test 3
{
    MockD2Bitmaps(
        "Test_Loot_PickUpLootOnGround_Test3_NoAlt.bmp",
        "Test_Loot_PickUpLootOnGround_Test3_HoldAlt.bmp",
    )
    Assert(PickUpLootOnGround(2, 1000), "Should be able to detect loot")
}

ReportPass()
