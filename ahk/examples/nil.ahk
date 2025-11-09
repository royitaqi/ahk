#Requires AutoHotkey v2.0.0

#include ../data_structure/Types.ahk


result := ""

if (nil) {
    result := result "nil = true`n"
} else {
    result := result "nil = false`n"
}
if (!nil) {
    result := result "!nil = true`n"
} else {
    result := result "!nil = false`n"
}
result := result "`n"

if ([]) {
    result := result "[] = true`n"
} else {
    result := result "[] = false`n"
}
if (![]) {
    result := result "![] = true`n"
} else {
    result := result "![] = false`n"
}
result := result "`n"

if ({}) {
    result := result "{} = true`n"
} else {
    result := result "{} = false`n"
}
if (!{}) {
    result := result "!{} = true`n"
} else {
    result := result "!{} = false`n"
}
result := result "`n"

MsgBox result
