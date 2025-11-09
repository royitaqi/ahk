#Requires AutoHotkey v2.0.0

ArrayToString(a) {
    ret := "a = [ "
    for v in a {
        if (!IsSet(v)) {
            ret := ret "unset "
        } else {
            ret := ret "" v " "
        }
    }
    return ret "]"
}

a := [1, 2, 3]
str := "`t`t`t" ArrayToString(a) "`n"
str := str "a.Delete(2)         `t" a.Delete(2)          "`t" ArrayToString(a) "`n" ; 2, a = [1,  , 3]
str := str "a.Get(3)            `t" a.Get(3)             "`t" ArrayToString(a) "`n" ; 3, a = [1,  , 3]
str := str "a.Has(2)            `t" a.Has(2)             "`t" ArrayToString(a) "`n" ; 0, a = [1,  , 3]
str := str "a.InsertAt(2, 4)    `t" a.InsertAt(2, 4)     "`t" ArrayToString(a) "`n" ;  , a = [1, 4,  , 3]
str := str "a.Pop()             `t" a.Pop()              "`t" ArrayToString(a) "`n" ;  , a = [1, 4,  ]
str := str "a.Push(5)           `t" a.Push(5)            "`t" ArrayToString(a) "`n" ;  , a = [1, 4,  , 5]
str := str "a.RemoveAt(3)       `t" a.RemoveAt(3)        "`t" ArrayToString(a) "`n" ;  , a = [1, 4, 5]

MsgBox str
