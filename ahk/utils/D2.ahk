#include ../data_structure/Types.ahk

#include Debug.ahk


class D2Window {
    static Hwnd := nil
    static KeepActivated := false

    static Get() {
        if (!this.Hwnd) {
            this.Hwnd := WinGetID("Diablo II")
        }
        Assert(this.Hwnd, "Must find D2 window")
        return this.Hwnd
    }

    static IsActive() {
        ; https://www.autohotkey.com/docs/v2/misc/WinTitle.htm
        WinActive { Hwnd: this.Get() }
    }

    static Activate() {
        ; https://www.autohotkey.com/docs/v2/misc/WinTitle.htm
        WinActivate { Hwnd: this.Get() }
    }

    static ActivateIfNecessary() {
        if (this.KeepActivated && !this.IsActive()) {
            this.Activate()
        }
    }
}
