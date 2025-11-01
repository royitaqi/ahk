IsD2Active()
{
    title := WinGetTitle("A")
    return SubStr(title, 1, StrLen("Diablo II")) == "Diablo II"
}

IsD2Windowed()
{
    color := PixelGetColor(533, 287, "Slow")
    return color != 0x000000
}
