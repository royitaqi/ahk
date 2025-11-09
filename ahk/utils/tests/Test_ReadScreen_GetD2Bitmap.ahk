#Requires AutoHotkey v2.0.0

#include ../../data_structure/Memory.ahk

#include ../Loot.ahk
#include ../ReadScreen.ahk
#include ../Script.ahk
#include ../UnitTest.ahk


Test_ReadScreen_GetD2Bitmap_MemoryLeak() {
    DoNotMockD2Bitmaps()
    WinActivate("Diablo II")

    before := GlobalMemoryStatusEx()
    loop 2000 {
        bitmap := GetD2Bitmap()
    }
    after := GlobalMemoryStatusEx()

    mem_used := after.MemoryLoad - before.MemoryLoad
    Assert(mem_used <= 2, "This test shouldn't use more than 1% of memory (actually used " mem_used "%, from " before.MemoryLoad "% to " after.MemoryLoad "%)")
}
RunTest(Test_ReadScreen_GetD2Bitmap_MemoryLeak)

ReportPass("Test_ReadScreen_GetD2Bitmap.ahk")
