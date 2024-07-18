section .data
    fmt_read db "%d,%d,%d,%d", 0

section .text
    extern prodotti, printf

    global read_file

read_file:
    ; Read the file line by line
    ; ... (file reading implementation)
    ret
