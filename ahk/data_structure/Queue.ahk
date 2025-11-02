#Requires AutoHotkey v2.0.0


class Queue {
    __New() {
        this.items := []
    }

    Prepend(item) {
        this.items.InsertAt(1, item)
    }

    Append(item) {
        this.items.Push(item)
    }

    Pop() {
        if (this.items.Length > 0) {
            return this.items.RemoveAt(1)
        }
        throw Error("Nothing to return")
    }

    Size() {
        return this.items.Length
    }

    IsEmpty() {
        return this.items.Length == 0
    }

    Clear() {
        this.items := []
    }
}
