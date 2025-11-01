﻿#Requires AutoHotkey v2.0.0

#HotIf WinActive("Diablo II")

SetTitleMatchMode(1)
SetDefaultMouseSpeed(0)
CoordMode("Mouse", "Client")
CoordMode("Pixel", "Client")

#include gdip/Gdip_Toolbox.ahk
pToken := Gdip_Startup()

#include utils/Cube.ahk
#include utils/DebugTools.ahk
#include utils/Inventory.ahk
#include utils/KeyboardAndMouse.ahk
#include utils/Logs.ahk
#include utils/ReadScreen.ahk
#include utils/SaveAndLoad.ahk
#include utils/Stash.ahk

#include LK/LK.ahk
#include LK/tests/test_lk.ahk

#include AdvancedMode.ahk
#include HoradricStack.ahk
#include QuickCast.ahk
#include SetPlayers.ahk
