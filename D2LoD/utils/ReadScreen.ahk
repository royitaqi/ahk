GetD2Bitmap(save_to_file := "")
{
    ; Get the active game window's handle
    hwnd := WinGetID("A")

    ; Capture a screenshot of the window
    bitmap := Gdip_BitmapFromHWND(hwnd, 1)

    ; Save bitmap to a file
    if (save_to_file) {
        Gdip_SaveBitmapToFile(bitmap, save_to_file)
    }

    return bitmap
}

ARGB2RGB(argb, &r, &g, &b)
{
    r := Gdip_RFromARGB(argb)
    g := Gdip_GFromARGB(argb)
    b := Gdip_BFromARGB(argb)
}

RGB2Hex(r, g, b)
{
    return Format("{:02X}{:02X}{:02X}", r, g, b)
}

GetPixelColorInRGB(bitmap, x, y)
{
    argb := Gdip_GetPixel(bitmap, x, y)
    return argb & 0xffffff
}

GetPixelColorInHex(bitmap, x, y)
{
    ; Get the color of the pixel at the coordinates
    rgb := GetPixelColorInRGB(bitmap, x, y)

    ; Convert the ARGB color to a hex value
    ARGB2RGB(rgb, &r, &g, &b)
    return RGB2Hex(r, g, b)
}

RGBAreClose(r1, g1, b1, r2, g2, b2, variation) {
    return r1 >= r2 - variation
        && r1 <= r2 + variation
        && g1 >= g2 - variation
        && g1 <= g2 + variation
        && b1 >= b2 - variation
        && b1 <= b2 + variation
}

DetectPixelColorInRect(bitmap, x1, y1, x2, y2, color1, variation1 := 0, color2 := 0, variation2 := 0, &match_x := 0, &match_y := 0)
{
    Assert(bitmap, "bitmap should have value")

    ARGB2RGB(color1, &r1, &g1, &b1)
    if (color2) {
        ARGB2RGB(color2, &r2, &g2, &b2)
    }

    x := x1
    loop x2 - x1 + 1
    {
        y := y1
        loop y2 - y1 + 1
        {
            ; Get the color of the pixel at the coordinates
            argb := Gdip_GetPixel(bitmap, x, y)
            ARGB2RGB(argb, &r, &g, &b)

            if (IsLogLevelDebug()) {
                hex := RGB2Hex(r, g, b)
                Log("DetectPixelColorInRect(): X=" x " Y=" y " color=0x" hex, 1)
            }

            ; Check if the color of the pixel is within range of any input colors
            if (RGBAreClose(r, g, b, r1, g1, b1, variation1)) {
                match_x := x
                match_y := y
                return 1
            }
            if (color2 && RGBAreClose(r, g, b, r2, g2, b2, variation2)) {
                match_x := x
                match_y := y
                return 2
            }

            y := y + 1
        }
        x := x + 1
    }
    return 0
}

DetectColoredText(bitmap, lines, color1, variation1 := 0, color2 := 0, variation2 := 0)
{
    x1 := 16
    y1 := 84
    ; Magic number. The width to look for.
    x2 := x1 + 8
    ; Each line is 9 pixels tall. Gap between two lines is 6 pixels tall.
    y2 := y1 + 9 + 15 * (lines - 1)

    return DetectPixelColorInRect(bitmap, x1, y1, x2, y2, color1, variation1, color2, variation2)
}