P_HealAndEnterRedPortal() {
    ; Talk to Malah to heal
    ClickOrMove2(158, 184, "Left", , 1000)

    ; Open minimap and apply frozen armor
    Send "B"
    Send "E"
    Click "Right"
    Sleep 400
    
    /*
        Portal positions:
        - 900, 285 (Anya is in the corner)
        - 1050, 315 (Anya is in the middle)
    */
    c_Portal1_X := 900
    c_Portal1_Y := 285
    c_Portal2_X := 1063
    c_Portal2_Y := 320
    bitmap := GetD2Bitmap()
    color1 := GetPixelColorInRGB(bitmap, c_Portal1_X, c_Portal1_Y)
    color2 := GetPixelColorInRGB(bitmap, c_Portal2_X, c_Portal2_Y)
    ARGB2RGB(color1, &r1, &g1, &b1)
    ARGB2RGB(color2, &r2, &g2, &b2)
    redness1 := r1 * 2 - g1 - b1
    redness2 := r2 * 2 - g2 - b2
    if (redness1 > redness2) {
        portal_x := c_Portal1_X
        portal_y := c_Portal1_Y
    } else {
        portal_x := c_Portal2_X
        portal_y := c_Portal2_Y
    }
    ; Click the red portal
    ClickOrMove2(portal_x, portal_y, "Left")

    ; Detect that we have entered the Temple
    loop {
        bitmap := GetD2Bitmap()

        /*
            The top left area should be black.
            > The color at X=100 Y=30 is 0x000000

            The area to the right should be light gray.
            > The color at X=180 Y=30 is 0x1C1C1C
        */
        if (GetPixelColorInRGB(bitmap, 100, 30) == 0x000000 &&
                GetPixelColorInRGB(bitmap, 180, 30) == 0x1C1C1C) {
            ; We are in the temple!
            break
        }

        Sleep(200)
    }
}
