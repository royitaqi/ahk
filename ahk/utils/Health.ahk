/*
    The strategy should be array of arrays, each inner array having two elements:
    - [1] Health percentages (10-90). Note: Always put low health percentage strategy first.
    - [2] Which potion to use (1-4)
    The percentages will be checked in order. For any percentage, if the health is below that, the corresponding potion will be used and the loop terminated.
*/
CheckHealth(strategy) {
    /*
        The cursor is at X=70 Y=510 - 100%  - The color at X=70 Y=510 is 0x380804
        The cursor is at X=70 Y=518 - 90%   - The color at X=70 Y=518 is 0x5C0000
        The cursor is at X=70 Y=526 - 80%   - The color at X=70 Y=526 is 0x5C0000
        The cursor is at X=70 Y=534 - 70%   - The color at X=70 Y=534 is 0x5C0000
        The cursor is at X=70 Y=542 - 60%   - The color at X=70 Y=542 is 0x5C0000
        The cursor is at X=70 Y=550 - 50%   - The color at X=70 Y=550 is 0x5C0000
        The cursor is at X=70 Y=558 - 40%   - The color at X=70 Y=558 is 0x5C0000
        The cursor is at X=70 Y=566 - 30%   - The color at X=70 Y=566 is 0x5C0000
        The cursor is at X=70 Y=574 - 20%   - The color at X=70 Y=574 is 0x240000
        The cursor is at X=70 Y=582 - 10%   - The color at X=70 Y=582 is 0x080404
        The cursor is at X=70 Y=590 - 0%    - The color at X=70 Y=590 is 0x080808
    */
    pixels := Map(
        110, Map("Y", 502, "Color", 0x5C0000), ; For test purpose only
        100, Map("Y", 510, "Color", 0x380804),
        90,  Map("Y", 518, "Color", 0x5C0000),
        80,  Map("Y", 526, "Color", 0x5C0000),
        70,  Map("Y", 534, "Color", 0x5C0000),
        60,  Map("Y", 542, "Color", 0x5C0000),
        50,  Map("Y", 550, "Color", 0x5C0000),
        40,  Map("Y", 558, "Color", 0x5C0000),
        30,  Map("Y", 566, "Color", 0x5C0000),
        20,  Map("Y", 574, "Color", 0x240000),
        10,  Map("Y", 582, "Color", 0x080404),
    )

    bitmap := GetD2Bitmap()
    
    n := strategy.Length
    i := 1
    loop n {
        percentage := strategy[i][1]
        potion := strategy[i][2]
        Assert(pixels.Has(percentage), "Given percentage (" percentage ") is not supported")

        pixel := pixels[percentage]
        y := pixel["Y"]
        color := pixel["Color"]

        is_health_below_percentage := (GetPixelColorInRGB(bitmap, 70, y) != color)

        if (is_health_below_percentage) {
            Press("" potion "")
            Log("Potion " potion " used")
            return potion
        }

        i := i + 1
    }
    return 0
}
