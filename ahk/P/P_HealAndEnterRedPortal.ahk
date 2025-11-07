P_HealAndEnterRedPortal() {
    ; Talk to Malah to heal
    ClickOrMove2(158, 184, "Left", , 1000)

    ; Open minimap and apply frozen armor
    Send "B"
    Send "E"
    Click "Right"
    Sleep 400
    
    ; Click the red portal
    ClickOrMove2(900, 285, "Left")

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
