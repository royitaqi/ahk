#include Log.ahk


Assert(expr, msg)
{
    if (!expr) {
        LogError(msg)
        Throw Error("msg", -1)
    }
}

/* Test mouse position */
TestMousePosition()
{
    MouseGetPos &xpos, &ypos
    Log("The cursor is at X=" xpos " Y=" ypos)
}

/* Test pixel color at current mouse position + (-10,-10) */
TestPixelColor()
{
    MouseGetPos &xpos, &ypos

    Log("Will test pixel in ...")
    countdown := 3
    loop 3
    {
        Log(countdown)
        Sleep(1000)
        countdown := countdown - 1
    }

    ; color := PixelGetColor(xpos, ypos, "Alt")
    ; color := GetPixelColorBuffered(xpos, ypos)

    bitmap := GetD2BitMap()
    color := GetPixelColorInHex(bitmap, xpos, ypos)

    Log("The color at X=" xpos " Y=" ypos " is 0x" color)
}
