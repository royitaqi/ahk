#include D2.ahk
#include KeyboardAndMouse.ahk
#include ReadScreen.ahk


SaveAndQuit(wait := true) {
    Send "{Escape}"
    ClickOrMove 500, 265, "", s_Premove_Delay
    ClickOrMove 500, 265, "Left", 0

    if (wait) {
        WaitUntilMainScreen()
    }
}

SinglePlayerChar1Hell(wait := true)
{
    ClickOrMove(475, 315, "Left", 100)
    ClickOrMove(200, 150, "Left", 0)
    ClickOrMove(200, 150, "Left", 100)
    ClickOrMove(475, 375, "Left", 0)

    if (wait) {
        WaitUntilGameLoaded()
    }
}

IsMainScreen(d2bitmap := 0, clear_mouse := false) {
    if (!d2bitmap) {
        if (clear_mouse) {
            ClearMouse()
        }
        d2bitmap := GetD2Bitmap()
    }

    /*
        The black space inside the second "I" of "Diablo II" should be black.
        > The color at X440 Y150 is 040404
    */
    if (GetPixelColorInRGB(d2bitmap, 440, 150) != 0x040404) {
        return 0
    }

    /*
        The "BATTLE.NET" button should be gray.
        > The color at X480 Y350 is 606060
    */
    if (GetPixelColorInRGB(d2bitmap, 480, 350) != 0x606060) {
        return 0
    }

    /*
        The snow mountain to the left of "D" should be gray.
        > The color at X150 Y70 is 707070
    */
    if (GetPixelColorInRGB(d2bitmap, 150, 70) != 0x707070) {
        return 0
    }

    /*
        The flame to the right of the menu should be bright yellow.
        > The color at X690 Y375 is FCE874
    */
    if (GetPixelColorInRGB(d2bitmap, 690, 375) != 0xFCE874) {
        return 0
    }

    return 1
}

IsGameLoaded(d2bitmap := 0, clear_mouse := false) {
    if (!d2bitmap) {
        if (clear_mouse) {
            ClearMouse()
        }
        d2bitmap := GetD2Bitmap()
    }

    /*
        The background to the left of the health gauge should be gray.
        > The color at X20 Y555 is 383838
    */
    if (GetPixelColorInRGB(d2bitmap, 20, 555) != 0x383838) {
        return 0
    }

    /*
        The arm ring on the angle to the left of the health gauge should be yellow.
        > The color at X20 Y553 is 484020
    */
    if (GetPixelColorInRGB(d2bitmap, 20, 553) != 0x484020) {
        return 0
    }

    /*
        The background to the right of the mana gauge should be gray.
        > The color at X1055 Y555 is 404040
    */
    if (GetPixelColorInRGB(d2bitmap, 1055, 555) != 0x404040) {
        return 0
    }

    /*
        The arm ring on the demon to the right of the mana gauge should be yellow.
        > The color at X1055 Y563 is 584438
    */
    if (GetPixelColorInRGB(d2bitmap, 1055, 563) != 0x584438) {
        return 0
    }

    return 1
}

IsGamePaused(d2bitmap := 0, clear_mouse := false) {
    if (!d2bitmap) {
        if (clear_mouse) {
            ClearMouse()
        }
        d2bitmap := GetD2Bitmap()
    }

    /*
        The center of the three "O"s in the pause menu should be yellow.
        The color at X467 Y210 is 74643C
        The color at X554 Y212 is 645834
        The color at X573 Y312 is 645834
    */
    if (GetPixelColorInRGB(d2bitmap, 467, 210) != 0x74643C ||
            GetPixelColorInRGB(d2bitmap, 554, 212) != 0x645834 ||
            GetPixelColorInRGB(d2bitmap, 573, 312) != 0x645834) {
        return 0
    }
    return 1
}

WaitUntilMainScreen() {
    while (!IsMainScreen(, true)) {
        Sleep(100)
    }
}

WaitUntilGameLoaded() {
    while (!IsGameLoaded(, true)) {
        Sleep(100)
    }
}

GetD2State(d2bitmap := 0, clear_mouse := false) {
    if (!d2bitmap) {
        if (clear_mouse) {
            ClearMouse()
        }
        d2bitmap := GetD2Bitmap()
    }

    if (IsGameLoaded(d2bitmap, clear_mouse)) {
        if (IsGamePaused(d2bitmap, clear_mouse)) {
            return "GamePaused"
        } else {
            return "GameRunning"
        }
    }
    if (IsMainScreen(d2bitmap, clear_mouse)) {
        return "MainScreen"
    }
    return "unknown"
}

PauseGameIfPossible() {
    ClearMouse()
    loop {
        d2bitmap := GetD2Bitmap()

        ; Cannot pause game if the game isn't loaded, or if the game is already paused
        if (!IsGameLoaded(d2bitmap, true) || IsGamePaused(d2bitmap, true)) {
            break
        }

        ; Game isn't paused yet. Press ESC to exit one layer of interaction (e.g. inventory,
        ; hireling, stats, skills, message box) or bring up pause menu.
        Send "{Escape}"
        Sleep 50
    }
}
