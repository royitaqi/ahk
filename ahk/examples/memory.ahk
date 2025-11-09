#include ../data_structure/Memory.ahk


; Example usage:
MemInfo := GlobalMemoryStatusEx()

if (MemInfo) {
    MsgBox "Memory Load: " MemInfo.MemoryLoad "`%`n"
      . "Total Physical Memory: " Round(MemInfo.TotalPhys / (1024*1024)) " MB`n"
      . "Available Physical Memory: " Round(MemInfo.AvailPhys / (1024*1024)) " MB"
} else {
    MsgBox "Failed to retrieve memory status."
}
