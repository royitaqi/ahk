#Requires AutoHotkey v2.0.0

; Define the function to be passed as an argument
MyCallbackFunction(message) {
    MsgBox "Callback received: " message
}

; Define the function that takes a function as an argument
ExecuteWithCallback(funcToCall, data) {
    MsgBox "Callback function name: " funcToCall.Name
    ; Call the passed function object
    funcToCall.Call(data)
}

; Call ExecuteWithCallback, passing MyCallbackFunction as the first argument
ExecuteWithCallback(MyCallbackFunction, "Hello from main script!")

; You can also use a lambda function (fat arrow expression) directly
ExecuteWithCallback((msg) => MsgBox("Lambda received: " msg), "Another message!")
