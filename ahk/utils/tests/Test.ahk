#Requires AutoHotkey v2.0.0

; This is the temporary ahk file that we will use to include all the test filenames and thus run them.
c_Temp_Master_File := "tmp.ahk"

; Find all test files under the folder and create "#include" and report statements
statements := "#include ../UnitTest.ahk`n`n"
loop Files, "Test_*.ahk", "F" {
    statements := statements "#include " A_LoopFilePath "`n"
}
statements := statements "`nReportPass(`"" c_Temp_Master_File "`")`n"

; Write all the statements into the temporary ahk file
FileOpen(c_Temp_Master_File, "w").Close()
FileAppend(statements, c_Temp_Master_File)

; Run that temporary ahk file.
; Note: Cannot use #include here, because it will be preprocessed before the above code can write to the file
Run(c_Temp_Master_File)
