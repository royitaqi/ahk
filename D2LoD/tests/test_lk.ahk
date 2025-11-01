#Requires AutoHotkey v2.0.0

#include ../lk.ahk

Test_LK()
{
    Test_LK_Loot()
    ;Test_LK_Waypoint()
}
Test_LK_Loot()
{
    Test(file)
    {
        bitmap := Gdip_CreateBitmapFromFile(file)
        Say(file " loaded")

        start := A_TickCount
        confidence := LK_Detect_Orange_Text(bitmap)
        time := A_TickCount - start
        Say("Result: " confidence " (" time ")")
    }

    Test("tests/Test_LK_Loot_Gul_Line2.jpg") ; failing in game ; pass in test
    Test("tests/Test_LK_Loot_Io_Line1.jpg") ; failing in game ; pass in test
    Test("tests/Test_LK_Loot_Io_Line2.jpg") ; failing in game ; pass in test
    Test("tests/Test_LK_Loot_Ko_Line1.jpg") ; failing in game ; pass in test
    Test("tests/Test_LK_Loot_Mal_Line1.jpg") ; failing in game ; pass in test
}
Test_LK_Waypoint()
{
    Test(file)
    {
        bitmap := Gdip_CreateBitmapFromFile(file)
        Say(file " loaded")

        start := A_TickCount
        confidence := LK_Detect_Waypoint_And_Recover(bitmap, recover := 0)
        time := A_TickCount - start
        Say("New: " confidence " (" time ")")

        ;start := A_TickCount
        ;confidence := LK_Detect_Waypoint_And_Recover_Old(bitmap, recover := 0)
        ;time := A_TickCount - start
        ;Say("Old: " confidence " (" time ")")
    }

    Test("tests/Test_LK_WayPoint_FarAbove_Night.jpg")
    Test("tests/Test_LK_WayPoint_FarAbove_Night2.jpg")
    Test("tests/Test_LK_WayPoint_FarAbove_NightRain.jpg")
    Test("tests/Test_LK_WayPoint_FarBelow_Day.jpg")
    Test("tests/Test_LK_WayPoint_FarBelow_Night.jpg") ; failing test
    Test("tests/Test_LK_WayPoint_FarBelow_Night2.jpg") ; failing test
    Test("tests/Test_LK_WayPoint_FarLeft_Day.jpg")
    Test("tests/Test_LK_WayPoint_FarRight_Day.jpg")
    Test("tests/Test_LK_WayPoint_MediumBottomLeft_Day.jpg")
    Test("tests/Test_LK_WayPoint_MediumBottomLeft_Night.jpg")
    Test("tests/Test_LK_WayPoint_RightAbove_Day.jpg")
    Test("tests/Test_LK_WayPoint_RightAbove_Night.jpg")
    Test("tests/Test_LK_WayPoint_RightBelow_Day.jpg")
    Test("tests/Test_LK_WayPoint_RightBelow_Night.jpg")
}
