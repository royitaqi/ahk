#Requires AutoHotkey v2.0.0

#include Types.ahk


class Disposable {
    __New(val, dispose, create := nil) {
        this.val := val
        this.dispose := dispose

        if (create) {
            create(this.val)
        }
    }

    __Delete() {
        if (this.dispose) {
            this.dispose.Call(this.val)
        }
    }
}
