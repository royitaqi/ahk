CheckHirelingAlive() {
    bitmap := GetD2Bitmap()

    /*
        If the hireling is alive, their name should be white.
        > The color at X=35 Y=68 is 0xC4C4C4
    */
    return GetPixelColorInRGB(bitmap, 35, 68) = 0xC4C4C4
}
