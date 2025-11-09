#Requires AutoHotkey v2.0.0

#include ../Loot.ahk
#include ../Script.ahk
#include ../UnitTest.ahk


Setup() {
    global s_Mocked_D2Bitmaps
    s_Mocked_D2Bitmaps := [
        Gdip_CreateBitmapFromFile("Test_Loot_PickUpLootOnGround_NoAlt.bmp"),
        Gdip_CreateBitmapFromFile("Test_Loot_PickUpLootOnGround_HoldAlt.bmp"),
    ]
}

; Test 1
{
    Setup()
    Assert(PickUpLootOnGround() = true, "Should be able to detect orange loot")
}

; Test 2
{
    Setup()
    Assert(PickUpLootOnGround(1) = true, "Should be able to detect purple loot")
}

ReportPass()
