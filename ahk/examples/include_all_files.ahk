; Find all files under the folder
files_to_include := ""
loop Files, "include_all_files/*.ahk", "F" {
    files_to_include := files_to_include "#include " A_LoopFilePath "`n"
}

; Write the #include statements into a temporary ahk file
temp_file := "tmp.ahk"
FileOpen(temp_file, "w").Close()
FileAppend(files_to_include, temp_file)

; Run that temporary ahk file.
; Note: Cannot use #include here, because it will be preprocessed before the above code can write to the file
Run(temp_file)
