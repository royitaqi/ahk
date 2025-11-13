F1::SetPlayers(1)
F2::SetPlayers(3)
F3::SetPlayers(7)

SetPlayers(n)
{
    Say("/players " n)
}

s_CurrentStage := 0
ResetStage()
{
    global
    s_CurrentStage := 0
    SetPlayers(1)
}

NextStageDiablo()
{
    global
    s_CurrentStage := Mod(s_CurrentStage + 1, 2)
    switch s_CurrentStage
    {
        case 0: Say("Sanctum")              SetPlayers(1)
        case 1: Say("Diablo")               SetPlayers(7)
    }
}

NextStageBaal()
{
    global
    s_CurrentStage := Mod(s_CurrentStage + 1, 7)
    switch s_CurrentStage
    {
        case 0: Say("Chamber")              SetPlayers(1)
        case 1: Say("Stage 1: Sharman")     SetPlayers(8)
        case 2: Say("Stage 2: Skeleton")    SetPlayers(1)
        case 3: Say("Stage 3: Council")     SetPlayers(5)
        case 4: Say("Stage 4: Lord")        SetPlayers(8)
        case 5: Say("Stage 5: Dinosaur")    SetPlayers(5)
        case 6: Say("Baal")                 SetPlayers(1)
    }
}
