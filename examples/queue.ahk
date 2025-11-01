#Requires AutoHotkey v2.0.0

#include ../data_structure/Queue.ahk


q := Queue()
q.Append("b")
q.Prepend("a")
a := q.Pop()
q.Append("c")
b := q.Pop()
c := q.Pop()
MsgBox("a=" a "`nb=" b "`nc=" c)
