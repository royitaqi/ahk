#include ReadScreen.ahk


SaveAndQuit(wait := 0) {
    Send "{Escape}"
    ClickOrMove 500, 265, "Left", 0

    if (wait) {
        WaitUntilMainScreen()
    }
}

SinglePlayerChar1Hell(wait := 0)
{
    ClickOrMove(475, 315, "Left", 100)
    ClickOrMove(200, 150, "Left", 0)
    ClickOrMove(200, 150, "Left", 100)
    ClickOrMove(475, 375, "Left", 0)

    if (wait) {
        WaitUntilGameLoaded()
    }
}

IsMainScreen(clear_mouse := 0) {
    if (clear_mouse) {
        ; Move mouse out of the way of any detection points
        ClickOrMove(400, 250, "", 0)
    }
    bitmap := GetD2Bitmap()

    /*
        The black space inside the second "I" of "Diablo II" should be black.
        > The color at X440 Y150 is 040404
    */
    if (GetPixelColorInRGB(bitmap, 440, 150) != 0x040404) {
        return 0
    }

    /*
        The "BATTLE.NET" button should be gray.
        > The color at X480 Y350 is 606060
    */
    if (GetPixelColorInRGB(bitmap, 480, 350) != 0x606060) {
        return 0
    }

    /*
        The snow mountain to the left of "D" should be gray.
        > The color at X150 Y70 is 707070
    */
    if (GetPixelColorInRGB(bitmap, 150, 70) != 0x707070) {
        return 0
    }

    /*
        The flame to the right of the menu should be bright yellow.
        > The color at X690 Y375 is FCE874
    */
    if (GetPixelColorInRGB(bitmap, 690, 375) != 0xFCE874) {
        return 0
    }

    return 1
}

IsGameLoaded(clear_mouse := 0) {
    if (clear_mouse) {
        ; Move mouse out of the way of any detection points
        ClickOrMove(400, 250, "", 0)
    }
    bitmap := GetD2Bitmap()

    /*
        The background to the left of the health gauge should be gray.
        > The color at X20 Y555 is 383838
    */
    if (GetPixelColorInRGB(bitmap, 20, 555) != 0x383838) {
        return 0
    }

    /*
        The arm ring on the angle to the left of the health gauge should be yellow.
        > The color at X20 Y553 is 484020
    */
    if (GetPixelColorInRGB(bitmap, 20, 553) != 0x484020) {
        return 0
    }

    /*
        The background to the right of the mana gauge should be gray.
        > The color at X1055 Y555 is 404040
    */
    if (GetPixelColorInRGB(bitmap, 1055, 555) != 0x404040) {
        return 0
    }

    /*
        The arm ring on the demon to the right of the mana gauge should be yellow.
        > The color at X1055 Y563 is 584438
    */
    if (GetPixelColorInRGB(bitmap, 1055, 563) != 0x584438) {
        return 0
    }

    return 1
}

WaitUntilMainScreen() {
    while (!IsMainScreen(true)) {
        Sleep(100)
    }
}

WaitUntilGameLoaded() {
    while (!IsGameLoaded(true)) {
        Sleep(100)
    }
}

GetGameState(clear_mouse := 0) {
    if (IsGameLoaded(clear_mouse)) {
        return "GameLoaded"
    }
    if (IsMainScreen(clear_mouse)) {
        return "MainScreen"
    }
    return "unknown"
}
