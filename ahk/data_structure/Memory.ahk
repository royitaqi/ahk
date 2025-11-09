#Requires AutoHotkey v2.0.0


; Define a function to get memory status
GlobalMemoryStatusEx() {
    ; MEMORYSTATUSEX structure size is 64 bytes (for both 32-bit and 64-bit AHK)
    ; The second argument "0" fills the buffer with zeros.
    static MemStatusEx := Buffer(64, 0)

    ; The first field of the structure (dwLength) must contain the size of the structure itself.
    ; "UInt" is a 32-bit unsigned integer type, which matches the dwLength field type.
    static init := NumPut("UInt", 64, MemStatusEx, 0)

    ; Call the GlobalMemoryStatusEx function
    ; The function takes one parameter: a pointer to the MEMORYSTATUSEX structure.
    ; "Ptr" is used for passing the address of the buffer.
    if (DllCall("kernel32\GlobalMemoryStatusEx", "Ptr", MemStatusEx)) {
        ; Read values from the buffer using NumGet, specifying the correct offset and type.
        ; The offsets are based on the MEMORYSTATUSEX structure definition:
        ; Offset 0: dwLength (UInt)
        ; Offset 4: dwMemoryLoad (UInt)
        ; Offset 8: ullTotalPhys (UInt64)
        ; Offset 16: ullAvailPhys (UInt64)
        ; Offset 24: ullTotalPageFile (UInt64)
        ; Offset 32: ullAvailPageFile (UInt64)
        ; Offset 40: ullTotalVirtual (UInt64)
        ; Offset 48: ullAvailVirtual (UInt64)
        ; Offset 56: ullAvailExtendedVirtual (UInt64)

        return {
            Length: NumGet(MemStatusEx, 0, "UInt"),
            MemoryLoad: NumGet(MemStatusEx, 4, "UInt"),
            TotalPhys: NumGet(MemStatusEx, 8, "UInt64"),
            AvailPhys: NumGet(MemStatusEx, 16, "UInt64"),
            TotalPageFile: NumGet(MemStatusEx, 24, "UInt64"),
            AvailPageFile: NumGet(MemStatusEx, 32, "UInt64"),
            TotalVirtual: NumGet(MemStatusEx, 40, "UInt64"),
            AvailVirtual: NumGet(MemStatusEx, 48, "UInt64"),
            AvailExtendedVirtual: NumGet(MemStatusEx, 56, "UInt64")
        }
    } else {
        ; Return false if the DllCall failed
        return false
    }
}
