#Requires AutoHotkey v2.0.0

#include ../data_structure/Disposable.ahk
#include ../data_structure/Types.ahk


MsgBoxCreate(val) {
    MsgBox("Object '" val "' created.")
}

MsgBoxDelete(val) {
    MsgBox("Object '" val "' deleted.")
}

my_global_1 := Disposable("my_global_1", MsgBoxDelete, MsgBoxCreate)
my_global_1 := nil

my_global__2_1st_ref := Disposable("my_global_2", MsgBoxDelete, MsgBoxCreate)
my_global__2_2nd_ref := my_global__2_1st_ref
my_global__2_1st_ref := nil

MyFunc() {
    in_func := Disposable("in_func", MsgBoxDelete, MsgBoxCreate)
    ret_from_func := Disposable("ret_from_func", MsgBoxDelete, MsgBoxCreate)
    return ret_from_func
}
ret := MyFunc()
