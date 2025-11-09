#include ../gdip/Gdip_All.ahk
#include ../gdip/Gdip_Toolbox.ahk
pToken := Gdip_Startup()

#include ../data_structure/Types.ahk

#include Debug.ahk


s_Max_X := 1068
s_Max_Y := 600
s_Hud_Y := 600

GetD2Bitmap := GetD2BitmapImpl
GetD2BitmapImpl(save_to_file := "")
{
    ; Get the active game window's handle
    hwnd := WinGetID("A")

    ; Capture a screenshot of the window
    bitmap := Gdip_BitmapFromHWND(hwnd, 1)

    ; Save bitmap to a file
    if (save_to_file) {
        Gdip_SaveBitmapToFile(bitmap, save_to_file)
    }

    ; TODO: Implement something to call Gdip_DisposeImage() to dispose the bitmap
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

DetectPixelColor(bitmap, x, y, r1, g1, b1, variation1 := 0, r2 := 0, g2 := 0, b2 := 0, variation2 := 0) {
    Assert(bitmap, "bitmap should have value")

    argb := Gdip_GetPixel(bitmap, x, y)
    ARGB2RGB(argb, &r, &g, &b)

    if (IsLogLevelDebug()) {
        hex := RGB2Hex(r, g, b)
        LogTedious("DetectPixelColor(): X=" x " Y=" y " color=0x" hex)
    }

    ; Check if the color of the pixel is within range of any input colors
    if (RGBAreClose(r, g, b, r1, g1, b1, variation1)) {
        match_x := x
        match_y := y
        return 1
    }
    if ((r2 || g2 || b2) && RGBAreClose(r, g, b, r2, g2, b2, variation2)) {
        match_x := x
        match_y := y
        return 2
    }
    return 0
}

DetectPixelColorInRect(bitmap, x1, y1, x2, y2, color1, variation1 := 0, color2 := 0, variation2 := 0, &match_x := 0, &match_y := 0) {
    Assert(bitmap, "bitmap should have value")

    ARGB2RGB(color1, &r1, &g1, &b1)
    r2 := g2 := b2 := 0
    if (color2) {
        ARGB2RGB(color2, &r2, &g2, &b2)
    }

    x := x1
    loop x2 - x1 + 1
    {
        y := y1
        loop y2 - y1 + 1
        {
            match := DetectPixelColor(bitmap, x, y, r1, g1, b1, variation1, r2, g2, b2, variation2)
            if (match) {
                match_x := x
                match_y := y
                return match
            }
            y := y + 1
        }
        x := x + 1
    }
    return 0
}
DetectPixelColorInRect2(bitmap, x1, y1, x2, y2, color1, variation1 := 0, color2 := 0, variation2 := 0, &match_x := 0, &match_y := 0) {
    return RectanglePattern(DetectColorCallback(bitmap, color1, variation1, color2, variation2), x1, y1, x2, y2, &match_x, &match_y)
}

DetectPixelColorInVerticalLine(bitmap, x, y1, y2, color1, variation1 := 0, color2 := 0, variation2 := 0, &match_x := 0, &match_y := 0) {
    Assert(bitmap, "bitmap should have value")

    ARGB2RGB(color1, &r1, &g1, &b1)
    if (color2) {
        ARGB2RGB(color2, &r2, &g2, &b2)
    }

    y := y1
    loop y2 - y1 + 1
    {
        match := DetectPixelColor(bitmap, x, y, r1, g1, b1, variation1, r2, g2, b2, variation2)
        if (match) {
            match_x := x
            match_y := y
            return match
        }
        y := y + 1
    }
    return 0
}

DetectColoredText(bitmap, lines, color1, variation1 := 0, color2 := 0, variation2 := 0) {
    x1 := 16
    y1 := 84
    ; Magic number. The width to look for.
    x2 := x1 + 8
    ; Each line is 9 pixels tall. Gap between two lines is 6 pixels tall.
    y2 := y1 + 9 + 15 * (lines - 1)

    return DetectPixelColorInRect(bitmap, x1, y1, x2, y2, color1, variation1, color2, variation2)
}

/*
    Returns 1 if color1 is found in minimap, 2 if color2, 0 if none.
*/
DetectColorInMinimap(bitmap := 0, color1 := 0, variation1 := 0, color2 := 0, variation2 := 0) {
    if (!bitmap) {
        bitmap := GetD2Bitmap()
    }

    /*
        Orange loot.
        > The color at X=899 Y=174 is 0xE07020

        Purple loot.
        > The color at X=899 Y=174 is 0xA420FC

        Minimap area.
        > The cursor is at X=791 Y=126
        > The cursor is at X=1004 Y=244
        Rounded to:
        - 800, 125
        - 1000, 245

        Character is at:
        > The cursor is at X=900 Y=172
        Rounded to:
        - 900, 172~173

        Finally adjust the minimap area to:
        - 800, 125
        - 1000, 220

        --

        A smaller area is:
        > The cursor is at X=857 Y=155
        > The cursor is at X=936 Y=191

        Adjusted area is:
        - 865, 155
        - 935, 190

        This seems more symmetric around the character
        - 865, 150
        - 935, 190
    */
    return DetectPixelColorInRect(bitmap, 865, 150, 935, 190, color1, variation1, color2, variation2)
}


/*
    For all the patterns below:
    - Expect callback:
        ```
        callback(x, y) {
            ...
        }
        ```
    - Returns the first non-nil value the callback returns. Otherwise, returns nil.
*/

VerticalStridePattern(callback, x_stride := 1, x1 := 0, y1 := 0, x2 := s_Max_X, y2 := s_Max_Y, &match_x := 0, &match_y := 0) {
    x := x1
    while (x <= x2) {
        y := y1
        while (y <= y2) {
            ret := callback(x, y)
            if (ret != nil) {
                match_x := x
                match_y := y
                return ret
            }
            y := y + 1
        }
        x := x + x_stride
    }
    return nil
}

RectanglePattern(callback, x1 := 0, y1 := 0, x2 := s_Max_X, y2 := s_Max_Y, &match_x := 0, &match_y := 0) {
    ; Rectangle pattern is just a vertical stride pattern with stride being 1
    return VerticalStridePattern(callback, 1, x1, y1, x2, y2, &match_x, &match_y)
}

/*
    Bitmap config is an array of pairs. Each pair is a bitmap and a boolean.
    The boolean indicates whether the color(s) should be detected in the bitmap or not.

    Returns a callback that can be given to one of the patterns in the above.
    
    When the callback is called with a (x, y) coordinate, it will return an array of integers.
    Each integer is the return value of DetectPixelColor() for the pixel on that coordinate in each of the bitmaps, respectively.
*/
DetectColorCallback(bitmap_config, color1 := 0, variation1 := 0, color2 := 0, variation2 := 0) {
    n := bitmap_config.Length
    for i, cfg in bitmap_config {
        Assert(cfg[1], "Bitmap [" i "] should have value")
    }

    ARGB2RGB(color1, &r1, &g1, &b1)
    r2 := g2 := b2 := 0
    if (color2) {
        ARGB2RGB(color2, &r2, &g2, &b2)
    }

    callback(x, y) {
        ret := []
        ret.Length := n
        good := 0
        for i, cfg in bitmap_config {
            bitmap := cfg[1]
            should_detect := cfg[2]
            ret[i] := DetectPixelColor(cfg[1], x, y, r1, g1, b1, variation1, r2, g2, b2, variation2)
            if ((ret[i] != 0) = should_detect) {
                good := good + 1
            }
        }
        if (good = n) {
            return ret
        }
        return nil
    }
    return callback
}
